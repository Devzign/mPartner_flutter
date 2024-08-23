import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_string.dart';
import '../../../../../utils/utils.dart';
import '../../../../data/models/cash_history_model.dart';
import '../../../../data/models/network_management_model/dealer_electrician_details_model.dart';
import '../../../../data/models/user_profile_model.dart';
import '../../../../state/contoller/ISmartCashHistoryController.dart';
import '../../../../state/contoller/Ismart_coin_history_controller.dart';
import '../../../../state/contoller/cash_summary_controller.dart';
import '../../../../state/contoller/coins_summary_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../widgets/rupee_with_sign_widget.dart';
import 'credit_txn_detail_screen.dart';
import 'debit_txn_detail_screen.dart';
import 'history_filter_screen.dart';
import 'util/cash_coin_history_util.dart';

class CashTransactionListScreen extends StatefulWidget {
  final bool isFromPerformanceScreen;
  final DealerElectricianDetail? listItemData;

  const CashTransactionListScreen(
      {this.isFromPerformanceScreen = false, this.listItemData, super.key});

  @override
  State<CashTransactionListScreen> createState() =>
      _CashTransactionListScreenState();
}

class _CashTransactionListScreenState extends State<CashTransactionListScreen> {
  ISmartCashHistoryController cashHistory = Get.find();
  ISmartCoinHistoryController coinHistory = Get.find();
  CoinsSummaryController coinsSummaryController = Get.find();
  CashSummaryController cashSummaryController = Get.find();
  TextEditingController searchController = TextEditingController();
  List<CashTransHistory> filteredData = [];
  List<UserProfile> storedUserProfile = [];
  Map<String, List<CashTransHistory>> groupedData = {};
  bool cashScreen = false;
  bool coinScreen = false;
  String selectedTab = 'Coins';
  bool filterOrNot = false;
  final ScrollController _scrollController = ScrollController();
  double variablePixelHeight = 0;
  double variablePixelWidth = 0;
  double pixelMultiplier = 0;
  double textMultiplier = 0;
  Map<String, List<CashTransHistory>> filteredDataGrouped = {};
  String? codeId;
  bool isShareButtonEnabled = true;

