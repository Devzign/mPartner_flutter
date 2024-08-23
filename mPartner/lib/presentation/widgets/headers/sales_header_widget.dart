import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';

class HeadingRegisterSales extends StatefulWidget {
  final String heading;
  final Icon icon;
  final int headingSize;
  final Function() onPressed;
  final Color textColor;

  const HeadingRegisterSales(
      {required this.heading,
      required this.onPressed,
      this.textColor = AppColors.iconColor,
      required this.icon,
      this.headingSize = AppConstants.FONT_SIZE_LARGE,
      super.key});

  @override
  State<HeadingRegisterSales> createState() => _HeadingRegisterSalesState();
}

class _HeadingRegisterSalesState extends State<HeadingRegisterSales> {
  @override
  Widget build(BuildContext context) {
    final variableTextMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    final variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    final variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();

    return Padding(
      padding: EdgeInsets.only(
          left: 14 * variablePixelWidth,
          top: 24 * variablePixelHeight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: widget.icon,
            onPressed: () => widget.onPressed.call(),
          ),
          Expanded(
            child: Text(
              widget.heading,
              softWrap: true,
              style: GoogleFonts.poppins(
                color: widget.textColor,
                fontSize: widget.headingSize * variableTextMultiplier,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
