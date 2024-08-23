import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';

class CommonDetailRow extends StatelessWidget {
  final String label;
  final String value;

  CommonDetailRow({
    required this.label,
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            label,
            style: GoogleFonts.poppins(
              color: AppColors.hintColor,
              fontSize: 14 * textMultiplier,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.10 * variablePixelWidth,
            )
        ),
        const HorizontalSpace(width: 30),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              color: AppColors.darkGrey,
              fontSize: 14 * textMultiplier,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.10 * variablePixelWidth,
            ),
            softWrap: true,
            textAlign: TextAlign.right,
          ),
        )
      ],
    );
  }
}
