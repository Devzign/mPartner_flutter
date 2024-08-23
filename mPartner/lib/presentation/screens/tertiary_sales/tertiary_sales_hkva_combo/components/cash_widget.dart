import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import 'package:intl/intl.dart';

class CashWidget extends StatelessWidget {
  CashWidget({super.key, required this.cash});
  final int cash;

  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0,
    symbol: '₹ ',
  );

  @override
  Widget build(BuildContext context) {
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Container(
      height: 20 * variablePixelHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(
        8 * variablePixelWidth,
        2 * variablePixelHeight,
        8 * variablePixelWidth,
        2 * variablePixelHeight,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0 * r),
        color: AppColors.lumiLight4,
      ),
      child: Text(
        '${indianRupeesFormat.format(cash)}',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 12 * f,
          color: AppColors.lumiBluePrimary,
        ),
      ),
    );
  }
}
