import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';

class ReportTypeTextWidget extends StatelessWidget {
  String text;
  final Function() onTap;
  ReportTypeTextWidget({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40 * h,
        width: double.infinity,
        child: Text(
                text,
                style: GoogleFonts.poppins(
                  color: AppColors.titleColor,
                  fontSize: 16 * f,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.50,
                ),
              ),
      ),
    );
  }
}
