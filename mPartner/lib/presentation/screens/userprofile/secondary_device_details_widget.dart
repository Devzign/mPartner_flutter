import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../widgets/verticalspace/vertical_space.dart';

class SecondaryDevDetails extends StatelessWidget {
  final String label;
  final String value;

  const SecondaryDevDetails({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double fontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.darkGreyText,
            fontSize: 14 * fontMultiplier,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.10 * variablePixelWidth,
          ),
        ),
        const VerticalSpace(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: AppColors.darkGreyText,
            fontSize: 16 * fontMultiplier,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.10 * variablePixelWidth,
          ),
        ),
      ],
    );
  }
}
