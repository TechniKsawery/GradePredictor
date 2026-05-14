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

  @override
  String get appearanceTitle => 'Wygląd';

  @override
  String get appearanceSubtitle => 'Motyw i styl aplikacji';

  @override
  String get themeLight => 'Jasny ☀️';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Ciemny 🌙';

  @override
  String get settingsHeroTitle => 'Twoja strefa nauki ✨';

  @override
  String get settingsHeroSubtitle =>
      'Motywy, konta i skala ocen w jednym miejscu.';

  @override
  String get remainingToggle => 'Wiele sprawdzianów';

  @override
  String get remainingWeightsTitle => 'Pozostałe sprawdziany (wagi)';

  @override
  String get addWeight => 'Dodaj wagę';

  @override
  String remainingImpossible(Object needed) {
    return 'Niemożliwe! Średnio potrzebujesz $needed';
  }

  @override
  String remainingEasy(Object needed) {
    return 'Łatwo! Średnio potrzebujesz 1.0 (lub mniej: $needed)';
  }

  @override
  String remainingNeededAtLeast(Object needed) {
    return 'Średnio musisz dostać co najmniej: $needed';
  }

  @override
  String get calendarTitle => 'Kalendarz sprawdzianów';

  @override
  String get addExam => 'Dodaj sprawdzian';

  @override
  String get editExam => 'Edytuj sprawdzian';

  @override
  String get examTitle => 'Nazwa sprawdzianu';

  @override
  String get examDate => 'Data';

  @override
  String get examSubject => 'Przedmiot';

  @override
  String get maxPoints => 'Maks. punktów';

  @override
  String get pointsMode => 'Punkty';

  @override
  String get pointsEarned => 'Zdobyte punkty';

  @override
  String get gradingModeLabel => 'Rodzaj oceniania';

  @override
  String get gradingModeGrades => 'Oceny 1-6';

  @override
  String get gradingModePoints => 'Punkty';

  @override
  String get gradingModeMixed => 'Mieszane';

  @override
  String get maxNormalPoints => 'Maks. punktów (normalnych)';

  @override
  String get maxBonusPoints => 'Maks. punktów (bonusowych)';

  @override
  String get chooseDate => 'Wybierz datę';

  @override
  String get noExams => 'Brak sprawdzianów. Dodaj pierwszy!';

  @override
  String get deleteExamConfirm => 'To usunie sprawdzian z kalendarza.';

  @override
  String get infoTitle => 'Jak to działa?';

  @override
  String get infoBody =>
      'Aplikacja liczy aktualną średnią i pokazuje ile musisz dostać z pozostałych sprawdzianów, żeby utrzymać/podnieść ocenę. Wykresy postępów, statystyki które przedmioty \"ratujesz\" w ostatniej chwili.';

  @override
  String get ok => 'OK';

  @override
  String get validationAllFields => 'Uzupełnij wszystkie pola!';

  @override
  String get unknownSubject => 'Nieznany przedmiot';

  @override
  String get validationSubjectName => 'Podaj nazwę przedmiotu';

  @override
  String get validationMaxPoints => 'Podaj prawidłową liczbę punktów';

  @override
  String get validationGrade => 'Wpisz poprawną ocenę (1-6)';

  @override
  String get validationPoints => 'Wpisz punkty i punkty maksymalne';

  @override
  String get validationWeight => 'Waga musi być większa od 0';

  @override
  String get validationExamTitle => 'Wpisz nazwę sprawdzianu';

  @override
  String get noSubjectsForExams => 'Dodaj przedmioty, aby planować sprawdziany';

  @override
  String get calendarNoSubjectsInfo =>
      'Nie możesz dodać sprawdzianu, dopóki nie dodasz chociaż jednego przedmiotu w zakładce Przedmioty.';

  @override
  String get noSubjectsShort => 'Brak przedmiotów';

  @override
  String get predictionFirstAddGrade => 'Najpierw dodaj jakąś ocenę!';

  @override
  String get predictionPointsSurplus => 'Masz już zapas punktów na ten cel!';

  @override
  String predictionPointsCurrentStatus(Object current, Object target) {
    return 'Twój obecny wynik to $current%, a cel to $target%.';
  }

  @override
  String predictionPointsMissing(Object remaining, Object target) {
    return 'Przy obecnej sumie punktów brakuje Ci jeszcze $remaining pkt do celu $target%';
  }

  @override
  String get predictionPointsNoExamsRecommendation =>
      'Wpisz nadchodzące sprawdziany do kalendarza – na pewno pojawią się okazje, by te punkty zdobyć!';

  @override
  String get predictionGoalEasy => 'Cel osiągniesz bez problemu!';

  @override
  String predictionGoalEasyExplanation(Object target) {
    return 'Nawet jeśli dostaniesz 0 pkt z nadchodzących sprawdzianów, Twój wynik nie spadnie poniżej $target%.';
  }

  @override
  String get predictionImpossibleShort => 'Niestety, cel jest nieosiągalny.';

  @override
  String predictionPointsImpossibleExplanation(Object extra) {
    return 'Nawet ze 100% z obecnych sprawdzianów brakuje Ci jeszcze $extra pkt.';
  }

  @override
  String predictionPointsRescueRecommendation(Object extra) {
    return 'Oprócz sprawdzianów z kalendarza, musisz zdobyć dodatkowe $extra pkt (np. z prac nadprogramowych), aby osiągnąć cel.';
  }

  @override
  String get predictionPointsNeededList =>
      'Twoje nadchodzące sprawdziany musisz zaliczyć na:';

  @override
  String predictionPointsNeededExplanation(Object remaining, Object total) {
    return 'Potrzebujesz $remaining pkt z nadchodzących $total możliwych.';
  }

  @override
  String get predictionPointsFocusAdvice =>
      'Skup się szczególnie na największym sprawdzianie – tam możesz najwięcej ugrać!';

  @override
  String get predictionGradesForecastTitle => 'Prognoza dla kolejnych ocen:';

  @override
  String predictionGradesNoExamsExplanation(Object target) {
    return 'Brak danych w kalendarzu. Sprawdziłem ile musisz dostać, żeby średnia wzrosła do $target.';
  }

  @override
  String get predictionGradesNoExamsRecommendation =>
      'Uzupełnij kalendarz o nadchodzące sprawdziany, żebyśmy wiedzieli ile wag zostało do końca roku!';

  @override
  String predictionGradesWeightScenario(Object weight) {
    return 'Ocena z wagą $weight';
  }

  @override
  String predictionGradesImpossibleWhy(Object best) {
    return 'Dostając 6, Twoja średnia wzrośnie tylko do $best.';
  }

  @override
  String get predictionGradesRescuePlanTitle =>
      'Kalendarz to za mało. Potrzebujesz planu ratunkowego!';

  @override
  String predictionGradesImpossibleExplanation(Object best) {
    return 'Nawet z samymi 6-tkami ze sprawdzianów w kalendarzu Twoja średnia wzrośnie tylko do $best.';
  }

  @override
  String predictionGradesRescueRecommendation(Object extra, Object target) {
    return 'Oprócz sprawdzianów z kalendarza, musisz zdobyć jeszcze dodatkowe $extra oceny \'6\' (o wadze 1.0), aby osiągnąć średnią $target.';
  }

  @override
  String get predictionGradesExamsNeededList =>
      'Nadchodzące sprawdziany musisz zaliczyć na:';

  @override
  String get predictionGradesExamsNeededExplanation =>
      'Wyliczyłem średnią ocenę ze wszystkich nadchodzących sprawdzianów.';

  @override
  String get predictionGradesExtraCreditAdvice =>
      'Jeśli te sprawdziany to nie wszystko, staraj się zdobyć dodatkowe plusy za aktywność!';

  @override
  String get predictionTargetLabel => 'Docelowa ocena lub %';

  @override
  String get predictionTargetHint => 'np. 4 lub 90';

  @override
  String predictionMinGrade(Object grade) {
    return 'min. $grade';
  }

  @override
  String get predictionOrSeparator => 'LUB';

  @override
  String get gradeTypeTest => 'Sprawdzian';

  @override
  String get gradeTypeQuiz => 'Kartkówka';

  @override
  String get gradeTypeHomework => 'Zadanie domowe';

  @override
  String get gradeTypeActivity => 'Aktywność';

  @override
  String get gradeTypeBonus => 'Dodatkowe';

  @override
  String get predictionAdviceKeepItUp =>
      'Dobra robota! Utrzymuj ten poziom w nadchodzących zadaniach.';

  @override
  String get predictionAdviceSleepWell =>
      'Możesz spać spokojnie, ale nie odpuszczaj całkowicie!';

  @override
  String get predictionAdviceFocusOnBig =>
      'Skup się szczególnie na największym sprawdzianie – tam możesz najwięcej ugrać!';

  @override
  String get predictionAdviceExtraCredit =>
      'Jeśli te sprawdziany to nie wszystko, staraj się zdobyć dodatkowe plusy za aktywność!';

  @override
  String get customGradingScaleTitle => 'Własna skala ocen';

  @override
  String get resetToGlobal => 'Przywróć ogólną skalę';

  @override
  String get customScaleSaved => 'Własna skala zapisana!';

  @override
  String get syncTitle => 'Import z e-dziennika';

  @override
  String get syncSubtitle =>
      'Połącz się ze swoim e-dziennikiem, aby automatycznie pobrać oceny i sprawdziany.';

  @override
  String get syncLoginLibrus => 'Login (Librus)';

  @override
  String get syncPassword => 'Hasło';

  @override
  String get syncStart => 'Rozpocznij synchronizację';

  @override
  String get syncSecurityNote =>
      'Twoje dane są bezpieczne i używane wyłącznie do pobrania ocen. Nie przechowujemy Twojego hasła.';

  @override
  String get syncDataFound => 'Znaleziono dane do importu:';

  @override
  String get syncGradesDetail => 'Szczegóły ocen (automatycznie wykryte):';

  @override
  String get syncConfirmImport => 'Zatwierdź i importuj';

  @override
  String get syncCancelReturn => 'Anuluj i wróć';

  @override
  String syncError(Object error) {
    return 'Błąd synchronizacji: $error';
  }

  @override
  String syncImportedCount(Object exams, Object grades) {
    return 'Zaimportowano: $grades ocen, $exams wydarzeń!';
  }

  @override
  String get syncLibrusLoginHint => 'Login (Librus)';

  @override
  String get syncVulcanTokenHint => 'Token (Vulcan)';

  @override
  String get syncVulcanSymbolLabel => 'Symbol (Vulcan)';

  @override
  String get syncVulcanPinLabel => 'Kod PIN';

  @override
  String get syncLibrusSyncButton => 'Importuj dane z e-dziennika';

  @override
  String syncTypeLabel(Object type) {
    return 'Typ: $type';
  }

  @override
  String syncWeightLabel(Object weight) {
    return 'Waga: $weight';
  }

  @override
  String syncPointsLabel(Object max, Object points) {
    return 'Pkt: $points/$max';
  }

  @override
  String get unknown => 'Nieznany';

  @override
  String get gradeLabel => 'Ocena';

  @override
  String get points => 'Punkty';

  @override
  String get bonus => 'Bonus';

  @override
  String get none => 'Brak';

  @override
  String get pdfReportTitle => 'Raport GradePredictor';

  @override
  String get pdfSummaryHeader => 'Podsumowanie aktualnych wyników:';

  @override
  String get pdfFooter => 'Wygenerowano przez aplikację GradePredictor';

  @override
  String get myAccount => 'Moje Konto';

  @override
  String get passwordTooShort => 'Hasło jest za krótkie';

  @override
  String get monthJanuary => 'Styczeń';

  @override
  String get monthFebruary => 'Luty';

  @override
  String get monthMarch => 'Marzec';

  @override
  String get monthApril => 'Kwiecień';

  @override
  String get monthMay => 'Maj';

  @override
  String get monthJune => 'Czerwiec';

  @override
  String get monthJuly => 'Lipiec';

  @override
  String get monthAugust => 'Sierpień';

  @override
  String get monthSeptember => 'Wrzesień';

  @override
  String get monthOctober => 'Październik';

  @override
  String get monthNovember => 'Listopad';

  @override
  String get monthDecember => 'Grudzień';

  @override
  String get dayMonday => 'Poniedziałek';

  @override
  String get dayTuesday => 'Wtorek';

  @override
  String get dayWednesday => 'Środa';

  @override
  String get dayThursday => 'Czwartek';

  @override
  String get dayFriday => 'Piątek';

  @override
  String get daySaturday => 'Sobota';

  @override
  String get daySunday => 'Niedziela';

  @override
  String get dayShortMonday => 'Pn';

  @override
  String get dayShortTuesday => 'Wt';

  @override
  String get dayShortWednesday => 'Śr';

  @override
  String get dayShortThursday => 'Cz';

  @override
  String get dayShortFriday => 'Pt';

  @override
  String get dayShortSaturday => 'So';

  @override
  String get dayShortSunday => 'Nd';

  @override
  String get monthShortJanuary => 'Sty';

  @override
  String get monthShortFebruary => 'Lut';

  @override
  String get monthShortMarch => 'Mar';

  @override
  String get monthShortApril => 'Kwi';

  @override
  String get monthShortMay => 'Maj';

  @override
  String get monthShortJune => 'Cze';

  @override
  String get monthShortJuly => 'Lip';

  @override
  String get monthShortAugust => 'Sie';

  @override
  String get monthShortSeptember => 'Wrz';

  @override
  String get monthShortOctober => 'Paź';

  @override
  String get monthShortNovember => 'Lis';

  @override
  String get monthShortDecember => 'Gru';

  @override
  String get disable => 'Wyłącz';

  @override
  String get librus => 'Librus';

  @override
  String get vulcan => 'Vulcan';

  @override
  String get autoSync => 'Auto-sync (co 15 minut)';
}
