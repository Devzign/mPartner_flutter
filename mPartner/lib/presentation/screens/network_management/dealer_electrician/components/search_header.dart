import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';


class SearchHeaderWidget extends StatelessWidget {
  final String title;
  final void Function()? onClose;

  const SearchHeaderWidget({
    Key? key,
    required this.title,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
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
              size: 30 * variablePixelMultiplier,
            ),
            onPressed: onClose,
          ),
        Container(
          margin: EdgeInsets.only(left: 10*variablePixelWidth),
          width: variablePixelWidth * 393,
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: AppColors.iconColor,
              fontStyle: FontStyle.normal,
              fontSize: 18 * variableTextMultiplier,
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
