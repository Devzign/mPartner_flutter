import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../presentation/widgets/common_button.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../screens/home/home_screen.dart';

class NothingHereYetWidget extends StatefulWidget {
  final String textForNothingHereYet;

  const NothingHereYetWidget({
    super.key,
    required this.textForNothingHereYet,
  });

  @override
  State<NothingHereYetWidget> createState() => _NothingHereYetWidgetState();
}

class _NothingHereYetWidgetState extends State<NothingHereYetWidget> {
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        translation(context).nothingHereyet,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkText2,
                          fontSize: 18 * textFontMultiplier,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12 * variablePixelHeight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.textForNothingHereYet,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 12 * textFontMultiplier,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 28 * variablePixelHeight),
                  SizedBox(
                    width: 300 * variablePixelWidth,
                    child: CommonButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      },
                      isEnabled: true,
                      buttonText: translation(context).goToHomePage,
                      backGroundColor: AppColors.lightWhite1,
                      textColor: AppColors.lumiBluePrimary,
                      defaultButton: false,
                      containerBackgroundColor: AppColors.white,
                    ),
                  )
                ],
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
