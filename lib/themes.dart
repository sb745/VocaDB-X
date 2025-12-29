import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Themes
class Themes {
  static final dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  );

  static final light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
  );

  static void changeTheme(String value) {
    if (value == 'light') {
      Get.changeTheme(light);
    } else if (value == 'dark') {
      Get.changeTheme(dark);
    }
    // 'system' theme is handled by the app's theme observer
  }

  /// Get the appropriate theme based on system brightness
  static ThemeData getSystemAwareTheme(Brightness systemBrightness) {
    return systemBrightness == Brightness.dark ? dark : light;
  }

  /// Get theme by name
  static ThemeData getThemeByName(String themeName) {
    if (themeName == 'light') {
      return light;
    } else if (themeName == 'dark') {
      return dark;
    } else if (themeName == 'system') {
      // For system theme, default to light (actual system theme will be applied by themeMode)
      return light;
    }
    return light;
  }
}
