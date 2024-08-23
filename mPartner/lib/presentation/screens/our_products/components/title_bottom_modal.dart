import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/app_colors.dart';

class titleBottomModal extends StatelessWidget {
  titleBottomModal({
    super.key,
    required this.title,
    required this.onPressed,
    this.spaceBetweeenIconAndHeading = 12,
    this.spaceBetweenDividerAndHeading = 16,
    this.icon = Icons.close,
    this.fontSize = 20,
    this.showButton = true,
  });
  final String title;
  final icon;
  final bool showButton;
  final double spaceBetweeenIconAndHeading,
      spaceBetweenDividerAndHeading,
      fontSize;

  VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: showButton,
          child: GestureDetector(
            onTap: onPressed,
            child: Icon(
              icon,
              color: Colors.black,
            ),
          ),
        ),
        Visibility(
          visible: showButton,
          child: SizedBox(
            height: spaceBetweeenIconAndHeading * h,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: AppColors.titleColor,
            fontSize: 20 * f,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.50 * w,
          ),
        ),
        SizedBox(
          height: spaceBetweenDividerAndHeading * h,
        ),
        Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: AppColors.bottomSheetSeparatorColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
