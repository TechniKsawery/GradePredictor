import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubjectTranslator {
  static final Map<String, String> _cache = {};
  static final Map<String, Future<String>> _inFlight = {};
  static final Map<String, Map<String, String>> _translations = {
    'język polski': {'en': 'Polish', 'de': 'Polnisch'},
    'j. polski': {'en': 'Polish', 'de': 'Polnisch'},
    'polski': {'en': 'Polish', 'de': 'Polnisch'},
    'język angielski': {'en': 'English', 'de': 'Englisch'},
    'j. angielski': {'en': 'English', 'de': 'Englisch'},
    'angielski': {'en': 'English', 'de': 'Englisch'},
    'angielski zawodowy': {'en': 'Vocational English', 'de': 'Fach-Englisch'},
    'j. angielski zawodowy': {'en': 'Vocational English', 'de': 'Fach-Englisch'},
    'j.angielski zawodowy': {'en': 'Vocational English', 'de': 'Fach-Englisch'},
    'język angielski zawodowy': {'en': 'Vocational English', 'de': 'Fach-Englisch'},
    'język niemiecki': {'en': 'German', 'de': 'Deutsch'},
    'j. niemiecki': {'en': 'German', 'de': 'Deutsch'},
    'niemiecki': {'en': 'German', 'de': 'Deutsch'},
    'język francuski': {'en': 'French', 'de': 'Französisch'},
    'j. francuski': {'en': 'French', 'de': 'Französisch'},
    'francuski': {'en': 'French', 'de': 'Französisch'},
    'język hiszpański': {'en': 'Spanish', 'de': 'Spanisch'},
    'j. hiszpański': {'en': 'Spanish', 'de': 'Spanisch'},
    'hiszpański': {'en': 'Spanish', 'de': 'Spanisch'},
    'język rosyjski': {'en': 'Russian', 'de': 'Russisch'},
    'j. rosyjski': {'en': 'Russian', 'de': 'Russisch'},
    'rosyjski': {'en': 'Russian', 'de': 'Russisch'},
    'język włoski': {'en': 'Italian', 'de': 'Italienisch'},
    'j. włoski': {'en': 'Italian', 'de': 'Italienisch'},
    'włoski': {'en': 'Italian', 'de': 'Italienisch'},
    'język chiński': {'en': 'Chinese', 'de': 'Chinesisch'},
    'j. chiński': {'en': 'Chinese', 'de': 'Chinesisch'},
    'j.chiński': {'en': 'Chinese', 'de': 'Chinesisch'},
    'chiński': {'en': 'Chinese', 'de': 'Chinesisch'},
    'łacina': {'en': 'Latin', 'de': 'Latein'},
    'historia': {'en': 'History', 'de': 'Geschichte'},
    'historia i teraźniejszość': {'en': 'History & Present', 'de': 'Geschichte & Gegenwart'},
    'hit': {'en': 'History & Present', 'de': 'Geschichte & Gegenwart'},
    'wiedza o społeczeństwie': {'en': 'Civics', 'de': 'Sozialkunde'},
    'wos': {'en': 'Civics', 'de': 'Sozialkunde'},
    'filozofia': {'en': 'Philosophy', 'de': 'Philosophie'},
    'etyka': {'en': 'Ethics', 'de': 'Ethik'},
    'religia': {'en': 'Religion', 'de': 'Religion'},
    'wiedza o kulturze': {'en': 'Cultural Studies', 'de': 'Kulturwissenschaft'},
    'wok': {'en': 'Cultural Studies', 'de': 'Kulturwissenschaft'},
    'matematyka': {'en': 'Mathematics', 'de': 'Mathematik'},
    'mat': {'en': 'Math', 'de': 'Mathe'},
    'fizyka': {'en': 'Physics', 'de': 'Physik'},
    'chemia': {'en': 'Chemistry', 'de': 'Chemie'},
    'biologia': {'en': 'Biology', 'de': 'Biologie'},
    'geografia': {'en': 'Geography', 'de': 'Geografie'},
    'przyroda': {'en': 'Science', 'de': 'Naturwissenschaften'},
    'informatyka': {'en': 'Computer Science', 'de': 'Informatik'},
    'technika': {'en': 'Technical Ed.', 'de': 'Technik'},
    'wychowanie fizyczne': {'en': 'Physical Education', 'de': 'Sport'},
    'wf': {'en': 'PE', 'de': 'Sport'},
    'plastyka': {'en': 'Art', 'de': 'Kunst'},
    'muzyka': {'en': 'Music', 'de': 'Musik'},
    'rysunek techniczny': {'en': 'Technical Drawing', 'de': 'Technisches Zeichnen'},
    'edukacja dla bezpieczeństwa': {'en': 'Safety Education', 'de': 'Sicherheitserziehung'},
    'edb': {'en': 'Safety Ed.', 'de': 'Sicherheitserz.'},
    'podstawy przedsiębiorczości': {'en': 'Entrepreneurship', 'de': 'Unternehmertum'},
    'przedsiębiorczość': {'en': 'Entrepreneurship', 'de': 'Unternehmertum'},
    'godzina wychowawcza': {'en': 'Homeroom', 'de': 'Klassenlehrerstunde'},
    'zajęcia z wychowawcą': {'en': 'Homeroom', 'de': 'Klassenlehrerstunde'},
    'doradztwo zawodowe': {'en': 'Career Guidance', 'de': 'Berufsberatung'},
    'wdż': {'en': 'Family Life Ed.', 'de': 'Familienkunde'},
    'wychowanie do życia w rodzinie': {'en': 'Family Life Ed.', 'de': 'Familienkunde'},
    'programowanie': {'en': 'Programming', 'de': 'Programmierung'},
    'sieci komputerowe': {'en': 'Computer Networks', 'de': 'Computernetzwerke'},
    'bazy danych': {'en': 'Databases', 'de': 'Datenbanken'},
    'systemy operacyjne': {'en': 'Operating Systems', 'de': 'Betriebssysteme'},
    'urządzenia techniki komputerowej': {'en': 'Computer Hardware', 'de': 'Computerhardware'},
    'witryny i aplikacje internetowe': {'en': 'Web Dev', 'de': 'Webentwicklung'},
    'pracownia': {'en': 'Lab', 'de': 'Labor'},
    'inf.03. przygotowanie do egzaminu': {'en': 'INF.03. Exam Preparation', 'de': 'INF.03. Vorbereitung auf die Prüfung'},
    'inf.03. przygotowanie do egzaminu zawodowego': {'en': 'INF.03. Vocational Exam Prep', 'de': 'INF.03. Vorbereitung auf die Fachprüfung'},
    'przygotowanie do egzaminu': {'en': 'Exam Preparation', 'de': 'Prüfungsvorbereitung'},
    'grafika komputerowa': {'en': 'Computer Graphics', 'de': 'Computergrafik'},
    'pracownia grafiki komputerowej': {'en': 'Computer Graphics Lab', 'de': 'Computergrafik-Labor'},
    'matura próbna pp': {'en': 'Mock Matura (Basic)', 'de': 'Probe-Abitur (Grundniveau)'},
    'matura próbna pr': {'en': 'Mock Matura (Extended)', 'de': 'Probe-Abitur (Erweitert)'},
    'matura próbna': {'en': 'Mock Matura', 'de': 'Probe-Abitur'},
    'procenty': {'en': 'Percentages', 'de': 'Prozent'},
    'wejściówka': {'en': 'Entrance Test', 'de': 'Einlasstest'},
    'zajęcia profilaktyczne z psychologiem': {'en': 'Preventive Classes with Psychologist', 'de': 'Präventionsunterricht mit Psychologen'},
    'edukacja zdrowotna': {'en': 'Health Education', 'de': 'Gesundheitserziehung'},
    'test': {'en': 'Test', 'de': 'Test'},
    'quiz': {'en': 'Quiz', 'de': 'Quiz'},
    'homework': {'en': 'Homework', 'de': 'Hausaufgabe'},
    'activity': {'en': 'Activity', 'de': 'Aktivität'},
    'bonus': {'en': 'Bonus', 'de': 'Bonus'},
    'śródroczna': {'en': 'Midterm', 'de': 'Halbjahres'},
    'sródroczna': {'en': 'Midterm', 'de': 'Halbjahres'},
    'roczna': {'en': 'Annual', 'de': 'Jahres'},
    'przewidywana śródroczna': {'en': 'Predicted Midterm', 'de': 'Vorh. Halbjahres'},
    'przewidywana sródroczna': {'en': 'Predicted Midterm', 'de': 'Vorh. Halbjahres'},
    'przewidywana roczna': {'en': 'Predicted Annual', 'de': 'Vorh. Jahres'},
    'proponowana śródroczna': {'en': 'Proposed Midterm', 'de': 'Vorgesch. Halbjahres'},
    'proponowana roczna': {'en': 'Proposed Annual', 'de': 'Vorgesch. Jahres'},
    'aktywność': {'en': 'Activity', 'de': 'Aktivität'},
    'zachowanie': {'en': 'Behavior', 'de': 'Verhalten'},
    'praca klasowa': {'en': 'Class Test', 'de': 'Klassenarbeit'},
    'kartkówka': {'en': 'Short Test', 'de': 'Kurztest'},
    'odpowiedź ustna': {'en': 'Oral Answer', 'de': 'Mündliche Antwort'},
    'zadanie domowe': {'en': 'Homework', 'de': 'Hausaufgabe'},
    'projekt': {'en': 'Project', 'de': 'Projekt'},
    'prezentacja': {'en': 'Presentation', 'de': 'Präsentation'},
    'referat': {'en': 'Paper', 'de': 'Referat'},
    'praca dodatkowa': {'en': 'Extra Work', 'de': 'Zusatzarbeit'},
    'konkurs': {'en': 'Competition', 'de': 'Wettbewerb'},
    'dyktando': {'en': 'Dictation', 'de': 'Diktat'},
    'wypracowanie': {'en': 'Essay', 'de': 'Aufsatz'},
    'lektura': {'en': 'Reading', 'de': 'Lektüre'},
    'ćwiczenia': {'en': 'Exercises', 'de': 'Übungen'},
    'laboratorium': {'en': 'Lab', 'de': 'Labor'},
    'egzamin': {'en': 'Exam', 'de': 'Prüfung'},
    'sprawdzian': {'en': 'Test', 'de': 'Test'},
    'ocena semestralna': {'en': 'Semester Grade', 'de': 'Semesternote'},
    'ocena końcowa': {'en': 'Final Grade', 'de': 'Endnote'},
  };

  static bool _containsWord(String text, String pattern) {
    int index = text.indexOf(pattern);
    while (index != -1) {
      bool startOk = index == 0 || !_isAlphanumeric(text.codeUnitAt(index - 1));
      bool endOk = index + pattern.length == text.length || !_isAlphanumeric(text.codeUnitAt(index + pattern.length));
      if (startOk && endOk) return true;
      index = text.indexOf(pattern, index + 1);
    }
    return false;
  }

  static bool _isAlphanumeric(int charCode) {
    if (charCode >= 97 && charCode <= 122) return true;
    if (charCode >= 65 && charCode <= 90) return true;
    if (charCode >= 48 && charCode <= 57) return true;
    const polishCodes = {
      261, 263, 281, 322, 324, 243, 347, 379, 381,
      260, 262, 280, 321, 323, 211, 346, 378, 380
    };
    return polishCodes.contains(charCode);
  }

  static String translate(BuildContext? context, String name) {
    if (context == null) return name;
    final locale = Localizations.localeOf(context).languageCode;

    final normalized = name.toLowerCase().trim();
    
    // Check cache first
    final cacheKey = '${locale}_$normalized';
    if (_cache.containsKey(cacheKey)) return _cache[cacheKey]!;

    // 1. Check exact match first
    if (_translations.containsKey(normalized)) {
      final result = _translations[normalized]![locale] ?? name;
      _cache[cacheKey] = result;
      return result;
    }

    // 2. Check partial/word match, sorting keys by length descending to match longest first
    final sortedKeys = _translations.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    for (var key in sortedKeys) {
      if (_containsWord(normalized, key)) {
        final result = _translations[key]![locale] ?? name;
        _cache[cacheKey] = result;
        return result;
      }
    }

    return name;
  }

  static Future<String> translateAsync(BuildContext context, String name) async {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'pl') return name;
    final syncResult = translate(context, name);
    if (syncResult != name) return syncResult;

    final normalized = name.toLowerCase().trim();
    final cacheKey = '${locale}_$normalized';

    if (_cache.containsKey(cacheKey)) return _cache[cacheKey]!;
    if (_inFlight.containsKey(cacheKey)) return _inFlight[cacheKey]!;

    final future = _translateWithGoogle(locale, name, cacheKey);
    _inFlight[cacheKey] = future;

    return future;
  }

  static Future<String> _translateWithGoogle(
    String locale,
    String name,
    String cacheKey,
  ) async {

    try {
      final url = 'https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=$locale&dt=t&q=${Uri.encodeComponent(name)}';
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 4),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data[0][0][0].toString();
        _cache[cacheKey] = result;
        return result;
      }
      return name;
    } on TimeoutException {
      return name;
    } catch (_) {
      return name;
    } finally {
      _inFlight.remove(cacheKey);
    }
  }
}
