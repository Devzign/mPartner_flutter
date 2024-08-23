import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';

class TripCardHeading extends StatelessWidget {
  TripCardHeading({
    super.key,
    required this.text,
    this.fontSize = 16,
  });
  final String text;
  double fontSize;
//ThailandTrip

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Text(
      text,
      softWrap: true,
      style: GoogleFonts.poppins(
        color: AppColors.blackText,
        fontSize: fontSize * f,
        fontWeight: FontWeight.w600,

      ),
    );
  }
}
