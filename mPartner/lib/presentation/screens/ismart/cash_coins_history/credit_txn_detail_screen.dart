import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../data/models/cash_history_model.dart';
import '../../../../data/models/coin_history_model.dart';
import '../../../../data/models/network_management_model/dealer_electrician_details_model.dart';
import '../../../../state/contoller/cash_summary_controller.dart';
import '../../../../state/contoller/coins_summary_controller.dart';
import '../../../../state/contoller/warranty_controller.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/coin_with_image_widget.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../widgets/rupee_with_sign_widget.dart';
import '../../help_and_support/help_and_support.dart';
import '../../network_management/dealer_electrician/components/performance_user_detail_widget.dart';
import '../../userprofile/user_profile_widget.dart';
import 'widgets/credit_txn_master_card.dart';

class CreditTransactionDetailScreen extends StatefulWidget {
  final CashTransHistory? cashTxnData;
  final CoinTransHistory? coinTxnData;
  final String saleType;
  final String state;
  final String stateMsg;
  final String cashOrCoinHistory;
  final String transMsg;
  final String points;
  final String pointsEarnedMsg;
  final String remark;
  final String otpRemark;
  final String category;
  final String model;
  final String customerName;
  final String customerPhone;
  final String transDate;
  final String serialNo;
  final String saleTypeRemark;
  final bool isFromPerformanceScreen;
  final DealerElectricianDetail? listItemData;

  const CreditTransactionDetailScreen(
      {super.key,
      this.cashTxnData,
      this.coinTxnData,
      required this.saleType,
      required this.state,
      required this.cashOrCoinHistory,
      required this.stateMsg,
      required this.transMsg,
      required this.points,
      required this.pointsEarnedMsg,
      required this.remark,
      required this.otpRemark,
      required this.category,
      required this.model,
      required this.customerName,
      required this.customerPhone,
      required this.transDate,
      required this.serialNo,
      required this.saleTypeRemark,
      this.isFromPerformanceScreen = false,
      this.listItemData});

  @override
  State<CreditTransactionDetailScreen> createState() =>
      _CreditTransactionDetailScreen();
}

