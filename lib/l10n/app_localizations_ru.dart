// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get settings => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get notifications => 'Уведомления';

  @override
  String get geolocation => 'Геолокация';

  @override
  String get clearCache => 'Очистить кэш';

  @override
  String get exportData => 'Экспорт моих данных';

  @override
  String get home => 'Главная';

  @override
  String get history => 'История';

  @override
  String get favorites => 'Избранное';

  @override
  String get profile => 'Профиль';

  @override
  String get identify => 'Определить';

  @override
  String get takePhoto => 'Сделать фото';

  @override
  String get chooseGallery => 'Выбрать из галереи';

  @override
  String get encyclopedia => 'Справочник грибов';

  @override
  String get recentIdentifications => 'Последние определения';

  @override
  String get identifyMushroomTitle => 'Определите гриб по фотографии';

  @override
  String get identifyMushroomSubtitle => 'Сфотографируйте гриб или выберите готовый снимок из галереи';

  @override
  String get openCameraSubtitle => 'Открыть камеру устройства';

  @override
  String get chooseGallerySubtitle => 'Использовать готовый снимок';

  @override
  String get encyclopediaSubtitle => 'Изучить виды и их особенности';

  @override
  String get emptyRecentHistory => 'Здесь появятся ваши недавние определения.';

  @override
  String get favoriteRemoved => 'Удалено из избранного';

  @override
  String get loading => 'Загрузка...';

  @override
  String get favoriteLoadError => 'Не удалось загрузить гриб';

  @override
  String get favoriteNotFound => 'Гриб не найден';

  @override
  String get emptyFavoritesTitle => 'Здесь пока пусто';

  @override
  String get emptyFavoritesDescription => 'Добавляйте интересные грибы из справочника, чтобы быстро возвращаться к ним.';

  @override
  String get openEncyclopedia => 'Открыть справочник';

  @override
  String get identificationHistory => 'История определений';

  @override
  String get searchMushroomsHint => 'Поиск по названию гриба...';

  @override
  String get clearSearch => 'Очистить поиск';

  @override
  String get all => 'Все';

  @override
  String get statusDetermined => 'Определён';

  @override
  String get statusNeedsCheck => 'Требует проверки';

  @override
  String get statusNotDetermined => 'Не определён';

  @override
  String get noResultsFound => 'Ничего не найдено';

  @override
  String get changeSearchOrFilter => 'Попробуйте изменить поиск или фильтр.';

  @override
  String get emptyHistoryTitle => 'История пока пуста';

  @override
  String get emptyHistoryDescription => 'Сфотографируйте гриб, чтобы здесь появилось ваше первое определение.';

  @override
  String get profileMyProfile => 'Мой профиль';

  @override
  String get profilePersonalAccount => 'Личный кабинет';

  @override
  String get profileMyActivity => 'Моя активность';

  @override
  String get profileIdentifications => 'Определений';

  @override
  String get profileRegistration => 'Регистрация';

  @override
  String get profileAccountManagement => 'Управление аккаунтом';

  @override
  String get profileAppSettings => 'Параметры приложения';

  @override
  String get profileLogoutAction => 'Выйти из аккаунта';

  @override
  String get profileDeleteAction => 'Удалить аккаунт';

  @override
  String get profileLogoutTitle => 'Выход';

  @override
  String get profileLogoutMessage => 'Вы действительно хотите выйти из аккаунта?';

  @override
  String get profileCancel => 'Отмена';

  @override
  String get profileLogoutConfirm => 'Выйти';

  @override
  String get profileDeleteTitle => 'Удаление аккаунта';

  @override
  String get profileDeleteWarning => 'ВНИМАНИЕ! Все ваши данные будут безвозвратно удалены: профиль, история определений, избранное и настройки. Это действие необратимо.';

  @override
  String get profileConfirmPassword => 'Подтвердите пароль';

  @override
  String get profileEnterPassword => 'Введите пароль';

  @override
  String get profileDeleteForever => 'Удалить навсегда';

  @override
  String get profileDeleteFailed => 'Не удалось удалить аккаунт';

  @override
  String get analysisSavedToHistory => 'Сохранено в историю';

  @override
  String get analysisDeadlyTitle => 'ОПАСНО! ОПРЕДЕЛЁН СМЕРТЕЛЬНО ЯДОВИТЫЙ ГРИБ';

  @override
  String get analysisDeadlyMessage => 'Изображение с высокой вероятностью соответствует смертельно ядовитому грибу. Употребление в пищу может привести к летальному исходу. Ни в коем случае не используйте этот гриб в пищу.';

  @override
  String get analysisUnderstood => 'Понятно';

  @override
  String get analysisResultTitle => 'Результат анализа';

  @override
  String get analysisPossibleMatches => 'Возможные варианты';

  @override
  String get analysisConfidence => 'уверенность';

  @override
  String get analysisInFavorites => 'В избранном';

  @override
  String get analysisAddToFavorites => 'Добавить в избранное';

  @override
  String get analysisReviewWarning => 'Не удалось надёжно определить гриб. Не используйте результат для решения о съедобности.';

  @override
  String get analysisEdibilitySeeDetails => 'Смотрите сведения о виде';

  @override
  String get analysisSafetyWarning => 'Автоматическое распознавание не гарантирует правильность определения гриба. Никогда не принимайте решение о съедобности только на основании результата приложения.';

  @override
  String get previewTitle => 'Предпросмотр';

  @override
  String get previewLoginRequired => 'Необходимо войти в аккаунт.';

  @override
  String previewAnalysisFailed(String error) {
    return 'Не удалось выполнить анализ: $error';
  }

  @override
  String get previewRetake => 'Переснять';

  @override
  String get previewConfirm => 'Подтвердить';

  @override
  String get previewCameraHint => 'Поместите гриб в центр кадра';

  @override
  String get previewAnalyzing => 'Идёт анализ...';

  @override
  String get disclaimerTitle => 'Важная информация';

  @override
  String get disclaimerSubtitle => 'Пожалуйста, ознакомьтесь перед использованием приложения';

  @override
  String get disclaimerSafetyTitle => 'Ваша безопасность важна';

  @override
  String get disclaimerAgreement => 'Я прочитал(а) и понимаю предупреждение';

  @override
  String get disclaimerSaving => 'Сохранение...';

  @override
  String get disclaimerAcceptContinue => 'Принять и продолжить';

  @override
  String get disclaimerFooter => 'Безопасность важнее любого результата распознавания.';

  @override
  String disclaimerSaveError(String error) {
    return 'Не удалось сохранить подтверждение: $error';
  }

  @override
  String get disclaimerEnglishSafetyNotice => 'Автоматическое распознавание грибов может ошибаться. Не используйте результат приложения для определения съедобности и никогда не употребляйте неизвестные грибы.';

  @override
  String get disclaimerOriginalTextLabel => 'Полный исходный текст предупреждения:';

  @override
  String get historyDetailTitle => 'Детали определения';

  @override
  String get historyDetailDeleteConfirmTitle => 'Удалить запись?';

  @override
  String get historyDetailDeleteConfirmMessage => 'Запись определения будет удалена без возможности восстановления.';

  @override
  String get historyDetailDeleteConfirmButton => 'Удалить';

  @override
  String get historyDetailDeleted => 'Запись удалена';

  @override
  String get historyDetailDeleteFailed => 'Не удалось удалить запись';

  @override
  String get historyDetailLoadFailed => 'Не удалось загрузить запись';

  @override
  String get historyDetailNotFound => 'Запись не найдена';

  @override
  String get historyDetailDate => 'Дата';

  @override
  String get historyDetailTime => 'Время';

  @override
  String get historyDetailResults => 'Результаты распознавания';

  @override
  String get historyDetailNotIdentified => 'Гриб не был определён.';

  @override
  String get historyDetailOpenMushroom => 'Открыть карточку гриба';

  @override
  String get historyDetailMushroomSubtitle => 'Описание и особенности вида';

  @override
  String get historyDetailDeleteAction => 'Удалить запись';

  @override
  String get historyDetailDeleteSubtitle => 'Удалить из истории определений';

  @override
  String get historyDetailSafetyNotice => 'Не используйте результат распознавания как подтверждение съедобности гриба.';

  @override
  String get historyDetailRemoveFavorite => 'Убрать из избранного';

  @override
  String get historyDetailAddFavorite => 'Добавить в избранное';

  @override
  String get historyDetailSavedMushrooms => 'Сохранённые грибы';

  @override
  String get loginWelcomeBack => 'С возвращением!';

  @override
  String get loginAccountTitle => 'Вход в аккаунт';

  @override
  String get loginPassword => 'Пароль';

  @override
  String get loginButton => 'Войти';

  @override
  String get loginNoAccount => 'Нет аккаунта?';

  @override
  String get loginRegister => 'Зарегистрироваться';

  @override
  String get loginFooter => 'Ваш помощник в мире грибов';

  @override
  String get loginFailed => 'Ошибка входа';

  @override
  String get navigationOfflineMessage => 'Нет подключения к сети. Работа в офлайн-режиме.';

  @override
  String get navigationOnlineMessage => 'Подключение восстановлено';

  @override
  String get mushroomDetailTitle => 'Карточка гриба';

  @override
  String get mushroomDetailLoadError => 'Не удалось загрузить информацию о грибе.';

  @override
  String get mushroomDetailDeadlyWarning => 'СМЕРТЕЛЬНО ОПАСЕН';

  @override
  String get mushroomDetailFamily => 'Семейство';

  @override
  String get mushroomDetailPhotos => 'Фотографии';

  @override
  String get mushroomDetailDescription => 'Описание';

  @override
  String get mushroomDetailNoDescription => 'Описание отсутствует.';

  @override
  String get mushroomDetailSeason => 'Сезон';

  @override
  String get mushroomDetailHabitat => 'Места произрастания';

  @override
  String get mushroomDetailLookalikes => 'Похожие виды (двойники)';

  @override
  String get mushroomDetailNoPhotos => 'Нет фотографий';

  @override
  String get mushroomDetailSimilarSpecies => 'Похожий вид';

  @override
  String get encyclopediaSearchHint => 'Поиск по названию...';

  @override
  String get encyclopediaLoadError => 'Не удалось загрузить справочник';

  @override
  String get encyclopediaEmpty => 'В справочнике пока нет грибов';

  @override
  String get registerTitle => 'Регистрация';

  @override
  String get registerCreateAccount => 'Создать аккаунт';

  @override
  String get registerSubtitle => 'Присоединяйтесь к Mushroom Identifier';

  @override
  String get registerCredentials => 'Данные для входа';

  @override
  String get registerPasswordHint => 'Пароль должен содержать минимум 8 символов, заглавную и строчную буквы, цифру и специальный символ.';

  @override
  String get registerAlreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get registerFailed => 'Ошибка регистрации';

  @override
  String get settingsAppSection => 'Приложение';

  @override
  String get settingsNotificationsSubtitle => 'Настройки уведомлений';

  @override
  String get settingsGeolocationSubtitle => 'Сохранять место находки гриба';

  @override
  String get settingsDataSection => 'Данные и хранилище';

  @override
  String get settingsClearCacheSubtitle => 'Удалить временные файлы';

  @override
  String get settingsClearCacheTitle => 'Очистить кэш?';

  @override
  String get settingsClearCacheMessage => 'Будут удалены временные файлы приложения. Ваш аккаунт, история определений и избранное не будут удалены.';

  @override
  String get settingsClearButton => 'Очистить';

  @override
  String get settingsCacheCleared => 'Временные файлы очищены';

  @override
  String settingsClearCacheFailed(String error) {
    return 'Не удалось очистить кэш: $error';
  }

  @override
  String get settingsExportTitle => 'Экспорт моих данных';

  @override
  String get settingsExportSubtitle => 'Сохранить историю и избранное в JSON';

  @override
  String settingsExportSaved(String filePath) {
    return 'Данные сохранены: $filePath';
  }

  @override
  String get settingsExportFailed => 'Не удалось экспортировать данные';

  @override
  String settingsExportError(String error) {
    return 'Ошибка экспорта: $error';
  }

  @override
  String get settingsLanguageTitle => 'Язык интерфейса';

  @override
  String get settingsLanguageFailed => 'Не удалось сохранить выбранный язык';

  @override
  String get authEmailAlreadyInUse => 'Этот email уже зарегистрирован';

  @override
  String get authInvalidEmail => 'Некорректный email';

  @override
  String get authWeakPassword => 'Слишком слабый пароль';

  @override
  String get authInvalidCredentials => 'Неверный email или пароль';

  @override
  String get authUserDisabled => 'Аккаунт заблокирован';

  @override
  String get authTooManyRequests => 'Слишком много попыток. Попробуйте позже';

  @override
  String get authRequiresRecentLogin => 'Требуется повторный вход для этой операции';

  @override
  String get authNetworkError => 'Ошибка подключения к сети';

  @override
  String get authOperationNotAllowed => 'Операция не разрешена';

  @override
  String get authSessionExpired => 'Срок действия сеанса истёк. Войдите снова';

  @override
  String get authNotAuthenticated => 'Пользователь не авторизован';

  @override
  String get authUserCreationFailed => 'Не удалось создать пользователя';

  @override
  String get authUnexpectedError => 'Произошла непредвиденная ошибка. Попробуйте ещё раз.';

  @override
  String get imageProcessingDecodeFailed => 'Не удалось прочитать изображение.';

  @override
  String get imageUnsupportedFormat => 'Поддерживаются только изображения в формате JPG или PNG.';

  @override
  String identificationConfidence(String confidence) {
    return 'Уверенность: $confidence';
  }

  @override
  String get exportStorageUnavailable => 'Не удалось сохранить файл в хранилище.';

  @override
  String get edibilityEdible => 'Съедобный';

  @override
  String get edibilityConditionallyEdible => 'Условно-съедобный';

  @override
  String get edibilityInedible => 'Несъедобный';

  @override
  String get edibilityPoisonous => 'Ядовитый';

  @override
  String get edibilityDeadlyPoisonous => 'Смертельно ядовитый';

  @override
  String get disclaimerFullWarning => 'ВНИМАНИЕ: Данный результат сгенерирован искусственным интеллектом и может содержать ошибки. Не употребляйте гриб в пищу, не будучи абсолютно уверенным в его безопасности.';

  @override
  String get analysisHighConfidence => 'Высокая уверенность';

  @override
  String get analysisNeedsCheckLabel => 'Рекомендуется проверить';

  @override
  String get analysisNotDeterminedMessage => 'Не удалось определить с достаточной уверенностью. Попробуйте сделать более чёткое фото с разных ракурсов.';

  @override
  String get cameraFrameHint => 'Расположите гриб в центре кадра';

  @override
  String get validationEmailRequired => 'Введите email';

  @override
  String validationEmailTooLong(int maxLength) {
    return 'Email не должен превышать $maxLength символов';
  }

  @override
  String get validationEmailInvalid => 'Некорректный формат email';

  @override
  String get validationPasswordRequired => 'Введите пароль';

  @override
  String validationPasswordTooShort(int minLength) {
    return 'Пароль должен содержать минимум $minLength символов';
  }

  @override
  String get validationPasswordUppercase => 'Пароль должен содержать заглавную букву';

  @override
  String get validationPasswordLowercase => 'Пароль должен содержать строчную букву';

  @override
  String get validationPasswordDigit => 'Пароль должен содержать цифру';

  @override
  String get validationPasswordSpecial => 'Пароль должен содержать специальный символ';

  @override
  String get validationConfirmRequired => 'Повторите пароль';

  @override
  String get validationPasswordsMismatch => 'Пароли не совпадают';

  @override
  String get appTitle => 'Определитель грибов';
}
