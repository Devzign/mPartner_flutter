import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../data/models/network_management_model/dealer_electrician_details_model.dart';
import '../../../../state/contoller/cash_summary_controller.dart';
import '../../../../state/contoller/coins_summary_controller.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/coin_with_image_widget.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../widgets/rupee_with_sign_widget.dart';
import '../../help_and_support/help_and_support.dart';
import '../../network_management/dealer_electrician/components/performance_user_detail_widget.dart';
import '../../userprofile/user_profile_widget.dart';
import 'widgets/debit_txn_master_card.dart';

class DebitCoinCashDetailedHistory extends StatelessWidget {
  final String state;
  final String stateMsg;
  final String cashOrCoinHistory;
  final String transactionRemark;
  final String points;
  final String pointsEarnedMsg;
  final String transactionType;
  final String customerName;
  final String transDate;
  final String transactionId;
  final String finalRemark;
  final bool? isFromPerformanceScreen;
  final DealerElectricianDetail? listItemData;

  const DebitCoinCashDetailedHistory(
      {super.key,
      required this.state,
      required this.cashOrCoinHistory,
      required this.stateMsg,
      required this.transactionRemark,
      required this.points,
      required this.pointsEarnedMsg,
      required this.transactionType,
      required this.customerName,
      required this.transDate,
      required this.transactionId,
      required this.finalRemark,
      this.isFromPerformanceScreen,
      this.listItemData});

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    CashSummaryController cashSummaryController = Get.find();
    CoinsSummaryController coinsSummaryController = Get.find();

    return Scaffold(
      backgroundColor: AppColors.lightWhite1,
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(14 * variablePixelWidth,
                      24 * variablePixelHeight, 24 * variablePixelWidth, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.arrow_back_outlined,
                                color: AppColors.iconColor,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          Text(
                            translation(context).history,
                            style: GoogleFonts.poppins(
                              color: AppColors.iconColor,
                              fontSize: AppConstants.FONT_SIZE_LARGE * textFontMultiplier,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      cashOrCoinHistory == 'Cash'
                          ? Container(
                              height: variablePixelHeight * 24,
                              decoration: BoxDecoration(
                                color: AppColors.lumiLight4,
                                borderRadius: BorderRadius.circular(
                                    10.0 * pixelMultiplier),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    5 * variablePixelWidth,
                                    0,
                                    5 * variablePixelWidth,
                                    0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GetBuilder<CashSummaryController>(
                                      builder: (_) {
                                        return RupeeWithSignWidget(
                                          cash: double.parse(
                                              cashSummaryController
                                                  .availableCash
                                                  .replaceAll(',', '')),
                                          color: AppColors.lumiBluePrimary,
                                          width: 120,
                                          weight: FontWeight.w500,
                                          size: 12,
                                        );
                                      },
                                    ),
                                    Text(
                                      " ${translation(context).available}",
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                        color: AppColors.lumiBluePrimary,
                                        fontSize: 12 * textFontMultiplier,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              height: variablePixelHeight * 24,
                              decoration: BoxDecoration(
                                color: AppColors.goldCoinLight,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    5 * variablePixelWidth,
                                    0,
                                    5 * variablePixelWidth,
                                    0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GetBuilder<CoinsSummaryController>(
                                        builder: (_) {
                                      return CoinWithImageWidget(
                                        coin: double.parse(
                                            coinsSummaryController
                                                .availableCoins
                                                .replaceAll(',', '')),
                                        width: 120,
                                        weight: FontWeight.w500,
                                        size: 12,
                                        color: AppColors.goldCoin,
                                      );
                                    }),
                                    Text(
                                      " ${translation(context).available}",
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                        color: AppColors.goldCoin,
                                        fontSize: 12 * textFontMultiplier,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                UserProfileWidget(),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    (isFromPerformanceScreen ?? false)
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16 * variablePixelWidth),
                            child: PerformanceDealerElectricianViewWidget(
                                listItemData!, 1, (value) {}, true),
                          )
                        : Container(),
                    MasterCard(
                      state: state,
                      stateMsg: stateMsg,
                      cashOrCoinHistory: cashOrCoinHistory,
                      transactionRemark: transactionRemark,
                      points: points,
                      pointsEarnedMsg: pointsEarnedMsg,
                      transactionType: transactionType,
                      customerName: customerName,
                      transDate: transDate,
                      transactionId: transactionId,
                      finalRemark: finalRemark,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HelpAndSupport()),
                        );
                      },
                      child: Container(
                          width: 157 * variablePixelWidth,
                          height: 40 * variablePixelHeight,
                          margin:
                              EdgeInsets.only(bottom: 16 * variablePixelHeight),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.help_outline,
                                size: 20 * pixelMultiplier,
                                color: AppColors.lumiBluePrimary,
                              ),
                              const HorizontalSpace(width: 4),
                              Text(
                                translation(context).helpAndSupport,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: AppColors.lumiBluePrimary,
                                  fontSize: textFontMultiplier * 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
