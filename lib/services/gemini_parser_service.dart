import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiParserService {
  // Mode A: Direct Client-Side Call (Easy testing/dev)
  // Mode B: Supabase Edge Function (Secure/Production)
  static const bool useEdgeFunction = false;

  // The API key provided by the user. In production, Mode B is recommended to hide this key.
  static String get _directApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  /// Parses a batch of raw grades using Gemini AI.
  /// Returns a map of grade ID -> parsed data, or null if the request fails.
  Future<Map<String, Map<String, dynamic>>?> parseGradesBatch(List<Map<String, dynamic>> rawGrades) async {
    if (rawGrades.isEmpty) return {};

    if (useEdgeFunction) {
      return await _parseViaEdgeFunction(rawGrades);
    } else {
      return await _parseViaDirectApi(rawGrades);
    }
  }

  Future<Map<String, Map<String, dynamic>>?> _parseViaDirectApi(List<Map<String, dynamic>> rawGrades) async {
    if (_directApiKey.isEmpty) {
      return null;
    }

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_directApiKey',
    );

    // Build a compact representation of grades to minimize token count
    final List<Map<String, dynamic>> compactGrades = rawGrades.map((g) {
      return {
        'id': g['id']?.toString() ?? '',
        'subject': g['subject_name'] ?? '',
        'category': g['category_name'] ?? '',
        'value': g['grade_text'] ?? '',
        'comment': g['comment'] ?? '',
      };
    }).toList();

    final prompt = '''
Jesteś ekspertem analizującym oceny i punkty w polskim dzienniku szkolnym (Librus/Vulcan).
Twoim zadaniem jest przeanalizowanie listy ocen i określenie dla każdej pozycji:
1. Czy to jest ocena punktowa (is_points: true) czy tradycyjna ocena 1-6 (is_points: false).
2. Liczba uzyskanych punktów (points: float lub null).
3. Maksymalna liczba punktów do zdobycia (max_points: float lub null).
4. Ostateczna wartość oceny w skali 1-6 (grade: float, np. "5-" to 4.75, "4+" to 4.5, "5" to 5.0, "1" to 1.0, brak oceny/nieobecność to 0.0).
    - Jeśli to ocena punktowa (is_points: true), zawsze przypisz grade = 0.0 (nie obliczaj oceny z punktów, aplikacja zajmie się tym na żądanie).
    - Jeśli to zwykła ocena (is_points: false), po prostu ją przeparsuj (np. "3+" -> 3.5, "4=" -> 3.75, "np"/"nb" -> 0.0).

Ważna zasada spójności przedmiotu: Zwróć uwagę, że zazwyczaj dany przedmiot w semestrze u jednego nauczyciela jest oceniany albo w pełni punktowo (wtedy nawet małe oceny typu "5" oznaczają 5 punktów, a nie ocenę bardzo dobrą), albo w pełni tradycyjnie (skala ocen 1-6). Przeanalizuj kontekst innych ocen w ramach tego samego przedmiotu (subject), aby podjąć spójną decyzję dla wszystkich ocen tego przedmiotu.

Zwróć wynik jako poprawny format JSON - wyłącznie tablicę obiektów (bez dodatkowego tekstu markdown, bez owijania w ```json):
Każdy obiekt w tablicy MUSI mieć dokładnie takie pola:
- "id": string (dokładnie ten sam co wejściowy)
- "is_points": boolean
- "points": number lub null
- "max_points": number lub null
- "grade": number
- "reason": string (krótkie wyjaśnienie dlaczego tak sklasyfikowano)

Oto dane do przetworzenia:
${jsonEncode(compactGrades)}
''';

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'responseMimeType': 'application/json',
          }
        }),
      );

      if (response.statusCode != 200) {
        return null;
      }

      final jsonDecoded = jsonDecode(response.body);
      final textContent = jsonDecoded['candidates']?[0]?['content']?[partsField(jsonDecoded)]?[0]?['text']?.toString() ?? '';
      
      final List<dynamic> parsedList = jsonDecode(textContent.trim());
      final Map<String, Map<String, dynamic>> resultMap = {};
      
      for (var item in parsedList) {
        if (item is Map<String, dynamic> && item.containsKey('id')) {
          resultMap[item['id'].toString()] = {
            'is_points': item['is_points'] == true,
            'points': item['points'] != null ? (item['points'] as num).toDouble() : null,
            'max_points': item['max_points'] != null ? (item['max_points'] as num).toDouble() : null,
            'grade': item['grade'] != null ? (item['grade'] as num).toDouble() : 0.0,
            'reason': item['reason'] ?? '',
          };
        }
      }
      return resultMap;
    } catch (_) {
      return null;
    }
  }

  // Safe getter for API parts (Gemini schema can slightly vary)
  dynamic partsField(dynamic jsonDecoded) {
    try {
      return 'parts';
    } catch (_) {
      return 'parts';
    }
  }

  Future<Map<String, Map<String, dynamic>>?> _parseViaEdgeFunction(List<Map<String, dynamic>> rawGrades) async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.functions.invoke(
        'parse-grades',
        body: {'grades': rawGrades},
      );

      if (response.status != 200 || response.data == null) {
        return null;
      }

      final List<dynamic> parsedList = response.data is String ? jsonDecode(response.data) : response.data;
      final Map<String, Map<String, dynamic>> resultMap = {};

      for (var item in parsedList) {
        if (item is Map<String, dynamic> && item.containsKey('id')) {
          resultMap[item['id'].toString()] = {
            'is_points': item['is_points'] == true,
            'points': item['points'] != null ? (item['points'] as num).toDouble() : null,
            'max_points': item['max_points'] != null ? (item['max_points'] as num).toDouble() : null,
            'grade': item['grade'] != null ? (item['grade'] as num).toDouble() : 0.0,
            'reason': item['reason'] ?? '',
          };
        }
      }
      return resultMap;
    } catch (_) {
      return null;
    }
  }
}
