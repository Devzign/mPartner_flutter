import 'package:get/get.dart';

import '../../utils/localdata/language_constants.dart';
import '../../utils/localdata/shared_preferences_util.dart';

class LanguageController extends GetxController {
  var language = ENGLISH;
  var languageText = DEFAULT_LANG_NAME;

  @override
  void onInit() async {
    super.onInit();
    String languageCode = await SharedPreferencesUtil.getLang() ?? ENGLISH;
    String lang = await SharedPreferencesUtil.getLangText() ?? DEFAULT_LANG_NAME;
    language = languageCode;
    languageText = lang;
    update();
  }

  updateLanguage(lang, languageString) async {
    await SharedPreferencesUtil.saveLang(lang);
    await SharedPreferencesUtil.saveLangText(languageString);
    language = lang;
    languageText = languageString;
    update();
  }

  clearLangData() {
    language = "";
    languageText = "";
    update();
  }
}
