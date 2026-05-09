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
  String get login => 'Login';

  @override
  String get signUp => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get welcomeBack => 'Welcome back, student!';

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
  String get subjectNameHint => 'Subject Name (e.g. Mathematics)';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get currentAverage => 'Current Average';

  @override
  String get addGrade => 'Add Grade';

  @override
  String get predict => 'Predict';

  @override
  String get weight => 'Weight';

  @override
  String get type => 'Type';

  @override
  String get gradeHint => 'Grade (e.g. 5)';

  @override
  String get weightHint => 'Weight (e.g. 1.0)';

  @override
  String get gradePredictor => 'Grade Predictor';

  @override
  String get targetAverage => 'Target Average';

  @override
  String get nextAssignmentWeight => 'Weight of next assignment';

  @override
  String get calculate => 'Calculate';

  @override
  String get statistics => 'Statistics';

  @override
  String get performance => 'Subject Performance';

  @override
  String get insights => 'Quick Insights';

  @override
  String get subjectsToRescue => 'Subjects to \'Rescue\'';

  @override
  String get bestSubject => 'Best Subject';

  @override
  String get noSubjects => 'No subjects added yet.';

  @override
  String get checkEmail => 'Check your email for confirmation!';

  @override
  String get accountCreated => 'Account created! Please login.';

  @override
  String impossible(Object needed) {
    return 'Impossible! You would need a $needed';
  }

  @override
  String easy(Object needed) {
    return 'Easy! You only need a 1.0 (or less: $needed)';
  }

  @override
  String neededAtLeast(Object needed) {
    return 'You need to get at least: $needed';
  }
}
