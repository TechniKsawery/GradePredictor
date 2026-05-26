import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('pl'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'GradePredictor'**
  String get appTitle;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'GradePredictor'**
  String get appName;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @newHere.
  ///
  /// In en, this message translates to:
  /// **'New here? Create an account'**
  String get newHere;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccount;

  /// No description provided for @subjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get subjects;

  /// No description provided for @addSubject.
  ///
  /// In en, this message translates to:
  /// **'Add Subject'**
  String get addSubject;

  /// No description provided for @newSubject.
  ///
  /// In en, this message translates to:
  /// **'New Subject'**
  String get newSubject;

  /// No description provided for @subjectNameHint.
  ///
  /// In en, this message translates to:
  /// **'Subject name (e.g. Math)'**
  String get subjectNameHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get confirmDelete;

  /// No description provided for @deleteSubjectConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will delete the subject and all its grades.'**
  String get deleteSubjectConfirm;

  /// No description provided for @editSubject.
  ///
  /// In en, this message translates to:
  /// **'Edit Subject'**
  String get editSubject;

  /// No description provided for @noSubjects.
  ///
  /// In en, this message translates to:
  /// **'No subjects. Add your first one!'**
  String get noSubjects;

  /// No description provided for @currentAverage.
  ///
  /// In en, this message translates to:
  /// **'Current Average'**
  String get currentAverage;

  /// No description provided for @tapToSeeGrades.
  ///
  /// In en, this message translates to:
  /// **'Tap to see grades'**
  String get tapToSeeGrades;

  /// No description provided for @addGrade.
  ///
  /// In en, this message translates to:
  /// **'Add Grade'**
  String get addGrade;

  /// No description provided for @editGrade.
  ///
  /// In en, this message translates to:
  /// **'Edit Grade'**
  String get editGrade;

  /// No description provided for @gradeHint.
  ///
  /// In en, this message translates to:
  /// **'Grade (e.g. 5.0)'**
  String get gradeHint;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @weightHint.
  ///
  /// In en, this message translates to:
  /// **'Weight (e.g. 2.0)'**
  String get weightHint;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @predict.
  ///
  /// In en, this message translates to:
  /// **'Predict'**
  String get predict;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @profileDescription.
  ///
  /// In en, this message translates to:
  /// **'Change your display name'**
  String get profileDescription;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enterName;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated!'**
  String get profileUpdated;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @languageDescription.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get languageDescription;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @passwordDescription.
  ///
  /// In en, this message translates to:
  /// **'Update account security'**
  String get passwordDescription;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Min. 6 characters'**
  String get passwordHint;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated!'**
  String get passwordUpdated;

  /// No description provided for @multiAccount.
  ///
  /// In en, this message translates to:
  /// **'Multiple Accounts'**
  String get multiAccount;

  /// No description provided for @multiAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch between profiles of children or friends'**
  String get multiAccountSubtitle;

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get addAccount;

  /// No description provided for @addRegisterAccount.
  ///
  /// In en, this message translates to:
  /// **'Add / Register Account'**
  String get addRegisterAccount;

  /// No description provided for @gradingScale.
  ///
  /// In en, this message translates to:
  /// **'Grading Scale (%)'**
  String get gradingScale;

  /// No description provided for @gradingScaleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Custom percentage thresholds'**
  String get gradingScaleSubtitle;

  /// No description provided for @newRegistration.
  ///
  /// In en, this message translates to:
  /// **'New registration?'**
  String get newRegistration;

  /// No description provided for @registerNewChild.
  ///
  /// In en, this message translates to:
  /// **'Register New Child'**
  String get registerNewChild;

  /// No description provided for @addExistingAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Existing Account'**
  String get addExistingAccount;

  /// No description provided for @childUserName.
  ///
  /// In en, this message translates to:
  /// **'Child/User Name'**
  String get childUserName;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ania'**
  String get nameHint;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get editName;

  /// No description provided for @switchedTo.
  ///
  /// In en, this message translates to:
  /// **'Switched to {name}'**
  String switchedTo(Object name);

  /// No description provided for @grade6Label.
  ///
  /// In en, this message translates to:
  /// **'Grade 6 (Excellent)'**
  String get grade6Label;

  /// No description provided for @grade5Label.
  ///
  /// In en, this message translates to:
  /// **'Grade 5 (Very Good)'**
  String get grade5Label;

  /// No description provided for @grade4Label.
  ///
  /// In en, this message translates to:
  /// **'Grade 4 (Good)'**
  String get grade4Label;

  /// No description provided for @grade3Label.
  ///
  /// In en, this message translates to:
  /// **'Grade 3 (Satisfactory)'**
  String get grade3Label;

  /// No description provided for @grade2Label.
  ///
  /// In en, this message translates to:
  /// **'Grade 2 (Fair)'**
  String get grade2Label;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(Object message);

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created!'**
  String get accountCreated;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Subject Performance'**
  String get performance;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Quick Insights'**
  String get insights;

  /// No description provided for @subjectsToRescue.
  ///
  /// In en, this message translates to:
  /// **'Subjects to Rescue'**
  String get subjectsToRescue;

  /// No description provided for @bestSubject.
  ///
  /// In en, this message translates to:
  /// **'Best Subject'**
  String get bestSubject;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @targetAverage.
  ///
  /// In en, this message translates to:
  /// **'Target Average'**
  String get targetAverage;

  /// No description provided for @nextAssignmentWeight.
  ///
  /// In en, this message translates to:
  /// **'Next Grade Weight'**
  String get nextAssignmentWeight;

  /// No description provided for @impossible.
  ///
  /// In en, this message translates to:
  /// **'Impossible! You\'d need {needed}'**
  String impossible(Object needed);

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy! You only need 1.0 (or less: {needed})'**
  String easy(Object needed);

  /// No description provided for @neededAtLeast.
  ///
  /// In en, this message translates to:
  /// **'You need to get at least: {needed}'**
  String neededAtLeast(Object needed);

  /// No description provided for @gradePredictor.
  ///
  /// In en, this message translates to:
  /// **'Grade Predictor'**
  String get gradePredictor;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmail;

  /// No description provided for @changeEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'Update your account email address'**
  String get changeEmailDescription;

  /// No description provided for @newEmail.
  ///
  /// In en, this message translates to:
  /// **'New email address'**
  String get newEmail;

  /// No description provided for @emailUpdated.
  ///
  /// In en, this message translates to:
  /// **'Email updated! Check your inbox.'**
  String get emailUpdated;

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// No description provided for @appearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Theme and app style'**
  String get appearanceSubtitle;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light ☀️'**
  String get themeLight;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark 🌙'**
  String get themeDark;

  /// No description provided for @settingsHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Your study zone ✨'**
  String get settingsHeroTitle;

  /// No description provided for @settingsHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Themes, accounts, and grading scale in one place.'**
  String get settingsHeroSubtitle;

  /// No description provided for @remainingToggle.
  ///
  /// In en, this message translates to:
  /// **'Multiple assignments'**
  String get remainingToggle;

  /// No description provided for @remainingWeightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Remaining assignments (weights)'**
  String get remainingWeightsTitle;

  /// No description provided for @addWeight.
  ///
  /// In en, this message translates to:
  /// **'Add weight'**
  String get addWeight;

  /// No description provided for @remainingImpossible.
  ///
  /// In en, this message translates to:
  /// **'Impossible! You need an average of {needed}'**
  String remainingImpossible(Object needed);

  /// No description provided for @remainingEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy! You only need 1.0 on average (or less: {needed})'**
  String remainingEasy(Object needed);

  /// No description provided for @remainingNeededAtLeast.
  ///
  /// In en, this message translates to:
  /// **'You need an average of at least: {needed}'**
  String remainingNeededAtLeast(Object needed);

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Exam calendar'**
  String get calendarTitle;

  /// No description provided for @addExam.
  ///
  /// In en, this message translates to:
  /// **'Add exam'**
  String get addExam;

  /// No description provided for @editExam.
  ///
  /// In en, this message translates to:
  /// **'Edit exam'**
  String get editExam;

  /// No description provided for @examTitle.
  ///
  /// In en, this message translates to:
  /// **'Exam name'**
  String get examTitle;

  /// No description provided for @examDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get examDate;

  /// No description provided for @examSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get examSubject;

  /// No description provided for @maxPoints.
  ///
  /// In en, this message translates to:
  /// **'Max points'**
  String get maxPoints;

  /// No description provided for @pointsMode.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get pointsMode;

  /// No description provided for @pointsEarned.
  ///
  /// In en, this message translates to:
  /// **'Points earned'**
  String get pointsEarned;

  /// No description provided for @gradingModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Grading type'**
  String get gradingModeLabel;

  /// No description provided for @gradingModeGrades.
  ///
  /// In en, this message translates to:
  /// **'Grades 1-6'**
  String get gradingModeGrades;

  /// No description provided for @gradingModePoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get gradingModePoints;

  /// No description provided for @gradingModeMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get gradingModeMixed;

  /// No description provided for @maxNormalPoints.
  ///
  /// In en, this message translates to:
  /// **'Max points (regular)'**
  String get maxNormalPoints;

  /// No description provided for @maxBonusPoints.
  ///
  /// In en, this message translates to:
  /// **'Max points (bonus)'**
  String get maxBonusPoints;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get chooseDate;

  /// No description provided for @noExams.
  ///
  /// In en, this message translates to:
  /// **'No exams yet. Add your first one!'**
  String get noExams;

  /// No description provided for @deleteExamConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will remove the exam from your calendar.'**
  String get deleteExamConfirm;

  /// No description provided for @infoTitle.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get infoTitle;

  /// No description provided for @infoBody.
  ///
  /// In en, this message translates to:
  /// **'The app calculates your current average and shows what you need on remaining exams to keep or raise your grade. Progress charts and stats highlight which subjects you are \"saving\" at the last moment.'**
  String get infoBody;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @validationAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields!'**
  String get validationAllFields;

  /// No description provided for @unknownSubject.
  ///
  /// In en, this message translates to:
  /// **'Unknown Subject'**
  String get unknownSubject;

  /// No description provided for @validationSubjectName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a subject name'**
  String get validationSubjectName;

  /// No description provided for @validationMaxPoints.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid max points'**
  String get validationMaxPoints;

  /// No description provided for @validationGrade.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid grade (1-6)'**
  String get validationGrade;

  /// No description provided for @validationPoints.
  ///
  /// In en, this message translates to:
  /// **'Please enter points and max points'**
  String get validationPoints;

  /// No description provided for @validationWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight must be greater than 0'**
  String get validationWeight;

  /// No description provided for @validationExamTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter an exam name'**
  String get validationExamTitle;

  /// No description provided for @noSubjectsForExams.
  ///
  /// In en, this message translates to:
  /// **'Add subjects first to plan exams'**
  String get noSubjectsForExams;

  /// No description provided for @calendarNoSubjectsInfo.
  ///
  /// In en, this message translates to:
  /// **'You cannot add an exam until you add at least one subject in the Subjects tab.'**
  String get calendarNoSubjectsInfo;

  /// No description provided for @noSubjectsShort.
  ///
  /// In en, this message translates to:
  /// **'No subjects'**
  String get noSubjectsShort;

  /// No description provided for @predictionFirstAddGrade.
  ///
  /// In en, this message translates to:
  /// **'Add a grade first!'**
  String get predictionFirstAddGrade;

  /// No description provided for @predictionPointsSurplus.
  ///
  /// In en, this message translates to:
  /// **'You already have enough points for this goal!'**
  String get predictionPointsSurplus;

  /// No description provided for @predictionPointsCurrentStatus.
  ///
  /// In en, this message translates to:
  /// **'Your current score is {current}%, and the goal is {target}%.'**
  String predictionPointsCurrentStatus(Object current, Object target);

  /// No description provided for @predictionPointsMissing.
  ///
  /// In en, this message translates to:
  /// **'With current grades you are missing {remaining} pts to reach {target}%'**
  String predictionPointsMissing(Object remaining, Object target);

  /// No description provided for @predictionPointsNoExamsRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Add upcoming exams to the calendar – there will surely be opportunities to earn these points!'**
  String get predictionPointsNoExamsRecommendation;

  /// No description provided for @predictionGoalEasy.
  ///
  /// In en, this message translates to:
  /// **'You will reach the goal easily!'**
  String get predictionGoalEasy;

  /// No description provided for @predictionGoalEasyExplanation.
  ///
  /// In en, this message translates to:
  /// **'Even with 0 pts from upcoming exams, your score won\'t drop below {target}%.'**
  String predictionGoalEasyExplanation(Object target);

  /// No description provided for @predictionImpossibleShort.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, the goal is unreachable.'**
  String get predictionImpossibleShort;

  /// No description provided for @predictionPointsImpossibleExplanation.
  ///
  /// In en, this message translates to:
  /// **'Even with 100% from current exams, you are still missing {extra} pts.'**
  String predictionPointsImpossibleExplanation(Object extra);

  /// No description provided for @predictionPointsRescueRecommendation.
  ///
  /// In en, this message translates to:
  /// **'In addition to calendar exams, you need to earn an extra {extra} pts (e.g., from extra projects) to reach your goal.'**
  String predictionPointsRescueRecommendation(Object extra);

  /// No description provided for @predictionPointsNeededList.
  ///
  /// In en, this message translates to:
  /// **'You must pass upcoming exams with:'**
  String get predictionPointsNeededList;

  /// No description provided for @predictionPointsNeededExplanation.
  ///
  /// In en, this message translates to:
  /// **'You need {remaining} pts out of {total} possible.'**
  String predictionPointsNeededExplanation(Object remaining, Object total);

  /// No description provided for @predictionPointsFocusAdvice.
  ///
  /// In en, this message translates to:
  /// **'Focus especially on the largest exam – that\'s where you can gain the most!'**
  String get predictionPointsFocusAdvice;

  /// No description provided for @predictionGradesForecastTitle.
  ///
  /// In en, this message translates to:
  /// **'Forecast for future grades:'**
  String get predictionGradesForecastTitle;

  /// No description provided for @predictionGradesNoExamsExplanation.
  ///
  /// In en, this message translates to:
  /// **'No data in calendar. I checked what you need to get for your average to rise to {target}.'**
  String predictionGradesNoExamsExplanation(Object target);

  /// No description provided for @predictionGradesNoExamsRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Add upcoming exams to the calendar so we know how many weights are left until the end of the year!'**
  String get predictionGradesNoExamsRecommendation;

  /// No description provided for @predictionGradesWeightScenario.
  ///
  /// In en, this message translates to:
  /// **'Grade with weight {weight}'**
  String predictionGradesWeightScenario(Object weight);

  /// No description provided for @predictionGradesImpossibleWhy.
  ///
  /// In en, this message translates to:
  /// **'By getting a 6, your average will only rise to {best}.'**
  String predictionGradesImpossibleWhy(Object best);

  /// No description provided for @predictionGradesRescuePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar is not enough. You need a rescue plan!'**
  String get predictionGradesRescuePlanTitle;

  /// No description provided for @predictionGradesImpossibleExplanation.
  ///
  /// In en, this message translates to:
  /// **'Even with straight 6s from calendar exams, your average will only rise to {best}.'**
  String predictionGradesImpossibleExplanation(Object best);

  /// No description provided for @predictionGradesRescueRecommendation.
  ///
  /// In en, this message translates to:
  /// **'In addition to calendar exams, you need to earn {extra} extra \'6\' grades (weight 1.0) to reach an average of {target}.'**
  String predictionGradesRescueRecommendation(Object extra, Object target);

  /// No description provided for @predictionGradesExamsNeededList.
  ///
  /// In en, this message translates to:
  /// **'You must pass upcoming exams with:'**
  String get predictionGradesExamsNeededList;

  /// No description provided for @predictionGradesExamsNeededExplanation.
  ///
  /// In en, this message translates to:
  /// **'I calculated the average grade from all upcoming exams.'**
  String get predictionGradesExamsNeededExplanation;

  /// No description provided for @predictionGradesExtraCreditAdvice.
  ///
  /// In en, this message translates to:
  /// **'If these exams aren\'t everything, try to get some extra credit for activity!'**
  String get predictionGradesExtraCreditAdvice;

  /// No description provided for @predictionTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Target grade or %'**
  String get predictionTargetLabel;

  /// No description provided for @predictionTargetHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 4 or 90'**
  String get predictionTargetHint;

  /// No description provided for @predictionMinGrade.
  ///
  /// In en, this message translates to:
  /// **'min. {grade}'**
  String predictionMinGrade(Object grade);

  /// No description provided for @predictionOrSeparator.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get predictionOrSeparator;

  /// No description provided for @gradeTypeTest.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get gradeTypeTest;

  /// No description provided for @gradeTypeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get gradeTypeQuiz;

  /// No description provided for @gradeTypeHomework.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get gradeTypeHomework;

  /// No description provided for @gradeTypeActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get gradeTypeActivity;

  /// No description provided for @gradeTypeBonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get gradeTypeBonus;

  /// No description provided for @predictionAdviceKeepItUp.
  ///
  /// In en, this message translates to:
  /// **'Great job! Keep it up in future assignments.'**
  String get predictionAdviceKeepItUp;

  /// No description provided for @predictionAdviceSleepWell.
  ///
  /// In en, this message translates to:
  /// **'You can sleep well, but don\'t give up completely!'**
  String get predictionAdviceSleepWell;

  /// No description provided for @predictionAdviceFocusOnBig.
  ///
  /// In en, this message translates to:
  /// **'Focus especially on the largest exam – that\'s where you can gain the most!'**
  String get predictionAdviceFocusOnBig;

  /// No description provided for @predictionAdviceExtraCredit.
  ///
  /// In en, this message translates to:
  /// **'If these exams aren\'t everything, try to get some extra credit for activity!'**
  String get predictionAdviceExtraCredit;

  /// No description provided for @customGradingScaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom Grading Scale'**
  String get customGradingScaleTitle;

  /// No description provided for @resetToGlobal.
  ///
  /// In en, this message translates to:
  /// **'Reset to Global Scale'**
  String get resetToGlobal;

  /// No description provided for @customScaleSaved.
  ///
  /// In en, this message translates to:
  /// **'Custom scale saved!'**
  String get customScaleSaved;

  /// No description provided for @syncTitle.
  ///
  /// In en, this message translates to:
  /// **'School Sync'**
  String get syncTitle;

  /// No description provided for @syncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect to your school account to automatically download grades and exams.'**
  String get syncSubtitle;

  /// No description provided for @syncLoginLibrus.
  ///
  /// In en, this message translates to:
  /// **'Login (Librus)'**
  String get syncLoginLibrus;

  /// No description provided for @syncPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get syncPassword;

  /// No description provided for @syncStart.
  ///
  /// In en, this message translates to:
  /// **'Start synchronization'**
  String get syncStart;

  /// No description provided for @syncSecurityNote.
  ///
  /// In en, this message translates to:
  /// **'Your data is secure and used only for downloading grades. We do not store your password.'**
  String get syncSecurityNote;

  /// No description provided for @syncDataFound.
  ///
  /// In en, this message translates to:
  /// **'Data found for import:'**
  String get syncDataFound;

  /// No description provided for @syncGradesDetail.
  ///
  /// In en, this message translates to:
  /// **'Grade details (automatically detected):'**
  String get syncGradesDetail;

  /// No description provided for @syncConfirmImport.
  ///
  /// In en, this message translates to:
  /// **'Confirm and import'**
  String get syncConfirmImport;

  /// No description provided for @syncCancelReturn.
  ///
  /// In en, this message translates to:
  /// **'Cancel and go back'**
  String get syncCancelReturn;

  /// No description provided for @syncError.
  ///
  /// In en, this message translates to:
  /// **'Sync error: {error}'**
  String syncError(Object error);

  /// No description provided for @syncImportedCount.
  ///
  /// In en, this message translates to:
  /// **'Imported: {grades} grades, {exams} events!'**
  String syncImportedCount(Object exams, Object grades);

  /// No description provided for @syncLibrusLoginHint.
  ///
  /// In en, this message translates to:
  /// **'Login (Librus)'**
  String get syncLibrusLoginHint;

  /// No description provided for @syncVulcanTokenHint.
  ///
  /// In en, this message translates to:
  /// **'Token (Vulcan)'**
  String get syncVulcanTokenHint;

  /// No description provided for @syncVulcanSymbolLabel.
  ///
  /// In en, this message translates to:
  /// **'Symbol (Vulcan)'**
  String get syncVulcanSymbolLabel;

  /// No description provided for @syncVulcanPinLabel.
  ///
  /// In en, this message translates to:
  /// **'PIN Code'**
  String get syncVulcanPinLabel;

  /// No description provided for @syncLibrusSyncButton.
  ///
  /// In en, this message translates to:
  /// **'Import data from school diary'**
  String get syncLibrusSyncButton;

  /// No description provided for @syncTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String syncTypeLabel(Object type);

  /// No description provided for @syncWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight: {weight}'**
  String syncWeightLabel(Object weight);

  /// No description provided for @syncPointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Pts: {points}/{max}'**
  String syncPointsLabel(Object max, Object points);

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @gradeLabel.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get gradeLabel;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @bonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get bonus;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @pdfReportTitle.
  ///
  /// In en, this message translates to:
  /// **'GradePredictor Report'**
  String get pdfReportTitle;

  /// No description provided for @pdfSummaryHeader.
  ///
  /// In en, this message translates to:
  /// **'Summary of current academic standing:'**
  String get pdfSummaryHeader;

  /// No description provided for @pdfFooter.
  ///
  /// In en, this message translates to:
  /// **'Generated by GradePredictor App'**
  String get pdfFooter;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password is too short'**
  String get passwordTooShort;

  /// No description provided for @monthJanuary.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJanuary;

  /// No description provided for @monthFebruary.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get monthFebruary;

  /// No description provided for @monthMarch.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMarch;

  /// No description provided for @monthApril.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApril;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJune.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJune;

  /// No description provided for @monthJuly.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJuly;

  /// No description provided for @monthAugust.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get monthAugust;

  /// No description provided for @monthSeptember.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get monthSeptember;

  /// No description provided for @monthOctober.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get monthOctober;

  /// No description provided for @monthNovember.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get monthNovember;

  /// No description provided for @monthDecember.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get monthDecember;

  /// No description provided for @dayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get dayMonday;

  /// No description provided for @dayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get dayTuesday;

  /// No description provided for @dayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get dayWednesday;

  /// No description provided for @dayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get dayThursday;

  /// No description provided for @dayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get dayFriday;

  /// No description provided for @daySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get daySaturday;

  /// No description provided for @daySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get daySunday;

  /// No description provided for @dayShortMonday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayShortMonday;

  /// No description provided for @dayShortTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayShortTuesday;

  /// No description provided for @dayShortWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayShortWednesday;

  /// No description provided for @dayShortThursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayShortThursday;

  /// No description provided for @dayShortFriday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayShortFriday;

  /// No description provided for @dayShortSaturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get dayShortSaturday;

  /// No description provided for @dayShortSunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get dayShortSunday;

  /// No description provided for @monthShortJanuary.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get monthShortJanuary;

  /// No description provided for @monthShortFebruary.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get monthShortFebruary;

  /// No description provided for @monthShortMarch.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get monthShortMarch;

  /// No description provided for @monthShortApril.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get monthShortApril;

  /// No description provided for @monthShortMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthShortMay;

  /// No description provided for @monthShortJune.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get monthShortJune;

  /// No description provided for @monthShortJuly.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get monthShortJuly;

  /// No description provided for @monthShortAugust.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get monthShortAugust;

  /// No description provided for @monthShortSeptember.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get monthShortSeptember;

  /// No description provided for @monthShortOctober.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get monthShortOctober;

  /// No description provided for @monthShortNovember.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get monthShortNovember;

  /// No description provided for @monthShortDecember.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get monthShortDecember;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @librus.
  ///
  /// In en, this message translates to:
  /// **'Librus'**
  String get librus;

  /// No description provided for @vulcan.
  ///
  /// In en, this message translates to:
  /// **'Vulcan'**
  String get vulcan;

  /// No description provided for @autoSync.
  ///
  /// In en, this message translates to:
  /// **'Auto-sync (every 15 minutes)'**
  String get autoSync;

  /// No description provided for @googleCalendarIntegrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Google Calendar integration'**
  String get googleCalendarIntegrationSubtitle;

  /// No description provided for @googleCalendarSignedOut.
  ///
  /// In en, this message translates to:
  /// **'Signed out of Google Calendar'**
  String get googleCalendarSignedOut;

  /// No description provided for @googleCalendarSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get googleCalendarSignOut;

  /// No description provided for @googleCalendarSignOutDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign out of Google account to change calendar'**
  String get googleCalendarSignOutDescription;

  /// No description provided for @googleCalendarAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to Google Calendar'**
  String get googleCalendarAdded;

  /// No description provided for @googleCalendarFailedToAdd.
  ///
  /// In en, this message translates to:
  /// **'Failed to add to Google Calendar'**
  String get googleCalendarFailedToAdd;

  /// No description provided for @examSummaryPrefix.
  ///
  /// In en, this message translates to:
  /// **'Exam'**
  String get examSummaryPrefix;

  /// No description provided for @showRawPoints.
  ///
  /// In en, this message translates to:
  /// **'Show raw points'**
  String get showRawPoints;

  /// No description provided for @convertPointsToGrades.
  ///
  /// In en, this message translates to:
  /// **'Convert points to grades'**
  String get convertPointsToGrades;

  /// No description provided for @sortLatest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortLatest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get sortOldest;

  /// No description provided for @sortHighestGrade.
  ///
  /// In en, this message translates to:
  /// **'Highest grades'**
  String get sortHighestGrade;

  /// No description provided for @sortLowestGrade.
  ///
  /// In en, this message translates to:
  /// **'Lowest grades'**
  String get sortLowestGrade;

  /// No description provided for @semester1.
  ///
  /// In en, this message translates to:
  /// **'Semester 1'**
  String get semester1;

  /// No description provided for @semester2.
  ///
  /// In en, this message translates to:
  /// **'Semester 2'**
  String get semester2;

  /// No description provided for @allYear.
  ///
  /// In en, this message translates to:
  /// **'Full year'**
  String get allYear;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @syncSyncing.
  ///
  /// In en, this message translates to:
  /// **'Sync in progress...'**
  String get syncSyncing;

  /// No description provided for @syncErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync error'**
  String get syncErrorTitle;

  /// No description provided for @syncActiveInterval.
  ///
  /// In en, this message translates to:
  /// **'Auto-sync active (every 15 min)'**
  String get syncActiveInterval;

  /// No description provided for @syncLastSync.
  ///
  /// In en, this message translates to:
  /// **'Last sync: {time}'**
  String syncLastSync(String time);

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String timeMinutesAgo(String minutes);

  /// No description provided for @vulcanTokenHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 3H6K9...'**
  String get vulcanTokenHint;

  /// No description provided for @vulcanSymbolHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. powiat-warszawski'**
  String get vulcanSymbolHint;

  /// No description provided for @autoSyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically download new grades in the background'**
  String get autoSyncSubtitle;

  /// No description provided for @syncLibrusEvents.
  ///
  /// In en, this message translates to:
  /// **'Dates and events (Librus Calendar)'**
  String get syncLibrusEvents;

  /// No description provided for @syncEventDefault.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get syncEventDefault;

  /// No description provided for @syncTerminLabel.
  ///
  /// In en, this message translates to:
  /// **'Due date: {date}'**
  String syncTerminLabel(String date);

  /// No description provided for @syncSaveAndAuto.
  ///
  /// In en, this message translates to:
  /// **'Save & auto-sync'**
  String get syncSaveAndAuto;

  /// No description provided for @syncSaveAndAutoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Refresh grades automatically every 15 min'**
  String get syncSaveAndAutoSubtitle;

  /// No description provided for @syncSyncNowTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncSyncNowTooltip;

  /// No description provided for @syncDefaultSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get syncDefaultSubject;

  /// No description provided for @predictionPointsStatus.
  ///
  /// In en, this message translates to:
  /// **'You have {current} / {max} pts ({pct}%).'**
  String predictionPointsStatus(String current, String max, String pct);

  /// No description provided for @predictionPointsNeededVal.
  ///
  /// In en, this message translates to:
  /// **'{points} / {max} pts'**
  String predictionPointsNeededVal(String points, String max);

  /// No description provided for @vulcanNotSupportedError.
  ///
  /// In en, this message translates to:
  /// **'Vulcan integration requires PIN pairing. Under development.'**
  String get vulcanNotSupportedError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
