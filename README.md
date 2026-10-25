# Определитель грибов (mushroom_identifier)

Flutter-приложение для автоматического определения видов грибов с помощью
искусственного интеллекта. Это **первый этап** разработки: заложен фундамент
проекта, интеграция с Firebase и модуль аутентификации.

## Архитектура

Чистая слоистая архитектура:

```
lib/
├── core/                  # тема, константы, валидаторы, роутер
│   ├── app_theme.dart
│   ├── app_router.dart
│   ├── constants.dart     # enum'ы Edibility / IdentificationStatus, ключи
│   └── validators.dart    # правила валидации email и пароля
├── models/                # модели данных Firestore
│   ├── app_user.dart
│   ├── user_settings.dart
│   ├── mushroom.dart
│   ├── mushroom_image.dart
│   ├── doppelganger.dart
│   ├── prediction.dart
│   ├── identification.dart
│   └── favorite.dart
├── services/              # доступ к Firebase
│   ├── firebase_service.dart      # инициализация, доступ к экземплярам
│   ├── auth_service.dart          # signUp / signIn / signOut / deleteAccount
│   ├── firestore_service.dart     # CRUD по всем коллекциям
│   ├── data_seed_service.dart     # заполнение тестовыми данными
│   └── preferences_service.dart   # SharedPreferences (дисклеймер, язык)
├── providers/             # управление состоянием (Provider)
│   ├── auth_provider.dart
│   └── settings_provider.dart
├── widgets/               # переиспользуемые виджеты
│   ├── app_text_field.dart
│   ├── loading_overlay.dart
│   └── edibility_badge.dart
├── screens/               # экраны
│   ├── disclaimer_screen.dart
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── settings_screen.dart
│   ├── main_navigation_screen.dart
│   └── tabs/
│       ├── home_tab.dart       # «Определить» (камера)
│       ├── history_tab.dart    # «История»
│       ├── favorites_tab.dart  # «Избранное»
│       └── profile_tab.dart    # «Профиль»
├── firebase_options.dart  # ЗАГЛУШКА — перегенерировать flutterfire
└── main.dart
```

## Структура данных Firestore

| Коллекция | Поля |
|-----------|------|
| `users/{uid}` | email, createdAt, totalIdentifications |
| `settings/{uid}` | language, notificationsEnabled, geolocationEnabled |
| `identifications/{id}` | userId, imageUrl, status, createdAt, results[] |
| `identifications/{id}/predictions/{id}` | mushroomId, confidence, mushroomName |
| `mushrooms/{id}` | nameRu, nameLatin, family, edibility, description, season, habitat, hasDoppelgangers |
| `mushroomImages/{id}` | mushroomId, imageUrl, description |
| `doppelgangers/{id}` | mushroomId, similarMushroomId, differences |
| `favorites/{id}` | userId, mushroomId, addedAt |

**Статусы определения:** `Determined`, `NeedsCheck`, `NotDetermined`.

**Съедобность:** `Edible`, `ConditionallyEdible`, `Inedible`, `Poisonous`,
`DeadlyPoisonous`.

Правила безопасности — в [`firestore.rules`](firestore.rules).

## Реализованный функционал (этап 1)

- **Дисклеймер** при первом запуске (чекбокс + «Принять»), сохранение факта
  принятия в SharedPreferences — больше не показывается.
- **SplashScreen** — проверка дисклеймера, состояния аутентификации и
  заполнение тестовых данных.
- **Регистрация** с валидацией:
  - email — корректный формат, до 200 символов;
  - пароль — минимум 8 символов, заглавная + строчная буквы, цифра,
    спецсимвол; подтверждение пароля; инлайн-ошибки.
- **Вход / выход**.
- **Профиль** — email, дата регистрации, количество определений, выход,
  удаление аккаунта (с подтверждением пароля и предупреждением; удаляет данные
  из Firebase Auth и Firestore).
- **Нижняя навигация** из 4 вкладок: Определить, История, Избранное, Профиль.
- **Настройки** — язык (RU/EN), уведомления, геолокация, очистка кэша, экспорт
  данных в JSON.
- **Тестовые данные** — 10 реальных видов грибов и связи «двойников»,
  заполняются `DataSeedService` только при отсутствии данных.

## Стилизация

- Material Design 3, зелёная «лесная» палитра (primary `#2E7D32`).
- Крупные элементы управления и высокий контраст для использования на улице.
- Весь интерфейс — на русском языке.

## Зависимости

`firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`,
`provider`, `image_picker`, `cached_network_image`, `go_router`,
`shared_preferences`, `intl`, `path_provider`, `share_plus`.

## Дальнейшие этапы

- Определение гриба по фото (ИИ-модель + загрузка в Storage).
- Карточка гриба, экран результатов, детальные изображения и двойники.
- Полноценная локализация (RU/EN).
