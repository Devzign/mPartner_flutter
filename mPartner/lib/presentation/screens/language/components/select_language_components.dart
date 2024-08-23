import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/language_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/localdata/language_constants.dart';

import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../../../view/app.dart';
import '../../../widgets/common_button.dart';
import '../bloc/language_bloc.dart';

class SelectLanguageComponent extends StatefulWidget {
  const SelectLanguageComponent({super.key});

  @override
  State<SelectLanguageComponent> createState() =>
      _SelectLanguageComponentState();
}

class _SelectLanguageComponentState extends State<SelectLanguageComponent> {
  Language? selectedLanguage;
  bool isButtonEnabled = false;
  double variablePixelHeight = 0;
  double variablePixelWidth = 0;
  double textFontMultiplier = 0;
  double pixelMultiplier = 0;

  @override
  Widget build(BuildContext context) {
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return BlocBuilder<LanguageBloc, LanguageState>(
      buildWhen: (previous, current) =>
          previous.languageScreenState != current.languageScreenState,
      builder: (context, state) {
        print("state: ${state}");
        print("state: ${state.languageScreenData}");
        switch (state.languageScreenState) {
          case RequestState.loading:
            return SizedBox(
              height: variablePixelHeight * 400.0,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case RequestState.loaded:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      EdgeInsets.fromLTRB(0, variablePixelHeight * 93, 0, 0),
                  child: Text(
                    "Select Language",
                    style: GoogleFonts.poppins(
                      color: AppColors.black,
                      fontSize: 24 * textFontMultiplier,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: variablePixelHeight * 20),
                Expanded(
                  child: ListView(
                    children: state.languageScreenData.map((language) {
                      bool isSelected = language == selectedLanguage;

                      return GestureDetector(
                        onTap: () async {
                          setState(() {
                            selectedLanguage = language;
                            if (selectedLanguage != null) {
                              isButtonEnabled = true;
                            }
                          });
                          if (language != null) {
                            Locale locale =
                                await setLocale(language.languagecode, language.language);
                            MainApp.setLocale(context, locale);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(2*pixelMultiplier),
                          padding: EdgeInsets.fromLTRB(
                              10 * variablePixelWidth,
                              5 * variablePixelHeight,
                              10 * variablePixelWidth,
                              5 * variablePixelHeight),
                          child: Card(
                            margin: EdgeInsets.all(1*pixelMultiplier),
                            color: AppColors.lightWhite1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10*pixelMultiplier),
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.lumiBluePrimary
                                    : Colors.transparent,
                                width: 1*pixelMultiplier,
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(16*variablePixelWidth, 16*variablePixelHeight, 16*variablePixelWidth, 16*variablePixelHeight),
                                child: Text(
                                  language.language,
                                  style: GoogleFonts.poppins(
                                    color: isSelected
                                        ? AppColors.lumiBluePrimary : AppColors.black,
                                    fontSize: 16*textFontMultiplier,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: variablePixelHeight * 15),
                CommonButton(
                    onPressed: () {
                      print('Selected Language: ${selectedLanguage!.language}');
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    isEnabled: isButtonEnabled,
                    buttonText: translation(context).continueButtonText,
                    containerBackgroundColor: AppColors.lightGrey,
                    containerHeight: variablePixelHeight * 56)
              ],
            );
          case RequestState.error:
            return SizedBox(
              height: 400*variablePixelHeight,
              child: Center(
                child: Text(state.languageScreenMessage),
              ),
            );
        }
      },
    );
  }
}
