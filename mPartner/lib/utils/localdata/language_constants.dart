import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpartner/state/contoller/language_controller.dart';
import 'package:mpartner/utils/localdata/shared_preferences_util.dart';

import '../l10n/app_localizations.dart';

const String DEFAULT_LANG_NAME = 'English';
//languages code
const String ENGLISH = 'en';
const String HINDI = 'hi';
const String GUJRATI = 'gu';
const String ASSAMESE = 'as';
const String BENGALI = 'be';
const String TELUGU = 'te';
const String MALAYALAM = 'ml';
const String TAMIL = 'ta';
const String PUNJABI= 'pa';
const String ODIA = 'or';
const String MARATHI= 'mr';
const String KANNADAM = 'kn';

Future<Locale> setLocale(String languageCode, String language) async {
  LanguageController controller = Get.find();
  controller.updateLanguage(languageCode, language);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  LanguageController controller = Get.find();
  String languageCode = await SharedPreferencesUtil.getLang() ?? ENGLISH;
  controller.language = languageCode;
  return _locale(controller.language);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, '');
    case HINDI:
      return const Locale(HINDI, "");
    case GUJRATI:
      return const Locale(GUJRATI, "");
    case ASSAMESE:
      return const Locale(ASSAMESE, "");
    case BENGALI:
      return const Locale(BENGALI, "");
    case TELUGU:
      return const Locale(TELUGU, '');
    case MALAYALAM:
      return const Locale(MALAYALAM, "");
    case TAMIL:
      return const Locale(TAMIL, "");
    case PUNJABI:
      return const Locale(PUNJABI, "");
    case ODIA:
      return const Locale(ODIA, "");
    case MARATHI:
      return const Locale(MARATHI, "");
    case KANNADAM:
      return const Locale(KANNADAM, "");
    default:
      return const Locale(ENGLISH, '');
  }
}

AppLocalizations translation(BuildContext context) {
  return AppLocalizations.of(context)!;
}
