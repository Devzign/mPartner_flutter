import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/utils/app_colors.dart';
import 'package:mpartner/utils/displaymethods/display_methods.dart';
import 'package:mpartner/utils/routes/app_routes.dart';
import 'package:mpartner/presentation/screens/menu/menu_screen.dart';
import 'chevron_right.dart';

class SectionHeading extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final VoidCallback? onPressed;
  bool showChevronRight;
  SectionHeading(
      {super.key,
      required this.text,
      this.fontWeight = FontWeight.w600,
      this.onPressed,
      this.showChevronRight = true});

  @override
  Widget build(BuildContext context) {
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: AppColors.blackText,
                fontSize: 16 * textMultiplier,
                fontWeight: fontWeight,
              ),
            ),
          ),
          if(showChevronRight)
          GestureDetector(
            onTap: onPressed,
            child: Container(
              height: 24 * h,
              width: 24 * w,
              decoration: const BoxDecoration(
              shape: BoxShape.circle, 
            ),
              child: ChevronRightWidget(onPressed: onPressed)),
          ),
        ],
      ),
    );
  }
}