class _CreditTransactionDetailScreen
    extends State<CreditTransactionDetailScreen> {
  WarrantyController warrantyController = Get.find();
  bool shouldShowDownloadButton = false;
  CoinsSummaryController coinsSummaryController = Get.find();
  CashSummaryController cashSummaryController = Get.find();

  @override
  void initState() {
    super.initState();
    warrantyController.getWarrantyPdfUrl(widget.serialNo ?? " ");
    if (widget.isFromPerformanceScreen) {
      warrantyController.primarySaleDate = "".obs;
      warrantyController.secondarySaleDate = "".obs;
      warrantyController.intermediarySaleDate = "".obs;
      warrantyController.tertiarySaleDate = "".obs;
      warrantyController.fetchSalesDates(widget.serialNo ?? " ");
    }
    logger.d("RAJAT_CC ${widget.cashTxnData?.otpRemark}");
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
                                size: 24,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
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
                    (widget.isFromPerformanceScreen)
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16 * variablePixelWidth),
                            child: PerformanceDealerElectricianViewWidget(
                                widget.listItemData!, 1, (value) {}, true),
                          )
                        : Container(),
                    MasterCard(
                      state: widget.state,
                      cashOrCoinHistory: widget.cashOrCoinHistory,
                      stateMsg: widget.stateMsg,
                      transMsg: widget.transMsg,
                      points: widget.points,
                      pointsEarnedMsg: widget.pointsEarnedMsg,
                      remark: widget.remark,
                      otpRemark: widget.otpRemark,
                      category: widget.category,
                      model: widget.model,
                      serialNo: widget.serialNo,
                      saleTypeRemark: widget.saleTypeRemark,
                      customerName: widget.customerName,
                      customerPhone: widget.customerPhone,
                      transDate: widget.transDate,
                    ),
                    SizedBox(
                      height: 20 * variablePixelHeight,
                    ),
                    Obx(() {
                      if (warrantyController.primarySaleDate.value.isEmpty &&
                          warrantyController.secondarySaleDate.value.isEmpty &&
                          warrantyController
                              .intermediarySaleDate.value.isEmpty &&
                          warrantyController.tertiarySaleDate.value.isEmpty) {
                        return Container();
                      } else {
                        return (widget.isFromPerformanceScreen)
                            ? Container(
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
                              )
                            : Container();
                      }
                    }),
                    Obx(() {
                      if (warrantyController.primarySaleDate.value.isEmpty &&
                          warrantyController.secondarySaleDate.value.isEmpty &&
                          warrantyController
                              .intermediarySaleDate.value.isEmpty &&
                          warrantyController.tertiarySaleDate.value.isEmpty) {
                        return Container();
                      } else {
                        return (widget.isFromPerformanceScreen)
                            ? SizedBox(
                                height: 20 * variablePixelHeight,
                              )
                            : Container();
                      }
                    }),
                    Obx(() {
                      if (warrantyController.primarySaleDate.isEmpty) {
                        return Container();
                      } else {
                        return (widget.isFromPerformanceScreen)
                            ? rowWidget(
                                translation(context).primarySaleDate,
                                warrantyController.primarySaleDate.value,
                                variablePixelWidth,
                                variablePixelHeight)
                            : Container();
                      }
                    }),
                    Obx(() {
                      if (warrantyController.primarySaleDate.isEmpty) {
                        return Container();
                      } else {
                        return (widget.isFromPerformanceScreen)
                            ? SizedBox(
                                height: 16 * variablePixelHeight,
                              )
                            : Container();
                      }
                    }),
                    Obx(() {
                      if (warrantyController.secondarySaleDate.isEmpty) {
                        return Container();
                      } else {
                        return (widget.isFromPerformanceScreen)
                            ? rowWidget(
                                translation(context).secondarySaleDate,
                                warrantyController.secondarySaleDate.value,
                                variablePixelWidth,
                                variablePixelHeight)
                            : Container();
                      }
                    }),
                    Obx(() {
                      if (warrantyController.secondarySaleDate.isEmpty) {
                        return Container();
                      } else {
                        return (widget.isFromPerformanceScreen)
                            ? SizedBox(
                                height: 16 * variablePixelHeight,
                              )
                            : Container();
                      }
                    }),
                    Obx(() {
                      if (warrantyController.intermediarySaleDate.isEmpty) {
                        return Container();
                      } else {
                        return (widget.isFromPerformanceScreen)
                            ? rowWidget(
                                translation(context).intermediarySaleDate,
                                warrantyController.intermediarySaleDate.value,
                                variablePixelWidth,
                                variablePixelHeight)
                            : Container();
                      }
                    }),
                    Obx(() {
                      if (warrantyController.intermediarySaleDate.isEmpty) {
                        return Container();
                      } else {
                        return (widget.isFromPerformanceScreen)
                            ? SizedBox(
                                height: 16 * variablePixelHeight,
                              )
                            : Container();
                      }
                    }),
                    Obx(() {
                      if (warrantyController.tertiarySaleDate.isEmpty) {
                        return Container();
                      } else {
                        return (widget.isFromPerformanceScreen)
                            ? rowWidget(
                                translation(context).tertiarySaleDate,
                                warrantyController.tertiarySaleDate.value,
                                variablePixelWidth,
                                variablePixelHeight)
                            : Container();
                      }
                    }),
                    Obx(() {
                      if (warrantyController.tertiarySaleDate.isEmpty) {
                        return Container();
                      } else {
                        return (widget.isFromPerformanceScreen)
                            ? SizedBox(
                                height: 24 * variablePixelHeight,
                              )
                            : Container();
                      }
                    }),
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
                            widget.state.toLowerCase() == 'rejected')
                        ? Container()
                        : Obx(() {
                            return Visibility(
                                visible: !warrantyController.isPdfLoading.value,
                                replacement: const Center(
                                    child: CircularProgressIndicator()),
                                child: (warrantyController.pdfExist.value &&
                                        (widget.state.toLowerCase() ==
                                                'accepted' ||
                                            widget.state.toLowerCase() ==
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
              ),
            ),
          ],
        ),
      ),
    );
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
            child: Container(
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
}
