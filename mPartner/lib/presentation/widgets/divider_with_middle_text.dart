import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';

class DividerWithMiddleText extends StatelessWidget {
  const DividerWithMiddleText({
    super.key,
    required this.text,
    this.textPadding = 8,
    this.lengthDivider = 136,
    this.fontSize = 14,
  });
  final String text;
  final double textPadding, lengthDivider, fontSize;

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: lengthDivider * variablePixelWidth,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1 * variablePixelWidth,
                // strokeAlign: BorderSide.strokeAlignCenter,
                color: AppColors.lightGrey2,
              ),
            ),
          ),
        ),
        SizedBox(width: textPadding * variablePixelWidth),
        Text(
          'OR',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.darkGreyText,
            fontSize: fontSize * variablePixelHeight,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: textPadding * variablePixelWidth),
        Container(
          width: lengthDivider * variablePixelWidth,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1 * variablePixelWidth,
                  // strokeAlign: BorderSide.strokeAlignCenter,
                  color: AppColors.lightGrey2),
            ),
          ),
        ),
      ],
    );
  }
}
