import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import 'coin_chip.dart';
import '../../../../../state/contoller/coin_redemption_options_controller.dart';
import '../../../../../state/contoller/coins_summary_controller.dart';

import '../../../../../utils/localdata/language_constants.dart';

class RedeemableCoinsWidget extends StatefulWidget {
  RedeemableCoinsWidget({super.key,});

  @override
  State<RedeemableCoinsWidget> createState() => _RedeemableCoinsWidgetState();
}

class _RedeemableCoinsWidgetState extends State<RedeemableCoinsWidget> {
  @override
  
  CoinRedemptionOptionsController coinRedemptionOptionsController = Get.find();
  CoinsSummaryController coinsSummaryController = Get.find();
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 24 * variablePixelWidth,
          vertical: 20 * variablePixelHeight),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translation(context).redeemableCoins,
                style: GoogleFonts.poppins(
                  color: AppColors.darkGreyText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.10,
                ),
              ),
              GetBuilder<CoinRedemptionOptionsController>(
                builder: (_) {
                  return Text(
                  coinRedemptionOptionsController.redeemText,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.lightGreyBorder,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.10,
                  ),
                );
                }
              )
            ],
          ),
          GetBuilder<CoinRedemptionOptionsController>(builder: (_) { 
             return CoinChip(coins: coinRedemptionOptionsController.redeemableBalance);
           },)
        ],
      ),
    );
  }
}
