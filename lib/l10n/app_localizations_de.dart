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

  @override
  String get appearanceTitle => 'Design';

  @override
  String get appearanceSubtitle => 'Thema und App-Stil';

  @override
  String get themeLight => 'Hell ☀️';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dunkel 🌙';

  @override
  String get settingsHeroTitle => 'Deine Lernzone ✨';

  @override
  String get settingsHeroSubtitle =>
      'Themen, Konten und Notenskala an einem Ort.';

  @override
  String get remainingToggle => 'Mehrere Klassenarbeiten';

  @override
  String get remainingWeightsTitle => 'Verbleibende Arbeiten (Gewichtungen)';

  @override
  String get addWeight => 'Gewichtung hinzufügen';

  @override
  String remainingImpossible(Object needed) {
    return 'Unmöglich! Du brauchst im Schnitt $needed';
  }

  @override
  String remainingEasy(Object needed) {
    return 'Einfach! Du brauchst im Schnitt nur 1,0 (oder weniger: $needed)';
  }

  @override
  String remainingNeededAtLeast(Object needed) {
    return 'Du brauchst im Schnitt mindestens: $needed';
  }

  @override
  String get calendarTitle => 'Kalender der Arbeiten';

  @override
  String get addExam => 'Arbeit hinzufügen';

  @override
  String get editExam => 'Arbeit bearbeiten';

  @override
  String get examTitle => 'Name der Arbeit';

  @override
  String get examDate => 'Datum';

  @override
  String get examSubject => 'Fach';

  @override
  String get maxPoints => 'Max. Punkte';

  @override
  String get pointsMode => 'Punkte';

  @override
  String get pointsEarned => 'Erreichte Punkte';

  @override
  String get gradingModeLabel => 'Bewertungsart';

  @override
  String get gradingModeGrades => 'Noten 1-6';

  @override
  String get gradingModePoints => 'Punkte';

  @override
  String get gradingModeMixed => 'Gemischt';

  @override
  String get maxNormalPoints => 'Max. Punkte (normal)';

  @override
  String get maxBonusPoints => 'Max. Punkte (Bonus)';

  @override
  String get chooseDate => 'Datum wählen';

  @override
  String get noExams => 'Keine Arbeiten. Füge die erste hinzu!';

  @override
  String get deleteExamConfirm => 'Dies entfernt die Arbeit aus dem Kalender.';

  @override
  String get infoTitle => 'So funktioniert\'s';

  @override
  String get infoBody =>
      'Die App berechnet den aktuellen Durchschnitt und zeigt, was du bei den verbleibenden Arbeiten brauchst, um die Note zu halten oder zu verbessern. Fortschrittsdiagramme und Statistiken zeigen, welche Fächer du in letzter Minute \"rettest\".';

  @override
  String get ok => 'OK';

  @override
  String get validationAllFields => 'Bitte füllen Sie alle Felder aus!';

  @override
  String get unknownSubject => 'Unbekanntes Fach';

  @override
  String get validationSubjectName => 'Fachnamen eingeben';

  @override
  String get validationMaxPoints => 'Gültige Maximalpunktzahl eingeben';

  @override
  String get validationGrade => 'Gültige Note eingeben (1-6)';

  @override
  String get validationPoints => 'Punkte und Max. Punkte eingeben';

  @override
  String get validationWeight => 'Gewichtung muss größer als 0 sein';

  @override
  String get validationExamTitle => 'Name der Arbeit eingeben';

  @override
  String get noSubjectsForExams => 'Zuerst Fächer hinzufügen';

  @override
  String get noSubjectsShort => 'Keine Fächer';

  @override
  String get predictionFirstAddGrade => 'Fügen Sie zuerst eine Note hinzu!';

  @override
  String get predictionPointsSurplus =>
      'Sie haben bereits genug Punkte für dieses Ziel!';

  @override
  String predictionPointsCurrentStatus(Object current, Object target) {
    return 'Ihr aktueller Stand ist $current%, und das Ziel ist $target%.';
  }

  @override
  String predictionPointsMissing(Object remaining, Object target) {
    return 'Mit den aktuellen Noten fehlen Ihnen $remaining Pkt, um $target% zu erreichen';
  }

  @override
  String get predictionPointsNoExamsRecommendation =>
      'Tragen Sie kommende Prüfungen in den Kalender ein – es wird sicher Gelegenheiten geben, diese Punkte zu sammeln!';

  @override
  String get predictionGoalEasy => 'Sie werden das Ziel problemlos erreichen!';

  @override
  String predictionGoalEasyExplanation(Object target) {
    return 'Selbst mit 0 Pkt aus kommenden Prüfungen wird Ihr Stand nicht unter $target% fallen.';
  }

  @override
  String get predictionImpossibleShort => 'Leider ist das Ziel unerreichbar.';

  @override
  String predictionPointsImpossibleExplanation(Object extra) {
    return 'Selbst mit 100% aus den aktuellen Prüfungen fehlen Ihnen noch $extra Pkt.';
  }

  @override
  String predictionPointsRescueRecommendation(Object extra) {
    return 'Zusätzlich zu den Kalenderprüfungen müssen Sie weitere $extra Pkt (z.B. durch Zusatzprojekte) sammeln, um Ihr Ziel zu erreichen.';
  }

  @override
  String get predictionPointsNeededList =>
      'Sie müssen die kommenden Prüfungen bestehen mit:';

  @override
  String predictionPointsNeededExplanation(Object remaining, Object total) {
    return 'Sie benötigen $remaining Pkt von $total möglichen.';
  }

  @override
  String get predictionPointsFocusAdvice =>
      'Konzentrieren Sie sich besonders auf die größte Prüfung – dort können Sie am meisten gewinnen!';

  @override
  String get predictionGradesForecastTitle => 'Prognose für zukünftige Noten:';

  @override
  String predictionGradesNoExamsExplanation(Object target) {
    return 'Keine Daten im Kalender. Ich habe geprüft, was Sie brauchen, damit Ihr Durchschnitt auf $target steigt.';
  }

  @override
  String get predictionGradesNoExamsRecommendation =>
      'Fügen Sie kommende Prüfungen zum Kalender hinzu, damit wir wissen, wie viele Gewichte bis Jahresende noch offen sind!';

  @override
  String predictionGradesWeightScenario(Object weight) {
    return 'Note mit Gewicht $weight';
  }

  @override
  String predictionGradesImpossibleWhy(Object best) {
    return 'Wenn Sie eine 6 bekommen, steigt Ihr Durchschnitt nur na $best.';
  }

  @override
  String get predictionGradesRescuePlanTitle =>
      'Kalender reicht nie. Sie brauchen einen Rettungsplan!';

  @override
  String predictionGradesImpossibleExplanation(Object best) {
    return 'Selbst mit lauter 6ern aus Kalenderprüfungen steigt Ihr Durchschnitt nur na $best.';
  }

  @override
  String predictionGradesRescueRecommendation(Object extra, Object target) {
    return 'Zusätzlich zu den Kalenderprüfungen müssen Sie noch $extra zusätzliche \'6\' Noten (Gewicht 1.0) erreichen, um einen Durchschnitt von $target zu erhalten.';
  }

  @override
  String get predictionGradesExamsNeededList =>
      'Sie müssen die kommenden Prüfungen bestehen mit:';

  @override
  String get predictionGradesExamsNeededExplanation =>
      'Ich habe die Durchschnittsnote aus wszystkich kommenden Prüfungen berechnet.';

  @override
  String get predictionGradesExtraCreditAdvice =>
      'Wenn te Prüfungen nie wszystko sind, versuchen Sie, zusätzliche Punkte für Aktivität zu bekommen!';

  @override
  String get predictionTargetLabel => 'Zielnote oder %';

  @override
  String get predictionTargetHint => 'z.B. 4 oder 90';

  @override
  String predictionMinGrade(Object grade) {
    return 'min. $grade';
  }

  @override
  String get predictionOrSeparator => 'ODER';

  @override
  String get gradeTypeTest => 'Klassenarbeit';

  @override
  String get gradeTypeQuiz => 'Test';

  @override
  String get gradeTypeHomework => 'Hausaufgabe';

  @override
  String get gradeTypeActivity => 'Mitarbeit';

  @override
  String get gradeTypeBonus => 'Bonus';

  @override
  String get predictionAdviceKeepItUp =>
      'Gute Arbeit! Behalten Sie dieses Niveau bei zukünftigen Aufgaben bei.';

  @override
  String get predictionAdviceSleepWell =>
      'Sie können beruhigt schlafen, aber geben Sie nie völlig auf!';

  @override
  String get predictionAdviceFocusOnBig =>
      'Konzentrieren Sie sich besonders na die größte Prüfung – dort können Sie am meisten gewinnen!';

  @override
  String get predictionAdviceExtraCredit =>
      'Wenn te Prüfungen nie wszystko sind, versuchen Sie, zusätzliche Punkte für Mitarbeit zu bekommen!';

  @override
  String get customGradingScaleTitle => 'Eigene Notenskala';

  @override
  String get resetToGlobal => 'Auf allgemeine Skala zurücksetzen';

  @override
  String get customScaleSaved => 'Eigene Skala gespeichert!';
}
