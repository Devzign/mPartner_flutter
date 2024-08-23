import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../widgets/verticalspace/vertical_space.dart';
import '../../../utils/localdata/language_constants.dart';

class ProfileInfoWidget extends StatelessWidget {
  final String title;
  final String content;

  const ProfileInfoWidget({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {

    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double fontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    String displayContent = content.isNotEmpty ? content : translation(context).addSecDev1;
    String displayContent2 = content.isNotEmpty ? content : translation(context).addSecDev2;

    TextStyle alternateNumberStyle = GoogleFonts.poppins(
      color: AppColors.hintColor,
      fontSize: 16 * fontMultiplier,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.10 * variablePixelWidth,
    );
    TextStyle numberStyle = GoogleFonts.poppins(
      color: AppColors.darkGreyText,
      fontSize: 16 * fontMultiplier,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.10 * variablePixelWidth,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VerticalSpace(height: 15),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: AppColors.darkGreyText,
            fontSize: 14 * fontMultiplier,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.10 * variablePixelWidth,
          ),
        ),
        const VerticalSpace(height: 8),
        if (title == translation(context).secondaryDevice1 || title == translation(context).secondaryDevice2)
          Text(
            title == translation(context).secondaryDevice1 ? displayContent : displayContent2,
            style: content.isNotEmpty ? numberStyle : alternateNumberStyle,
          ),
        if (title != translation(context).secondaryDevice1  && title != translation(context).secondaryDevice2)
          Text(
            content,
            style: GoogleFonts.poppins(
              color: AppColors.darkGreyText,
              fontSize: 16 * fontMultiplier,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.10 * variablePixelWidth,
            ),
          ),
        const VerticalSpace(height: 10),
      ],
    );
  }
}
