// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'GradePredictor';

  @override
  String get login => 'Einloggen';

  @override
  String get signUp => 'Registrieren';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get welcomeBack => 'Willkommen zurück, Student!';

  @override
  String get newHere => 'Neu hier? Konto erstellen';

  @override
  String get alreadyHaveAccount => 'Bereits ein Konto? Einloggen';

  @override
  String get subjects => 'Fächer';

  @override
  String get addSubject => 'Fach hinzufügen';

  @override
  String get newSubject => 'Neues Fach';

  @override
  String get subjectNameHint => 'Fachname (z.B. Mathematik)';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get currentAverage => 'Aktueller Durchschnitt';

  @override
  String get addGrade => 'Note hinzufügen';

  @override
  String get predict => 'Vorhersagen';

  @override
  String get weight => 'Gewichtung';

  @override
  String get type => 'Typ';

  @override
  String get gradeHint => 'Note (z.B. 5)';

  @override
  String get weightHint => 'Gewichtung (z.B. 1.0)';

  @override
  String get gradePredictor => 'Notenrechner';

  @override
  String get targetAverage => 'Zieldurchschnitt';

  @override
  String get nextAssignmentWeight => 'Gewichtung der nächsten Note';

  @override
  String get calculate => 'Berechnen';

  @override
  String get statistics => 'Statistiken';

  @override
  String get performance => 'Fachleistung';

  @override
  String get insights => 'Schnelle Einblicke';

  @override
  String get subjectsToRescue => 'Fächer zum \'Retten\'';

  @override
  String get bestSubject => 'Bestes Fach';

  @override
  String get noSubjects => 'Noch keine Fächer hinzugefügt.';

  @override
  String get checkEmail => 'Überprüfen Sie Ihre E-Mail zur Bestätigung!';

  @override
  String get accountCreated => 'Konto erstellt! Bitte einloggen.';

  @override
  String impossible(Object needed) {
    return 'Unmöglich! Sie bräuchten eine $needed';
  }

  @override
  String easy(Object needed) {
    return 'Einfach! Sie brauchen nur eine 1.0 (oder weniger: $needed)';
  }

  @override
  String neededAtLeast(Object needed) {
    return 'Sie müssen mindestens eine $needed bekommen';
  }

  @override
  String get settings => 'Einstellungen';

  @override
  String get displayName => 'Anzeigename';

  @override
  String get changePassword => 'Kennwort ändern';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get update => 'Aktualisieren';

  @override
  String get profileUpdated => 'Profil erfolgreich aktualisiert!';

  @override
  String get passwordUpdated => 'Passwort erfolgreich aktualisiert!';

  @override
  String error(Object message) {
    return 'Fehler: $message';
  }

  @override
  String get changeLanguage => 'Sprache ändern';
}
