import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';

class SaleRegistered extends StatelessWidget {
  SaleRegistered({super.key, required this.text1, required this.text2});
  final text1, text2;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text1,
          style: GoogleFonts.poppins(
            color: AppColors.grayText,
            fontSize: 14 * f,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          text2,
          style: GoogleFonts.poppins(
            color: AppColors.darkGreyText,
            fontSize: 14 * f,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
