import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../CommonCoins/available_coins_widget.dart';

class HeaderWidgetWithCoinInfo extends StatelessWidget {
  final String heading;
  final VoidCallback onPressed;
  final Icon icon;

  const HeaderWidgetWithCoinInfo({super.key, required this.heading, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    final variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double fontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    return Padding(
        padding: EdgeInsets.fromLTRB(14 * variablePixelWidth,
            24 * variablePixelHeight, 20 * variablePixelWidth, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: icon,
                  onPressed:onPressed,
                ),
                Text(
                  heading,
                  style: GoogleFonts.poppins(
                    color: AppColors.iconColor,
                    fontSize: AppConstants.FONT_SIZE_LARGE * fontMultiplier,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const AvailableCoinsWidget(
              fontColor: AppColors.goldCoin,
              fontSize: 12,
            )
          ],
        ));
  }
}
