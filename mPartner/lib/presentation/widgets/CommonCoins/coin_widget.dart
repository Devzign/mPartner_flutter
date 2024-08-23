import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/utils/displaymethods/display_methods.dart';

import '../../../../utils/app_colors.dart';
import '../coin_with_image_widget.dart';
import '../coin_with_image_widget.dart';

class CoinWidget extends StatelessWidget {
  CoinWidget({
    super.key,
    this.coins = 3500,
    this.iconSize = 12.5,
    this.textSize = 12,
    this.leftPadding = 4,
    this.rightPadding = 8,
    this.verticalPadding = 2,
    this.postString = "",
  });
  final int coins;
  String postString;
  double iconSize, leftPadding, rightPadding, verticalPadding, textSize;

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Container(
      padding: EdgeInsets.fromLTRB(
          leftPadding * variablePixelWidth,
          verticalPadding * variablePixelHeight,
          rightPadding * variablePixelWidth,
          verticalPadding * variablePixelHeight),
      decoration: ShapeDecoration(
        color: AppColors.goldCoinLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12 * variablePixelWidth),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CoinWithImageWidget(
              coin: double.tryParse("$coins") ?? 0,
              color: AppColors.goldCoin,
              size: iconSize.toInt(),
              weight: FontWeight.w500,
              width: 120),

          Text(
            " ${postString}",
            style: GoogleFonts.poppins(
              color: AppColors.goldCoin,
              fontSize: textSize * variablePixelHeight,
              fontWeight: FontWeight.w600,
            ),
          ),
          // SizedBox(
          //     width: iconSize * variablePixelWidth,
          //     height: iconSize * variablePixelHeight,
          //     child: SvgPicture.asset('assets/mpartner/GoldCoin.svg')),
          // SizedBox(
          //   width: 2 * variablePixelWidth,
          // ),
          // Text(
          //   "$coins ${postString}",
          //   style: GoogleFonts.poppins(
          //     color: AppColors.goldCoin,
          //     fontSize: 12 * variablePixelHeight,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          // SizedBox(
          //     width: iconSize * variablePixelWidth,
          //     height: iconSize * variablePixelHeight,
          //     child: SvgPicture.asset('assets/mpartner/GoldCoin.svg')),
          // SizedBox(
          //   width: 2 * variablePixelWidth,
          // ),
          // Text(
          //   "$coins ${postString}",
          //   style: GoogleFonts.poppins(
          //     color: AppColors.goldCoin,
          //     fontSize: 12 * variablePixelHeight,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
        ],
      ),
    );
  }
}
