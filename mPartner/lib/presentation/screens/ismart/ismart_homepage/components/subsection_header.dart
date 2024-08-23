import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/utils/app_colors.dart';
import 'package:mpartner/utils/displaymethods/display_methods.dart';

class SubsectionHeader extends StatelessWidget {
  String sectionHeader;
  SubsectionHeader({super.key, required this.sectionHeader});

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      margin: EdgeInsets.only(
        left: 24 * variablePixelWidth,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        sectionHeader,
        style: GoogleFonts.poppins(
          color: AppColors.darkText2,
          fontSize: 16 * textMultiplier,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
