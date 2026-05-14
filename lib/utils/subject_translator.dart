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
  };

  static String translate(BuildContext? context, String name) {
    if (context == null) return name;
    final locale = Localizations.localeOf(context).languageCode;

    final normalized = name.toLowerCase().trim();
    
    // Check cache first
    final cacheKey = '${locale}_$normalized';
    if (_cache.containsKey(cacheKey)) return _cache[cacheKey]!;

    for (var entry in _translations.entries) {
      if (normalized == entry.key || normalized.contains(entry.key)) {
        final result = entry.value[locale] ?? name;
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
