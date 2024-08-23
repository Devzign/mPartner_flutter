import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';

class NoOfBatteryMessage extends StatelessWidget {
  NoOfBatteryMessage({
    super.key,
    required this.number,
  });
  String number;
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text:
                '${translation(context).basedOnInverterCapacityPleaseScan} ${number} ',
            style: GoogleFonts.poppins(
              color: AppColors.grayText,
              fontSize: 12 * f,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: 'X ',
            style: GoogleFonts.poppins(
              color: AppColors.grayText,
              fontSize: 10 * f,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: translation(context).batteryOfTheSamemodel,
            style: GoogleFonts.poppins(
              color: AppColors.grayText,
              fontSize: 12 * f,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
