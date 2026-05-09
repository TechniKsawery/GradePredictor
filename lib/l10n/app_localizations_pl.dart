// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'GradePredictor';

  @override
  String get login => 'Zaloguj się';

  @override
  String get signUp => 'Zarejestruj się';

  @override
  String get email => 'Email';

  @override
  String get password => 'Hasło';

  @override
  String get welcomeBack => 'Witaj z powrotem, studencie!';

  @override
  String get newHere => 'Nowy tutaj? Utwórz konto';

  @override
  String get alreadyHaveAccount => 'Masz już konto? Zaloguj się';

  @override
  String get subjects => 'Przedmioty';

  @override
  String get addSubject => 'Dodaj przedmiot';

  @override
  String get newSubject => 'Nowy przedmiot';

  @override
  String get subjectNameHint => 'Nazwa przedmiotu (np. Matematyka)';

  @override
  String get cancel => 'Anuluj';

  @override
  String get add => 'Dodaj';

  @override
  String get currentAverage => 'Aktualna średnia';

  @override
  String get addGrade => 'Dodaj ocenę';

  @override
  String get predict => 'Prognozuj';

  @override
  String get weight => 'Waga';

  @override
  String get type => 'Typ';

  @override
  String get gradeHint => 'Ocena (np. 5)';

  @override
  String get weightHint => 'Waga (np. 1.0)';

  @override
  String get gradePredictor => 'Kalkulator ocen';

  @override
  String get targetAverage => 'Docelowa średnia';

  @override
  String get nextAssignmentWeight => 'Waga następnej oceny';

  @override
  String get calculate => 'Oblicz';

  @override
  String get statistics => 'Statystyki';

  @override
  String get performance => 'Wyniki przedmiotów';

  @override
  String get insights => 'Szybkie wglądy';

  @override
  String get subjectsToRescue => 'Przedmioty do \'ratowania\'';

  @override
  String get bestSubject => 'Najlepszy przedmiot';

  @override
  String get noSubjects => 'Brak dodanych przedmiotów.';

  @override
  String get checkEmail => 'Sprawdź email w celu potwierdzenia!';

  @override
  String get accountCreated => 'Konto utworzone! Zaloguj się.';

  @override
  String impossible(Object needed) {
    return 'Niemożliwe! Potrzebowałbyś $needed';
  }

  @override
  String easy(Object needed) {
    return 'Łatwo! Potrzebujesz tylko 1.0 (lub mniej: $needed)';
  }

  @override
  String neededAtLeast(Object needed) {
    return 'Musisz dostać co najmniej: $needed';
  }

  @override
  String get settings => 'Ustawienia';

  @override
  String get displayName => 'Nazwa wyświetlana';

  @override
  String get changePassword => 'Zmień hasło';

  @override
  String get newPassword => 'Nowe hasło';

  @override
  String get update => 'Aktualizuj';

  @override
  String get profileUpdated => 'Profil zaktualizowany pomyślnie!';

  @override
  String get passwordUpdated => 'Hasło zaktualizowane pomyślnie!';

  @override
  String error(Object message) {
    return 'Błąd: $message';
  }

  @override
  String get changeLanguage => 'Zmień język';

  @override
  String get profileDescription => 'Tak będą Cię widzieć inni studenci';

  @override
  String get enterName => 'Wpisz swoją nazwę';

  @override
  String get languageDescription => 'Zmień język aplikacji';

  @override
  String get passwordDescription => 'Zaktualizuj zabezpieczenia konta';

  @override
  String get passwordHint => 'Minimum 6 znaków';

  @override
  String get delete => 'Usuń';

  @override
  String get confirmDelete => 'Czy na pewno?';

  @override
  String get deleteSubjectConfirm =>
      'To usunie przedmiot wraz ze wszystkimi ocenami.';

  @override
  String get editSubject => 'Edytuj przedmiot';

  @override
  String get editGrade => 'Edytuj ocenę';

  @override
  String get save => 'Zapisz';
}
