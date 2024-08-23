import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';

class TripDuration extends StatelessWidget {
  TripDuration({
    super.key,
    required this.duration,
    required this.isSolo,
  });
  final String duration;
  final bool isSolo;
// '3D 2N'
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${duration} /',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: AppColors.darkGrey,
            fontSize: 14 * f,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          width: 4 * w,
        ),
        Icon(
          isSolo ? Icons.person_2_outlined : Icons.groups_2_outlined,
          size: 16 * f,
        ),
      ],
    );
  }
}
