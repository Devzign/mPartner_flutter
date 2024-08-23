import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';

class MySnackBar {
  static SnackBar createSnackBar(BuildContext context) {
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier= DisplayMethods(context: context).getPixelMultiplier();
    return SnackBar(
      content: Text(
        translation(context).secondaryDeviceUpdated,
        style: GoogleFonts.poppins(
          color: AppColors.lumiDarkBlack,
          fontSize: 14 * textFontMultiplier,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25 * variablePixelWidth,
        ),
      ),
      elevation: 3,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.lightGreen, width: 1 * variablePixelWidth),
        borderRadius: BorderRadius.circular(4 * pixelMultiplier),
      ),
      backgroundColor: AppColors.lightGreen,
      duration: const Duration(seconds: 3),
    );
  }
}
