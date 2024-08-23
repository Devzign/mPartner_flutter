import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import 'dashboard.dart';

class CustomContainer extends StatelessWidget {
  DashboardDataPeice data;
  Color? backgroundColor;
  int integerHeight;
  CustomContainer({super.key, required this.data, this.backgroundColor, required this.integerHeight});

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
      DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
      DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
      DisplayMethods(context: context).getPixelMultiplier();
    double textFontMultiplier =
      DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        border: Border.all(
          width: 1,
          color: AppColors.lightGrey2,
        ),
        borderRadius: BorderRadius.circular(12 * variablePixelWidth),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(40, 64, 147, 0.08),
            offset: Offset(1, 2),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ]
      ),
      child: Center(child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16 * variablePixelHeight,horizontal: 5*variablePixelWidth),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              data.value < 10 ? "0${data.value.toString()}" : data.value.toString(),
              style: GoogleFonts.poppins(
                color: data.integerColor,
                fontSize: integerHeight * textFontMultiplier,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              data.label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: 12 * textFontMultiplier,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.10 * variablePixelWidth,
              ),
            )
          ],
        ),
      )),
    );
  }
}