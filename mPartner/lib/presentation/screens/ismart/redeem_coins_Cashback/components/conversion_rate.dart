import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/localdata/language_constants.dart';

class ConversionRateWidget extends StatelessWidget {
  String start;
  String end;
  var rate;
  ConversionRateWidget({super.key, required this.start,required this.end, required this.rate});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${start}-${end}",
          style: GoogleFonts.poppins(
              color: AppColors.darkGreyText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 0.09,
              letterSpacing: 0.50),
        ),
        Text(
          "₹ ${rate} ${translation(context).perCoin}",
          style: GoogleFonts.roboto(
              color: AppColors.darkGreyText,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
