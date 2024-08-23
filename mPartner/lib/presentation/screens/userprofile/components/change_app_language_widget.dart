import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../data/models/language_model.dart';
import '../../../../services/services_locator.dart';
import '../../../../state/contoller/language_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../view/app.dart';
import '../../../widgets/common_divider.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

class ChangeAppLanguageWidget extends StatefulWidget {
  const ChangeAppLanguageWidget({super.key});

  @override
  State<ChangeAppLanguageWidget> createState() =>
      _ChangeAppLanguageWidgetState();
}

class _ChangeAppLanguageWidgetState extends State<ChangeAppLanguageWidget> {
  List<Language> languages = [];
  LanguageController languageController = Get.find();
  var isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    getLanguageList();
  }

  Future<void> getLanguageList() async {
    try {
      isLoading.value = true;
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.getLanguageData();
      result.fold(
        (error) {
          isLoading.value = false;
          //languageController.languageText = 'English';
        },
        (List<Language> languageList) {
          isLoading.value = false;
          languages.addAll(languageList);
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showLanguagesBottomSheet(
      BuildContext context,
      double variablePixelHeight,
      double variablePixelWidth,
      double textMultiplier,
      double pixelMultiplier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0 * pixelMultiplier),
        ),
      ),
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  8 * variablePixelWidth,
                  8 * variablePixelHeight,
                  8 * variablePixelWidth,
                  8 * variablePixelHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Container(
                        height: 5 * variablePixelHeight,
                        width: 50 * variablePixelWidth,
                        decoration: BoxDecoration(
                          color: AppColors.dividerGreyColor,
                          borderRadius:
                              BorderRadius.circular(12 * pixelMultiplier),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: AppColors.black,
                      size: 28 * pixelMultiplier,
                    ),
                  ),
                  const VerticalSpace(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0 * variablePixelWidth),
                    child: Text(
                      translation(context).selectlanguage,
                      style: GoogleFonts.poppins(
                        color: AppColors.titleColor,
                        fontSize: 20 * textMultiplier,
                        fontWeight: FontWeight.w600,
                        height: 0.06,
                        letterSpacing: 0.50 * variablePixelWidth,
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 16),
                  Padding(
                    padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                    child: const CustomDivider(color: AppColors.dividerColor),
                  ),
                  Container(
                    width: 345 * variablePixelWidth,
                    height: 560 * variablePixelHeight,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var language in languages)
                            ListTile(
                              title: Text(language.language),
                              titleTextStyle: GoogleFonts.poppins(
                                color: languageController.languageText == language.language
                                    ? AppColors.lumiBluePrimary
                                    : AppColors.darkGreyText,
                                fontSize: 16 * textMultiplier,
                                fontWeight: FontWeight.w500,
                              ),
                              onTap: () async {
                                setState(() {
                                  languageController.languageText = language.language;
                                });
                                Locale locale =
                                    await setLocale(language.languagecode, language.language);
                                MainApp.setLocale(context, locale);
                                Navigator.pop(context);
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double fontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translation(context).appLanguage,
          style: GoogleFonts.poppins(
            color: AppColors.darkGreyText,
            fontSize: 14 * fontMultiplier,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.10,
          ),
        ),
        const VerticalSpace(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() {
              if (isLoading.isTrue) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Text(
                  languageController.languageText,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 16 * fontMultiplier,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.10,
                  ),
                );
              }
            }),
            GestureDetector(
              onTap: () {
                showLanguagesBottomSheet(context, variablePixelHeight,
                    variablePixelWidth, fontMultiplier, pixelMultiplier);
              },
              child: Text(
                translation(context).change,
                style: GoogleFonts.poppins(
                  color: AppColors.lumiBluePrimary,
                  fontSize: 14 * fontMultiplier,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.10,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
