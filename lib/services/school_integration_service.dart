import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:html/parser.dart' show parse;
import 'school_extraction_service.dart';

enum SchoolProvider { librus, vulcan }

class SchoolSyncResult {
  final List<Map<String, dynamic>> subjects;
  final List<Map<String, dynamic>> grades;
  final List<Map<String, dynamic>> exams;

  SchoolSyncResult({
    required this.subjects,
    required this.grades,
    required this.exams,
  });
}

class SchoolIntegrationService {
  final String email;
  final String password;
  final SchoolProvider provider;

  SchoolIntegrationService({
    required this.email,
    required this.password,
    required this.provider,
  });

  // Librus Synergia Web Portal Constants
  static const String _librusWebUrl = 'https://synergia.librus.pl';

  Future<SchoolSyncResult> sync() async {
    if (provider == SchoolProvider.librus) {
      return await _syncLibrusScraper();
    } else {
      return await _syncVulcan();
    }
  }

  Future<SchoolSyncResult> _syncLibrusScraper() async {
    final client = http.Client();
    try {
      final userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

      // 1. Authenticate via Web Portal
      final loginReq = http.Request('POST', Uri.parse('$_librusWebUrl/loguj'));
      loginReq.followRedirects = false; // We want to catch the 302 and the Set-Cookie
      loginReq.headers['Content-Type'] = 'application/x-www-form-urlencoded';
      loginReq.headers['User-Agent'] = userAgent;
      loginReq.body = 'login=${Uri.encodeComponent(email)}&passwd=${Uri.encodeComponent(password)}';
      
      final loginStream = await client.send(loginReq);
      final loginResponse = await http.Response.fromStream(loginStream);

      if (loginResponse.statusCode != 302 && loginResponse.statusCode != 303) {
        throw Exception('Błędny login lub hasło (konto Synergia).');
      }

      // Extract session cookies securely
      final rawCookies = loginResponse.headers['set-cookie'] ?? '';
      if (!rawCookies.contains('DZIENNIK')) {
        throw Exception('Brak autoryzacji DZIENNIK w odpowiedzi. Sprawdź poprawność danych.');
      }

      String extractCookie(String name) {
        final match = RegExp('$name=([^;]+)').firstMatch(rawCookies);
        return match != null ? '$name=${match.group(1)}' : '';
      }

      final cookieHeader = [extractCookie('JSESSIONID'), extractCookie('DZIENNIK')]
          .where((c) => c.isNotEmpty)
          .join('; ');

      // 2. Fetch Grades HTML page
      final gradesReq = http.Request('GET', Uri.parse('$_librusWebUrl/przegladaj_oceny/uczen'));
      gradesReq.headers['Cookie'] = cookieHeader;
      gradesReq.headers['User-Agent'] = userAgent;
      
      final gradesStream = await client.send(gradesReq);
      final gradesResponse = await http.Response.fromStream(gradesStream);

      if (gradesResponse.statusCode != 200) {
        throw Exception('Nie udało się pobrać strony z ocenami (Błąd ${gradesResponse.statusCode})');
      }

      // --- TEMPORARY DEBUG DUMP ---
      try {
        await http.post(Uri.parse('http://10.0.2.2:8080/'), body: gradesResponse.body);
      } catch (e) {
        // Ignore if server isn't running
      }
      // ----------------------------

      // 3. Parse HTML
      final document = parse(gradesResponse.body);
      
      final List<Map<String, dynamic>> processedGrades = [];
      final Set<String> foundSubjects = {};

      // Flexible row searching: Any table row
      final rows = document.querySelectorAll('tr');

      for (var row in rows) {
        // Find all grade boxes in this row
        final gradeBoxes = row.querySelectorAll('.grade-box');
        if (gradeBoxes.isEmpty) continue; // Not a grade row

        // Robust subject name extraction
        String subjectName = '';
        final cells = row.querySelectorAll('td, th');
        for (var cell in cells) {
          String text = cell.text.replaceAll(RegExp(r'\s+'), ' ').trim();
          // Skip empty cells, expand icons (+/-), or cells that are just numbers/grades
          if (text.isNotEmpty && !text.contains('+/-') && text.length > 2 && !RegExp(r'^[0-9\.\-\+]+$').hasMatch(text)) {
            subjectName = text;
            break;
          }
        }
        
        if (subjectName.isEmpty || subjectName.toLowerCase().contains('zachowanie')) continue;

        foundSubjects.add(subjectName);

        for (var box in gradeBoxes) {
          // Sometimes the grade is in an <a> tag, sometimes directly in the <span class="grade-box">
          final aTag = box.querySelector('a');
          final targetElement = aTag ?? box;
          
          final gradeText = targetElement.text.trim();
          final titleHtml = targetElement.attributes['title'] ?? box.attributes['title'] ?? '';
          
          // Clean HTML from title
          final cleanTitle = titleHtml.replaceAll(RegExp(r'<[^>]*>'), ' ').replaceAll('&nbsp;', ' ');
          
          // Parse numerical grade (handles modifiers like 5- -> 4.75 or base 5.0)
          double gradeValue = 0.0;
          final baseGradeRegex = RegExp(r'^[1-6]');
          if (baseGradeRegex.hasMatch(gradeText)) {
             gradeValue = double.tryParse(gradeText.substring(0, 1)) ?? 0.0;
          }
          if (gradeValue == 0) continue;

          final extracted = SchoolExtractionService.extract(cleanTitle, '');

          processedGrades.add({
            'subject_name': subjectName,
            'grade': gradeValue,
            'weight': extracted.weight,
            'type': extracted.type,
            'points': extracted.points,
            'max_points': extracted.maxPoints,
            'date': DateTime.now().toIso8601String(), 
          });
        }
      }

      return SchoolSyncResult(
        subjects: foundSubjects.map((name) => {'name': name}).toList(),
        grades: processedGrades,
        exams: [],
      );

    } catch (e) {
      rethrow;
    } finally {
      client.close();
    }
  }

  Future<SchoolSyncResult> _syncVulcan() async {
    // Vulcan requires a different approach (Token/PIN/Symbol)
    // We treat 'email' as Token and 'password' as PIN for the pairing dialog
    throw Exception('Integracja z Vulcan wymaga parowania kodem PIN. Funkcja w przygotowaniu.');
  }

  SchoolSyncResult _processData(List<Map<String, dynamic>> rawSubjects, List<Map<String, dynamic>> rawGrades, List<Map<String, dynamic>> rawExams) {
    final List<Map<String, dynamic>> processedGrades = [];
    
    for (var raw in rawGrades) {
      final extracted = SchoolExtractionService.extract(raw['description'], raw['category']);
      
      processedGrades.add({
        'subject_name': raw['subject'],
        'grade': raw['grade'],
        'weight': extracted.weight,
        'type': extracted.type,
        'points': extracted.points,
        'max_points': extracted.maxPoints,
        'date': raw['date'],
      });
    }

    return SchoolSyncResult(
      subjects: rawSubjects,
      grades: processedGrades,
      exams: [], // Logic for exams can be added here
    );
  }

  // --- Real Auth Helpers (Placeholder for actual implementation) ---
  
  String _generateLibrusSignature(String method, String url) {
    // Real signature logic using HMAC-SHA1
    return ""; 
  }
}
