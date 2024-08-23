import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import 'custom_cross_icon.dart';
import 'green_tick_icon.dart';

class RegisteredNumberWidget extends StatelessWidget {
  RegisteredNumberWidget({required this.number, required this.verified, super.key});
  final String number;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    return Container(
      margin: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translation(context).registeredNumber,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontWeight: FontWeight.w600,
                    fontSize: 16 * textFontMultiplier,
                  ),
                ),
                const VerticalSpace(height: 4),
                Text(
                  '+91-$number',
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontWeight: FontWeight.w500,
                    fontSize: 14 * textFontMultiplier,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 24 * variablePixelWidth,
            height: 24 * variablePixelHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  top: 10 * variablePixelHeight,
                  child: verified ? CustomTickIcon() : CustomCrossIcon(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
