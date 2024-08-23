import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

class NoTripsAvailable extends StatelessWidget {
  const NoTripsAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 125 * w,
              height: 119 * h,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12 * r),
                ),
              ),
              child:
                  Lottie.asset('assets/mpartner/json_assets/img_no_trips.json'),
            ),
            const VerticalSpace(height: 16),
            Text(
              translation(context).noTripText1,
              style: GoogleFonts.poppins(
                color: AppColors.darkText2,
                fontSize: 18 * f,
                fontWeight: FontWeight.w600,
              ),
            ),
            const VerticalSpace(height: 12),
            Text(
              translation(context).noTripText2,
              style: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: 14 * f,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              translation(context).noTripText3,
              style: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: 14 * f,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
