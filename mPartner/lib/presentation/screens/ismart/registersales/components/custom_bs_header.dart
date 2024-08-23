import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';

class CustomBSHeaderWidget extends StatelessWidget {
  final String title;
  final void Function()? onClose;

  const CustomBSHeaderWidget({
    Key? key,
    required this.title,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    double variableTextMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onClose != null)
          IconButton(
            icon: Icon(
              Icons.close,
              color: AppColors.iconColor,
              weight: 400,
              size: 32 * variablePixelMultiplier,
            ),
            onPressed: onClose,
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12 * variablePixelWidth),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: AppColors.iconColor,
                fontStyle: FontStyle.normal,
                fontSize: 20 * variableTextMultiplier,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        Divider(
          thickness: 1,
          color: AppColors.dividerGreyColor,
        ),
      ],
    );
  }
}
