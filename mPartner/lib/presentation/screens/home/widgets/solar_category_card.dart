import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/utils/app_colors.dart';
import 'package:mpartner/presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../utils/displaymethods/display_methods.dart';

class SolarCategoryCard extends StatefulWidget {
  final String imagePath;
  final String text;

   SolarCategoryCard({
    super.key,
    required this.imagePath,
    required this.text,
  });

  @override
  State<SolarCategoryCard> createState() => _SolarCategoryCardState();
}

class _SolarCategoryCardState extends State<SolarCategoryCard> {
  @override
  Widget build(BuildContext context) {
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Container(
        padding: EdgeInsets.only(
            top: 16 * variablePixelHeight, bottom: 16 * variablePixelHeight),
        margin: EdgeInsets.only(right: 16 * variablePixelWidth),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.white_234),
            borderRadius: BorderRadius.circular(8),
          ),
          color: AppColors.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(widget.imagePath),
            VerticalSpace(height: 9),
            Text(
              widget.text,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: AppColors.blackText,
                  fontWeight: FontWeight.w500,
                  fontSize: 12 * textMultiplier),
            )
          ],
        ));
  }
}
