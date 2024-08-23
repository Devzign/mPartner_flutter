import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_string.dart';

class QRcodeWidget extends StatelessWidget {
  const QRcodeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Container(
      width: 150 * variablePixelWidth,
      height: 148 * variablePixelHeight,
      padding: EdgeInsets.symmetric(
          horizontal: 16 * variablePixelWidth,
          vertical: 16 * variablePixelHeight),
      decoration: ShapeDecoration(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8 * variablePixelWidth)),
        shadows: const [
          BoxShadow(
            color: AppColors.qrBoxShadow,
            blurRadius: 18,
            offset: Offset(1, 2),
            spreadRadius: 3,
          )
        ],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          child: SvgPicture.asset(
            'assets/mpartner/QRcode.svg',
            height: 70 * variablePixelHeight,
            width: 70 * variablePixelWidth,
          ),
        ),
        SizedBox(height: 16 * variablePixelHeight),
        Text(
          WarrantyString.scanQrCode,
          style: GoogleFonts.poppins(
            color: AppColors.black,
            fontSize: 14 * variablePixelHeight,
            fontWeight: FontWeight.w500,
          ),
        )
      ]),
    );
  }
}
