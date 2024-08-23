import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../state/contoller/cash_summary_controller.dart';
import '../../../../state/contoller/coins_summary_controller.dart';
import '../../../../state/contoller/notification_controller.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/coin_with_image_widget.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../widgets/rupee_with_sign_widget.dart';
import '../../help_and_support/help_and_support.dart';
import '../../userprofile/user_profile_widget.dart';
import 'widgets/debit_txn_master_card.dart';

class DebitCoinCashDetailedNotification extends StatefulWidget {
  final String txnId;
  final String txnType;
  final String cashOrCoinHistory;
  final bool isFromPerformanceScreen;
  final String saleType;

  const DebitCoinCashDetailedNotification({
    super.key,
    required this.txnId,
    required this.txnType,
    required this.cashOrCoinHistory,
    this.isFromPerformanceScreen = false,
    this.saleType = 'Tertiary',
  });

  @override
  State<DebitCoinCashDetailedNotification> createState() =>
      _DebitCoinCashDetailedNotification();
}

class _DebitCoinCashDetailedNotification
    extends State<DebitCoinCashDetailedNotification> {
  NotificationController notificationController = Get.find();

  @override
  void initState() {
    super.initState();
    fetchTxnDetails();
  }

  Future<void> fetchTxnDetails() async {
    await notificationController.fetchTransactionDetails(
      txnId: widget.txnId,
      txnType: widget.txnType,
    );
  }

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
            child: WillPopScope(
          onWillPop: () async {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.of(context).pushReplacementNamed(AppRoutes.homepage);
            }
            return false;
          },
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
                                  size: 24,
                                ),
                                onPressed: () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.of(context).pushReplacementNamed(
                                        AppRoutes.homepage);
                                  }
                                }),
                            Text(
                              translation(context).history,
                              style: GoogleFonts.poppins(
                                color: AppColors.iconColor,
                                fontSize: AppConstants.FONT_SIZE_LARGE *
                                    textFontMultiplier,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        widget.cashOrCoinHistory == 'Cash'
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
              Obx(() {
                if (notificationController.txnLoading.isTrue) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MasterCard(
                          state:
                              notificationController.getTransactionData.status,
                          stateMsg: _getStateMsg(
                              notificationController.getTransactionData.status),
                          cashOrCoinHistory: widget.cashOrCoinHistory,
                          customerName: notificationController
                              .getTransactionData.customerName,
                          transDate:
                              DateFormat(AppConstants.appDateFormatWithTime)
                                  .format(DateTime.parse(notificationController
                                      .getTransactionData.transactionDate)),
                          transactionId: notificationController
                              .getTransactionData.transactionId,
                          transactionRemark:
                              notificationController.getTransactionData.message,
                          points: notificationController
                                      .getTransactionData.redemptionMode ==
                                  ''
                              ? notificationController
                                  .getTransactionData.totalAmount
                              : notificationController
                                  .getTransactionData.redeemed,
                          pointsEarnedMsg: notificationController
                                      .getTransactionData.status ==
                                  'Successful'
                              ? 'Cash earned'
                              : '',
                          transactionType: notificationController
                                      .getTransactionData.redemptionMode ==
                                  ''
                              ? 'cashback'
                              : notificationController
                                  .getTransactionData.redemptionMode
                                  .toLowerCase(),
                          finalRemark: notificationController
                                  .getTransactionData.remark
                                  .toString()
                                  .isNotEmpty
                              ? 'Remarks: ${notificationController.getTransactionData.remark}'
                              : '',
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HelpAndSupport()),
                            );
                          },
                          child: SizedBox(
                              width: 157 * variablePixelWidth,
                              height: 40 * variablePixelHeight,
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
                  ));
                }
              })
            ],
          ),
        )));
  }

  String _getStateMsg(String status) {
    switch (status) {
      case 'Successful':
        return translation(context).transactionSuccessfulExclamation;
      case 'Failed':
        return translation(context).transactionFailedExclamation;
      case 'Pending':
        return "Transaction Pending!";
      default:
        return "-";
    }
  }
}
