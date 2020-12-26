import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

/*
  tutorial link
  https://blog.geekyants.com/flutter-in-app-localization-438289682f0c

  To add new language

  1. Add the new langauge’s json file in assets > languages
  2. Declare the same json file in pubspec.yaml
  3. Add the language display name and code to the supportedLanguages and supportedLanguagesCodes lists respectively in the Application class.
  4. Update the languagesMap on your Settings page by adding a new MapEntry for the new language
 */
class AppTranslations {
  Locale locale;
  static Map<dynamic, dynamic> _localisedValues;

  AppTranslations(Locale locale) {
    this.locale = locale;
    _localisedValues = null;
  }

  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations);
  }

  static Future<AppTranslations> load(Locale locale) async {
    AppTranslations appTranslations = AppTranslations(locale);
    String jsonContent = await rootBundle
        .loadString("assets/languages/${locale.languageCode}.json");
    _localisedValues = json.decode(jsonContent);
    return appTranslations;
  }

  get currentLanguage => locale.languageCode;

  String text(String key) {
    if (_localisedValues != null) {
      return _localisedValues[key] ?? "$key not found";
    } else {
      return "";
    }
  }

  List<String> array(String key) {
    if (_localisedValues != null) {
      return List<String>.from(_localisedValues[key]) ?? "$key not found";
    } else {
      return [];
    }
  }

  Map<String, String> map(String key) {
    if (_localisedValues != null) {
      return Map<String, String>.from(_localisedValues[key]) ??
          "$key not found";
    } else {
      return Map();
    }
  }
}
