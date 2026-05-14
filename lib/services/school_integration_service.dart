import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

enum SchoolProvider { librus, vulcan }

Map<String, dynamic> _processLibrusDataSync(Map<String, dynamic> input) {
  final rawSubjects = (input['rawSubjects'] as List<dynamic>?) ?? [];
  final rawGrades = (input['rawGrades'] as List<dynamic>?) ?? [];
  final rawCategories = (input['rawCategories'] as List<dynamic>?) ?? [];
  final rawPointGrades = (input['rawPointGrades'] as List<dynamic>?) ?? [];
  final rawHomeWorks = (input['rawHomeWorks'] as List<dynamic>?) ?? [];
  final rawEvents = (input['rawEvents'] as List<dynamic>?) ?? [];

  final Map<int, String> subjectMap = {};
  for (var s in rawSubjects) {
    final id = int.tryParse(s['Id']?.toString() ?? '');
    final name = s['Name'] ?? 'Nieznany';
    if (id != null) subjectMap[id] = name;
  }

  final Map<int, Map<String, dynamic>> categoryMap = {};
  for (var c in rawCategories) {
    final id = int.tryParse(c['Id']?.toString() ?? '');
    if (id != null) {
      categoryMap[id] = {
        'name': c['Name'],
        'weight': int.tryParse(c['Weight']?.toString() ?? '1') ?? 1,
        'max_grade': c['MaxGrade'] ?? c['Max'] ?? c['MaxPoints'],
      };
    }
  }

  final List<Map<String, dynamic>> processedGrades = [];
  for (var g in rawGrades) {
    final int subjectId = int.tryParse(g['Subject']?['Id']?.toString() ?? '0') ?? 0;
    final int categoryId = int.tryParse(g['Category']?['Id']?.toString() ?? '0') ?? 0;

    final String subjectName = subjectMap[subjectId] ?? 'Przedmiot $subjectId';
    final String gradeText = (g['Grade']?.toString() ?? '').trim();
    if (gradeText.isEmpty) continue;

    final category = categoryMap[categoryId];
    final double weight = (category?['weight'] ?? 1).toDouble();
    final String type = category?['name'] ?? 'Bieżąca';
    final double? categoryMaxGrade = double.tryParse(category?['max_grade']?.toString() ?? '');

    double gradeValue = 0.0;
    double? points;
    double? maxPoints;

    final slashMatch = RegExp(r'^(\d+(?:[.,]\d+)?)\s*/\s*(\d+(?:[.,]\d+)?)$').firstMatch(gradeText);
    if (slashMatch != null) {
      final ptsStr = slashMatch.group(1);
      final maxPtsStr = slashMatch.group(2);
      if (ptsStr != null && maxPtsStr != null) {
        final pts = double.tryParse(ptsStr.replaceAll(',', '.')) ?? 0;
        final maxPts = double.tryParse(maxPtsStr.replaceAll(',', '.')) ?? 0;
        points = pts;
        maxPoints = maxPts;
        if (maxPts > 0) {
          final ratio = pts / maxPts;
          if (ratio >= 0.9) gradeValue = 6;
          else if (ratio >= 0.75) gradeValue = 5;
          else if (ratio >= 0.6) gradeValue = 4;
          else if (ratio >= 0.45) gradeValue = 3;
          else if (ratio >= 0.3) gradeValue = 2;
          else gradeValue = 1;
        }
      }
    } else if (categoryMaxGrade != null || (double.tryParse(gradeText) != null && double.parse(gradeText) > 6)) {
      final pts = double.tryParse(gradeText) ?? 0;
      points = pts;
      maxPoints = categoryMaxGrade;
      if (categoryMaxGrade != null && categoryMaxGrade > 0) {
        final ratio = pts / categoryMaxGrade;
        if (ratio >= 0.9) gradeValue = 6;
        else if (ratio >= 0.75) gradeValue = 5;
        else if (ratio >= 0.6) gradeValue = 4;
        else if (ratio >= 0.45) gradeValue = 3;
        else if (ratio >= 0.3) gradeValue = 2;
        else gradeValue = 1;
      } else {
        gradeValue = pts.clamp(1, 6);
      }
    } else {
      final match = RegExp(r'([1-6])').firstMatch(gradeText);
      if (match != null) {
        final valStr = match.group(1);
        if (valStr != null) {
          gradeValue = double.parse(valStr);
          if (gradeText.contains('+')) gradeValue += 0.5;
          if (gradeText.contains('-')) gradeValue -= 0.25;
        }
      }
    }

    if (gradeValue > 0) {
      processedGrades.add({
        'subject_name': subjectName,
        'grade': gradeValue,
        'weight': weight,
        'type': type,
        'date': g['AddDate'] ?? g['Date'] ?? DateTime.now().toIso8601String(),
        'points': points,
        'max_points': maxPoints,
      });
    }
  }

  for (var g in rawPointGrades) {
    final int subjectId = int.tryParse(g['Subject']?['Id']?.toString() ?? '0') ?? 0;
    final String subjectName = subjectMap[subjectId] ?? 'Przedmiot $subjectId';

    final dynamic pointsRaw = g['Score'] ?? g['Points'];
    final dynamic maxRaw = g['MaxScore'] ?? g['MaxPoints'] ?? g['Category']?['MaxScore'];
    final double? pts = pointsRaw != null ? double.tryParse(pointsRaw.toString()) : null;
    final double? maxPts = maxRaw != null ? double.tryParse(maxRaw.toString()) : null;
    if (pts == null) continue;

    double gradeValue = 0.0;
    if (maxPts != null && maxPts > 0) {
      final ratio = pts / maxPts;
      if (ratio >= 0.9) gradeValue = 6;
      else if (ratio >= 0.75) gradeValue = 5;
      else if (ratio >= 0.6) gradeValue = 4;
      else if (ratio >= 0.45) gradeValue = 3;
      else if (ratio >= 0.3) gradeValue = 2;
      else gradeValue = 1;
    } else {
      gradeValue = pts.clamp(1, 6);
    }

    processedGrades.add({
      'subject_name': subjectName,
      'grade': gradeValue,
      'weight': 1.0,
      'type': g['Category']?['Name'] ?? 'Punktowa',
      'date': g['AddDate'] ?? g['Date'] ?? DateTime.now().toIso8601String(),
      'points': pts,
      'max_points': maxPts,
    });
  }

  final List<Map<String, dynamic>> processedExams = [];
  for (var hw in rawHomeWorks) {
    final int subjectId = int.tryParse(hw['Subject']?['Id']?.toString() ?? '0') ?? 0;
    final String subjectName = subjectMap[subjectId] ?? 'Nieznany';
    final String title = hw['Content']?.toString().trim() ?? 'Zadanie domowe';
    final String? dateStr = hw['Date']?.toString() ?? hw['AddDate']?.toString();
    if (dateStr == null) continue;
    processedExams.add({
      'subject_name': subjectName,
      'title': title.length > 80 ? '${title.substring(0, 77)}...' : title,
      'date': dateStr,
      'weight': 1.0,
      'max_points': null,
    });
  }

  for (var ev in rawEvents) {
    final int subjectId = int.tryParse(ev['Subject']?['Id']?.toString() ?? '0') ?? 0;
    final String subjectName = subjectMap[subjectId] ?? 'Nieznany';
    final String title = ev['Topic']?.toString().trim() ?? ev['Title']?.toString().trim() ?? 'Sprawdzian';
    final String? dateStr = ev['Date']?.toString() ?? ev['EventDate']?.toString();
    if (dateStr == null) continue;
    processedExams.add({
      'subject_name': subjectName,
      'title': title.length > 80 ? '${title.substring(0, 77)}...' : title,
      'date': dateStr,
      'weight': 1.0,
      'max_points': null,
    });
  }

  return {
    'subjects': subjectMap.values.map((name) => {'name': name}).toList(),
    'grades': processedGrades,
    'exams': processedExams,
  };
}
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

  Future<SchoolSyncResult> sync() async {
    if (provider == SchoolProvider.librus) {
      return await _syncLibrusMobileApi();
    } else {
      return await _syncVulcan();
    }
  }

  Future<SchoolSyncResult> _syncLibrusMobileApi() async {
    const String userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0';
    final container = CookieContainer();
    final client = HttpClient();
    
    // Follow redirects manually to capture cookies at every step
    client.findProxy = null;

    Future<void> getWithCookies(String url, {String? referer}) async {
      var nextUrl = url;
      for (var hop = 0; hop < 10; hop++) {
        final request = await client.getUrl(Uri.parse(nextUrl));
        request.followRedirects = false;
        request.headers.set('User-Agent', userAgent);
        if (referer != null) request.headers.set('Referer', referer);
        for (var cookie in container.getCookies()) {
          request.cookies.add(cookie);
        }

        final response = await request.close();
        container.updateCookies(response.cookies);

        if (response.statusCode >= 300 && response.statusCode < 400) {
          nextUrl = response.headers.value('location') ?? nextUrl;
          // Make absolute if relative redirect
          if (!nextUrl.startsWith('http')) {
            final base = Uri.parse(url);
            nextUrl = base.resolve(nextUrl).toString();
          }
          referer = url;
          await response.drain();
          continue;
        }
        await response.drain();
        break;
      }
    }

    Future<void> postWithCookies(String url, Map<String, String> body, {String? referer}) async {
      final request = await client.postUrl(Uri.parse(url));
      request.followRedirects = false;
      request.headers.set('User-Agent', userAgent);
      request.headers.set('Content-Type', 'application/x-www-form-urlencoded');
      if (referer != null) request.headers.set('Referer', referer);
      for (var cookie in container.getCookies()) {
        request.cookies.add(cookie);
      }

      final data = body.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
      request.write(data);

      final response = await request.close();
      container.updateCookies(response.cookies);

      // Follow any redirect after POST as GET
      if (response.statusCode >= 300 && response.statusCode < 400) {
        var nextUrl = response.headers.value('location') ?? url;
        if (!nextUrl.startsWith('http')) {
          final base = Uri.parse(url);
          nextUrl = base.resolve(nextUrl).toString();
        }
        await response.drain();
        await getWithCookies(nextUrl, referer: url);
      } else {
        await response.drain();
      }
    }

    Future<dynamic> fetchLibrus(String endpoint) async {
      const String apiBaseUrl = 'https://synergia.librus.pl/gateway/api/2.0';
      final requestUrl = Uri.parse('$apiBaseUrl/$endpoint');

      final request = await client.getUrl(requestUrl);
      request.followRedirects = false;
      request.headers.set('User-Agent', userAgent);
      for (var cookie in container.getCookies()) {
        request.cookies.add(cookie);
      }

      final response = await request.close();
      if (response.statusCode != 200) {
        await response.drain();
        throw Exception('Błąd pobierania $endpoint: ${response.statusCode}');
      }

      final responseBody = await response.transform(utf8.decoder).join();
      final data = jsonDecode(responseBody);
      if (data is Map && data.isNotEmpty) {
        return data.values.first;
      }
      return data;
    }

    try {
      // 1. Handshake
      await getWithCookies('https://synergia.librus.pl/loguj/portalRodzina?v=1774820765');
      await postWithCookies(
        'https://api.librus.pl/OAuth/Authorization?client_id=46',
        {'action': 'login', 'login': email, 'pass': password},
        referer: 'https://synergia.librus.pl/loguj/portalRodzina',
      );
      await getWithCookies('https://api.librus.pl/OAuth/Authorization/2FA?client_id=46');
      await getWithCookies('https://api.librus.pl/OAuth/Authorization/Grant?client_id=46');

      // 2. Fetch Data
      final List<dynamic> rawSubjects = await fetchLibrus('Subjects');
      final List<dynamic> rawGrades = await fetchLibrus('Grades');
      final List<dynamic> rawCategories = await fetchLibrus('Grades/Categories');

      // Point grades (e.g. "12/15" style)
      List<dynamic> rawPointGrades = [];
      try { rawPointGrades = await fetchLibrus('PointGrades'); } catch (_) {}

      // Calendar events: HomeWorks + SchoolNotices as exams
      List<dynamic> rawHomeWorks = [];
      try { rawHomeWorks = await fetchLibrus('HomeWorks'); } catch (_) {}
      List<dynamic> rawEvents = [];
      try { rawEvents = await fetchLibrus('Events'); } catch (_) {}

      // 3. Process Data (offloaded to background isolate via compute)
      final processed = await compute(_processLibrusDataSync, {
        'rawSubjects': rawSubjects,
        'rawGrades': rawGrades,
        'rawCategories': rawCategories,
        'rawPointGrades': rawPointGrades,
        'rawHomeWorks': rawHomeWorks,
        'rawEvents': rawEvents,
      });

      return SchoolSyncResult(
        subjects: (processed['subjects'] as List).cast<Map<String, dynamic>>(),
        grades: (processed['grades'] as List).cast<Map<String, dynamic>>(),
        exams: (processed['exams'] as List).cast<Map<String, dynamic>>(),
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
}

class CookieContainer {
  final Map<String, Cookie> _cookies = {};

  void updateCookies(List<Cookie> newCookies) {
    for (var cookie in newCookies) {
      _cookies[cookie.name] = cookie;
    }
  }

  List<Cookie> getCookies() {
    return _cookies.values.toList();
  }
}
