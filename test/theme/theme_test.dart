import 'package:challengemultiplication/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    test('configures the Material theme used by the app', () {
      final theme = AppTheme.themeData;

      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.light);
      expect(theme.appBarTheme.centerTitle, isTrue);
      expect(theme.elevatedButtonTheme.style, isNotNull);
      expect(theme.outlinedButtonTheme.style, isNotNull);
      expect(theme.dialogTheme.backgroundColor, AppTheme.colorScheme.surface);
    });
  });
}
