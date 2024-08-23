import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/localdata/language_constants.dart';

class NoMoreNotificationWidget extends StatefulWidget {
  const NoMoreNotificationWidget({super.key});

  @override
  State<NoMoreNotificationWidget> createState() => _NoMoreNotificationWidgetState();
}

class _NoMoreNotificationWidgetState extends State<NoMoreNotificationWidget> {
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      padding: EdgeInsets.fromLTRB(
        36.0 * variablePixelWidth,
        24.0 * variablePixelHeight,
        24.0 * variablePixelWidth,
        24.0 * variablePixelHeight,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            translation(context).noMoreNotificationsToShow,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: AppColors.hintColor,
                fontSize: 14 * textFontMultiplier,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.10 * variablePixelWidth
            ),
          )
        ],
      ),
    );
  }
}