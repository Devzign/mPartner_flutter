import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../horizontalspace/horizontal_space.dart';

class HeaderWidgetWithRightAlignActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onBackPress;
  final bool showCustomActionButton;
  final String? customActionButtonText;
  final IconData? customActionButtonIcon;
  final VoidCallback? onCustomActionButtonPress;
  final double rightPadding;

  const HeaderWidgetWithRightAlignActionButton({
    super.key,
    required this.text,
    this.onBackPress,
    this.showCustomActionButton = false,
    this.customActionButtonText,
    this.customActionButtonIcon,
    this.onCustomActionButtonPress,
    this.rightPadding = 20,
  });

  @override
  Widget build(BuildContext context) {
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return Padding(
      padding: EdgeInsets.fromLTRB(14 * variablePixelWidth, 24 * variablePixelHeight,
          rightPadding * variablePixelWidth, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_outlined,
                color: AppColors.iconColor,
               size: 24 * variablePixelMultiplier),
            onPressed: onBackPress ?? () => Navigator.of(context).pop(),
            color: AppColors.iconColor,
          ),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: AppConstants.FONT_SIZE_LARGE * f,
              color: AppColors.iconColor,
            ),
          ),
          if (showCustomActionButton)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onCustomActionButtonPress,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          customActionButtonIcon ?? Icons.add,
                          color: AppColors.logoutColor,
                          size: 18 * variablePixelWidth,
                        ),
                        const HorizontalSpace(
                          width: 8,
                        ),
                        Text(
                          customActionButtonText ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: AppConstants.FONT_SIZE_EXTRA_SMALL * f,
                            fontWeight: FontWeight.w500,
                            color: AppColors.logoutColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
