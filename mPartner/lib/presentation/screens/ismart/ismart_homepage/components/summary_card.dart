import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../utils/routes/app_routes.dart';
import '../../../../../state/contoller/coins_summary_controller.dart';
import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_string.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/coin_with_image_widget.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../../home/widgets/section_headings.dart';
import '../../cash_coins_history/cash_coin_history_screen.dart';
import 'balance_details.dart';
import 'redeem_cash.dart';
import 'redeem_coins.dart';

class SummaryCardWidget extends StatefulWidget {
  CardType cardType;

  SummaryCardWidget({super.key, required this.cardType});

  @override
  State<SummaryCardWidget> createState() => _SummaryCardWidgetState();
}

class _SummaryCardWidgetState extends State<SummaryCardWidget> {
  final UserDataController _udc = Get.find();

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultipler =
        DisplayMethods(context: context).getPixelMultiplier();
    CoinsSummaryController coinsSummaryController = Get.find();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: 20 * variablePixelWidth,
          vertical: 20 * variablePixelHeight),
      margin: EdgeInsets.only(
        left: 24 * variablePixelWidth,
        right: 24 * variablePixelWidth,
        top: 20 * variablePixelHeight,
      ),
      decoration: ShapeDecoration(
        color: AppColors.lightWhite1,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 1 * variablePixelWidth, color: AppColors.white_234),
          borderRadius: BorderRadius.circular(12 * pixelMultipler),
        ),
      ),
      child: Column(
        children: [
          SectionHeading(
            text: widget.cardType == CardType.Cash
                ? translation(context).cashSummary
                : translation(context).coinsSummary,
            fontWeight: FontWeight.w600,
            onPressed: () {
              // if (_udc.isPrimaryNumberLogin) {
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
          ),
          SizedBox(
            height: 12 * variablePixelHeight,
          ),
          BalanceDetailsCard(cardType: widget.cardType),
          const VerticalSpace(height: 14),
          if (widget.cardType != CardType.Cash &&
              (double.parse(
                      coinsSummaryController.bonusCoins.replaceAll(",", "")) >
                  0))
            const BonusCoinsSection(),
          if (_udc.isPrimaryNumberLogin) const VerticalSpace(height: 20),
          if (_udc.isPrimaryNumberLogin)
            GestureDetector(
              onTap: () {
                if (widget.cardType == CardType.Cash) {
                  Navigator.pushNamed(context, AppRoutes.redeemCashHome);
                } else {
                  Navigator.pushNamed(context, AppRoutes.redeemCoins);
                }
              },
              child: SectionHeading(
                text: widget.cardType == CardType.Cash
                    ? translation(context).redeemYourCash
                    : translation(context).redeemYourCoins,
                fontWeight: FontWeight.w400,
              ),
            ),
          if (_udc.isPrimaryNumberLogin) const VerticalSpace(height: 8),
          if (_udc.isPrimaryNumberLogin)
            widget.cardType == CardType.Cash
                ? GestureDetector(
                    onTap: () {
                      if (widget.cardType == CardType.Cash) {
                        Navigator.pushNamed(context, AppRoutes.redeemCashHome);
                      } else {
                        Navigator.pushNamed(context, AppRoutes.redeemCoins);
                      }
                    },
                    child: const RedeemCashWidget())
                : GestureDetector(
                    onTap: () {
                      if (widget.cardType == CardType.Cash) {
                        Navigator.pushNamed(context, AppRoutes.redeemCashHome);
                      } else {
                        Navigator.pushNamed(context, AppRoutes.redeemCoins);
                      }
                    },
                    child: const RedeemCoinsWidget())
        ],
      ),
    );
  }
}

class BonusCoinsSection extends StatelessWidget {
  const BonusCoinsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double fontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    CoinsSummaryController coinsSummaryController = Get.find();

    return Stack(children: [
      Container(
        padding: EdgeInsets.symmetric(
          vertical: 16 * variablePixelHeight,
          horizontal: 12 * variablePixelWidth,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [AppColors.goldCoinGradient1, AppColors.goldCoinGradient2],
            radius: 1.5,
            focal: Alignment.center,
          ),
          borderRadius: BorderRadius.circular(8.0 * pixelMultiplier),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translation(context).bonusCoins,
                  style: GoogleFonts.poppins(
                    fontSize: 14 * fontMultiplier,
                    fontWeight: FontWeight.w700,
                    color: AppColors.bonusCoinText,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4 * variablePixelWidth,
                    vertical: 2 * variablePixelHeight,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20 * pixelMultiplier),
                    border: Border.all(
                        color: AppColors.white.withOpacity(0.2), width: 1.0),
                    color: AppColors.white.withOpacity(0.5),
                  ),
                  child: Center(
                    child: Obx(() {
                      return CoinWithImageWidget(
                        coin: double.parse(coinsSummaryController.bonusCoins
                            .replaceAll(",", "")),
                        color: AppColors.bonusCoinText,
                        size: 14,
                        weight: FontWeight.w600,
                        width: 120,
                      );
                    }),
                  ),
                ),
              ],
            ),
            VerticalSpace(height: 2),
            Text(
              translation(context).bonusIncluded,
              style: GoogleFonts.poppins(
                fontSize: 10 * fontMultiplier,
                color: AppColors.bonusCoinText,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: SvgPicture.asset(
          'assets/mpartner/ismart/bonus_coins_design.svg',
          height: 50 * variablePixelHeight,
          width: 39 * variablePixelWidth,
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        child: SvgPicture.asset(
          'assets/mpartner/ismart/bonus_coins_design2.svg',
          height: 45 * variablePixelHeight,
          width: 30 * variablePixelWidth,
        ),
      ),
    ]);
  }
}
