import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../state/contoller/coins_summary_controller.dart';
import '../../../utils/localdata/language_constants.dart';
import '../coin_with_image_widget.dart';
import '../coin_with_image_widget.dart';

class AvailableCoinsWidget extends StatefulWidget {
  const AvailableCoinsWidget(
      {super.key,
      this.fontColor = AppColors.lumiBluePrimary,
      this.fontSize = 16.0});
  final fontColor;
  final double fontSize;
  @override
  State<AvailableCoinsWidget> createState() => _AvailableCoinsWidgetState();
}

class _AvailableCoinsWidgetState extends State<AvailableCoinsWidget> {
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();

    CoinsSummaryController coinsSummaryController = Get.find();
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 8 * variablePixelWidth,
          vertical: 2 * variablePixelHeight),
      decoration: ShapeDecoration(
        color: AppColors.goldCoinLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          GetBuilder<CoinsSummaryController>(
            builder: (_) {
              return CoinWithImageWidget(
                  coin: double.tryParse(coinsSummaryController.availableCoins
                          .replaceAll(",", "")) ??
                      0,
                  color: widget.fontColor,
                  size: widget.fontSize.toInt(),
                  weight: FontWeight.w600,
                  width: 160);
            },
          ),
          Text(
            " ${translation(context).available}",
            style: GoogleFonts.poppins(
              color: widget.fontColor,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),

          // SizedBox(
          //     width: 12.5 * variablePixelWidth,
          //     height: 12.5 * variablePixelHeight,
          //     child: SvgPicture.asset('assets/mpartner/GoldCoin.svg')),
          // SizedBox(
          //   width: 2 * variablePixelWidth,
          // ),
          // GetBuilder<CoinsSummaryController>(
          //   builder: (_) {
          //     return Text(
          //       "${coinsSummaryController.availableCoins} ${translation(context).available}",
          //       // "12,34,56,789 Available",
          //       style: GoogleFonts.poppins(
          //         color: AppColors.goldCoin,
          //         fontSize: 12,
          //
          //         fontWeight: FontWeight.w500,
          //       ),
          //       overflow: TextOverflow.ellipsis,
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
