import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @geolocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get geolocation;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear cache'**
  String get clearCache;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export my data'**
  String get exportData;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @identify.
  ///
  /// In en, this message translates to:
  /// **'Identify'**
  String get identify;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @chooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseGallery;

  /// No description provided for @encyclopedia.
  ///
  /// In en, this message translates to:
  /// **'Mushroom encyclopedia'**
  String get encyclopedia;

  /// No description provided for @recentIdentifications.
  ///
  /// In en, this message translates to:
  /// **'Recent identifications'**
  String get recentIdentifications;

  /// No description provided for @identifyMushroomTitle.
  ///
  /// In en, this message translates to:
  /// **'Identify a mushroom from a photo'**
  String get identifyMushroomTitle;

  /// No description provided for @identifyMushroomSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of a mushroom or choose an existing picture from your gallery'**
  String get identifyMushroomSubtitle;

  /// No description provided for @openCameraSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open your device camera'**
  String get openCameraSubtitle;

  /// No description provided for @chooseGallerySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use an existing photo'**
  String get chooseGallerySubtitle;

  /// No description provided for @encyclopediaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore mushroom species and their characteristics'**
  String get encyclopediaSubtitle;

  /// No description provided for @emptyRecentHistory.
  ///
  /// In en, this message translates to:
  /// **'Your recent identifications will appear here.'**
  String get emptyRecentHistory;

  /// No description provided for @favoriteRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get favoriteRemoved;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @favoriteLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load mushroom'**
  String get favoriteLoadError;

  /// No description provided for @favoriteNotFound.
  ///
  /// In en, this message translates to:
  /// **'Mushroom not found'**
  String get favoriteNotFound;

  /// No description provided for @emptyFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyFavoritesTitle;

  /// No description provided for @emptyFavoritesDescription.
  ///
  /// In en, this message translates to:
  /// **'Save interesting mushrooms from the encyclopedia to easily find them again.'**
  String get emptyFavoritesDescription;

  /// No description provided for @openEncyclopedia.
  ///
  /// In en, this message translates to:
  /// **'Open encyclopedia'**
  String get openEncyclopedia;

  /// No description provided for @identificationHistory.
  ///
  /// In en, this message translates to:
  /// **'Identification history'**
  String get identificationHistory;

  /// No description provided for @searchMushroomsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by mushroom name...'**
  String get searchMushroomsHint;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @statusDetermined.
  ///
  /// In en, this message translates to:
  /// **'Identified'**
  String get statusDetermined;

  /// No description provided for @statusNeedsCheck.
  ///
  /// In en, this message translates to:
  /// **'Needs review'**
  String get statusNeedsCheck;

  /// No description provided for @statusNotDetermined.
  ///
  /// In en, this message translates to:
  /// **'Not identified'**
  String get statusNotDetermined;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @changeSearchOrFilter.
  ///
  /// In en, this message translates to:
  /// **'Try changing your search or filter.'**
  String get changeSearchOrFilter;

  /// No description provided for @emptyHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'No identification history yet'**
  String get emptyHistoryTitle;

  /// No description provided for @emptyHistoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of a mushroom to see your first identification here.'**
  String get emptyHistoryDescription;

  /// No description provided for @profileMyProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get profileMyProfile;

  /// No description provided for @profilePersonalAccount.
  ///
  /// In en, this message translates to:
  /// **'Personal account'**
  String get profilePersonalAccount;

  /// No description provided for @profileMyActivity.
  ///
  /// In en, this message translates to:
  /// **'My activity'**
  String get profileMyActivity;

  /// No description provided for @profileIdentifications.
  ///
  /// In en, this message translates to:
  /// **'Identifications'**
  String get profileIdentifications;

  /// No description provided for @profileRegistration.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get profileRegistration;

  /// No description provided for @profileAccountManagement.
  ///
  /// In en, this message translates to:
  /// **'Account management'**
  String get profileAccountManagement;

  /// No description provided for @profileAppSettings.
  ///
  /// In en, this message translates to:
  /// **'App preferences'**
  String get profileAppSettings;

  /// No description provided for @profileLogoutAction.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogoutAction;

  /// No description provided for @profileDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profileDeleteAction;

  /// No description provided for @profileLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogoutTitle;

  /// No description provided for @profileLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get profileLogoutMessage;

  /// No description provided for @profileCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileCancel;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogoutConfirm;

  /// No description provided for @profileDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profileDeleteTitle;

  /// No description provided for @profileDeleteWarning.
  ///
  /// In en, this message translates to:
  /// **'WARNING! All your data will be permanently deleted, including your profile, identification history, favorites, and settings. This action cannot be undone.'**
  String get profileDeleteWarning;

  /// No description provided for @profileConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get profileConfirmPassword;

  /// No description provided for @profileEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get profileEnterPassword;

  /// No description provided for @profileDeleteForever.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get profileDeleteForever;

  /// No description provided for @profileDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account'**
  String get profileDeleteFailed;

  /// No description provided for @analysisSavedToHistory.
  ///
  /// In en, this message translates to:
  /// **'Saved to history'**
  String get analysisSavedToHistory;

  /// No description provided for @analysisDeadlyTitle.
  ///
  /// In en, this message translates to:
  /// **'DANGER! A DEADLY POISONOUS MUSHROOM WAS IDENTIFIED'**
  String get analysisDeadlyTitle;

  /// No description provided for @analysisDeadlyMessage.
  ///
  /// In en, this message translates to:
  /// **'The image is highly likely to show a deadly poisonous mushroom. Eating this mushroom may be fatal. Do not eat it under any circumstances.'**
  String get analysisDeadlyMessage;

  /// No description provided for @analysisUnderstood.
  ///
  /// In en, this message translates to:
  /// **'Understood'**
  String get analysisUnderstood;

  /// No description provided for @analysisResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Analysis result'**
  String get analysisResultTitle;

  /// No description provided for @analysisPossibleMatches.
  ///
  /// In en, this message translates to:
  /// **'Possible matches'**
  String get analysisPossibleMatches;

  /// No description provided for @analysisConfidence.
  ///
  /// In en, this message translates to:
  /// **'confidence'**
  String get analysisConfidence;

  /// No description provided for @analysisInFavorites.
  ///
  /// In en, this message translates to:
  /// **'In favorites'**
  String get analysisInFavorites;

  /// No description provided for @analysisAddToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get analysisAddToFavorites;

  /// No description provided for @analysisReviewWarning.
  ///
  /// In en, this message translates to:
  /// **'The mushroom could not be reliably identified. Do not use this result to determine whether it is safe to eat.'**
  String get analysisReviewWarning;

  /// No description provided for @analysisEdibilitySeeDetails.
  ///
  /// In en, this message translates to:
  /// **'See species details'**
  String get analysisEdibilitySeeDetails;

  /// No description provided for @analysisSafetyWarning.
  ///
  /// In en, this message translates to:
  /// **'Automated mushroom identification is not guaranteed to be accurate. Never decide whether a mushroom is safe to eat based on this app alone.'**
  String get analysisSafetyWarning;

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo preview'**
  String get previewTitle;

  /// No description provided for @previewLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please log in to your account.'**
  String get previewLoginRequired;

  /// No description provided for @previewAnalysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Analysis failed: {error}'**
  String previewAnalysisFailed(String error);

  /// No description provided for @previewRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get previewRetake;

  /// No description provided for @previewConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get previewConfirm;

  /// No description provided for @previewCameraHint.
  ///
  /// In en, this message translates to:
  /// **'Place the mushroom in the center of the frame'**
  String get previewCameraHint;

  /// No description provided for @previewAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get previewAnalyzing;

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Important information'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please read this information before using the app'**
  String get disclaimerSubtitle;

  /// No description provided for @disclaimerSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your safety matters'**
  String get disclaimerSafetyTitle;

  /// No description provided for @disclaimerAgreement.
  ///
  /// In en, this message translates to:
  /// **'I have read and understand the warning'**
  String get disclaimerAgreement;

  /// No description provided for @disclaimerSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get disclaimerSaving;

  /// No description provided for @disclaimerAcceptContinue.
  ///
  /// In en, this message translates to:
  /// **'Accept and continue'**
  String get disclaimerAcceptContinue;

  /// No description provided for @disclaimerFooter.
  ///
  /// In en, this message translates to:
  /// **'Safety matters more than any identification result.'**
  String get disclaimerFooter;

  /// No description provided for @disclaimerSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save your confirmation: {error}'**
  String disclaimerSaveError(String error);

  /// No description provided for @disclaimerEnglishSafetyNotice.
  ///
  /// In en, this message translates to:
  /// **'Automated mushroom identification can be wrong. The app cannot establish whether a mushroom is safe to eat. Never eat an unidentified mushroom or rely on this app alone for an edibility decision. Misidentification may cause serious poisoning or death.'**
  String get disclaimerEnglishSafetyNotice;

  /// No description provided for @disclaimerOriginalTextLabel.
  ///
  /// In en, this message translates to:
  /// **'Full original warning (Russian):'**
  String get disclaimerOriginalTextLabel;

  /// No description provided for @historyDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Identification details'**
  String get historyDetailTitle;

  /// No description provided for @historyDetailDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this record?'**
  String get historyDetailDeleteConfirmTitle;

  /// No description provided for @historyDetailDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This identification record will be permanently deleted and cannot be recovered.'**
  String get historyDetailDeleteConfirmMessage;

  /// No description provided for @historyDetailDeleteConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get historyDetailDeleteConfirmButton;

  /// No description provided for @historyDetailDeleted.
  ///
  /// In en, this message translates to:
  /// **'Record deleted'**
  String get historyDetailDeleted;

  /// No description provided for @historyDetailDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete record'**
  String get historyDetailDeleteFailed;

  /// No description provided for @historyDetailLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load record'**
  String get historyDetailLoadFailed;

  /// No description provided for @historyDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Record not found'**
  String get historyDetailNotFound;

  /// No description provided for @historyDetailDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get historyDetailDate;

  /// No description provided for @historyDetailTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get historyDetailTime;

  /// No description provided for @historyDetailResults.
  ///
  /// In en, this message translates to:
  /// **'Identification results'**
  String get historyDetailResults;

  /// No description provided for @historyDetailNotIdentified.
  ///
  /// In en, this message translates to:
  /// **'The mushroom could not be identified.'**
  String get historyDetailNotIdentified;

  /// No description provided for @historyDetailOpenMushroom.
  ///
  /// In en, this message translates to:
  /// **'Open mushroom details'**
  String get historyDetailOpenMushroom;

  /// No description provided for @historyDetailMushroomSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Species description and characteristics'**
  String get historyDetailMushroomSubtitle;

  /// No description provided for @historyDetailDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete record'**
  String get historyDetailDeleteAction;

  /// No description provided for @historyDetailDeleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove from identification history'**
  String get historyDetailDeleteSubtitle;

  /// No description provided for @historyDetailSafetyNotice.
  ///
  /// In en, this message translates to:
  /// **'Do not use identification results as confirmation that a mushroom is safe to eat.'**
  String get historyDetailSafetyNotice;

  /// No description provided for @historyDetailRemoveFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get historyDetailRemoveFavorite;

  /// No description provided for @historyDetailAddFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get historyDetailAddFavorite;

  /// No description provided for @historyDetailSavedMushrooms.
  ///
  /// In en, this message translates to:
  /// **'Saved mushrooms'**
  String get historyDetailSavedMushrooms;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get loginWelcomeBack;

  /// No description provided for @loginAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get loginAccountTitle;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginButton;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginNoAccount;

  /// No description provided for @loginRegister.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get loginRegister;

  /// No description provided for @loginFooter.
  ///
  /// In en, this message translates to:
  /// **'Your companion in the world of mushrooms'**
  String get loginFooter;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed'**
  String get loginFailed;

  /// No description provided for @navigationOfflineMessage.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Working offline.'**
  String get navigationOfflineMessage;

  /// No description provided for @navigationOnlineMessage.
  ///
  /// In en, this message translates to:
  /// **'Connection restored'**
  String get navigationOnlineMessage;

  /// No description provided for @mushroomDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Mushroom details'**
  String get mushroomDetailTitle;

  /// No description provided for @mushroomDetailLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load mushroom information.'**
  String get mushroomDetailLoadError;

  /// No description provided for @mushroomDetailDeadlyWarning.
  ///
  /// In en, this message translates to:
  /// **'DEADLY POISONOUS'**
  String get mushroomDetailDeadlyWarning;

  /// No description provided for @mushroomDetailFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get mushroomDetailFamily;

  /// No description provided for @mushroomDetailPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get mushroomDetailPhotos;

  /// No description provided for @mushroomDetailDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get mushroomDetailDescription;

  /// No description provided for @mushroomDetailNoDescription.
  ///
  /// In en, this message translates to:
  /// **'No description available.'**
  String get mushroomDetailNoDescription;

  /// No description provided for @mushroomDetailSeason.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get mushroomDetailSeason;

  /// No description provided for @mushroomDetailHabitat.
  ///
  /// In en, this message translates to:
  /// **'Habitat'**
  String get mushroomDetailHabitat;

  /// No description provided for @mushroomDetailLookalikes.
  ///
  /// In en, this message translates to:
  /// **'Similar species (lookalikes)'**
  String get mushroomDetailLookalikes;

  /// No description provided for @mushroomDetailNoPhotos.
  ///
  /// In en, this message translates to:
  /// **'No photos available'**
  String get mushroomDetailNoPhotos;

  /// No description provided for @mushroomDetailSimilarSpecies.
  ///
  /// In en, this message translates to:
  /// **'Similar species'**
  String get mushroomDetailSimilarSpecies;

  /// No description provided for @encyclopediaSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search mushrooms by name...'**
  String get encyclopediaSearchHint;

  /// No description provided for @encyclopediaLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load the mushroom encyclopedia'**
  String get encyclopediaLoadError;

  /// No description provided for @encyclopediaEmpty.
  ///
  /// In en, this message translates to:
  /// **'No mushrooms in the encyclopedia yet'**
  String get encyclopediaEmpty;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registerTitle;

  /// No description provided for @registerCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get registerCreateAccount;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join Mushroom Identifier'**
  String get registerSubtitle;

  /// No description provided for @registerCredentials.
  ///
  /// In en, this message translates to:
  /// **'Sign-in details'**
  String get registerCredentials;

  /// No description provided for @registerPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Your password must contain at least 8 characters, uppercase and lowercase letters, a number, and a special character.'**
  String get registerPasswordHint;

  /// No description provided for @registerAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get registerAlreadyHaveAccount;

  /// No description provided for @registerFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registerFailed;

  /// No description provided for @settingsAppSection.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get settingsAppSection;

  /// No description provided for @settingsNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get settingsNotificationsSubtitle;

  /// No description provided for @settingsGeolocationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save where mushrooms are found'**
  String get settingsGeolocationSubtitle;

  /// No description provided for @settingsDataSection.
  ///
  /// In en, this message translates to:
  /// **'Data and storage'**
  String get settingsDataSection;

  /// No description provided for @settingsClearCacheSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Delete temporary files'**
  String get settingsClearCacheSubtitle;

  /// No description provided for @settingsClearCacheTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear cache?'**
  String get settingsClearCacheTitle;

  /// No description provided for @settingsClearCacheMessage.
  ///
  /// In en, this message translates to:
  /// **'Temporary app files will be deleted. Your account, identification history, and favorites will not be deleted.'**
  String get settingsClearCacheMessage;

  /// No description provided for @settingsClearButton.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get settingsClearButton;

  /// No description provided for @settingsCacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Temporary files cleared'**
  String get settingsCacheCleared;

  /// No description provided for @settingsClearCacheFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear cache: {error}'**
  String settingsClearCacheFailed(String error);

  /// No description provided for @settingsExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export my data'**
  String get settingsExportTitle;

  /// No description provided for @settingsExportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save identification history and favorites as JSON'**
  String get settingsExportSubtitle;

  /// No description provided for @settingsExportSaved.
  ///
  /// In en, this message translates to:
  /// **'Data saved: {filePath}'**
  String settingsExportSaved(String filePath);

  /// No description provided for @settingsExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export data'**
  String get settingsExportFailed;

  /// No description provided for @settingsExportError.
  ///
  /// In en, this message translates to:
  /// **'Export error: {error}'**
  String settingsExportError(String error);

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save the selected language'**
  String get settingsLanguageFailed;

  /// No description provided for @authEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get authEmailAlreadyInUse;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get authInvalidEmail;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get authWeakPassword;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get authInvalidCredentials;

  /// No description provided for @authUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled'**
  String get authUserDisabled;

  /// No description provided for @authTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later'**
  String get authTooManyRequests;

  /// No description provided for @authRequiresRecentLogin.
  ///
  /// In en, this message translates to:
  /// **'Please sign in again to complete this action'**
  String get authRequiresRecentLogin;

  /// No description provided for @authNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network connection error'**
  String get authNetworkError;

  /// No description provided for @authOperationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'This operation is not allowed'**
  String get authOperationNotAllowed;

  /// No description provided for @authSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again'**
  String get authSessionExpired;

  /// No description provided for @authNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'You are not signed in'**
  String get authNotAuthenticated;

  /// No description provided for @authUserCreationFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create your account'**
  String get authUserCreationFailed;

  /// No description provided for @authUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get authUnexpectedError;

  /// No description provided for @imageProcessingDecodeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to read the image.'**
  String get imageProcessingDecodeFailed;

  /// No description provided for @imageUnsupportedFormat.
  ///
  /// In en, this message translates to:
  /// **'Only JPG and PNG images are supported.'**
  String get imageUnsupportedFormat;

  /// No description provided for @identificationConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence: {confidence}'**
  String identificationConfidence(String confidence);

  /// No description provided for @exportStorageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Failed to save the file to storage.'**
  String get exportStorageUnavailable;

  /// No description provided for @edibilityEdible.
  ///
  /// In en, this message translates to:
  /// **'Edible'**
  String get edibilityEdible;

  /// No description provided for @edibilityConditionallyEdible.
  ///
  /// In en, this message translates to:
  /// **'Conditionally edible'**
  String get edibilityConditionallyEdible;

  /// No description provided for @edibilityInedible.
  ///
  /// In en, this message translates to:
  /// **'Inedible'**
  String get edibilityInedible;

  /// No description provided for @edibilityPoisonous.
  ///
  /// In en, this message translates to:
  /// **'Poisonous'**
  String get edibilityPoisonous;

  /// No description provided for @edibilityDeadlyPoisonous.
  ///
  /// In en, this message translates to:
  /// **'Deadly poisonous'**
  String get edibilityDeadlyPoisonous;

  /// No description provided for @disclaimerFullWarning.
  ///
  /// In en, this message translates to:
  /// **'WARNING: This result was generated by artificial intelligence and may contain errors. Do not eat a mushroom unless you are absolutely certain it is safe.'**
  String get disclaimerFullWarning;

  /// No description provided for @analysisHighConfidence.
  ///
  /// In en, this message translates to:
  /// **'High confidence'**
  String get analysisHighConfidence;

  /// No description provided for @analysisNeedsCheckLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification recommended'**
  String get analysisNeedsCheckLabel;

  /// No description provided for @analysisNotDeterminedMessage.
  ///
  /// In en, this message translates to:
  /// **'The mushroom could not be identified with sufficient confidence. Try taking a clearer photo from different angles.'**
  String get analysisNotDeterminedMessage;

  /// No description provided for @cameraFrameHint.
  ///
  /// In en, this message translates to:
  /// **'Place the mushroom in the center of the frame'**
  String get cameraFrameHint;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailTooLong.
  ///
  /// In en, this message translates to:
  /// **'Email must not exceed {maxLength} characters'**
  String validationEmailTooLong(int maxLength);

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address format'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least {minLength} characters'**
  String validationPasswordTooShort(int minLength);

  /// No description provided for @validationPasswordUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain an uppercase letter'**
  String get validationPasswordUppercase;

  /// No description provided for @validationPasswordLowercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain a lowercase letter'**
  String get validationPasswordLowercase;

  /// No description provided for @validationPasswordDigit.
  ///
  /// In en, this message translates to:
  /// **'Password must contain a number'**
  String get validationPasswordDigit;

  /// No description provided for @validationPasswordSpecial.
  ///
  /// In en, this message translates to:
  /// **'Password must contain a special character'**
  String get validationPasswordSpecial;

  /// No description provided for @validationConfirmRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get validationConfirmRequired;

  /// No description provided for @validationPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordsMismatch;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Mushroom Identifier'**
  String get appTitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
