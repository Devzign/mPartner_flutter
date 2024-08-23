import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';

class AddTravellerCard extends StatelessWidget {
  const AddTravellerCard({super.key, required this.number});
  final int number;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Opacity(
      opacity: 0.80,
      child: Container(
        padding: EdgeInsets.all(16 * r),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.lightGrey2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${translation(context).addTraveller} ${number}',
              style: GoogleFonts.poppins(
                color: AppColors.darkGrey,
                fontSize: 16 * f,
                height: 24 / 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
                height: 24 * r,
                width: 24 * r,
                child: const Icon(
                  Icons.add,
                  color: AppColors.lumiBluePrimary,
                ))
          ],
        ),
      ),
    );
  }
}
