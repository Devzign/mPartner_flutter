import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../utils/app_colors.dart';
import '../../utils/displaymethods/display_methods.dart';
import '../../utils/localdata/language_constants.dart';
import '../screens/tertiarysalessingleproduct/components/help_and_support_widget.dart';

class SomethingWentWrongWidget extends StatelessWidget {
  const SomethingWentWrongWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return Expanded(
      child: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24 * variablePixelWidth,
            24 * variablePixelHeight,
            24 * variablePixelWidth,
            24 * variablePixelHeight,
          ),
          child: Column(
            children: [
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12 * pixelMultiplier),
                      ),
                    ),
                    child: Lottie.asset(
                        'assets/mpartner/json_assets/img_something_went_wrong.json'),
                  ),
                  SizedBox(height: 12 * variablePixelHeight),
                  Text(
                    translation(context).somethingWentWrong,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkText2,
                      fontSize: 18 * textFontMultiplier,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12 * variablePixelHeight),
                  Text(
                    translation(context).experiencingSomeTechnicalDifficulties,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGreyText,
                      fontSize: 12 * textFontMultiplier,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const HelpAndSupportWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
