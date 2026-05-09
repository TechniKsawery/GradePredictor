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
}
