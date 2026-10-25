class UserSettings {
  final String language;
  final bool notificationsEnabled;
  final bool geolocationEnabled;

  const UserSettings({
    this.language = 'ru',
    this.notificationsEnabled = true,
    this.geolocationEnabled = false,
  });

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      language: map['language'] as String? ?? 'ru',
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      geolocationEnabled: map['geolocationEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'language': language,
      'notificationsEnabled': notificationsEnabled,
      'geolocationEnabled': geolocationEnabled,
    };
  }

  UserSettings copyWith({
    String? language,
    bool? notificationsEnabled,
    bool? geolocationEnabled,
  }) {
    return UserSettings(
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      geolocationEnabled: geolocationEnabled ?? this.geolocationEnabled,
    );
  }
}
