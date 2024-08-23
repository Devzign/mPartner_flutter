import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

class CustomTextWidget extends StatelessWidget {
  final String title;
  final String description;

  CustomTextWidget({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      margin: EdgeInsets.only(top: 8 * variablePixelHeight, left: 24 * variablePixelWidth, bottom: 24 * variablePixelHeight, right: 20 * variablePixelWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppColors.lumiDarkBlack,
              fontSize: 16 * textFontMultiplier,
              fontWeight: FontWeight.w600,
            ),
          ),
          const VerticalSpace(height: 4),
          Padding(
            padding: EdgeInsets.only(right: 24 * variablePixelWidth),
            child: Container(
              width: 345 * variablePixelWidth,
              height: 40 * variablePixelHeight,
              child: Text(
                description,
                style: GoogleFonts.poppins(
                  color: AppColors.darkGreyText,
                  fontWeight: FontWeight.w500,
                  fontSize: 14 * textFontMultiplier,
                  letterSpacing: 0.25 * variablePixelWidth,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
