import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';

class CommonDetailRowWidget extends StatelessWidget {
  final String label;
  final Object value;

  const CommonDetailRowWidget({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.hintColor,
            fontSize: 14 * textFontMultiplier,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.10,
          ),
        ),
        const HorizontalSpace(width: 20),
        _buildValueWidget(value, textFontMultiplier),
      ],
    );
  }

  Widget _buildValueWidget(Object value, double textFontMultiplier) {
    if (value is Widget) {
      return value;
    } else {
      return Expanded(
        child: Align(
          alignment: Alignment.topRight,
          child: Text(
            '$value',
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: AppColors.darkGreyText,
              fontSize: 14 * textFontMultiplier,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.50,
            ),
          ),
        ),
      );
    }
  }
}

