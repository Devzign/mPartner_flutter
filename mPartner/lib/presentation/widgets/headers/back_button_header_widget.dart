import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';

class HeaderWidgetWithBackButton extends StatelessWidget {
  HeaderWidgetWithBackButton({
    super.key,
    required this.heading,
    this.leftPadding = 14,
    this.topPadding = 24,
    this.rightPadding = 20,
    this.iconColor = AppColors.iconColor,
    this.textColor = AppColors.iconColor,
    required this.onPressed,
    this.icon = Icons.arrow_back_outlined,
  });

  final double leftPadding, topPadding;
  final double rightPadding;
  final String heading;
  final Color iconColor, textColor;
  VoidCallback onPressed;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    double variablePixel =
        DisplayMethods(context: context).getVariablePixelWidth();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return Padding(
      padding: EdgeInsets.fromLTRB(
          leftPadding * variablePixel, topPadding * variablePixel, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                icon,
                color: iconColor,
              ),
              onPressed: onPressed),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              heading,
              style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: AppConstants.FONT_SIZE_LARGE * f,
                  fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
