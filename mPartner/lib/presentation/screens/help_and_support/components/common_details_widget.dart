import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/verticalspace/vertical_space.dart';


class CommonDetailWidget extends StatelessWidget {
  final IconData? icon;
  final String? iconAssetPath;
  final String text;

  const CommonDetailWidget({
    Key? key,
    this.icon,
    this.iconAssetPath,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.0 * variablePixelWidth, right: 16 * variablePixelWidth),
          child: Container(
            height: 32 * variablePixelHeight,
            width: 32 * variablePixelWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0 * pixelMultiplier),
              color: AppColors.lumiLight5,
            ),
            child: icon != null
                ? Icon(
              icon,
              color: AppColors.lumiBluePrimary,
              size: 24 * pixelMultiplier,
            )
                : iconAssetPath != null
                ? Image.asset(
              iconAssetPath!,
              width: 24 * variablePixelWidth,
              height: 24 * variablePixelHeight,
            )
                : null,
          ),
        ),
        const VerticalSpace(height: 4),
        Padding(
          padding: EdgeInsets.only(left: 16.0 * variablePixelWidth, right: 16 * variablePixelWidth),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: AppColors.darkGreyText,
              fontSize: 14 * textMultiplier,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.50 * variablePixelWidth,
            ),
          ),
        )
      ],
    );
  }
}
