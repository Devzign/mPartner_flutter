import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';

class ProductChipMiniWidget extends StatelessWidget {
  String productName;
  String productCount;
  ProductChipMiniWidget(
      {super.key, required this.productName, required this.productCount});

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      //height: 24 * h,
      padding: EdgeInsets.only(top: 10 * h, left: 8 * w, right: 8 * w, bottom: 8 * h),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.lightGrey2),
          borderRadius: BorderRadius.circular(100 * r),
        ),
      ),
      child: Text(
        "${productName} (${productCount})",
        style: GoogleFonts.poppins(
          color: AppColors.darkGreyText,
          fontSize: 10 * f,
          fontWeight: FontWeight.w500,
          height: 0.16,
          letterSpacing: 0.10,
        ),
      ),
    );
  }
}
