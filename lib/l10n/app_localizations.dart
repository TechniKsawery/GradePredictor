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
