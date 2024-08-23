import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../utils/app_colors.dart';
import '../../utils/displaymethods/display_methods.dart';
import '../../utils/localdata/language_constants.dart';
import '../../utils/routes/app_routes.dart';
import 'common_button.dart';

class ComingSoonWidget extends StatelessWidget {
  final bool navigateHomeLogin;

  const ComingSoonWidget({super.key, required this.navigateHomeLogin});

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 47 * variablePixelHeight),
          Container(
            width: 266 * variablePixelWidth,
            height: 266 * variablePixelHeight,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12 * pixelMultiplier),
              ),
            ),
            child: Lottie.asset(
                'assets/mpartner/json_assets/img_upcoming_feature.json'),
          ),
          SizedBox(height: 12 * variablePixelHeight),
          Text(
            translation(context).comingSoon,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.lumiDarkBlack,
              fontSize: 18 * textMultiplier,
              height: 20 / 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12 * variablePixelHeight),
          Text(
            translation(context).underDevelopment,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.darkGrey,
              fontSize: 14 * textMultiplier,
              height: 21 / 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 219 * variablePixelWidth,
              height: 50 * variablePixelHeight,
              child: CommonButton(
                onPressed: () {
                  navigateHomeLogin
                      ? Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.homepage,
                          (Route<dynamic> route) => false,
                        )
                      : Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.welcome,
                          (Route<dynamic> route) => false,
                        );
                },
                isEnabled: true,
                buttonText: translation(context).goToHomePage,
                withContainer: false,
                backGroundColor: AppColors.lightWhite1,
                textColor: AppColors.blackText,
                defaultButton: false,
                bottomPadding: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
