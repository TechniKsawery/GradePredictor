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
  String get appName => 'GradePredictor';

  @override
  String get login => 'Einloggen';

  @override
  String get signUp => 'Registrieren';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get welcomeBack => 'Willkommen zurück!';

  @override
  String get newHere => 'Neu hier? Konto erstellen';

  @override
  String get alreadyHaveAccount => 'Konto? Einloggen';

  @override
  String get subjects => 'Fächer';

  @override
  String get addSubject => 'Fach hinzufügen';

  @override
  String get newSubject => 'Neues Fach';

  @override
  String get subjectNameHint => 'Fachname (z.B. Mathe)';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get save => 'Speichern';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get confirmDelete => 'Sind Sie sicher?';

  @override
  String get deleteSubjectConfirm => 'Dies löscht das Fach und alle Noten.';

  @override
  String get editSubject => 'Fach bearbeiten';

  @override
  String get noSubjects => 'Keine Fächer. Fügen Sie eines hinzu!';

  @override
  String get currentAverage => 'Aktueller Durchschnitt';

  @override
  String get tapToSeeGrades => 'Noten anzeigen';

  @override
  String get addGrade => 'Note hinzufügen';

  @override
  String get editGrade => 'Note bearbeiten';

  @override
  String get gradeHint => 'Note (z.B. 1.0)';

  @override
  String get weight => 'Gewichtung';

  @override
  String get weightHint => 'Gewichtung (z.B. 2.0)';

  @override
  String get type => 'Typ';

  @override
  String get predict => 'Vorhersage';

  @override
  String get settings => 'Einstellungen';

  @override
  String get displayName => 'Anzeigename';

  @override
  String get profileDescription => 'Anzeigenamen ändern';

  @override
  String get enterName => 'Name eingeben';

  @override
  String get profileUpdated => 'Profil aktualisiert!';

  @override
  String get changeLanguage => 'Sprache ändern';

  @override
  String get languageDescription => 'Bevorzugte Sprache wählen';

  @override
  String get chooseLanguage => 'Sprache wählen';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get passwordDescription => 'Kontosicherheit aktualisieren';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get passwordHint => 'Min. 6 Zeichen';

  @override
  String get passwordUpdated => 'Passwort aktualisiert!';

  @override
  String get multiAccount => 'Multi-Account';

  @override
  String get multiAccountSubtitle =>
      'Wechseln Sie zwischen Profilen von Kindern oder Freunden';

  @override
  String get addAccount => 'Konto hinzufügen';

  @override
  String get addRegisterAccount => 'Hinzufügen / Registrieren';

  @override
  String get gradingScale => 'Notenskala (%)';

  @override
  String get gradingScaleSubtitle => 'Eigene Prozentschwellen';

  @override
  String get newRegistration => 'Neue Registrierung?';

  @override
  String get registerNewChild => 'Kind registrieren';

  @override
  String get addExistingAccount => 'Konto hinzufügen';

  @override
  String get childUserName => 'Name des Kindes';

  @override
  String get nameHint => 'z.B. Anja';

  @override
  String get user => 'Benutzer';

  @override
  String get editName => 'Name bearbeiten';

  @override
  String switchedTo(Object name) {
    return 'Gewechselt zu $name';
  }

  @override
  String get grade6Label => 'Note 6 (Hervorragend)';

  @override
  String get grade5Label => 'Note 5 (Sehr gut)';

  @override
  String get grade4Label => 'Note 4 (Gut)';

  @override
  String get grade3Label => 'Note 3 (Befriedigend)';

  @override
  String get grade2Label => 'Note 2 (Ausreichend)';

  @override
  String error(Object message) {
    return 'Fehler: $message';
  }

  @override
  String get accountCreated => 'Konto erstellt!';

  @override
  String get statistics => 'Statistiken';

  @override
  String get performance => 'Fachleistung';

  @override
  String get insights => 'Einblicke';

  @override
  String get subjectsToRescue => 'Fächer zu retten';

  @override
  String get bestSubject => 'Bestes Fach';

  @override
  String get calculate => 'Berechnen';

  @override
  String get targetAverage => 'Zieldurchschnitt';

  @override
  String get nextAssignmentWeight => 'Gewichtung der nächsten Note';

  @override
  String impossible(Object needed) {
    return 'Unmöglich! Du bräuchtest $needed';
  }

  @override
  String easy(Object needed) {
    return 'Einfach! Du brauchst nur 1,0 (oder weniger: $needed)';
  }

  @override
  String neededAtLeast(Object needed) {
    return 'Du musst mindestens eine $needed bekommen';
  }

  @override
  String get gradePredictor => 'Notenrechner';

  @override
  String get changeEmail => 'E-Mail ändern';

  @override
  String get changeEmailDescription => 'E-Mail-Adresse aktualisieren';

  @override
  String get newEmail => 'Neue E-Mail-Adresse';

  @override
  String get emailUpdated => 'E-Mail aktualisiert! Posteingang prüfen.';
}
