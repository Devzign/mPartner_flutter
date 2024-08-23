import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/common_divider.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

selectGenderBottomSheet(BuildContext context, Function(String selectedGender) onGenderSelected,) {
  double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
  double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
  double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
  double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VerticalSpace(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Center(
              child: Container(
                height: 5 * variablePixelHeight,
                width: 50 * variablePixelWidth,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12 * pixelMultiplier),
                ),
              ),
            ),
          ),
          const VerticalSpace(height: 16),
          Container(
            margin: EdgeInsets.only(left: 10.0 * variablePixelWidth, right: 24 * variablePixelWidth),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 28 * pixelMultiplier,
              ),
            ),
          ),
          const VerticalSpace(height: 12),
          Container(
            margin: EdgeInsets.only(left: 24.0 * variablePixelWidth, right: 24 * variablePixelWidth),
            child: Text(
              translation(context).selectGender,
              style: GoogleFonts.poppins(
                color: AppColors.titleColor,
                fontSize: 20 * textMultiplier,
                fontWeight: FontWeight.w600,
                height: 0.06,
                letterSpacing: 0.50,
              ),
            ),
          ),
          const VerticalSpace(height: 16),
          Container(
            margin: EdgeInsets.only(left: 24.0 * variablePixelWidth, right: 24 * variablePixelWidth),
            child: const CustomDivider(color: AppColors.dividerColor),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0 * variablePixelWidth, right: 24 * variablePixelWidth),
            child: ListTile(
              title: Text(
                translation(context).male,
                style: GoogleFonts.poppins(
                  color: AppColors.titleColor,
                  fontSize: 16 * textMultiplier,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.50,
                ),
              ),
              onTap: () {
                onGenderSelected(translation(context).male);
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0 * variablePixelWidth, right: 24 * variablePixelWidth),
            child: ListTile(
              title: Text(
                translation(context).female,
                style: GoogleFonts.poppins(
                  color: AppColors.titleColor,
                  fontSize: 16 * textMultiplier,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.50,
                ),
              ),
              onTap: () {
                onGenderSelected(translation(context).female);
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0 * variablePixelWidth, right: 24 * variablePixelWidth),
            child: ListTile(
              title: Text(
                translation(context).preferNotToSay,
                style: GoogleFonts.poppins(
                  color: AppColors.titleColor,
                  fontSize: 16 * textMultiplier,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.50,
                ),
              ),
              onTap: () {
                onGenderSelected(translation(context).preferNotToSay);
                Navigator.of(context).pop();
              },
            ),
          ),
          const VerticalSpace(height: 24),
        ],
      );
    },
  );
}
