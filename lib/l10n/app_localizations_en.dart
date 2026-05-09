// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GradePredictor';

  @override
  String get appName => 'GradePredictor';

  @override
  String get login => 'Login';

  @override
  String get signUp => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get newHere => 'New here? Create an account';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get subjects => 'Subjects';

  @override
  String get addSubject => 'Add Subject';

  @override
  String get newSubject => 'New Subject';

  @override
  String get subjectNameHint => 'Subject name (e.g. Math)';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDelete => 'Are you sure?';

  @override
  String get deleteSubjectConfirm =>
      'This will delete the subject and all its grades.';

  @override
  String get editSubject => 'Edit Subject';

  @override
  String get noSubjects => 'No subjects. Add your first one!';

  @override
  String get currentAverage => 'Current Average';

  @override
  String get tapToSeeGrades => 'Tap to see grades';

  @override
  String get addGrade => 'Add Grade';

  @override
  String get editGrade => 'Edit Grade';

  @override
  String get gradeHint => 'Grade (e.g. 5.0)';

  @override
  String get weight => 'Weight';

  @override
  String get weightHint => 'Weight (e.g. 2.0)';

  @override
  String get type => 'Type';

  @override
  String get predict => 'Predict';

  @override
  String get settings => 'Settings';

  @override
  String get displayName => 'Display Name';

  @override
  String get profileDescription => 'Change your display name';

  @override
  String get enterName => 'Enter name';

  @override
  String get profileUpdated => 'Profile updated!';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get languageDescription => 'Select your preferred language';

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get changePassword => 'Change Password';

  @override
  String get passwordDescription => 'Update account security';

  @override
  String get newPassword => 'New Password';

  @override
  String get passwordHint => 'Min. 6 characters';

  @override
  String get passwordUpdated => 'Password updated!';

  @override
  String get multiAccount => 'Multiple Accounts';

  @override
  String get multiAccountSubtitle =>
      'Switch between profiles of children or friends';

  @override
  String get addAccount => 'Add Account';

  @override
  String get addRegisterAccount => 'Add / Register Account';

  @override
  String get gradingScale => 'Grading Scale (%)';

  @override
  String get gradingScaleSubtitle => 'Custom percentage thresholds';

  @override
  String get newRegistration => 'New registration?';

  @override
  String get registerNewChild => 'Register New Child';

  @override
  String get addExistingAccount => 'Add Existing Account';

  @override
  String get childUserName => 'Child/User Name';

  @override
  String get nameHint => 'e.g. Ania';

  @override
  String get user => 'User';

  @override
  String get editName => 'Edit Name';

  @override
  String switchedTo(Object name) {
    return 'Switched to $name';
  }

  @override
  String get grade6Label => 'Grade 6 (Excellent)';

  @override
  String get grade5Label => 'Grade 5 (Very Good)';

  @override
  String get grade4Label => 'Grade 4 (Good)';

  @override
  String get grade3Label => 'Grade 3 (Satisfactory)';

  @override
  String get grade2Label => 'Grade 2 (Fair)';

  @override
  String error(Object message) {
    return 'Error: $message';
  }

  @override
  String get accountCreated => 'Account created!';

  @override
  String get statistics => 'Statistics';

  @override
  String get performance => 'Subject Performance';

  @override
  String get insights => 'Quick Insights';

  @override
  String get subjectsToRescue => 'Subjects to Rescue';

  @override
  String get bestSubject => 'Best Subject';

  @override
  String get calculate => 'Calculate';

  @override
  String get targetAverage => 'Target Average';

  @override
  String get nextAssignmentWeight => 'Next Grade Weight';

  @override
  String impossible(Object needed) {
    return 'Impossible! You\'d need $needed';
  }

  @override
  String easy(Object needed) {
    return 'Easy! You only need 1.0 (or less: $needed)';
  }

  @override
  String neededAtLeast(Object needed) {
    return 'You need to get at least: $needed';
  }

  @override
  String get gradePredictor => 'Grade Predictor';

  @override
  String get changeEmail => 'Change Email';

  @override
  String get changeEmailDescription => 'Update your account email address';

  @override
  String get newEmail => 'New email address';

  @override
  String get emailUpdated => 'Email updated! Check your inbox.';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get appearanceSubtitle => 'Theme and app style';

  @override
  String get themeLight => 'Light ☀️';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dark 🌙';

  @override
  String get settingsHeroTitle => 'Your study zone ✨';

  @override
  String get settingsHeroSubtitle =>
      'Themes, accounts, and grading scale in one place.';

  @override
  String get remainingToggle => 'Multiple assignments';

  @override
  String get remainingWeightsTitle => 'Remaining assignments (weights)';

  @override
  String get addWeight => 'Add weight';

  @override
  String remainingImpossible(Object needed) {
    return 'Impossible! You need an average of $needed';
  }

  @override
  String remainingEasy(Object needed) {
    return 'Easy! You only need 1.0 on average (or less: $needed)';
  }

  @override
  String remainingNeededAtLeast(Object needed) {
    return 'You need an average of at least: $needed';
  }

  @override
  String get calendarTitle => 'Exam calendar';

  @override
  String get addExam => 'Add exam';

  @override
  String get editExam => 'Edit exam';

  @override
  String get examTitle => 'Exam name';

  @override
  String get examDate => 'Date';

  @override
  String get examSubject => 'Subject';

  @override
  String get maxPoints => 'Max points';

  @override
  String get pointsMode => 'Points';

  @override
  String get pointsEarned => 'Points earned';

  @override
  String get gradingModeLabel => 'Grading type';

  @override
  String get gradingModeGrades => 'Grades 1-6';

  @override
  String get gradingModePoints => 'Points';

  @override
  String get gradingModeMixed => 'Mixed';

  @override
  String get maxNormalPoints => 'Max points (regular)';

  @override
  String get maxBonusPoints => 'Max points (bonus)';

  @override
  String get chooseDate => 'Choose date';

  @override
  String get noExams => 'No exams yet. Add your first one!';

  @override
  String get deleteExamConfirm =>
      'This will remove the exam from your calendar.';

  @override
  String get infoTitle => 'How it works';

  @override
  String get infoBody =>
      'The app calculates your current average and shows what you need on remaining exams to keep or raise your grade. Progress charts and stats highlight which subjects you are \"saving\" at the last moment.';

  @override
  String get ok => 'OK';

  @override
  String get validationAllFields => 'Please fill in all fields!';

  @override
  String get unknownSubject => 'Unknown Subject';

  @override
  String get validationSubjectName => 'Please enter a subject name';

  @override
  String get validationMaxPoints => 'Please enter valid max points';

  @override
  String get validationGrade => 'Please enter a valid grade (1-6)';

  @override
  String get validationPoints => 'Please enter points and max points';

  @override
  String get validationWeight => 'Weight must be greater than 0';

  @override
  String get validationExamTitle => 'Please enter an exam name';

  @override
  String get noSubjectsForExams => 'Add subjects first to plan exams';

  @override
  String get noSubjectsShort => 'No subjects';

  @override
  String get predictionFirstAddGrade => 'Add a grade first!';

  @override
  String get predictionPointsSurplus =>
      'You already have enough points for this goal!';

  @override
  String predictionPointsCurrentStatus(Object current, Object target) {
    return 'Your current score is $current%, and the goal is $target%.';
  }

  @override
  String predictionPointsMissing(Object remaining, Object target) {
    return 'With current grades you are missing $remaining pts to reach $target%';
  }

  @override
  String get predictionPointsNoExamsRecommendation =>
      'Add upcoming exams to the calendar – there will surely be opportunities to earn these points!';

  @override
  String get predictionGoalEasy => 'You will reach the goal easily!';

  @override
  String predictionGoalEasyExplanation(Object target) {
    return 'Even with 0 pts from upcoming exams, your score won\'t drop below $target%.';
  }

  @override
  String get predictionImpossibleShort =>
      'Unfortunately, the goal is unreachable.';

  @override
  String predictionPointsImpossibleExplanation(Object extra) {
    return 'Even with 100% from current exams, you are still missing $extra pts.';
  }

  @override
  String predictionPointsRescueRecommendation(Object extra) {
    return 'In addition to calendar exams, you need to earn an extra $extra pts (e.g., from extra projects) to reach your goal.';
  }

  @override
  String get predictionPointsNeededList => 'You must pass upcoming exams with:';

  @override
  String predictionPointsNeededExplanation(Object remaining, Object total) {
    return 'You need $remaining pts out of $total possible.';
  }

  @override
  String get predictionPointsFocusAdvice =>
      'Focus especially on the largest exam – that\'s where you can gain the most!';

  @override
  String get predictionGradesForecastTitle => 'Forecast for future grades:';

  @override
  String predictionGradesNoExamsExplanation(Object target) {
    return 'No data in calendar. I checked what you need to get for your average to rise to $target.';
  }

  @override
  String get predictionGradesNoExamsRecommendation =>
      'Add upcoming exams to the calendar so we know how many weights are left until the end of the year!';

  @override
  String predictionGradesWeightScenario(Object weight) {
    return 'Grade with weight $weight';
  }

  @override
  String predictionGradesImpossibleWhy(Object best) {
    return 'By getting a 6, your average will only rise to $best.';
  }

  @override
  String get predictionGradesRescuePlanTitle =>
      'Calendar is not enough. You need a rescue plan!';

  @override
  String predictionGradesImpossibleExplanation(Object best) {
    return 'Even with straight 6s from calendar exams, your average will only rise to $best.';
  }

  @override
  String predictionGradesRescueRecommendation(Object extra, Object target) {
    return 'In addition to calendar exams, you need to earn $extra extra \'6\' grades (weight 1.0) to reach an average of $target.';
  }

  @override
  String get predictionGradesExamsNeededList =>
      'You must pass upcoming exams with:';

  @override
  String get predictionGradesExamsNeededExplanation =>
      'I calculated the average grade from all upcoming exams.';

  @override
  String get predictionGradesExtraCreditAdvice =>
      'If these exams aren\'t everything, try to get some extra credit for activity!';

  @override
  String get predictionTargetLabel => 'Target grade or %';

  @override
  String get predictionTargetHint => 'e.g. 4 or 90';

  @override
  String predictionMinGrade(Object grade) {
    return 'min. $grade';
  }

  @override
  String get predictionOrSeparator => 'OR';

  @override
  String get gradeTypeTest => 'Test';

  @override
  String get gradeTypeQuiz => 'Quiz';

  @override
  String get gradeTypeHomework => 'Homework';

  @override
  String get gradeTypeActivity => 'Activity';

  @override
  String get gradeTypeBonus => 'Bonus';

  @override
  String get predictionAdviceKeepItUp =>
      'Great job! Keep it up in future assignments.';

  @override
  String get predictionAdviceSleepWell =>
      'You can sleep well, but don\'t give up completely!';

  @override
  String get predictionAdviceFocusOnBig =>
      'Focus especially on the largest exam – that\'s where you can gain the most!';

  @override
  String get predictionAdviceExtraCredit =>
      'If these exams aren\'t everything, try to get some extra credit for activity!';

  @override
  String get customGradingScaleTitle => 'Custom Grading Scale';

  @override
  String get resetToGlobal => 'Reset to Global Scale';

  @override
  String get customScaleSaved => 'Custom scale saved!';
}
