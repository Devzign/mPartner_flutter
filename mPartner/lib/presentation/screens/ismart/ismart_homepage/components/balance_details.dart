import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../state/contoller/cash_summary_controller.dart';
import '../../../../../state/contoller/coins_summary_controller.dart';
import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_string.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/coin_with_image_widget.dart';
import '../../../../widgets/rupee_with_sign_widget.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../cash_coins_history/cash_coin_history_screen.dart';

class BalanceDetailsCard extends StatefulWidget {
  CardType cardType;

  BalanceDetailsCard({super.key, required this.cardType});

  @override
  State<BalanceDetailsCard> createState() => _BalanceDetailsCardState();
}

class _BalanceDetailsCardState extends State<BalanceDetailsCard> {
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultipler =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    CoinsSummaryController coinsSummaryController = Get.find();
    CashSummaryController cashSummaryController = Get.find();
    final UserDataController udc = Get.find();

    return Row(
      children: [
        Expanded(
            flex: 5,
            child: InkWell(
              onTap: () {
                // if (udc.isPrimaryNumberLogin) {
                widget.cardType.toString() == CardType.Cash.toString()
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CashCoinHistoryScreen(
                                cardType: FilterCashCoin.cashType)))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CashCoinHistoryScreen(
                                cardType: FilterCashCoin.coinType)));
                // }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12 * variablePixelHeight),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    shadows: [
                      BoxShadow(
                        color: AppColors.balanceBoxShadow,
                        blurRadius: 8 * pixelMultipler,
                        offset: const Offset(1, 2),
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.cardType == CardType.Coins
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(
                                    16 * variablePixelWidth,
                                    24 * variablePixelHeight,
                                    16 * variablePixelWidth,
                                    0 * variablePixelHeight),
                                child: Text(
                                  translation(context).availableCoinsBalance,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkGreyText,
                                    fontSize: 14 * textMultiplier,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.fromLTRB(
                                    16 * variablePixelWidth,
                                    24 * variablePixelHeight,
                                    16 * variablePixelWidth,
                                    0 * variablePixelHeight),
                                child: Text(
                                  translation(context).availableCashBalance,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkGreyText,
                                    fontSize: 14 * textMultiplier,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                        widget.cardType == CardType.Coins
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(
                                    16 * variablePixelWidth,
                                    8 * variablePixelHeight,
                                    16 * variablePixelWidth,
                                    16 * variablePixelHeight),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GetBuilder<CoinsSummaryController>(
                                      builder: (_) {
                                        return CoinWithImageWidget(
                                          //coin: double.parse("1234"),
                                          coin: double.parse(
                                              coinsSummaryController
                                                  .availableCoins
                                                  .replaceAll(",", "")),
                                          width: 150,
                                          weight: FontWeight.w600,
                                          size: 18,
                                          color: AppColors.lumiBluePrimary,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.fromLTRB(
                                    16 * variablePixelWidth,
                                    8 * variablePixelHeight,
                                    16 * variablePixelWidth,
                                    16 * variablePixelHeight),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GetBuilder<CashSummaryController>(
                                      builder: (_) {
                                        return RupeeWithSignWidget(
                                          //cash: 123456789012,
                                          cash: double.parse(
                                              cashSummaryController
                                                  .availableCash),
                                          color: AppColors.lumiBluePrimary,
                                          size: 18,
                                          weight: FontWeight.w600,
                                          width: 150,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  )),
            )),
        SizedBox(width: 12 * variablePixelWidth),
        Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12*variablePixelHeight),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                shadows: [
                  BoxShadow(
                    color: AppColors.balanceBoxShadow,
                    blurRadius: 12 * pixelMultipler,
                    offset: const Offset(1, 2),
                    spreadRadius: 2 * pixelMultipler,
                  )
                ],
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        // if (udc.isPrimaryNumberLogin) {
                        if (widget.cardType == CardType.Cash) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CashCoinHistoryScreen(
                                          cardType: FilterCashCoin.cashType)));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CashCoinHistoryScreen(
                                          cardType: FilterCashCoin.coinType)));
                        }
                        // }
                      },
                      child: Container(
                        child: Column(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16 * variablePixelWidth,
                            ),
                            child: Text(
                              translation(context).earned,
                              style: GoogleFonts.poppins(
                                  color: AppColors.darkGreyText,
                                  fontSize: 14 * textMultiplier,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          const VerticalSpace(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              widget.cardType == CardType.Coins
                                  ? GetBuilder<CoinsSummaryController>(
                                      builder: (_) {
                                        return CoinWithImageWidget(
                                          //coin: 123467890,
                                          coin: double.parse(
                                              coinsSummaryController.earnedCoins
                                                  .replaceAll(",", "")),
                                          width: 140,
                                          weight: FontWeight.w600,
                                          size: 16,
                                          color: AppColors.green,
                                        );
                                      },
                                    )
                                  : GetBuilder<CashSummaryController>(
                                      builder: (_) {
                                        return RupeeWithSignWidget(
                                          //cash: 123456789012,
                                          cash: double.parse(
                                              cashSummaryController.earnedCash),
                                          color: AppColors.green,
                                          size: 16,
                                          weight: FontWeight.w600,
                                          width: 140,
                                        );
                                      },
                                    )
                            ],
                          ),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16*variablePixelWidth,vertical: 12*variablePixelHeight),
                      child: Container(
                        width: double.infinity,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: AppColors.white_234,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // if (udc.isPrimaryNumberLogin) {
                        if (widget.cardType == CardType.Cash) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CashCoinHistoryScreen(
                                          cardType: FilterCashCoin.cashType)));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CashCoinHistoryScreen(
                                          cardType: FilterCashCoin.coinType)));
                        }
                        // }
                      },
                      child: Column(children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16 * variablePixelWidth,
                          ),
                          child: Text(
                            translation(context).redeemed,
                            style: GoogleFonts.poppins(
                                color: AppColors.darkGreyText,
                                fontSize: 14 * textMultiplier,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        const VerticalSpace(height: 3),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.cardType == CardType.Coins
                                ? GetBuilder<CoinsSummaryController>(
                                    builder: (_) {
                                      return CoinWithImageWidget(
                                        // coin: double.parse("123456789012"),
                                        coin: double.parse(
                                            coinsSummaryController.redeemedCoins
                                                .replaceAll(",", "")),
                                        width: 140,
                                        weight: FontWeight.w600,
                                        size: 16,
                                        color: AppColors.errorRed,
                                      );
                                    },
                                  )
                                : GetBuilder<CashSummaryController>(
                                    builder: (_) {
                                      return RupeeWithSignWidget(
                                        // cash: 123456789012,
                                        cash: double.parse(
                                            cashSummaryController.redeemedCash),
                                        color: AppColors.errorRed,
                                        size: 16,
                                        weight: FontWeight.w600,
                                        width: 140,
                                      );
                                    },
                                  )
                          ],
                        ),
                      ]),
                    ),
                  ]),
            ))
      ],
    );
  }
}