  Widget buildTab(String tabName) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = tabName;
        });
      },
      child: Text(
        tabName,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: selectedTab == tabName
              ? AppColors.lightWhite1
              : AppColors.lumiLight4,
          fontSize: 12 * textMultiplier,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.07,
        ),
      ),
    );
  }

  void groupData() {
    groupedData.clear();
    for (var transaction in cashHistory.cashHistoryList) {
      DateTime transDate = DateTime.parse(transaction.transDate);
      String yearMonth = DateFormat('MMMM yyyy').format(transDate);
      groupedData.putIfAbsent(yearMonth, () => []);
      groupedData[yearMonth]!.add(transaction);
    }
  }

  @override
  void initState() {
    codeId =
        (widget.isFromPerformanceScreen) ? widget.listItemData!.code : null;
    cashHistory.fetchCashHistory(code: codeId);
    loadData();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    Map<String, String> selectedValues = cashHistory.selectedValues;

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!cashHistory.isLoading.value) {
        if (cashHistory.filterFlag == false.obs) {
          cashHistory.fetchCashHistory(code: codeId);
        } else {
          if (cashHistory.isEarnEnable.value) {
            cashHistory.fetchFilteredData(
                cashHistory.selectedValues['selectedSaleType'] ?? "",
                cashHistory.selectedValues['selectedTransType'] == ""
                    ? "Credit"
                    : cashHistory.selectedValues['selectedTransType'] ?? "",
                cashHistory.selectedValues['selectCreditTransType'] ?? "",
                cashHistory.selectedValues['selectDebitTransType'] ?? "",
                cashHistory.selectedValues['fromDateVal'] ?? "",
                cashHistory.selectedValues['toDateVal'] ?? "",
                cashHistory.selectedValues['selectedCategory'] ?? "",
                cashHistory.selectedValues['redemptionMode'] ?? "",
                code: codeId);
          } else if (cashHistory.isRedeemEnable.value) {
            cashHistory.fetchFilteredData(
                cashHistory.selectedValues['selectedSaleType'] ?? "",
                cashHistory.selectedValues['selectedTransType'] == ""
                    ? "Debit"
                    : cashHistory.selectedValues['selectedTransType'] ?? "",
                cashHistory.selectedValues['selectCreditTransType'] ?? "",
                cashHistory.selectedValues['selectDebitTransType'] ?? "",
                cashHistory.selectedValues['fromDateVal'] ?? "",
                cashHistory.selectedValues['toDateVal'] ?? "",
                cashHistory.selectedValues['selectedCategory'] ?? "",
                cashHistory.selectedValues['redemptionMode'] ?? "",
                code: codeId);
          } else if (cashHistory.filterFlag.value = true) {
            cashHistory.fetchFilteredData(
                selectedValues['selectedSaleType']!,
                selectedValues['selectedTransType']!,
                selectedValues['selectCreditTransType']!,
                selectedValues['selectDebitTransType']!,
                selectedValues['fromDateVal']!,
                selectedValues['toDateVal']!,
                selectedValues['selectedCategory']!,
                selectedValues['redemptionMode']!,
                code: codeId);
          } else {
            cashHistory.fetchCashHistory(code: codeId);
          }
        }
      }
    }
  }

  Future<void> loadData() async {
    UserDataController controller = Get.find();
    storedUserProfile = controller.userProfile;
  }

  void groupFilteredData() {
    filteredDataGrouped.clear();
    for (var transaction in filteredData) {
      DateTime transDate = DateTime.parse(transaction.transDate);
      String yearMonth = DateFormat('MMMM yyyy').format(transDate);
      filteredDataGrouped.putIfAbsent(yearMonth, () => []);
      filteredDataGrouped[yearMonth]!.add(transaction);
    }
  }

  Widget showTxnTypeWidget(
      String txnType,
      String totalValue,
      String recentValue,
      Color colorsValue,
      Color cashColorVal,
      Color earnedRedeemColorVal,
      Color earnedRedeemBackgroundColorVal,
      bool isEnable) {
    return Stack(
      children: [
        Stack(
          children: [
            Container(
              width: 165 * variablePixelWidth,
              margin: EdgeInsets.only(
                  right: (txnType == "Earned") ? 16 * variablePixelWidth : 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8 * pixelMultiplier),
                  ),
                  border: Border.all(
                    color: AppColors.grayText.withOpacity(0.3),
                    width: 1.1,
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RupeeWithSignWidget(
                    cash: double.parse(totalValue.replaceAll(',', '')),
                    color: cashColorVal,
                    width: 160,
                    weight: FontWeight.w600,
                    size: 16,
                  ),
                  SizedBox(
                    height: 10 * variablePixelHeight,
                  ),
                  Text(
                    recentValue,
                    style: GoogleFonts.poppins(
                      fontSize: 12 * textMultiplier,
                      letterSpacing: 0.10,
                      height: 0.10,
                      fontWeight: FontWeight.w500,
                      color: colorsValue,
                    ),
                  ),
                ],
              ),
            ),
            (!isEnable)
                ? Container()
                : Positioned(
                    top: -2,
                    right: (txnType == "Earned") ? 10 : 0,
                    child: Container(
                      alignment: Alignment.center,
                      height: 30 * variablePixelHeight,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Obx(() {
                            groupData();
                            groupFilteredData();
                            return GestureDetector(
                              onTap: () {
                                cashHistory.clearCashHistoryList();
                                cashHistory.isEarnEnable = false.obs;
                                cashHistory.isRedeemEnable = false.obs;
                                if ((cashHistory.selectedValues['fromDateVal']!
                                            .isNotEmpty &&
                                        cashHistory.selectedValues['toDateVal']!
                                            .isNotEmpty) ||
                                    (cashHistory.searchKey.value.isNotEmpty)) {
                                  cashHistory.filterFlag = true.obs;
                                  cashHistory.isFilterApplied = true.obs;
                                }
                                cashHistory.selectedValues = {
                                  'selectedSaleType': "",
                                  'selectedTransType': "",
                                  'selectCreditTransType': "",
                                  'selectDebitTransType': "",
                                  'fromDateVal': cashHistory
                                          .selectedValues['fromDateVal'] ??
                                      "",
                                  'toDateVal':
                                      cashHistory.selectedValues['toDateVal'] ??
                                          "",
                                  'selectedDateRange':
                                      cashHistory.selectedValues[
                                              'selectedDateRange'] ??
                                          "",
                                  'selectedCategory': "",
                                  'redemptionMode': "",
                                }.obs;
                                if (cashHistory.isFilterApplied.value) {
                                  cashHistory
                                      .fetchFilteredData(
                                          cashHistory.selectedValues[
                                                  'selectedSaleType'] ??
                                              "",
                                          cashHistory.selectedValues[
                                                  'selectedTransType'] ??
                                              "",
                                          cashHistory.selectedValues[
                                                  'selectCreditTransType'] ??
                                              "",
                                          cashHistory.selectedValues[
                                                  'selectDebitTransType'] ??
                                              "",
                                          cashHistory.selectedValues[
                                                  'fromDateVal'] ??
                                              "",
                                          cashHistory.selectedValues[
                                                  'toDateVal'] ??
                                              "",
                                          cashHistory.selectedValues[
                                                  'selectedCategory'] ??
                                              "",
                                          cashHistory.selectedValues[
                                                  'redemptionMode'] ??
                                              "",
                                          code: codeId);
                                } else {
                                  cashHistory.fetchCashHistory(code: codeId);
                                }
                              },
                              child: Container(
                                height: 25 * variablePixelHeight,
                                width: 25 * variablePixelWidth,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.lightGrey2,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: AppColors.iconColor,
                                  size: 20,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    groupData();

    return Obx(() {
      groupData();
      groupFilteredData();
      return WillPopScope(
          onWillPop: () async {
            cashHistory.clearIsmartCashHistory();
            cashSummaryController.clearCashSummaryData(
                code: widget.listItemData?.code);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.of(context).pushReplacementNamed(AppRoutes.homepage);
            }
            return false;
          },
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: [
                      (widget.isFromPerformanceScreen)
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(
                                  5 * variablePixelWidth,
                                  0,
                                  5 * variablePixelWidth,
                                  10 * variablePixelHeight),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GetBuilder<CashSummaryController>(
                                    builder: (_) {
                                      return RupeeWithSignWidget(
                                        cash: double.parse(cashSummaryController
                                            .availableCash
                                            .replaceAll(',', '')),
                                        color: AppColors.lumiBluePrimary,
                                        width: 120,
                                        weight: FontWeight.w600,
                                        size: 14,
                                      );
                                    },
                                  ),
                                  Text(
                                    " ${translation(context).cash}  ${translation(context).available} ",
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.lumiBluePrimary,
                                      fontSize: 14 * textMultiplier,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 24 * variablePixelWidth,
                          right: 24 * variablePixelWidth,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: variablePixelWidth * 297,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.lightWhite1,
                                borderRadius:
                                    BorderRadius.circular(8 * pixelMultiplier),
                                border: Border.all(
                                  color: AppColors.lightGrey1,
                                  width: 1 * variablePixelWidth,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const HorizontalSpace(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: searchController,
                                      textInputAction: TextInputAction.search,
                                      maxLength: 32,
                                      maxLines: 1,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[0-9a-zA-Z]")),
                                      ],
                                      style: GoogleFonts.poppins(
                                        color: AppColors.darkGreyText,
                                        fontSize: 11 * textMultiplier,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.50,
                                      ),
                                      onChanged: (value) {
                                        String searchKey = searchController.text
                                            .toLowerCase()
                                            .trim();
                                        if (searchKey.isEmpty) {
                                          cashHistory.clearCashHistoryList();
                                          if ((cashHistory.selectedValues[
                                                          'fromDateVal']
                                                      .toString()
                                                      .isNotEmpty &&
                                                  cashHistory.selectedValues[
                                                          'toDateVal']
                                                      .toString()
                                                      .isNotEmpty) ||
                                              (cashHistory.selectedValues[
                                                      'selectedTransType']
                                                  .toString()
                                                  .isNotEmpty)) {
                                            cashHistory.filterFlag = true.obs;
                                            cashHistory.isFilterApplied =
                                                true.obs;
                                          }

                                          if (cashHistory
                                              .isFilterApplied.value) {
                                            cashHistory.fetchFilteredData(
                                                cashHistory.selectedValues[
                                                        'selectedSaleType'] ??
                                                    "",
                                                cashHistory.selectedValues[
                                                        'selectedTransType'] ??
                                                    "",
                                                cashHistory.selectedValues[
                                                        'selectCreditTransType'] ??
                                                    "",
                                                cashHistory.selectedValues[
                                                        'selectDebitTransType'] ??
                                                    "",
                                                cashHistory.selectedValues[
                                                        'fromDateVal'] ??
                                                    "",
                                                cashHistory.selectedValues[
                                                        'toDateVal'] ??
                                                    "",
                                                cashHistory.selectedValues[
                                                        'selectedCategory'] ??
                                                    "",
                                                cashHistory.selectedValues[
                                                        'redemptionMode'] ??
                                                    "",
                                                code: codeId);
                                          } else {
                                            cashHistory.filterFlag.value =
                                                false;
                                            cashHistory.isFilterApplied.value =
                                                false;
                                            cashHistory.fetchCashHistory(
                                                code: codeId);
                                          }
                                        } else if (searchKey.length < 3) {
                                          cashHistory.searchKey.value = "";
                                        } else {
                                          cashHistory.searchKey.value =
                                              searchKey;
                                        }
                                      },
                                      onEditingComplete: () {
                                        String searchKey = searchController.text
                                            .toLowerCase()
                                            .trim();
                                        if (searchKey.length >= 3) {
                                          cashHistory.searchKey.value =
                                              searchKey;
                                          cashHistory.clearCashHistoryList();
                                          cashHistory.filterFlag.value = true;
                                          cashHistory.isFilterApplied.value =
                                              true;
                                          cashHistory.fetchFilteredData(
                                              cashHistory.selectedValues[
                                                      'selectedSaleType'] ??
                                                  "",
                                              cashHistory.selectedValues[
                                                      'selectedTransType'] ??
                                                  "",
                                              cashHistory.selectedValues[
                                                      'selectCreditTransType'] ??
                                                  "",
                                              cashHistory.selectedValues[
                                                      'selectDebitTransType'] ??
                                                  "",
                                              cashHistory.selectedValues[
                                                      'fromDateVal'] ??
                                                  "",
                                              cashHistory.selectedValues[
                                                      'toDateVal'] ??
                                                  "",
                                              cashHistory.selectedValues[
                                                      'selectedCategory'] ??
                                                  "",
                                              cashHistory.selectedValues[
                                                      'redemptionMode'] ??
                                                  "",
                                              code: codeId);
                                        }
                                      },
                                      enabled: cashHistory.isLoading.value
                                          ? false
                                          : true,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText:
                                            "Search serial no./transaction ID",
                                        hintStyle: GoogleFonts.poppins(
                                          color: AppColors.lightGreyBorder,
                                          fontSize: textMultiplier * 11,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.50,
                                        ),
                                        counterText: "",
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 5 * variablePixelHeight,
                                        bottom: 5 * variablePixelHeight),
                                    child: SizedBox(
                                      height: variablePixelHeight * 30,
                                      child: const VerticalDivider(
                                        color: AppColors.lightGrey1,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 8 * variablePixelWidth,
                                        right: 8 * variablePixelWidth,
                                        top: 0),
                                    child: GestureDetector(
                                      onTap: () {
                                        String searchKey = searchController.text
                                            .toLowerCase()
                                            .trim();
                                        if (searchKey.length >= 3) {
                                          cashHistory.searchKey.value =
                                              searchKey;
                                          cashHistory.clearCashHistoryList();
                                          cashHistory.filterFlag.value = true;
                                          cashHistory.isFilterApplied.value =
                                              true;
                                          cashHistory.fetchFilteredData(
                                              cashHistory.selectedValues[
                                                      'selectedSaleType'] ??
                                                  "",
                                              cashHistory.selectedValues[
                                                      'selectedTransType'] ??
                                                  "",
                                              cashHistory.selectedValues[
                                                      'selectCreditTransType'] ??
                                                  "",
                                              cashHistory.selectedValues[
                                                      'selectDebitTransType'] ??
                                                  "",
                                              cashHistory.selectedValues[
                                                      'fromDateVal'] ??
                                                  "",
                                              cashHistory.selectedValues[
                                                      'toDateVal'] ??
                                                  "",
                                              cashHistory.selectedValues[
                                                      'selectedCategory'] ??
                                                  "",
                                              cashHistory.selectedValues[
                                                      'redemptionMode'] ??
                                                  "",
                                              code: codeId);
                                        }
                                      },
                                      child: Icon(
                                        Icons.search,
                                        size: 20 * pixelMultiplier,
                                        color: cashHistory
                                                .searchKey.value.isNotEmpty
                                            ? AppColors.lumiBluePrimary
                                            : AppColors.grayText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: cashHistory.isLoading.value
                                  ? () {}
                                  : () async {
                                      String searchKey = searchController.text
                                          .toLowerCase()
                                          .trim();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HistoryFilter(
                                                    historyType:
                                                        FilterCashCoin.cash,
                                                    code:
                                                        (widget.listItemData !=
                                                                null)
                                                            ? widget
                                                                .listItemData!
                                                                .code
                                                            : null,
                                                    searchKey: searchKey,
                                                  ))).then((_) {
                                        if (!cashHistory
                                            .isFilterApplied.value) {
                                          cashHistory.searchKey.value = "";
                                          searchController.clear();
                                        }
                                      });
                                    },
                              child: Container(
                                width: pixelMultiplier * 40,
                                height: pixelMultiplier * 40,
                                decoration: BoxDecoration(
                                  color: AppColors.lightWhite1,
                                  borderRadius: BorderRadius.circular(
                                      8 * pixelMultiplier),
                                  border: Border.all(
                                    color: AppColors.lightGrey1,
                                    width: 1.0,
                                  ),
                                ),
                                child: Obx(() {
                                  return Center(
                                    child: Icon(
                                      cashHistory.isFilterApplied.value
                                          ? Icons.filter_alt
                                          : Icons.filter_alt_outlined,
                                      size: 24 * pixelMultiplier,
                                      color: cashHistory.isFilterApplied.value
                                          ? AppColors.lumiBluePrimary
                                          : AppColors.blackText,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            24 * variablePixelWidth,
                            20 * variablePixelHeight,
                            24 * variablePixelWidth,
                            20 * variablePixelHeight),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translation(context).transactionSummary,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkGreyText,
                                    fontSize: 14 * textMultiplier,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.50,
                                  ),
                                ),
                                GetBuilder<ISmartCashHistoryController>(
                                    builder: (_) {
                                  return cashHistory.isDateSelected == true.obs
                                      ? Text(
                                          "${cashHistory.selectedValues['fromDateVal']} - ${cashHistory.selectedValues['toDateVal']}",
                                          style: GoogleFonts.poppins(
                                            color: AppColors.darkGrey,
                                            fontSize: 12 * textMultiplier,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.50,
                                          ),
                                        )
                                      : const SizedBox();
                                }),
                              ],
                            ),
                            Row(
                              children: [
                                GetBuilder<ISmartCashHistoryController>(
                                    builder: (_) {
                                  return GestureDetector(
                                    onTap: cashHistory.isLoading.value
                                        ? () {}
                                        : ((cashHistory.pageNumber.value == 1 ||
                                                    cashHistory.filterPageNumber
                                                            .value ==
                                                        1) &&
                                                cashHistory
                                                    .cashHistoryList.isEmpty)
                                            ? () {}
                                            : () async {
                                                if (isShareButtonEnabled) {
                                                  setState(() {
                                                    isShareButtonEnabled =
                                                        false;
                                                  });
                                                  await cashHistory.fetchCashExcelData(
                                                      cashHistory.selectedValues[
                                                              'selectedSaleType'] ??
                                                          "",
                                                      cashHistory.selectedValues[
                                                              'selectedTransType'] ??
                                                          "",
                                                      cashHistory.selectedValues[
                                                              'selectCreditTransType'] ??
                                                          "",
                                                      cashHistory.selectedValues[
                                                              'selectDebitTransType'] ??
                                                          "",
                                                      cashHistory.selectedValues[
                                                              'fromDateVal'] ??
                                                          "",
                                                      cashHistory.selectedValues[
                                                              'toDateVal'] ??
                                                          "",
                                                      cashHistory.selectedValues[
                                                              'selectedCategory'] ??
                                                          "",
                                                      cashHistory.selectedValues[
                                                              'redemptionMode'] ??
                                                          "",
                                                      code: codeId);
                                                  if (cashHistory
                                                      .cashExcelReportUrl
                                                      .value
                                                      .isNotEmpty) {
                                                    await Share.share(
                                                        cashHistory
                                                            .cashExcelReportUrl
                                                            .value);
                                                    setState(() {
                                                      isShareButtonEnabled =
                                                          true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      isShareButtonEnabled =
                                                          true;
                                                    });
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          cashHistory
                                                              .excelReportNotFound
                                                              .value,
                                                          style:
                                                              const TextStyle(
                                                            color: AppColors
                                                                .lumiDarkBlack,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            letterSpacing: 0.25,
                                                          ),
                                                        ),
                                                        elevation: 3,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: const BorderSide(
                                                              color: AppColors
                                                                  .lightGreen,
                                                              width: 1),
                                                          borderRadius: BorderRadius
                                                              .circular(4 *
                                                                  pixelMultiplier),
                                                        ),
                                                        backgroundColor:
                                                            AppColors
                                                                .lightGreen,
                                                        duration:
                                                            const Duration(
                                                                seconds: 3),
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                    child: Container(
                                      width: 28 * variablePixelWidth,
                                      height: 28 * variablePixelHeight,
                                      decoration: BoxDecoration(
                                        color: AppColors.lightWhite1,
                                        borderRadius: BorderRadius.circular(
                                            5 * pixelMultiplier),
                                        border: Border.all(
                                          color: AppColors.lightGrey1,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.share_outlined,
                                        size: 20 * pixelMultiplier,
                                        color: ((cashHistory.pageNumber.value ==
                                                        1 ||
                                                    cashHistory.filterPageNumber
                                                            .value ==
                                                        1) &&
                                                cashHistory
                                                    .cashHistoryList.isEmpty)
                                            ? AppColors.dividerColor
                                            : AppColors.darkGreyText,
                                      ),
                                    ),
                                  );
                                }),
                                SizedBox(
                                  width: variablePixelWidth * 12,
                                ),
                                GetBuilder<ISmartCashHistoryController>(
                                    builder: (_) {
                                  return GestureDetector(
                                    onTap: cashHistory.isLoading.value
                                        ? () {}
                                        : ((cashHistory.pageNumber.value == 1 ||
                                                    cashHistory.filterPageNumber
                                                            .value ==
                                                        1) &&
                                                cashHistory
                                                    .cashHistoryList.isEmpty)
                                            ? () {}
                                            : () async {
                                                await cashHistory.fetchCashExcelData(
                                                    cashHistory.selectedValues[
                                                            'selectedSaleType'] ??
                                                        "",
                                                    cashHistory.selectedValues[
                                                            'selectedTransType'] ??
                                                        "",
                                                    cashHistory.selectedValues[
                                                            'selectCreditTransType'] ??
                                                        "",
                                                    cashHistory.selectedValues[
                                                            'selectDebitTransType'] ??
                                                        "",
                                                    cashHistory.selectedValues[
                                                            'fromDateVal'] ??
                                                        "",
                                                    cashHistory.selectedValues[
                                                            'toDateVal'] ??
                                                        "",
                                                    cashHistory.selectedValues[
                                                            'selectedCategory'] ??
                                                        "",
                                                    cashHistory.selectedValues[
                                                            'redemptionMode'] ??
                                                        "",
                                                    code: codeId);
                                                if (cashHistory
                                                    .cashExcelReportUrl
                                                    .value
                                                    .isNotEmpty) {
                                                  await launchUrlString(
                                                      cashHistory
                                                          .cashExcelReportUrl
                                                          .value);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        cashHistory
                                                            .excelReportNotFound
                                                            .value,
                                                        style: const TextStyle(
                                                          color: AppColors
                                                              .lumiDarkBlack,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          letterSpacing: 0.25,
                                                        ),
                                                      ),
                                                      elevation: 3,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: const BorderSide(
                                                            color: AppColors
                                                                .lightGreen,
                                                            width: 1),
                                                        borderRadius: BorderRadius
                                                            .circular(4 *
                                                                pixelMultiplier),
                                                      ),
                                                      backgroundColor:
                                                          AppColors.lightGreen,
                                                      duration: const Duration(
                                                          seconds: 3),
                                                    ),
                                                  );
                                                }
                                              },
                                    child: Container(
                                      width: 28 * variablePixelWidth,
                                      height: 28 * variablePixelHeight,
                                      decoration: BoxDecoration(
                                        color: AppColors.lightWhite1,
                                        borderRadius: BorderRadius.circular(
                                            5 * pixelMultiplier),
                                        border: Border.all(
                                          color: AppColors.lightGrey1,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.file_download_outlined,
                                        size: 20 * pixelMultiplier,
                                        color: ((cashHistory.pageNumber.value ==
                                                        1 ||
                                                    cashHistory.filterPageNumber
                                                            .value ==
                                                        1) &&
                                                cashHistory
                                                    .cashHistoryList.isEmpty)
                                            ? AppColors.dividerColor
                                            : AppColors.darkGreyText,
                                      ),
                                    ),
                                  );
                                })
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 100 * variablePixelHeight,
                        padding: EdgeInsets.only(
                            left: 24 * variablePixelWidth,
                            right: 24 * variablePixelWidth,
                            bottom: 20.0 * variablePixelHeight),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: GetBuilder<ISmartCashHistoryController>(
                                  builder: (_) {
                                return GestureDetector(
                                  onTap: cashHistory.isLoading.value
                                      ? () {}()
                                      : () {
                                          if (cashHistory.selectedValues[
                                                          'selectedTransType']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  FilterCashCoin.creditType ||
                                              cashHistory.selectedValues[
                                                          'selectedTransType']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  FilterCashCoin.debitType ||
                                              (cashHistory.selectedValues[
                                                          'selectedTransType']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  FilterCashCoin
                                                      .debitCreditType) ||
                                              (cashHistory.selectedValues[
                                                          'selectedTransType']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  FilterCashCoin
                                                      .creditDebitType)) {
                                            return () {};
                                          } else {
                                            return () {
                                              cashHistory
                                                  .clearCashHistoryList();
                                              cashHistory.filterFlag.value =
                                                  true;
                                              cashHistory
                                                  .isFilterApplied.value = true;
                                              cashHistory.isEarnEnable =
                                                  true.obs;
                                              cashHistory.isRedeemEnable =
                                                  false.obs;
                                              cashHistory.selectedValues = {
                                                'selectedSaleType': "",
                                                'selectedTransType': "Credit",
                                                'selectCreditTransType': "",
                                                'selectDebitTransType': "",
                                                'fromDateVal':
                                                    cashHistory.selectedValues[
                                                            'fromDateVal'] ??
                                                        "",
                                                'toDateVal':
                                                    cashHistory.selectedValues[
                                                            'toDateVal'] ??
                                                        "",
                                                'selectedDateRange': cashHistory
                                                            .selectedValues[
                                                        'selectedDateRange'] ??
                                                    "",
                                                'selectedCategory': "",
                                                'redemptionMode': "",
                                              }.obs;
                                              cashHistory.fetchFilteredData(
                                                  cashHistory.selectedValues[
                                                          'selectedSaleType'] ??
                                                      "",
                                                  cashHistory.selectedValues[
                                                          'selectedTransType'] ??
                                                      "",
                                                  cashHistory.selectedValues[
                                                          'selectCreditTransType'] ??
                                                      "",
                                                  cashHistory.selectedValues[
                                                          'selectDebitTransType'] ??
                                                      "",
                                                  cashHistory.selectedValues[
                                                          'fromDateVal'] ??
                                                      "",
                                                  cashHistory.selectedValues[
                                                          'toDateVal'] ??
                                                      "",
                                                  cashHistory.selectedValues[
                                                          'selectedCategory'] ??
                                                      "",
                                                  cashHistory.selectedValues[
                                                          'redemptionMode'] ??
                                                      "",
                                                  code: codeId);
                                            };
                                          }
                                        }(),
                                  child: showTxnTypeWidget(
                                      translation(context).earned,
                                      cashHistory.earnedCash,
                                      "Credit (${cashHistory.creditCount})",
                                      (cashHistory.selectedValues['selectedTransType'].toString().toLowerCase() == FilterCashCoin.debitCreditType) ||
                                              (cashHistory.selectedValues['selectedTransType'].toString().toLowerCase() ==
                                                  FilterCashCoin
                                                      .creditDebitType)
                                          ? AppColors.hintColor
                                          : AppColors.successGreen,
                                      (cashHistory.selectedValues['selectedTransType'].toString().toLowerCase() == FilterCashCoin.debitCreditType) ||
                                              (cashHistory.selectedValues['selectedTransType'].toString().toLowerCase() ==
                                                  FilterCashCoin
                                                      .creditDebitType)
                                          ? AppColors.hintColor
                                          : AppColors.lumiBluePrimary,
                                      (cashHistory.selectedValues['selectedTransType']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  FilterCashCoin
                                                      .debitCreditType) ||
                                              (cashHistory.selectedValues['selectedTransType']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  FilterCashCoin
                                                      .creditDebitType)
                                          ? AppColors.hintColor
                                          : AppColors.darkGrey,
                                      (cashHistory.selectedValues['selectedTransType']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  FilterCashCoin
                                                      .debitCreditType) ||
                                              (cashHistory
                                                      .selectedValues['selectedTransType']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  FilterCashCoin.creditDebitType)
                                          ? AppColors.lumiLight4.withOpacity(0.3)
                                          : AppColors.lumiLight4,
                                      cashHistory.isEarnEnable.value),
                                );
                              }),
                            ),
                            Expanded(
                              child: GetBuilder<ISmartCashHistoryController>(
                                  builder: (_) {
                                return GestureDetector(
                                  onTap: cashHistory.isLoading.value
                                      ? () {}()
                                      : () {
                                          if (cashHistory.selectedValues[
                                                          'selectedTransType']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  FilterCashCoin.creditType ||
                                              cashHistory.selectedValues[
                                                          'selectedTransType']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  FilterCashCoin.debitType ||
                                              (cashHistory.selectedValues[
                                                          'selectedTransType']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  FilterCashCoin
                                                      .debitCreditType) ||
                                              (cashHistory.selectedValues[
                                                          'selectedTransType']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  FilterCashCoin
                                                      .creditDebitType)) {
                                            return () {};
                                          } else {
                                            return () {
                                              cashHistory
                                                  .clearCashHistoryList();
                                              cashHistory.filterFlag.value =
                                                  true;
                                              cashHistory
                                                  .isFilterApplied.value = true;
                                              cashHistory.isEarnEnable =
                                                  false.obs;
                                              cashHistory.isRedeemEnable =
                                                  true.obs;
                                              cashHistory.selectedValues = {
                                                'selectedSaleType': "",
                                                'selectedTransType': "Debit",
                                                'selectCreditTransType': "",
                                                'selectDebitTransType': "",
                                                'fromDateVal':
                                                    cashHistory.selectedValues[
                                                            'fromDateVal'] ??
                                                        "",
                                                'toDateVal':
                                                    cashHistory.selectedValues[
                                                            'toDateVal'] ??
                                                        "",
                                                'selectedDateRange': cashHistory
                                                            .selectedValues[
                                                        'selectedDateRange'] ??
                                                    "",
                                                'selectedCategory': "",
                                                'redemptionMode': "",
                                              }.obs;
                                              cashHistory.fetchFilteredData(
                                                  cashHistory.selectedValues[
                                                          'selectedSaleType'] ??
                                                      "",
                                                  cashHistory.selectedValues[
                                                          'selectedTransType'] ??
                                                      "",
                                                  cashHistory.selectedValues[
                                                          'selectCreditTransType'] ??
                                                      "",
                                                  cashHistory.selectedValues[
                                                          'selectDebitTransType'] ??
                                                      "",
                                                  cashHistory.selectedValues[
                                                          'fromDateVal'] ??
                                                      "",
                                                  cashHistory.selectedValues[
                                                          'toDateVal'] ??
                                                      "",
                                                  cashHistory.selectedValues[
                                                          'selectedCategory'] ??
                                                      "",
                                                  cashHistory.selectedValues[
                                                          'redemptionMode'] ??
                                                      "",
                                                  code: codeId);
                                            };
                                          }
                                        }(),
                                  child: showTxnTypeWidget(
                                      translation(context).redeemed,
                                      cashHistory.redeemedCash,
                                      "Debit (${cashHistory.debitCount})",
                                      (cashHistory.selectedValues['selectedTransType'].toString().toLowerCase() == FilterCashCoin.debitCreditType) ||
                                              (cashHistory.selectedValues['selectedTransType'].toString().toLowerCase() ==
                                                  FilterCashCoin
                                                      .creditDebitType)
                                          ? AppColors.hintColor
                                          : AppColors.errorRed,
                                      (cashHistory.selectedValues['selectedTransType'].toString().toLowerCase() == FilterCashCoin.debitCreditType) ||
                                              (cashHistory.selectedValues['selectedTransType'].toString().toLowerCase() ==
                                                  FilterCashCoin
                                                      .creditDebitType)
                                          ? AppColors.hintColor
                                          : AppColors.lumiBluePrimary,
                                      (cashHistory.selectedValues['selectedTransType']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  FilterCashCoin
                                                      .debitCreditType) ||
                                              (cashHistory.selectedValues['selectedTransType']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  FilterCashCoin
                                                      .creditDebitType)
                                          ? AppColors.hintColor
                                          : AppColors.darkGrey,
                                      (cashHistory.selectedValues['selectedTransType']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  FilterCashCoin
                                                      .debitCreditType) ||
                                              (cashHistory
                                                      .selectedValues['selectedTransType']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  FilterCashCoin.creditDebitType)
                                          ? AppColors.lumiLight4.withOpacity(0.3)
                                          : AppColors.lumiLight4,
                                      cashHistory.isRedeemEnable.value),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      (cashHistory.isLoading.value &&
                              cashHistory.cashHistoryList.isEmpty)
                          ? loadingWidget(cashHistory.isLoading.value)
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount:
                                  groupedData.length + (filterOrNot ? 0 : 1),
                              itemBuilder: (BuildContext context, int index) {
                                var yearMonth;
                                var transactions;
                                if (index < groupedData.length) {
                                  yearMonth = groupedData.keys.elementAt(index);
                                  transactions = groupedData[yearMonth]!;
                                  return Container(
                                    padding: EdgeInsets.fromLTRB(
                                        0, 0, 0, 5 * variablePixelHeight),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightWhite1,
                                      borderRadius: BorderRadius.circular(
                                          10.0 * pixelMultiplier),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 393 * variablePixelWidth,
                                          height: 28 * variablePixelHeight,
                                          color: AppColors.lumiLight5,
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                24 * variablePixelWidth,
                                                0,
                                                24 * variablePixelWidth,
                                                0),
                                            child: Text(
                                              yearMonth,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                color: AppColors.darkGrey,
                                                fontSize: 14 * textMultiplier,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.10,
                                              ),
                                            ),
                                          ),
                                        ),
                                        for (var transaction
                                            in transactions) ...[
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                24 * variablePixelWidth,
                                                12 * variablePixelHeight,
                                                24 * variablePixelWidth,
                                                0),
                                            child: InkWell(
                                              onTap: () {
                                                if (transaction.creditType
                                                        .toLowerCase() ==
                                                    FilterCashCoin.creditType) {
                                                  if (transaction.creditStatus
                                                          .toLowerCase() ==
                                                      FilterCashCoin
                                                          .acceptedType) {
                                                    transaction.redemptionmode ==
                                                            "Coins converted to cash"
                                                        ? Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        DebitCoinCashDetailedHistory(
                                                                          state:
                                                                              'Successful',
                                                                          stateMsg:
                                                                              translation(context).transactionSuccessfulExclamation,
                                                                          cashOrCoinHistory:
                                                                              'Cash',
                                                                          transactionRemark:
                                                                              transaction.remark,
                                                                          points:
                                                                              rupeeNoSign.format(transaction.points),
                                                                          pointsEarnedMsg:
                                                                              'Cash earned',
                                                                          listItemData:
                                                                              widget.listItemData,
                                                                          isFromPerformanceScreen:
                                                                              widget.isFromPerformanceScreen,
                                                                          transactionType:
                                                                              "cashback",
                                                                          customerName: transaction.customerName.toString().isNotEmpty
                                                                              ? transaction.customerName
                                                                              : '-',
                                                                          transDate:
                                                                              DateFormat(AppConstants.cashCoinDateFormatWithTime).format(DateTime.parse(transaction.transDate)),
                                                                          transactionId: transaction.serial.toString().isNotEmpty
                                                                              ? transaction.serial
                                                                              : '-',
                                                                          finalRemark:
                                                                              '',
                                                                        )))
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        CreditTransactionDetailScreen(
                                                                          cashTxnData:
                                                                              transaction,
                                                                          saleType:
                                                                              transaction.saleType,
                                                                          listItemData:
                                                                              widget.listItemData,
                                                                          isFromPerformanceScreen:
                                                                              widget.isFromPerformanceScreen,
                                                                          state:
                                                                              transaction.creditStatus,
                                                                          stateMsg:
                                                                              'Accepted!',
                                                                          cashOrCoinHistory:
                                                                              'Cash',
                                                                          transMsg:
                                                                              '\u20B9${rupeeNoSign.format(transaction.points)} credited for the sale of ${transaction.model}',
                                                                          points:
                                                                              rupeeNoSign.format(transaction.points),
                                                                          pointsEarnedMsg:
                                                                              CashHistoryStrings.cashEarned,
                                                                          remark:
                                                                              transaction.remark,
                                                                          otpRemark:
                                                                              transaction.otpRemark,
                                                                          serialNo: transaction.serial.toString().isNotEmpty
                                                                              ? transaction.serial
                                                                              : '-',
                                                                          category: transaction.category.toString().isNotEmpty
                                                                              ? transaction.category
                                                                              : '-',
                                                                          model: transaction.model.toString().isNotEmpty
                                                                              ? transaction.model
                                                                              : '-',
                                                                          saleTypeRemark: transaction.saleType == 'Secondary'
                                                                              ? '${transaction.saleType} Sale to Dealer'
                                                                              : transaction.saleType == 'Tertiary'
                                                                                  ? '${transaction.saleType} Sale to customer'
                                                                                  : transaction.saleType == 'Intermediary'
                                                                                      ? '${transaction.saleType} Sale to electrician'
                                                                                      : '${transaction.saleType}',
                                                                          customerName: CashCoinHistoryUtil().getCustomerName(
                                                                              transaction,
                                                                              widget.isFromPerformanceScreen),
                                                                          customerPhone: CashCoinHistoryUtil().getPhoneNumber(
                                                                              transaction,
                                                                              widget.isFromPerformanceScreen),
                                                                          transDate:
                                                                              DateFormat(AppConstants.cashCoinDateFormatWithTime).format(DateTime.parse(transaction.transDate)),
                                                                        )));
                                                  }
                                                  if (transaction.creditStatus
                                                          .toLowerCase() ==
                                                      FilterCashCoin
                                                          .pendingType) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CreditTransactionDetailScreen(
                                                                  cashTxnData:
                                                                      transaction,
                                                                  saleType:
                                                                      transaction
                                                                          .saleType,
                                                                  listItemData:
                                                                      widget
                                                                          .listItemData,
                                                                  isFromPerformanceScreen:
                                                                      widget
                                                                          .isFromPerformanceScreen,
                                                                  state: transaction
                                                                      .creditStatus,
                                                                  stateMsg:
                                                                      'Pending!',
                                                                  cashOrCoinHistory:
                                                                      'Cash',
                                                                  transMsg:
                                                                      '\u20B9${rupeeNoSign.format(transaction.points)} credit is pending, it will reflect soon',
                                                                  points: rupeeNoSign.format(
                                                                      transaction
                                                                          .points),
                                                                  pointsEarnedMsg:
                                                                      'Cash Pending',
                                                                  remark:
                                                                      transaction
                                                                          .remark,
                                                                  otpRemark:
                                                                      transaction
                                                                          .otpRemark,
                                                                  serialNo: transaction
                                                                          .serial
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? transaction
                                                                          .serial
                                                                      : '-',
                                                                  category: transaction
                                                                          .category
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? transaction
                                                                          .category
                                                                      : '-',
                                                                  model: transaction
                                                                          .model
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? transaction
                                                                          .model
                                                                      : '-',
                                                                  saleTypeRemark: transaction
                                                                              .saleType ==
                                                                          'Secondary'
                                                                      ? '${transaction.saleType} Sale to Dealer'
                                                                      : transaction.saleType ==
                                                                              'Tertiary'
                                                                          ? '${transaction.saleType} Sale to customer'
                                                                          : transaction.saleType == 'Intermediary'
                                                                              ? '${transaction.saleType} Sale to electrician'
                                                                              : '${transaction.saleType}',
                                                                  customerName: CashCoinHistoryUtil()
                                                                      .getCustomerName(
                                                                          transaction,
                                                                          widget
                                                                              .isFromPerformanceScreen),
                                                                  customerPhone:
                                                                      CashCoinHistoryUtil().getPhoneNumber(
                                                                          transaction,
                                                                          widget
                                                                              .isFromPerformanceScreen),
                                                                  transDate: DateFormat(
                                                                          AppConstants
                                                                              .cashCoinDateFormatWithTime)
                                                                      .format(DateTime.parse(
                                                                          transaction
                                                                              .transDate)),
                                                                )));
                                                  }
                                                  if (transaction.creditStatus
                                                          .toLowerCase() ==
                                                      FilterCashCoin
                                                          .rejectedType) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CreditTransactionDetailScreen(
                                                                  cashTxnData:
                                                                      transaction,
                                                                  saleType:
                                                                      transaction
                                                                          .saleType,
                                                                  listItemData:
                                                                      widget
                                                                          .listItemData,
                                                                  isFromPerformanceScreen:
                                                                      widget
                                                                          .isFromPerformanceScreen,
                                                                  state: transaction
                                                                      .creditStatus,
                                                                  stateMsg:
                                                                      'Rejected!',
                                                                  cashOrCoinHistory:
                                                                      'Cash',
                                                                  transMsg:
                                                                      '\u20B9${rupeeNoSign.format(transaction.points)} credit is rejected',
                                                                  points: rupeeNoSign.format(
                                                                      transaction
                                                                          .points),
                                                                  pointsEarnedMsg:
                                                                      'Cash Rejected',
                                                                  remark:
                                                                      transaction
                                                                          .remark,
                                                                  otpRemark:
                                                                      transaction
                                                                          .otpRemark,
                                                                  serialNo: transaction
                                                                          .serial
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? transaction
                                                                          .serial
                                                                      : '-',
                                                                  category: transaction
                                                                          .category
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? transaction
                                                                          .category
                                                                      : '-',
                                                                  model: transaction
                                                                          .model
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? transaction
                                                                          .model
                                                                      : '-',
                                                                  saleTypeRemark: transaction
                                                                              .saleType ==
                                                                          'Secondary'
                                                                      ? '${transaction.saleType} Sale to Dealer'
                                                                      : transaction.saleType ==
                                                                              'Tertiary'
                                                                          ? '${transaction.saleType} Sale to customer'
                                                                          : transaction.saleType == 'Intermediary'
                                                                              ? '${transaction.saleType} Sale to electrician'
                                                                              : '${transaction.saleType}',
                                                                  customerName: CashCoinHistoryUtil()
                                                                      .getCustomerName(
                                                                          transaction,
                                                                          widget
                                                                              .isFromPerformanceScreen),
                                                                  customerPhone:
                                                                      CashCoinHistoryUtil().getPhoneNumber(
                                                                          transaction,
                                                                          widget
                                                                              .isFromPerformanceScreen),
                                                                  transDate: DateFormat(
                                                                          AppConstants
                                                                              .cashCoinDateFormatWithTime)
                                                                      .format(DateTime.parse(
                                                                          transaction
                                                                              .transDate)),
                                                                )));
                                                  }
                                                }
                                                if (transaction.creditType
                                                        .toLowerCase() ==
                                                    FilterCashCoin.debitType) {
                                                  if (transaction.debitStatus
                                                          .toLowerCase() ==
                                                      FilterCashCoin
                                                          .successfulType) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DebitCoinCashDetailedHistory(
                                                                  state:
                                                                      'Successful',
                                                                  stateMsg: translation(
                                                                          context)
                                                                      .transactionSuccessfulExclamation,
                                                                  cashOrCoinHistory:
                                                                      'Cash',
                                                                  transactionRemark:
                                                                      '\u20B9${rupeeNoSign.format(transaction.points)} debited for redeeming via ${transaction.redemptionmode} Wallet',
                                                                  points: rupeeNoSign.format(
                                                                      transaction
                                                                          .points),
                                                                  pointsEarnedMsg:
                                                                      'Cash Redeemed',
                                                                  listItemData:
                                                                      widget
                                                                          .listItemData,
                                                                  isFromPerformanceScreen:
                                                                      widget
                                                                          .isFromPerformanceScreen,
                                                                  transactionType:
                                                                      transaction
                                                                          .redemptionmode
                                                                          .toLowerCase(),
                                                                  customerName: transaction
                                                                          .customerName
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? transaction
                                                                          .customerName
                                                                      : '-',
                                                                  transDate: DateFormat(
                                                                          AppConstants
                                                                              .cashCoinDateFormatWithTime)
                                                                      .format(DateTime.parse(
                                                                          transaction
                                                                              .transDate)),
                                                                  transactionId: transaction
                                                                          .serial
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? transaction
                                                                          .serial
                                                                      : '-',
                                                                  finalRemark: transaction
                                                                          .remark
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? 'Remarks: ${transaction.remark}'
                                                                      : '',
                                                                )));
                                                  }
                                                  if (transaction.debitStatus
                                                          .toLowerCase() ==
                                                      FilterCashCoin
                                                          .pendingType) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DebitCoinCashDetailedHistory(
                                                                  state:
                                                                      'Pending',
                                                                  stateMsg:
                                                                      'Transaction Pending!',
                                                                  cashOrCoinHistory:
                                                                      'Cash',
                                                                  transactionRemark: transaction
                                                                              .redemptionmode
                                                                              .toLowerCase()! ==
                                                                          FilterCashCoin
                                                                              .pinelabType
                                                                      ? translation(
                                                                              context)
                                                                          .txnPinelabPendingMessage
                                                                      : transaction.redemptionmode.toLowerCase()! ==
                                                                              FilterCashCoin.upiType
                                                                          ? translation(context).txnUPIPendingMessage
                                                                          : transaction.redemptionmode.toLowerCase()! == FilterCashCoin.paytmType
                                                                              ? translation(context).txnPaytmPendingMessage
                                                                              : translation(context).transactionFailureMessage,
                                                                  points: rupeeNoSign.format(
                                                                      transaction
                                                                          .points),
                                                                  pointsEarnedMsg:
                                                                      '',
                                                                  listItemData:
                                                                      widget
                                                                          .listItemData,
                                                                  isFromPerformanceScreen:
                                                                      widget
                                                                          .isFromPerformanceScreen,
                                                                  transactionType:
                                                                      transaction
                                                                          .redemptionmode
                                                                          .toLowerCase(),
                                                                  customerName: transaction
                                                                          .customerName
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? transaction
                                                                          .customerName
                                                                      : '-',
                                                                  transDate: DateFormat(
                                                                          AppConstants
                                                                              .cashCoinDateFormatWithTime)
                                                                      .format(DateTime.parse(
                                                                          transaction
                                                                              .transDate)),
                                                                  transactionId: transaction
                                                                          .serial
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? transaction
                                                                          .serial
                                                                      : '-',
                                                                  finalRemark: transaction
                                                                          .remark
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? 'Remarks: ${transaction.remark}'
                                                                      : '',
                                                                )));
                                                  }
                                                  if (transaction.debitStatus
                                                          .toLowerCase() ==
                                                      FilterCashCoin
                                                          .failureType) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DebitCoinCashDetailedHistory(
                                                                  state:
                                                                      'Failed',
                                                                  stateMsg: translation(
                                                                          context)
                                                                      .transactionFailedExclamation,
                                                                  cashOrCoinHistory:
                                                                      'Cash',
                                                                  transactionRemark:
                                                                      translation(
                                                                              context)
                                                                          .transactionFailureMessage,
                                                                  points: rupeeNoSign.format(
                                                                      transaction
                                                                          .points),
                                                                  pointsEarnedMsg:
                                                                      '',
                                                                  listItemData:
                                                                      widget
                                                                          .listItemData,
                                                                  isFromPerformanceScreen:
                                                                      widget
                                                                          .isFromPerformanceScreen,
                                                                  transactionType:
                                                                      transaction
                                                                          .redemptionmode
                                                                          .toLowerCase(),
                                                                  customerName: transaction
                                                                          .customerName
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? transaction
                                                                          .customerName
                                                                      : '-',
                                                                  transDate: DateFormat(
                                                                          AppConstants
                                                                              .cashCoinDateFormatWithTime)
                                                                      .format(DateTime.parse(
                                                                          transaction
                                                                              .transDate)),
                                                                  transactionId: transaction
                                                                          .serial
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? transaction
                                                                          .serial
                                                                      : '-',
                                                                  finalRemark: transaction
                                                                          .remark
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? 'Remarks: ${transaction.remark}'
                                                                      : '',
                                                                )));
                                                  }
                                                  if (transaction.debitStatus
                                                          .toLowerCase() ==
                                                      FilterCashCoin
                                                          .failedType) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DebitCoinCashDetailedHistory(
                                                                  state:
                                                                      'Failed',
                                                                  stateMsg: translation(
                                                                          context)
                                                                      .transactionFailedExclamation,
                                                                  cashOrCoinHistory:
                                                                      'Cash',
                                                                  transactionRemark:
                                                                      translation(
                                                                              context)
                                                                          .transactionFailureMessage,
                                                                  points: rupeeNoSign.format(
                                                                      transaction
                                                                          .points),
                                                                  pointsEarnedMsg:
                                                                      '',
                                                                  listItemData:
                                                                      widget
                                                                          .listItemData,
                                                                  isFromPerformanceScreen:
                                                                      widget
                                                                          .isFromPerformanceScreen,
                                                                  transactionType:
                                                                      transaction
                                                                          .redemptionmode
                                                                          .toLowerCase(),
                                                                  customerName: transaction
                                                                          .customerName
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? transaction
                                                                          .customerName
                                                                      : '-',
                                                                  transDate: DateFormat(
                                                                          AppConstants
                                                                              .cashCoinDateFormatWithTime)
                                                                      .format(DateTime.parse(
                                                                          transaction
                                                                              .transDate)),
                                                                  transactionId: transaction
                                                                          .serial
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? transaction
                                                                          .serial
                                                                      : '-',
                                                                  finalRemark: transaction
                                                                          .remark
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? 'Remarks: ${transaction.remark}'
                                                                      : '',
                                                                )));
                                                  }
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        DateFormat(AppConstants
                                                                .cashCoinDateFormatWithTime)
                                                            .format(DateTime
                                                                .parse(transaction
                                                                    .transDate)),
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: AppColors
                                                              .darkGrey,
                                                          fontSize: 14 *
                                                              textMultiplier,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.10,
                                                        ),
                                                      ),
                                                      RupeeWithSignWidget(
                                                        cash: double.parse(
                                                            transaction.points
                                                                .toString()
                                                                .replaceAll(
                                                                    ',', '')),
                                                        color: () {
                                                          if (transaction
                                                                  .creditType
                                                                  .toLowerCase() ==
                                                              FilterCashCoin
                                                                  .creditType) {
                                                            if (transaction
                                                                    .creditStatus
                                                                    .toLowerCase() ==
                                                                FilterCashCoin
                                                                    .acceptedType) {
                                                              return AppColors
                                                                  .successGreen;
                                                            } else if (transaction
                                                                    .creditStatus
                                                                    .toLowerCase() ==
                                                                FilterCashCoin
                                                                    .pendingType) {
                                                              return AppColors
                                                                  .grayText;
                                                            } else if (transaction
                                                                    .creditStatus
                                                                    .toLowerCase() ==
                                                                FilterCashCoin
                                                                    .rejectedType) {
                                                              return AppColors
                                                                  .grayText;
                                                            } else {
                                                              return AppColors
                                                                  .grayText;
                                                            }
                                                          } else if (transaction
                                                                  .creditType
                                                                  .toLowerCase() ==
                                                              FilterCashCoin
                                                                  .debitType) {
                                                            if (transaction
                                                                    .debitStatus
                                                                    .toLowerCase() ==
                                                                FilterCashCoin
                                                                    .successfulType) {
                                                              return AppColors
                                                                  .exceedRed;
                                                            } else if (transaction
                                                                    .debitStatus
                                                                    .toLowerCase() ==
                                                                FilterCashCoin
                                                                    .pendingType) {
                                                              return AppColors
                                                                  .grayText;
                                                            } else if (transaction
                                                                    .debitStatus
                                                                    .toLowerCase() ==
                                                                FilterCashCoin
                                                                    .failedType) {
                                                              return AppColors
                                                                  .grayText;
                                                            } else if (transaction
                                                                    .debitStatus
                                                                    .toLowerCase() ==
                                                                FilterCashCoin
                                                                    .failureType) {
                                                              return AppColors
                                                                  .grayText;
                                                            } else {
                                                              return AppColors
                                                                  .grayText;
                                                            }
                                                          } else {
                                                            return AppColors
                                                                .grayText;
                                                          }
                                                        }(),
                                                        showSign: true,
                                                        signText: () {
                                                          if (transaction
                                                                      .creditType
                                                                      .toLowerCase() ==
                                                                  FilterCashCoin
                                                                      .creditType &&
                                                              transaction
                                                                      .points !=
                                                                  0) {
                                                            return '+';
                                                          } else if (transaction
                                                                      .creditType
                                                                      .toLowerCase() ==
                                                                  FilterCashCoin
                                                                      .debitType &&
                                                              transaction
                                                                      .points !=
                                                                  0) {
                                                            return '-';
                                                          } else {
                                                            return '';
                                                          }
                                                        }(),
                                                        width: 120,
                                                        weight: FontWeight.w600,
                                                        size: 14,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: 6 *
                                                          variablePixelHeight),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        transaction.label,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: AppColors
                                                              .darkGrey,
                                                          fontSize: 12 *
                                                              textMultiplier,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          letterSpacing: 0.10,
                                                        ),
                                                      ),
                                                      Text(
                                                        () {
                                                          if (widget
                                                              .isFromPerformanceScreen) {
                                                            if (transaction
                                                                    .creditType ==
                                                                FilterCashCoin
                                                                    .debit) {
                                                              return "${transaction.debitStatus}";
                                                            } else {
                                                              return transaction
                                                                  .creditStatus;
                                                            }
                                                          } else {
                                                            if (transaction
                                                                    .creditType ==
                                                                FilterCashCoin
                                                                    .debit) {
                                                              return transaction
                                                                  .debitStatus;
                                                            } else {
                                                              return transaction
                                                                  .creditStatus;
                                                            }
                                                          }
                                                        }(),
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: AppColors
                                                              .darkGrey,
                                                          fontSize: 12 *
                                                              textMultiplier,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: 6 *
                                                          variablePixelHeight),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          () {
                                                            if (transaction
                                                                    .creditType
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                FilterCashCoin
                                                                    .debitType) {
                                                              if (transaction
                                                                      .redemptionmode ==
                                                                  FilterCashCoin
                                                                      .upi) {
                                                                return FilterCashCoin
                                                                    .redeemedViaUpi;
                                                              }
                                                              if (transaction
                                                                      .redemptionmode
                                                                      .toString()
                                                                      .toLowerCase() ==
                                                                  FilterCashCoin
                                                                      .paytmType) {
                                                                return FilterCashCoin
                                                                    .redeemedViaPaytm;
                                                              }
                                                              if (transaction
                                                                      .redemptionmode
                                                                      .toString()
                                                                      .toLowerCase() ==
                                                                  FilterCashCoin
                                                                      .pinelabType) {
                                                                return FilterCashCoin
                                                                    .redeemedViaPineLabs;
                                                              }
                                                              if (transaction
                                                                      .redemptionmode
                                                                      .toString()
                                                                      .toLowerCase() ==
                                                                  FilterCashCoin
                                                                      .creditNoteType) {
                                                                return FilterCashCoin
                                                                    .redeemedViaCreditNote;
                                                              }
                                                              return "-";
                                                            } else {
                                                              if (transaction
                                                                      .redemptionmode ==
                                                                  FilterCashCoin
                                                                      .redemptionMode) {
                                                                return FilterCashCoin
                                                                    .creditViaCashback;
                                                              } else {
                                                                String type =
                                                                    "-";
                                                                String mod =
                                                                    "-";
                                                                if (transaction
                                                                    .saleType
                                                                    .toString()
                                                                    .isNotEmpty) {
                                                                  type = transaction
                                                                      .saleType
                                                                      .toString();
                                                                }
                                                                if (transaction
                                                                    .model
                                                                    .toString()
                                                                    .isNotEmpty) {
                                                                  mod = transaction
                                                                      .model
                                                                      .toString();
                                                                }
                                                                return '$type for $mod';
                                                              }
                                                            }
                                                          }(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: AppColors
                                                                .darkGrey,
                                                            fontSize: 12 *
                                                                textMultiplier,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            letterSpacing: 0.10,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        transaction.creditType,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: AppColors
                                                              .darkGrey,
                                                          fontSize: 12 *
                                                              textMultiplier,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if (transaction !=
                                                      transactions.last)
                                                    const Divider(
                                                      thickness: 1,
                                                      color:
                                                          AppColors.lightGrey2,
                                                    ),
                                                  if (transaction ==
                                                      transactions.last)
                                                    SizedBox(
                                                      height: 24 *
                                                          variablePixelHeight,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                } else {
                                  return Obx(() {
                                    return (cashHistory.cashHistoryList.isEmpty)
                                        ? loadingWidget(
                                            cashHistory.isLoading.value)
                                        : loadingWidget(
                                            cashHistory.hasMore.value);
                                  });
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ));
    });
  }

  Widget loadingWidget(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ((cashHistory.pageNumber.value == 1 ||
                        cashHistory.filterPageNumber.value == 1) &&
                    cashHistory.cashHistoryList.isEmpty)
                ? Text(translation(context).emptyData)
                : Text(translation(context).noDataFound),
      ),
    );
  }
}
