import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mushroom_identifier/core/validators.dart';

void main() {
  group('Validators.validateEmail', () {
    test('пустой email отклоняется', () {
      expect(Validators.validateEmail(''), isNotNull);
    });

    test('некорректный формат отклоняется', () {
      expect(Validators.validateEmail('not-an-email'), isNotNull);
    });

    test('корректный email принимается', () {
      expect(Validators.validateEmail('user@example.com'), isNull);
    });
  });

  group('Validators.validatePassword', () {
    test('короткий пароль отклоняется', () {
      expect(Validators.validatePassword('Aa1!'), isNotNull);
    });

    test('без спецсимвола отклоняется', () {
      expect(Validators.validatePassword('Abcdefg1'), isNotNull);
    });

    test('валидный пароль принимается', () {
      expect(Validators.validatePassword('Abcdef1!'), isNull);
    });
  });

  group('Validators.validateConfirmPassword', () {
    test('несовпадающие пароли отклоняются', () {
      expect(
        Validators.validateConfirmPassword('Abcdef1!', 'Other1!a'),
        isNotNull,
      );
    });

    test('совпадающие пароли принимаются', () {
      expect(
        Validators.validateConfirmPassword('Abcdef1!', 'Abcdef1!'),
        isNull,
      );
    });
  });

  testWidgets('Простой smoke-тест виджета', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('Определитель грибов'))),
    );
    expect(find.text('Определитель грибов'), findsOneWidget);
  });
}
