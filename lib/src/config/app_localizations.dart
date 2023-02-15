import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  Locale locale;
  static Map<dynamic, dynamic>? _localizedValues;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// Carrega JSON segons current locale
  static Future<AppLocalizations> load(Locale locale) async {
    print("app locales LOAD locale.languageCode --> "+locale.languageCode);

    AppLocalizations appTranslations = AppLocalizations(locale);

    String jsonContent = await rootBundle.loadString("assets/i18n/${locale.languageCode}.json");

    _localizedValues = json.decode(jsonContent);

    return appTranslations;
  }

  bool get isEN {
    if (locale.languageCode.toUpperCase() == "EN") {
      return true;
    }

    return false;
  }

  String getString(String value){
    return _localizedValues != null ? _localizedValues![value] : "";
  }

  String getCurrentLocaleString() {
    return locale.languageCode;
  }
}

/// A isSupported cal afegir tots els locales dels idiomes que tingui l'app
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final Locale? newLocale;

  const AppLocalizationsDelegate({this.newLocale});

  /// Afegim els idiomes supported
  @override
  bool isSupported(Locale locale) {
    return ["es", "en", "ca"].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(newLocale ?? locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return true;
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}