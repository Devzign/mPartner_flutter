import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/utils/app_colors.dart';
import 'package:mpartner/utils/displaymethods/display_methods.dart';

import '../../../../widgets/coin_with_image_widget.dart';

class CoinChip extends StatefulWidget {
  CoinChip({
    super.key,
    this.coins = 0,
    this.iconSize = 12.5,
    this.leftPadding = 4,
    this.rightPadding = 8,
    this.verticalPadding = 2,
  });
  final int coins;
  double iconSize, leftPadding, rightPadding, verticalPadding;

  @override
  State<CoinChip> createState() => _CoinChipState();
}

class _CoinChipState extends State<CoinChip> {
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Container(
      padding: EdgeInsets.fromLTRB(
          widget.leftPadding * variablePixelWidth,
          widget.verticalPadding * variablePixelHeight,
          widget.rightPadding * variablePixelWidth,
          widget.verticalPadding * variablePixelHeight),
      decoration: ShapeDecoration(
        color: AppColors.goldCoinLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12 * variablePixelWidth),
        ),
      ),
      child: Row(
        children: [
          CoinWithImageWidget(
              coin: double.tryParse("${widget.coins}") ?? 0,
              color: AppColors.goldCoin,
              size: 12,
              weight: FontWeight.w600,
              width: 120),
          // SizedBox(
          //     width: widget.iconSize * variablePixelWidth,
          //     height: widget.iconSize * variablePixelHeight,
          //     child: SvgPicture.asset('assets/mpartner/GoldCoin.svg')),
          // SizedBox(
          //   width: 2 * variablePixelWidth,
          // ),
          // Text(
          //   "${widget.coins}",
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
