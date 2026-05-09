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
  String get appName => 'GradePredictor';

  @override
  String get login => 'Zaloguj się';

  @override
  String get signUp => 'Zarejestruj się';

  @override
  String get email => 'Email';

  @override
  String get password => 'Hasło';

  @override
  String get welcomeBack => 'Witaj z powrotem!';

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
  String get save => 'Zapisz';

  @override
  String get edit => 'Edytuj';

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
  String get noSubjects => 'Brak przedmiotów. Dodaj pierwszy!';

  @override
  String get currentAverage => 'Aktualna średnia';

  @override
  String get tapToSeeGrades => 'Dotknij, aby zobaczyć oceny';

  @override
  String get addGrade => 'Dodaj ocenę';

  @override
  String get editGrade => 'Edytuj ocenę';

  @override
  String get gradeHint => 'Ocena (np. 5.0)';

  @override
  String get weight => 'Waga';

  @override
  String get weightHint => 'Waga (np. 2.0)';

  @override
  String get type => 'Typ';

  @override
  String get predict => 'Prognozuj';

  @override
  String get settings => 'Ustawienia';

  @override
  String get displayName => 'Nazwa użytkownika';

  @override
  String get profileDescription => 'Zmień swoją nazwę wyświetlaną';

  @override
  String get enterName => 'Wpisz imię';

  @override
  String get profileUpdated => 'Profil zaktualizowany!';

  @override
  String get changeLanguage => 'Zmień język';

  @override
  String get languageDescription => 'Wybierz preferowany język';

  @override
  String get chooseLanguage => 'Wybierz język';

  @override
  String get changePassword => 'Zmień hasło';

  @override
  String get passwordDescription => 'Zaktualizuj zabezpieczenia konta';

  @override
  String get newPassword => 'Nowe hasło';

  @override
  String get passwordHint => 'Min. 6 znaków';

  @override
  String get passwordUpdated => 'Hasło zmienione!';

  @override
  String get multiAccount => 'Wiele Kont';

  @override
  String get multiAccountSubtitle =>
      'Przełączaj się między profilami dzieci lub znajomych';

  @override
  String get addAccount => 'Dodaj konto';

  @override
  String get addRegisterAccount => 'Dodaj / Zarejestruj konto';

  @override
  String get gradingScale => 'Skala ocen (%)';

  @override
  String get gradingScaleSubtitle => 'Własne progi procentowe';

  @override
  String get newRegistration => 'Nowa rejestracja?';

  @override
  String get registerNewChild => 'Zarejestruj nowe dziecko';

  @override
  String get addExistingAccount => 'Dodaj istniejące konto';

  @override
  String get childUserName => 'Imię / Nazwa';

  @override
  String get nameHint => 'np. Ania';

  @override
  String get user => 'Użytkownik';

  @override
  String get editName => 'Edytuj nazwę';

  @override
  String switchedTo(Object name) {
    return 'Przełączono na $name';
  }

  @override
  String get grade6Label => 'Ocena 6 (Celujący)';

  @override
  String get grade5Label => 'Ocena 5 (Bardzo dobry)';

  @override
  String get grade4Label => 'Ocena 4 (Dobry)';

  @override
  String get grade3Label => 'Ocena 3 (Dostateczny)';

  @override
  String get grade2Label => 'Ocena 2 (Dopuszczający)';

  @override
  String error(Object message) {
    return 'Błąd: $message';
  }

  @override
  String get accountCreated => 'Konto utworzone!';

  @override
  String get statistics => 'Statystyki';

  @override
  String get performance => 'Wyniki przedmiotów';

  @override
  String get insights => 'Szybkie wglądy';

  @override
  String get subjectsToRescue => 'Przedmioty do poprawy';

  @override
  String get bestSubject => 'Najlepszy przedmiot';

  @override
  String get calculate => 'Oblicz';

  @override
  String get targetAverage => 'Docelowa średnia';

  @override
  String get nextAssignmentWeight => 'Waga następnej oceny';

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
  String get gradePredictor => 'Kalkulator ocen';

  @override
  String get changeEmail => 'Zmień e-mail';

  @override
  String get changeEmailDescription => 'Zaktualizuj adres e-mail konta';

  @override
  String get newEmail => 'Nowy adres e-mail';

  @override
  String get emailUpdated => 'E-mail zaktualizowany! Sprawdź skrzynkę.';
}
