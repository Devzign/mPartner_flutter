import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../state/contoller/cash_summary_controller.dart';
import '../../../../state/contoller/coins_summary_controller.dart';
import '../../../../state/contoller/notification_controller.dart';
import '../../../../state/contoller/warranty_controller.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/coin_with_image_widget.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../widgets/rupee_with_sign_widget.dart';
import '../../help_and_support/help_and_support.dart';
import '../../userprofile/user_profile_widget.dart';
import 'widgets/credit_txn_master_card.dart';

class CreditCoinCashDetailedScreen extends StatefulWidget {
  final String txnId;
  final String txnType;
  final String cashOrCoinHistory;
  final bool isFromPerformanceScreen;
  final String saleType;

  const CreditCoinCashDetailedScreen({
    super.key,
    required this.txnId,
    required this.txnType,
    required this.cashOrCoinHistory,
    this.isFromPerformanceScreen = false,
    this.saleType = 'Tertiary',
  });

  @override
  State<CreditCoinCashDetailedScreen> createState() =>
      _CreditCoinCashDetailedScreen();
}

class _CreditCoinCashDetailedScreen
    extends State<CreditCoinCashDetailedScreen> {
  WarrantyController warrantyController = Get.find();
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

    CoinsSummaryController coinsSummaryController = Get.find();
    CashSummaryController cashSummaryController = Get.find();
    WarrantyController warrantyController = Get.find();

    return WillPopScope(
        onWillPop: () async {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.of(context).pushReplacementNamed(AppRoutes.homepage);
          }
          return false;
        },
        child: Scaffold(
          backgroundColor: AppColors.lightWhite1,
          body: GetBuilder<NotificationController>(builder: (_) {
            warrantyController.getWarrantyPdfUrl(
                notificationController.getTransactionData.serialNumber ?? " ");
            return SafeArea(
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
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              AppRoutes.homepage);
                                    }
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                  if (notificationController.txnLoading.value == true) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          MasterCard(
                            state: notificationController
                                    .getTransactionData?.status ??
                                "",
                            cashOrCoinHistory: widget.cashOrCoinHistory,
                            category: notificationController
                                    .getTransactionData.productType ??
                                "-",
                            model: notificationController
                                    .getTransactionData.modelName ??
                                "-",
                            serialNo: notificationController
                                    .getTransactionData.serialNumber ??
                                "-",
                            saleTypeRemark: notificationController
                                .getTransactionData.saleRemark,
                            customerName: notificationController
                                .getTransactionData.customerName,
                            customerPhone: notificationController
                                .getTransactionData?.customerPhone,
                            transDate:
                                DateFormat(AppConstants.appDateFormatWithTime)
                                    .format(DateTime.parse(
                                        notificationController
                                            .getTransactionData
                                            .transactionDate)),
                            stateMsg:
                                "${notificationController.getTransactionData.status}!",
                            transMsg: _getTransactionMessage(
                                widget.cashOrCoinHistory,
                                widget.cashOrCoinHistory == 'Cash'
                                    ? notificationController
                                        .getTransactionData.totalAmount
                                    : notificationController
                                        .getTransactionData.totalCoins,
                                notificationController
                                    .getTransactionData.status,
                                notificationController
                                    .getTransactionData.productType),
                            points: widget.cashOrCoinHistory == 'Cash'
                                ? notificationController
                                    .getTransactionData.totalAmount
                                : notificationController
                                    .getTransactionData.totalCoins,
                            pointsEarnedMsg: _getPointsEarnedMessage(
                                widget.cashOrCoinHistory,
                                notificationController
                                    .getTransactionData.status),
                            remark: notificationController
                                .getTransactionData.message,
                            otpRemark: notificationController
                                .getTransactionData.otpRemark,
                          ),
                          SizedBox(
                            height: 20 * variablePixelHeight,
                          ),
                          Obx(() {
                            if (warrantyController
                                    .primarySaleDate.value.isEmpty &&
                                warrantyController
                                    .secondarySaleDate.value.isEmpty &&
                                warrantyController
                                    .intermediarySaleDate.value.isEmpty &&
                                warrantyController
                                    .tertiarySaleDate.value.isEmpty) {
                              return Container();
                            } else {
                              return Container(
                                padding: EdgeInsets.only(
                                    left: 24 * variablePixelWidth),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  translation(context).sellingDate,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.0 * textFontMultiplier,
                                    letterSpacing: 0.10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackText,
                                  ),
                                ),
                              );
                            }
                          }),
                          Obx(() {
                            if (warrantyController
                                    .primarySaleDate.value.isEmpty &&
                                warrantyController
                                    .secondarySaleDate.value.isEmpty &&
                                warrantyController
                                    .intermediarySaleDate.value.isEmpty &&
                                warrantyController
                                    .tertiarySaleDate.value.isEmpty) {
                              return Container();
                            } else {
                              return SizedBox(
                                height: 20 * variablePixelHeight,
                              );
                            }
                          }),
                          Obx(() {
                            if (warrantyController.primarySaleDate.isEmpty) {
                              return Container();
                            } else {
                              return rowWidget(
                                  translation(context).primarySaleDate,
                                  warrantyController.primarySaleDate.value,
                                  variablePixelWidth,
                                  variablePixelHeight);
                            }
                          }),
                          Obx(() {
                            if (warrantyController.primarySaleDate.isEmpty) {
                              return Container();
                            } else {
                              return SizedBox(
                                height: 16 * variablePixelHeight,
                              );
                            }
                          }),
                          Obx(() {
                            if (warrantyController.secondarySaleDate.isEmpty) {
                              return Container();
                            } else {
                              return rowWidget(
                                  translation(context).secondarySaleDate,
                                  warrantyController.secondarySaleDate.value,
                                  variablePixelWidth,
                                  variablePixelHeight);
                            }
                          }),
                          Obx(() {
                            if (warrantyController.secondarySaleDate.isEmpty) {
                              return Container();
                            } else {
                              return SizedBox(
                                height: 16 * variablePixelHeight,
                              );
                            }
                          }),
                          Obx(() {
                            if (warrantyController
                                .intermediarySaleDate.isEmpty) {
                              return Container();
                            } else {
                              return rowWidget(
                                  translation(context).intermediarySaleDate,
                                  warrantyController.intermediarySaleDate.value,
                                  variablePixelWidth,
                                  variablePixelHeight);
                            }
                          }),
                          Obx(() {
                            if (warrantyController
                                .intermediarySaleDate.isEmpty) {
                              return Container();
                            } else {
                              return SizedBox(
                                height: 16 * variablePixelHeight,
                              );
                            }
                          }),
                          Obx(() {
                            if (warrantyController.tertiarySaleDate.isEmpty) {
                              return Container();
                            } else {
                              return rowWidget(
                                  translation(context).tertiarySaleDate,
                                  warrantyController.tertiarySaleDate.value,
                                  variablePixelWidth,
                                  variablePixelHeight);
                            }
                          }),
                          Obx(() {
                            if (warrantyController.tertiarySaleDate.isEmpty) {
                              return Container();
                            } else {
                              return SizedBox(
                                height: 24 * variablePixelHeight,
                              );
                            }
                          }),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const HelpAndSupport()),
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
                          ),
                          SizedBox(
                            height: 7 * variablePixelHeight,
                          ),
                          (widget.isFromPerformanceScreen ||
                                  widget.saleType != 'Tertiary' ||
                                  notificationController
                                          .getTransactionData.status
                                          .toString()
                                          .toLowerCase() ==
                                      'rejected')
                              ? Container()
                              : Obx(() {
                                  return Visibility(
                                      visible: !warrantyController
                                          .isPdfLoading.value,
                                      replacement: const Center(
                                          child: CircularProgressIndicator()),
                                      child: (warrantyController
                                                  .pdfExist.value &&
                                              (notificationController
                                                          .getTransactionData
                                                          .status
                                                          .toString()
                                                          .toLowerCase() ==
                                                      'accepted' ||
                                                  notificationController
                                                          .getTransactionData
                                                          .status
                                                          .toString()
                                                          .toLowerCase() ==
                                                      'pending') &&
                                              widget.saleType == 'Tertiary')
                                          ? CommonButton(
                                              onPressed: () async {
                                                await launchUrlString(
                                                    warrantyController
                                                        .urlToDownload.value);
                                              },
                                              backGroundColor:
                                                  AppColors.lumiBluePrimary,
                                              textColor: AppColors.lightWhite,
                                              buttonText: translation(context)
                                                  .downloadWarrantyCard,
                                              isEnabled: true,
                                              containerBackgroundColor:
                                                  AppColors.lightWhite1,
                                            )
                                          : const SizedBox());
                                })
                        ],
                      ),
                    ));
                  }
                })
              ],
            ));
          }),
        ));
  }

  Widget rowWidget(String data1, String data2, double variablePixelWidth,
      double variablePixelHeight) {
    var textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      padding: EdgeInsets.only(
          left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              data1,
              style: GoogleFonts.poppins(
                fontSize: 13.0 * textMultiplier,
                letterSpacing: 0.10,
                fontWeight: FontWeight.w500,
                color: AppColors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              data2.isEmpty ? "-" : data2,
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                fontSize: 13.0 * textMultiplier,
                letterSpacing: 0.10,
                fontWeight: FontWeight.w600,
                color: AppColors.blackText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getTransactionMessage(
      String txnType, String amt, String txnStatus, String model) {
    int points = int.parse(amt);
    switch (txnStatus) {
      case 'Accepted':
        if (txnType == "Cash") {
          return '\u20B9${rupeeNoSign.format(points)} credited for the sale of $model';
        } else {
          return '${rupeeNoSign.format(points)} coins credited to mPartner coin wallet';
        }
      case 'Rejected':
        if (txnType == "Cash") {
          return '\u20B9${rupeeNoSign.format(points)} credit is rejected';
        } else {
          return '${rupeeNoSign.format(points)} coins credit is rejected';
        }
      case 'Pending':
        if (txnType == "Cash") {
          return '\u20B9${rupeeNoSign.format(points)} credit is pending. It will reflect soon.';
        } else {
          return '${rupeeNoSign.format(points)} coins credit is pending';
        }
      default:
        return "-";
    }
  }

  _getPointsEarnedMessage(String txnType, String txnStatus) {
    if (txnType == 'Cash') {
      switch (txnStatus) {
        case 'Accepted':
          return "Cash Earned";
        case 'Rejected':
          return "Cash Rejected";
        case 'Pending':
          return "Cash Pending";
        default:
          return "-";
      }
    } else {
      switch (txnStatus) {
        case 'Accepted':
          return "Coin Earned";
        case 'Rejected':
          return "Coin Rejected";
        case 'Pending':
          return "Coin Pending";
        default:
          return "-";
      }
    }
  }
}
