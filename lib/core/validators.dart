import '../l10n/app_localizations.dart';
import 'constants.dart';

class Validators {
  Validators._();

  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]"
    r"(?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
    r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$",
  );

  static final RegExp _upperRegExp = RegExp(r'[A-ZА-ЯЁ]');
  static final RegExp _lowerRegExp = RegExp(r'[a-zа-яё]');
  static final RegExp _digitRegExp = RegExp(r'[0-9]');
  static final RegExp _specialRegExp = RegExp(
    r'''[~!?@#$%^&*_\-+()\[\]{}><\\/|"' .,;:]''',
  );

  static String? validateEmail(
    String? value, [
    AppLocalizations? l10n,
  ]) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return l10n?.validationEmailRequired ?? 'Введите email';
    }

    if (email.length > AppConstants.emailMaxLength) {
      return l10n?.validationEmailTooLong(
            AppConstants.emailMaxLength,
          ) ??
          'Email не должен превышать '
              '${AppConstants.emailMaxLength} символов';
    }

    if (!_emailRegExp.hasMatch(email)) {
      return l10n?.validationEmailInvalid ?? 'Некорректный формат email';
    }

    return null;
  }

  static String? validatePassword(
    String? value, [
    AppLocalizations? l10n,
  ]) {
    final password = value ?? '';

    if (password.isEmpty) {
      return l10n?.validationPasswordRequired ?? 'Введите пароль';
    }

    if (password.length < AppConstants.passwordMinLength) {
      return l10n?.validationPasswordTooShort(
            AppConstants.passwordMinLength,
          ) ??
          'Пароль должен содержать минимум '
              '${AppConstants.passwordMinLength} символов';
    }

    if (!_upperRegExp.hasMatch(password)) {
      return l10n?.validationPasswordUppercase ??
          'Пароль должен содержать заглавную букву';
    }

    if (!_lowerRegExp.hasMatch(password)) {
      return l10n?.validationPasswordLowercase ??
          'Пароль должен содержать строчную букву';
    }

    if (!_digitRegExp.hasMatch(password)) {
      return l10n?.validationPasswordDigit ?? 'Пароль должен содержать цифру';
    }

    if (!_specialRegExp.hasMatch(password)) {
      return l10n?.validationPasswordSpecial ??
          'Пароль должен содержать специальный символ';
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String original, [
    AppLocalizations? l10n,
  ]) {
    if (value == null || value.isEmpty) {
      return l10n?.validationConfirmRequired ?? 'Повторите пароль';
    }

    if (value != original) {
      return l10n?.validationPasswordsMismatch ?? 'Пароли не совпадают';
    }

    return null;
  }
}
