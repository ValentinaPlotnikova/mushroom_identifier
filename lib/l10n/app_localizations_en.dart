// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get geolocation => 'Location';

  @override
  String get clearCache => 'Clear cache';

  @override
  String get exportData => 'Export my data';

  @override
  String get home => 'Home';

  @override
  String get history => 'History';

  @override
  String get favorites => 'Favorites';

  @override
  String get profile => 'Profile';

  @override
  String get identify => 'Identify';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseGallery => 'Choose from gallery';

  @override
  String get encyclopedia => 'Mushroom encyclopedia';

  @override
  String get recentIdentifications => 'Recent identifications';

  @override
  String get identifyMushroomTitle => 'Identify a mushroom from a photo';

  @override
  String get identifyMushroomSubtitle => 'Take a photo of a mushroom or choose an existing picture from your gallery';

  @override
  String get openCameraSubtitle => 'Open your device camera';

  @override
  String get chooseGallerySubtitle => 'Use an existing photo';

  @override
  String get encyclopediaSubtitle => 'Explore mushroom species and their characteristics';

  @override
  String get emptyRecentHistory => 'Your recent identifications will appear here.';

  @override
  String get favoriteRemoved => 'Removed from favorites';

  @override
  String get loading => 'Loading...';

  @override
  String get favoriteLoadError => 'Failed to load mushroom';

  @override
  String get favoriteNotFound => 'Mushroom not found';

  @override
  String get emptyFavoritesTitle => 'Nothing here yet';

  @override
  String get emptyFavoritesDescription => 'Save interesting mushrooms from the encyclopedia to easily find them again.';

  @override
  String get openEncyclopedia => 'Open encyclopedia';

  @override
  String get identificationHistory => 'Identification history';

  @override
  String get searchMushroomsHint => 'Search by mushroom name...';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get all => 'All';

  @override
  String get statusDetermined => 'Identified';

  @override
  String get statusNeedsCheck => 'Needs review';

  @override
  String get statusNotDetermined => 'Not identified';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get changeSearchOrFilter => 'Try changing your search or filter.';

  @override
  String get emptyHistoryTitle => 'No identification history yet';

  @override
  String get emptyHistoryDescription => 'Take a photo of a mushroom to see your first identification here.';

  @override
  String get profileMyProfile => 'My profile';

  @override
  String get profilePersonalAccount => 'Personal account';

  @override
  String get profileMyActivity => 'My activity';

  @override
  String get profileIdentifications => 'Identifications';

  @override
  String get profileRegistration => 'Joined';

  @override
  String get profileAccountManagement => 'Account management';

  @override
  String get profileAppSettings => 'App preferences';

  @override
  String get profileLogoutAction => 'Log out';

  @override
  String get profileDeleteAction => 'Delete account';

  @override
  String get profileLogoutTitle => 'Log out';

  @override
  String get profileLogoutMessage => 'Are you sure you want to log out of your account?';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get profileLogoutConfirm => 'Log out';

  @override
  String get profileDeleteTitle => 'Delete account';

  @override
  String get profileDeleteWarning => 'WARNING! All your data will be permanently deleted, including your profile, identification history, favorites, and settings. This action cannot be undone.';

  @override
  String get profileConfirmPassword => 'Confirm password';

  @override
  String get profileEnterPassword => 'Please enter your password';

  @override
  String get profileDeleteForever => 'Delete permanently';

  @override
  String get profileDeleteFailed => 'Failed to delete account';

  @override
  String get analysisSavedToHistory => 'Saved to history';

  @override
  String get analysisDeadlyTitle => 'DANGER! A DEADLY POISONOUS MUSHROOM WAS IDENTIFIED';

  @override
  String get analysisDeadlyMessage => 'The image is highly likely to show a deadly poisonous mushroom. Eating this mushroom may be fatal. Do not eat it under any circumstances.';

  @override
  String get analysisUnderstood => 'Understood';

  @override
  String get analysisResultTitle => 'Analysis result';

  @override
  String get analysisPossibleMatches => 'Possible matches';

  @override
  String get analysisConfidence => 'confidence';

  @override
  String get analysisInFavorites => 'In favorites';

  @override
  String get analysisAddToFavorites => 'Add to favorites';

  @override
  String get analysisReviewWarning => 'The mushroom could not be reliably identified. Do not use this result to determine whether it is safe to eat.';

  @override
  String get analysisEdibilitySeeDetails => 'See species details';

  @override
  String get analysisSafetyWarning => 'Automated mushroom identification is not guaranteed to be accurate. Never decide whether a mushroom is safe to eat based on this app alone.';

  @override
  String get previewTitle => 'Photo preview';

  @override
  String get previewLoginRequired => 'Please log in to your account.';

  @override
  String previewAnalysisFailed(String error) {
    return 'Analysis failed: $error';
  }

  @override
  String get previewRetake => 'Retake';

  @override
  String get previewConfirm => 'Confirm';

  @override
  String get previewCameraHint => 'Place the mushroom in the center of the frame';

  @override
  String get previewAnalyzing => 'Analyzing...';

  @override
  String get disclaimerTitle => 'Important information';

  @override
  String get disclaimerSubtitle => 'Please read this information before using the app';

  @override
  String get disclaimerSafetyTitle => 'Your safety matters';

  @override
  String get disclaimerAgreement => 'I have read and understand the warning';

  @override
  String get disclaimerSaving => 'Saving...';

  @override
  String get disclaimerAcceptContinue => 'Accept and continue';

  @override
  String get disclaimerFooter => 'Safety matters more than any identification result.';

  @override
  String disclaimerSaveError(String error) {
    return 'Could not save your confirmation: $error';
  }

  @override
  String get disclaimerEnglishSafetyNotice => 'Automated mushroom identification can be wrong. The app cannot establish whether a mushroom is safe to eat. Never eat an unidentified mushroom or rely on this app alone for an edibility decision. Misidentification may cause serious poisoning or death.';

  @override
  String get disclaimerOriginalTextLabel => 'Full original warning (Russian):';

  @override
  String get historyDetailTitle => 'Identification details';

  @override
  String get historyDetailDeleteConfirmTitle => 'Delete this record?';

  @override
  String get historyDetailDeleteConfirmMessage => 'This identification record will be permanently deleted and cannot be recovered.';

  @override
  String get historyDetailDeleteConfirmButton => 'Delete';

  @override
  String get historyDetailDeleted => 'Record deleted';

  @override
  String get historyDetailDeleteFailed => 'Failed to delete record';

  @override
  String get historyDetailLoadFailed => 'Failed to load record';

  @override
  String get historyDetailNotFound => 'Record not found';

  @override
  String get historyDetailDate => 'Date';

  @override
  String get historyDetailTime => 'Time';

  @override
  String get historyDetailResults => 'Identification results';

  @override
  String get historyDetailNotIdentified => 'The mushroom could not be identified.';

  @override
  String get historyDetailOpenMushroom => 'Open mushroom details';

  @override
  String get historyDetailMushroomSubtitle => 'Species description and characteristics';

  @override
  String get historyDetailDeleteAction => 'Delete record';

  @override
  String get historyDetailDeleteSubtitle => 'Remove from identification history';

  @override
  String get historyDetailSafetyNotice => 'Do not use identification results as confirmation that a mushroom is safe to eat.';

  @override
  String get historyDetailRemoveFavorite => 'Remove from favorites';

  @override
  String get historyDetailAddFavorite => 'Add to favorites';

  @override
  String get historyDetailSavedMushrooms => 'Saved mushrooms';

  @override
  String get loginWelcomeBack => 'Welcome back!';

  @override
  String get loginAccountTitle => 'Sign in to your account';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get loginRegister => 'Sign up';

  @override
  String get loginFooter => 'Your companion in the world of mushrooms';

  @override
  String get loginFailed => 'Sign-in failed';

  @override
  String get navigationOfflineMessage => 'No internet connection. Working offline.';

  @override
  String get navigationOnlineMessage => 'Connection restored';

  @override
  String get mushroomDetailTitle => 'Mushroom details';

  @override
  String get mushroomDetailLoadError => 'Failed to load mushroom information.';

  @override
  String get mushroomDetailDeadlyWarning => 'DEADLY POISONOUS';

  @override
  String get mushroomDetailFamily => 'Family';

  @override
  String get mushroomDetailPhotos => 'Photos';

  @override
  String get mushroomDetailDescription => 'Description';

  @override
  String get mushroomDetailNoDescription => 'No description available.';

  @override
  String get mushroomDetailSeason => 'Season';

  @override
  String get mushroomDetailHabitat => 'Habitat';

  @override
  String get mushroomDetailLookalikes => 'Similar species (lookalikes)';

  @override
  String get mushroomDetailNoPhotos => 'No photos available';

  @override
  String get mushroomDetailSimilarSpecies => 'Similar species';

  @override
  String get encyclopediaSearchHint => 'Search mushrooms by name...';

  @override
  String get encyclopediaLoadError => 'Failed to load the mushroom encyclopedia';

  @override
  String get encyclopediaEmpty => 'No mushrooms in the encyclopedia yet';

  @override
  String get registerTitle => 'Registration';

  @override
  String get registerCreateAccount => 'Create an account';

  @override
  String get registerSubtitle => 'Join Mushroom Identifier';

  @override
  String get registerCredentials => 'Sign-in details';

  @override
  String get registerPasswordHint => 'Your password must contain at least 8 characters, uppercase and lowercase letters, a number, and a special character.';

  @override
  String get registerAlreadyHaveAccount => 'Already have an account?';

  @override
  String get registerFailed => 'Registration failed';

  @override
  String get settingsAppSection => 'App';

  @override
  String get settingsNotificationsSubtitle => 'Notification preferences';

  @override
  String get settingsGeolocationSubtitle => 'Save where mushrooms are found';

  @override
  String get settingsDataSection => 'Data and storage';

  @override
  String get settingsClearCacheSubtitle => 'Delete temporary files';

  @override
  String get settingsClearCacheTitle => 'Clear cache?';

  @override
  String get settingsClearCacheMessage => 'Temporary app files will be deleted. Your account, identification history, and favorites will not be deleted.';

  @override
  String get settingsClearButton => 'Clear';

  @override
  String get settingsCacheCleared => 'Temporary files cleared';

  @override
  String settingsClearCacheFailed(String error) {
    return 'Failed to clear cache: $error';
  }

  @override
  String get settingsExportTitle => 'Export my data';

  @override
  String get settingsExportSubtitle => 'Save identification history and favorites as JSON';

  @override
  String settingsExportSaved(String filePath) {
    return 'Data saved: $filePath';
  }

  @override
  String get settingsExportFailed => 'Failed to export data';

  @override
  String settingsExportError(String error) {
    return 'Export error: $error';
  }

  @override
  String get settingsLanguageTitle => 'App language';

  @override
  String get settingsLanguageFailed => 'Failed to save the selected language';

  @override
  String get authEmailAlreadyInUse => 'This email is already registered';

  @override
  String get authInvalidEmail => 'Invalid email address';

  @override
  String get authWeakPassword => 'Password is too weak';

  @override
  String get authInvalidCredentials => 'Incorrect email or password';

  @override
  String get authUserDisabled => 'This account has been disabled';

  @override
  String get authTooManyRequests => 'Too many attempts. Please try again later';

  @override
  String get authRequiresRecentLogin => 'Please sign in again to complete this action';

  @override
  String get authNetworkError => 'Network connection error';

  @override
  String get authOperationNotAllowed => 'This operation is not allowed';

  @override
  String get authSessionExpired => 'Your session has expired. Please sign in again';

  @override
  String get authNotAuthenticated => 'You are not signed in';

  @override
  String get authUserCreationFailed => 'Failed to create your account';

  @override
  String get authUnexpectedError => 'An unexpected error occurred. Please try again.';

  @override
  String get imageProcessingDecodeFailed => 'Failed to read the image.';

  @override
  String get imageUnsupportedFormat => 'Only JPG and PNG images are supported.';

  @override
  String identificationConfidence(String confidence) {
    return 'Confidence: $confidence';
  }

  @override
  String get exportStorageUnavailable => 'Failed to save the file to storage.';

  @override
  String get edibilityEdible => 'Edible';

  @override
  String get edibilityConditionallyEdible => 'Conditionally edible';

  @override
  String get edibilityInedible => 'Inedible';

  @override
  String get edibilityPoisonous => 'Poisonous';

  @override
  String get edibilityDeadlyPoisonous => 'Deadly poisonous';

  @override
  String get disclaimerFullWarning => 'WARNING: This result was generated by artificial intelligence and may contain errors. Do not eat a mushroom unless you are absolutely certain it is safe.';

  @override
  String get analysisHighConfidence => 'High confidence';

  @override
  String get analysisNeedsCheckLabel => 'Verification recommended';

  @override
  String get analysisNotDeterminedMessage => 'The mushroom could not be identified with sufficient confidence. Try taking a clearer photo from different angles.';

  @override
  String get cameraFrameHint => 'Place the mushroom in the center of the frame';

  @override
  String get validationEmailRequired => 'Enter your email address';

  @override
  String validationEmailTooLong(int maxLength) {
    return 'Email must not exceed $maxLength characters';
  }

  @override
  String get validationEmailInvalid => 'Invalid email address format';

  @override
  String get validationPasswordRequired => 'Enter your password';

  @override
  String validationPasswordTooShort(int minLength) {
    return 'Password must contain at least $minLength characters';
  }

  @override
  String get validationPasswordUppercase => 'Password must contain an uppercase letter';

  @override
  String get validationPasswordLowercase => 'Password must contain a lowercase letter';

  @override
  String get validationPasswordDigit => 'Password must contain a number';

  @override
  String get validationPasswordSpecial => 'Password must contain a special character';

  @override
  String get validationConfirmRequired => 'Confirm your password';

  @override
  String get validationPasswordsMismatch => 'Passwords do not match';

  @override
  String get appTitle => 'Mushroom Identifier';
}
