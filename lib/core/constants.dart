import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Определитель грибов';

  static const String prefDisclaimerAccepted = 'disclaimer_accepted';
  static const String prefLanguage = 'language';

  static const String usersCollection = 'users';
  static const String settingsCollection = 'settings';
  static const String identificationsCollection = 'identifications';
  static const String predictionsSubcollection = 'predictions';
  static const String mushroomsCollection = 'mushrooms';
  static const String mushroomImagesCollection = 'mushroomImages';
  static const String doppelgangersCollection = 'doppelgangers';
  static const String favoritesCollection = 'favorites';

  static const String disclaimerText =
      'ВНИМАНИЕ: Данный результат сгенерирован искусственным интеллектом и '
      'может содержать ошибки. Не употребляйте гриб в пищу, не будучи '
      'абсолютно уверенным в его безопасности.';

  static const String analysisWarningText =
      'ВНИМАНИЕ: Данный результат сгенерирован искусственным интеллектом и '
      'может содержать ошибки. Не употребляйте гриб в пищу, не будучи '
      'абсолютно уверенным в его безопасности на основе дополнительной '
      'проверки.';

  static const String labelHighConfidence = 'Высокая уверенность';
  static const String labelNeedsCheck = 'Рекомендуется проверить';

  static const String messageNotDetermined =
      'Не удалось определить с достаточной уверенностью. Попробуйте сделать '
      'более чёткое фото с разных ракурсов.';

  static const String cameraHint = 'Расположите гриб в центре кадра';

  static String storagePathForIdentification(
    String uid,
    int timestamp,
  ) {
    return 'users/$uid/identifications/$timestamp.jpg';
  }

  static const int emailMaxLength = 200;
  static const int passwordMinLength = 8;
}

enum IdentificationStatus {
  determined('Determined', 'Определён'),
  needsCheck('NeedsCheck', 'Требует проверки'),
  notDetermined('NotDetermined', 'Не определён');

  const IdentificationStatus(this.value, this.labelRu);

  final String value;
  final String labelRu;

  String localizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case IdentificationStatus.determined:
        return l10n.statusDetermined;
      case IdentificationStatus.needsCheck:
        return l10n.statusNeedsCheck;
      case IdentificationStatus.notDetermined:
        return l10n.statusNotDetermined;
    }
  }

  static IdentificationStatus fromValue(String value) {
    return IdentificationStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => IdentificationStatus.notDetermined,
    );
  }
}

enum Edibility {
  edible('Edible', 'Съедобный'),
  conditionallyEdible('ConditionallyEdible', 'Условно-съедобный'),
  inedible('Inedible', 'Несъедобный'),
  poisonous('Poisonous', 'Ядовитый'),
  deadlyPoisonous('DeadlyPoisonous', 'Смертельно ядовитый');

  const Edibility(this.value, this.labelRu);

  final String value;
  final String labelRu;

  String localizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case Edibility.edible:
        return l10n.edibilityEdible;
      case Edibility.conditionallyEdible:
        return l10n.edibilityConditionallyEdible;
      case Edibility.inedible:
        return l10n.edibilityInedible;
      case Edibility.poisonous:
        return l10n.edibilityPoisonous;
      case Edibility.deadlyPoisonous:
        return l10n.edibilityDeadlyPoisonous;
    }
  }

  static Edibility fromValue(String value) {
    return Edibility.values.firstWhere(
      (edibility) => edibility.value == value,
      orElse: () => Edibility.inedible,
    );
  }
}
