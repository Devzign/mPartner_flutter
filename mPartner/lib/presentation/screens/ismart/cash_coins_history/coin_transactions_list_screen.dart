import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_string.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/utils.dart';
import '../../../../data/models/coin_history_model.dart';
import '../../../../data/models/network_management_model/dealer_electrician_details_model.dart';
import '../../../../data/models/user_profile_model.dart';
import '../../../../state/contoller/Ismart_coin_history_controller.dart';
import '../../../../state/contoller/coins_summary_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/coin_with_image_widget.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import 'credit_txn_detail_screen.dart';
import 'debit_txn_detail_screen.dart';
import 'history_filter_screen.dart';
import 'util/cash_coin_history_util.dart';

class CoinTransactionListScreen extends StatefulWidget {
  final bool isFromPerformanceScreen;
  final DealerElectricianDetail? listItemData;

  const CoinTransactionListScreen(
      {this.isFromPerformanceScreen = false, this.listItemData, super.key});

  @override
  State<CoinTransactionListScreen> createState() =>
      _CoinTransactionListScreenState();
}

class _CoinTransactionListScreenState extends State<CoinTransactionListScreen> {
  ISmartCoinHistoryController coinHistory = Get.find();
  CoinsSummaryController coinsSummaryController = Get.find();
  List<UserProfile> storedUserProfile = [];
  TextEditingController searchController = TextEditingController();
  List<CoinTransHistory> filteredData = [];
  final ScrollController _scrollController = ScrollController();
  Map<String, List<CoinTransHistory>> groupedData = {};
  String? codeId;

  bool cashScreen = false;
  bool coinScreen = false;
  String selectedTab = 'Coins';
  bool filterOrNot = false;
  double variablePixelHeight = 0;
  double variablePixelWidth = 0;
  double textFontMultiplier = 0;
  double pixelMultiplier = 0;
  double textMultiplier = 0;
  Map<String, List<CoinTransHistory>> filteredDataGrouped = {};

  bool disableCreditCard = false;
  bool disableDebitCard = false;
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
    for (var transaction in coinHistory.coinHistoryList) {
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
    coinHistory.fetchCoinHistory(code: codeId);
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
    Map<String, String> selectedValues = coinHistory.selectedValues;

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!coinHistory.isLoading.value) {
        if (coinHistory.filterFlag.value == false) {
          coinHistory.fetchCoinHistory(code: codeId);
        } else {
          if (coinHistory.isEarnEnable.value) {
            coinHistory.fetchFilteredData(
                coinHistory.selectedValues['selectedSaleType'] ?? "",
                coinHistory.selectedValues['selectedTransType'] == ""
                    ? "Credit"
                    : coinHistory.selectedValues['selectedTransType'] ?? "",
                coinHistory.selectedValues['CreditType'] ?? "",
                coinHistory.selectedValues['selectCreditTransType'] ?? "",
                coinHistory.selectedValues['selectDebitTransType'] ?? "",
                coinHistory.selectedValues['fromDateVal'] ?? "",
                coinHistory.selectedValues['toDateVal'] ?? "",
                coinHistory.selectedValues['selectedCategory'] ?? "",
                coinHistory.selectedValues['redemptionMode'] ?? "",
                code: codeId);
          } else if (coinHistory.isRedeemEnable.value) {
            coinHistory.fetchFilteredData(
                coinHistory.selectedValues['selectedSaleType'] ?? "",
                coinHistory.selectedValues['selectedTransType'] == ""
                    ? "Debit"
                    : coinHistory.selectedValues['selectedTransType'] ?? "",
                coinHistory.selectedValues['CreditType'] ?? "",
                coinHistory.selectedValues['selectCreditTransType'] ?? "",
                coinHistory.selectedValues['selectDebitTransType'] ?? "",
                coinHistory.selectedValues['fromDateVal'] ?? "",
                coinHistory.selectedValues['toDateVal'] ?? "",
                coinHistory.selectedValues['selectedCategory'] ?? "",
                coinHistory.selectedValues['redemptionMode'] ?? "",
                code: codeId);
          } else if (coinHistory.filterFlag.value = true) {
            coinHistory.fetchFilteredData(
                selectedValues['selectedSaleType']!,
                selectedValues['selectedTransType']!,
                selectedValues['CreditType']!,
                selectedValues['selectCreditTransType']!,
                selectedValues['selectDebitTransType']!,
                selectedValues['fromDateVal']!,
                selectedValues['toDateVal']!,
                selectedValues['selectedCategory']!,
                selectedValues['redemptionMode']!,
                code: codeId);
          } else {
            coinHistory.fetchCoinHistory(code: codeId);
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
      Color coinColorVal,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CoinWithImageWidget(
                        coin: double.parse(totalValue.replaceAll(',', '')),
                        width: 160,
                        weight: FontWeight.w600,
                        size: 16,
                        color: coinColorVal,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10 * variablePixelHeight,
                  ),
                  Text(
                    recentValue,
                    style: GoogleFonts.poppins(
                      fontSize: 12 * textFontMultiplier,
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
                                coinHistory.clearCoinHistoryList();
                                coinHistory.isEarnEnable = false.obs;
                                coinHistory.isRedeemEnable = false.obs;
                                if ((coinHistory.selectedValues['fromDateVal']!
                                            .isNotEmpty &&
                                        coinHistory.selectedValues['toDateVal']!
                                            .isNotEmpty) ||
                                    (coinHistory.searchKey.value.isNotEmpty)) {
                                  coinHistory.filterFlag = true.obs;
                                  coinHistory.isFilterApplied = true.obs;
                                }
                                coinHistory.selectedValues = {
                                  'selectedSaleType': "",
                                  'selectedTransType': "",
                                  'CreditType': '',
                                  'selectCreditTransType': "",
                                  'selectDebitTransType': "",
                                  'fromDateVal': coinHistory
                                          .selectedValues['fromDateVal'] ??
                                      "",
                                  'toDateVal':
                                      coinHistory.selectedValues['toDateVal'] ??
                                          "",
                                  'selectedDateRange':
                                      coinHistory.selectedValues[
                                              'selectedDateRange'] ??
                                          "",
                                  'selectedCategory': "",
                                  'redemptionMode': "",
                                }.obs;
                                if (coinHistory.isFilterApplied.value) {
                                  coinHistory.fetchFilteredData(
                                      coinHistory.selectedValues[
                                              'selectedSaleType'] ??
                                          "",
                                      coinHistory
                                                  .selectedValues[
                                              'selectedTransType'] ??
                                          "",
                                      coinHistory.selectedValues[
                                              'CreditType'] ??
                                          "",
                                      coinHistory
                                                  .selectedValues[
                                              'selectCreditTransType'] ??
                                          "",
                                      coinHistory.selectedValues[
                                              'selectDebitTransType'] ??
                                          "",
                                      coinHistory
                                              .selectedValues['fromDateVal'] ??
                                          "",
                                      coinHistory.selectedValues['toDateVal'] ??
                                          "",
                                      coinHistory.selectedValues[
                                              'selectedCategory'] ??
                                          "",
                                      coinHistory.selectedValues[
                                              'redemptionMode'] ??
                                          "",
                                      code: codeId);
                                } else {
                                  coinHistory.fetchCoinHistory(code: codeId);
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
    textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    groupData();
    return Obx(() {
      groupData();
      groupFilteredData();
      return WillPopScope(
        onWillPop: () async {
          coinHistory.clearIsmartCoinHistory();
          coinsSummaryController.clearCoinSummaryData(
              code: widget.listItemData?.code!);
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
                                GetBuilder<CoinsSummaryController>(
                                  builder: (_) {
                                    return CoinWithImageWidget(
                                      coin: double.parse(coinsSummaryController
                                          .availableCoins
                                          .replaceAll(',', '')),
                                      width: 120,
                                      weight: FontWeight.w600,
                                      size: 14,
                                      color: AppColors.lumiBluePrimary,
                                    );
                                  },
                                ),
                                Text(
                                  " ${translation(context).coins}  ${translation(context).available} ",
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
                            decoration: BoxDecoration(
                              color: AppColors.lightWhite1,
                              borderRadius:
                                  BorderRadius.circular(8 * pixelMultiplier),
                              border: Border.all(
                                color: AppColors.lightGrey1,
                                width: 1.0,
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
                                      color: AppColors.darkGrey,
                                      fontSize: 11 * textMultiplier,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.50,
                                    ),
                                    onChanged: (value) {
                                      String searchKey = searchController.text
                                          .toLowerCase()
                                          .trim();
                                      logger.d("onChanged $searchKey");
                                      if (searchKey.isEmpty) {
                                        coinHistory.clearCoinHistoryList();
                                        if ((coinHistory.selectedValues[
                                                        'fromDateVal']
                                                    .toString()
                                                    .isNotEmpty &&
                                                coinHistory
                                                    .selectedValues['toDateVal']
                                                    .toString()
                                                    .isNotEmpty) ||
                                            (coinHistory.selectedValues[
                                                    'selectedTransType']
                                                .toString()
                                                .isNotEmpty)) {
                                          coinHistory.filterFlag = true.obs;
                                          coinHistory.isFilterApplied =
                                              true.obs;
                                        }

                                        if (coinHistory.isFilterApplied.value) {
                                          coinHistory.fetchFilteredData(
                                              coinHistory.selectedValues[
                                                      'selectedSaleType'] ??
                                                  "",
                                              coinHistory.selectedValues[
                                                      'selectedTransType'] ??
                                                  "",
                                              coinHistory.selectedValues[
                                                      'CreditType'] ??
                                                  "",
                                              coinHistory.selectedValues[
                                                      'selectCreditTransType'] ??
                                                  "",
                                              coinHistory.selectedValues[
                                                      'selectDebitTransType'] ??
                                                  "",
                                              coinHistory.selectedValues[
                                                      'fromDateVal'] ??
                                                  "",
                                              coinHistory.selectedValues[
                                                      'toDateVal'] ??
                                                  "",
                                              coinHistory.selectedValues[
                                                      'selectedCategory'] ??
                                                  "",
                                              coinHistory.selectedValues[
                                                      'redemptionMode'] ??
                                                  "",
                                              code: codeId);
                                        } else {
                                          coinHistory.filterFlag.value = false;
                                          coinHistory.isFilterApplied.value =
                                              false;
                                          coinHistory.fetchCoinHistory(
                                              code: codeId);
                                        }
                                      } else if (searchKey.length < 3) {
                                        coinHistory.searchKey.value = "";
                                      } else {
                                        coinHistory.searchKey.value = searchKey;
                                      }
                                    },
                                    onEditingComplete: () {
                                      String searchKey = searchController.text
                                          .toLowerCase()
                                          .trim();
                                      logger.d("onEditingComplete $searchKey");
                                      if (searchKey.length >= 3) {
                                        coinHistory.searchKey.value = searchKey;
                                        coinHistory.clearCoinHistoryList();
                                        coinHistory.filterFlag.value = true;
                                        coinHistory.isFilterApplied.value =
                                            true;
                                        coinHistory.fetchFilteredData(
                                            coinHistory
                                                        .selectedValues[
                                                    'selectedSaleType'] ??
                                                "",
                                            coinHistory
                                                        .selectedValues[
                                                    'selectedTransType'] ??
                                                "",
                                            coinHistory
                                                        .selectedValues[
                                                    'CreditType'] ??
                                                "",
                                            coinHistory
                                                        .selectedValues[
                                                    'selectCreditTransType'] ??
                                                "",
                                            coinHistory
                                                        .selectedValues[
                                                    'selectDebitTransType'] ??
                                                "",
                                            coinHistory.selectedValues[
                                                    'fromDateVal'] ??
                                                "",
                                            coinHistory.selectedValues[
                                                    'toDateVal'] ??
                                                "",
                                            coinHistory.selectedValues[
                                                    'selectedCategory'] ??
                                                "",
                                            coinHistory.selectedValues[
                                                    'redemptionMode'] ??
                                                "",
                                            code: codeId);
                                      }
                                    },
                                    enabled: coinHistory.isLoading.value
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
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        counterText: ""),
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
                                        coinHistory.searchKey.value = searchKey;
                                        coinHistory.clearCoinHistoryList();
                                        coinHistory.filterFlag.value = true;
                                        coinHistory.isFilterApplied.value =
                                            true;
                                        coinHistory.fetchFilteredData(
                                            coinHistory
                                                        .selectedValues[
                                                    'selectedSaleType'] ??
                                                "",
                                            coinHistory
                                                        .selectedValues[
                                                    'selectedTransType'] ??
                                                "",
                                            coinHistory
                                                        .selectedValues[
                                                    'CreditType'] ??
                                                "",
                                            coinHistory
                                                        .selectedValues[
                                                    'selectCreditTransType'] ??
                                                "",
                                            coinHistory
                                                        .selectedValues[
                                                    'selectDebitTransType'] ??
                                                "",
                                            coinHistory.selectedValues[
                                                    'fromDateVal'] ??
                                                "",
                                            coinHistory.selectedValues[
                                                    'toDateVal'] ??
                                                "",
                                            coinHistory.selectedValues[
                                                    'selectedCategory'] ??
                                                "",
                                            coinHistory.selectedValues[
                                                    'redemptionMode'] ??
                                                "",
                                            code: codeId);
                                      }
                                    },
                                    child: Icon(
                                      Icons.search,
                                      size: 20 * pixelMultiplier,
                                      color:
                                          coinHistory.searchKey.value.isNotEmpty
                                              ? AppColors.lumiBluePrimary
                                              : AppColors.lightGreyBorder,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: coinHistory.isLoading.value
                                ? () {}
                                : () async {
                                    String searchKey = searchController.text
                                        .toLowerCase()
                                        .trim();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HistoryFilter(
                                                  historyType:
                                                      FilterCashCoin.coin,
                                                  code: (widget.listItemData !=
                                                          null)
                                                      ? widget
                                                          .listItemData!.code
                                                      : null,
                                                  searchKey: searchKey,
                                                ))).then((_) {
                                      if (!coinHistory.isFilterApplied.value) {
                                        coinHistory.searchKey.value = "";
                                        searchController.clear();
                                      }
                                    });
                                  },
                            child: Container(
                              width: pixelMultiplier * 40,
                              height: pixelMultiplier * 40,
                              decoration: BoxDecoration(
                                color: AppColors.lightWhite1,
                                borderRadius:
                                    BorderRadius.circular(8 * pixelMultiplier),
                                border: Border.all(
                                  color: AppColors.lightGrey1,
                                  width: 1.0,
                                ),
                              ),
                              child: Obx(() {
                                return Center(
                                  child: Icon(
                                    coinHistory.isFilterApplied.value
                                        ? Icons.filter_alt
                                        : Icons.filter_alt_outlined,
                                    size: 24 * pixelMultiplier,
                                    color: coinHistory.isFilterApplied.value
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
                                  color: AppColors.darkGrey,
                                  fontSize: 14 * textMultiplier,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.50,
                                ),
                              ),
                              GetBuilder<ISmartCoinHistoryController>(
                                  builder: (_) {
                                return coinHistory.isDateSelected == true.obs
                                    ? Text(
                                        "${coinHistory.selectedValues['fromDateVal']} - ${coinHistory.selectedValues['toDateVal']}",
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
                              GetBuilder<ISmartCoinHistoryController>(
                                  builder: (_) {
                                return GestureDetector(
                                  onTap: coinHistory.isLoading.value
                                      ? () {}
                                      : ((coinHistory.pageNumber.value == 1 ||
                                                  coinHistory.filterPageNumber
                                                          .value ==
                                                      1) &&
                                              coinHistory
                                                  .coinHistoryList.isEmpty)
                                          ? () {}
                                          : () async {
                                              if (isShareButtonEnabled) {
                                                setState(() {
                                                  isShareButtonEnabled = false;
                                                });
                                                await coinHistory.fetchCoinExcelData(
                                                    coinHistory.selectedValues[
                                                            'selectedSaleType'] ??
                                                        "",
                                                    coinHistory.selectedValues[
                                                            'selectedTransType'] ??
                                                        "",
                                                    coinHistory.selectedValues[
                                                            'CreditType'] ??
                                                        "",
                                                    coinHistory.selectedValues[
                                                            'selectCreditTransType'] ??
                                                        "",
                                                    coinHistory.selectedValues[
                                                            'selectDebitTransType'] ??
                                                        "",
                                                    coinHistory.selectedValues[
                                                            'fromDateVal'] ??
                                                        "",
                                                    coinHistory.selectedValues[
                                                            'toDateVal'] ??
                                                        "",
                                                    coinHistory.selectedValues[
                                                            'selectedCategory'] ??
                                                        "",
                                                    coinHistory.selectedValues[
                                                            'redemptionMode'] ??
                                                        "",
                                                    code: codeId);

                                                if (coinHistory
                                                    .coinExcelReportUrl
                                                    .value
                                                    .isNotEmpty) {
                                                  await Share.share(coinHistory
                                                      .coinExcelReportUrl
                                                      .value);
                                                  setState(() {
                                                    isShareButtonEnabled = true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    isShareButtonEnabled = true;
                                                  });
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        coinHistory
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
                                      color:
                                          ((coinHistory.pageNumber.value == 1 ||
                                                      coinHistory
                                                              .filterPageNumber
                                                              .value ==
                                                          1) &&
                                                  coinHistory
                                                      .coinHistoryList.isEmpty)
                                              ? AppColors.dividerColor
                                              : AppColors.darkGreyText,
                                    ),
                                  ),
                                );
                              }),
                              SizedBox(
                                width: variablePixelWidth * 12,
                              ),
                              GetBuilder<ISmartCoinHistoryController>(
                                  builder: (_) {
                                return GestureDetector(
                                  onTap: coinHistory.isLoading.value
                                      ? () {}
                                      : ((coinHistory.pageNumber.value == 1 ||
                                                  coinHistory.filterPageNumber
                                                          .value ==
                                                      1) &&
                                              coinHistory
                                                  .coinHistoryList.isEmpty)
                                          ? () {}
                                          : () async {
                                              await coinHistory.fetchCoinExcelData(
                                                  coinHistory.selectedValues[
                                                          'selectedSaleType'] ??
                                                      "",
                                                  coinHistory.selectedValues[
                                                          'selectedTransType'] ??
                                                      "",
                                                  coinHistory.selectedValues[
                                                          'CreditType'] ??
                                                      "",
                                                  coinHistory.selectedValues[
                                                          'selectCreditTransType'] ??
                                                      "",
                                                  coinHistory.selectedValues[
                                                          'selectDebitTransType'] ??
                                                      "",
                                                  coinHistory.selectedValues[
                                                          'fromDateVal'] ??
                                                      "",
                                                  coinHistory.selectedValues[
                                                          'toDateVal'] ??
                                                      "",
                                                  coinHistory.selectedValues[
                                                          'selectedCategory'] ??
                                                      "",
                                                  coinHistory.selectedValues[
                                                          'redemptionMode'] ??
                                                      "",
                                                  code: codeId);
                                              if (coinHistory.coinExcelReportUrl
                                                  .value.isNotEmpty) {
                                                await launchUrlString(
                                                    coinHistory
                                                        .coinExcelReportUrl
                                                        .value);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      coinHistory
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
                                      color:
                                          ((coinHistory.pageNumber.value == 1 ||
                                                      coinHistory
                                                              .filterPageNumber
                                                              .value ==
                                                          1) &&
                                                  coinHistory
                                                      .coinHistoryList.isEmpty)
                                              ? AppColors.dividerColor
                                              : AppColors.darkGreyText,
                                    ),
                                  ),
                                );
                              }),
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
                            child: GetBuilder<ISmartCoinHistoryController>(
                                builder: (_) {
                              return GestureDetector(
                                onTap: coinHistory.isLoading.value
                                    ? () {}()
                                    : () {
                                        if (coinHistory.selectedValues[
                                                        'selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin.creditType ||
                                            coinHistory.selectedValues[
                                                        'selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin.debitType ||
                                            (coinHistory.selectedValues[
                                                        'selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin
                                                    .debitCreditType) ||
                                            (coinHistory.selectedValues[
                                                        'selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin
                                                    .creditDebitType)) {
                                          return () {};
                                        } else {
                                          return () {
                                            coinHistory.clearCoinHistoryList();
                                            coinHistory.filterFlag.value = true;
                                            coinHistory.isEarnEnable = true.obs;
                                            coinHistory.isRedeemEnable =
                                                false.obs;
                                            coinHistory.isFilterApplied.value =
                                                true;
                                            coinHistory.selectedValues = {
                                              'selectedSaleType': "",
                                              'selectedTransType': "Credit",
                                              'CreditType': "Earned,Bonus",
                                              'selectCreditTransType': "",
                                              'selectDebitTransType': "",
                                              'fromDateVal':
                                                  coinHistory.selectedValues[
                                                          'fromDateVal'] ??
                                                      "",
                                              'toDateVal':
                                                  coinHistory.selectedValues[
                                                          'toDateVal'] ??
                                                      "",
                                              'selectedDateRange': coinHistory
                                                          .selectedValues[
                                                      'selectedDateRange'] ??
                                                  "",
                                              'selectedCategory': "",
                                              'redemptionMode': "",
                                            }.obs;
                                            coinHistory.fetchFilteredData(
                                                coinHistory.selectedValues[
                                                        'selectedSaleType'] ??
                                                    "",
                                                coinHistory.selectedValues[
                                                        'selectedTransType'] ??
                                                    "",
                                                coinHistory.selectedValues[
                                                        'CreditType'] ??
                                                    "",
                                                coinHistory.selectedValues[
                                                        'selectCreditTransType'] ??
                                                    "",
                                                coinHistory.selectedValues[
                                                        'selectDebitTransType'] ??
                                                    "",
                                                coinHistory.selectedValues[
                                                        'fromDateVal'] ??
                                                    "",
                                                coinHistory.selectedValues[
                                                        'toDateVal'] ??
                                                    "",
                                                coinHistory.selectedValues[
                                                        'selectedCategory'] ??
                                                    "",
                                                coinHistory.selectedValues[
                                                        'redemptionMode'] ??
                                                    "",
                                                code: codeId);
                                          };
                                        }
                                      }(),
                                child: showTxnTypeWidget(
                                    translation(context).earned,
                                    coinHistory.earnedCoin,
                                    "Credit (${coinHistory.creditCount})",
                                    (coinHistory.selectedValues['selectedTransType'].toString().toLowerCase() == FilterCashCoin.debitCreditType) ||
                                            (coinHistory.selectedValues['selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin.creditDebitType)
                                        ? AppColors.hintColor
                                        : AppColors.successGreen,
                                    (coinHistory.selectedValues['selectedTransType'].toString().toLowerCase() == FilterCashCoin.debitCreditType) ||
                                            (coinHistory.selectedValues['selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin.creditDebitType)
                                        ? AppColors.hintColor
                                        : AppColors.lumiBluePrimary,
                                    (coinHistory.selectedValues['selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin
                                                    .debitCreditType) ||
                                            (coinHistory.selectedValues['selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin.creditDebitType)
                                        ? AppColors.hintColor
                                        : AppColors.darkGrey,
                                    (coinHistory.selectedValues['selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin
                                                    .debitCreditType) ||
                                            (coinHistory
                                                    .selectedValues['selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin.creditDebitType)
                                        ? AppColors.lumiLight4.withOpacity(0.3)
                                        : AppColors.lumiLight4,
                                    coinHistory.isEarnEnable.value),
                              );
                            }),
                          ),
                          Expanded(
                            child: GetBuilder<CoinsSummaryController>(
                                builder: (_) {
                              return GestureDetector(
                                onTap: coinHistory.isLoading.value
                                    ? () {}()
                                    : () {
                                        if (coinHistory.selectedValues[
                                                        'selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin.creditType ||
                                            coinHistory.selectedValues[
                                                        'selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin.debitType ||
                                            (coinHistory.selectedValues[
                                                        'selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin
                                                    .debitCreditType) ||
                                            (coinHistory.selectedValues[
                                                        'selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin
                                                    .creditDebitType)) {
                                          return () {};
                                        } else {
                                          return () {
                                            coinHistory.clearCoinHistoryList();
                                            coinHistory.isEarnEnable =
                                                false.obs;
                                            coinHistory.isRedeemEnable =
                                                true.obs;
                                            coinHistory.isFilterApplied.value =
                                                true;
                                            coinHistory.filterFlag.value = true;
                                            coinHistory.selectedValues = {
                                              'selectedSaleType': "",
                                              'selectedTransType': "Debit",
                                              'CreditType': '',
                                              'selectCreditTransType': "",
                                              'selectDebitTransType': "",
                                              'fromDateVal':
                                                  coinHistory.selectedValues[
                                                          'fromDateVal'] ??
                                                      "",
                                              'toDateVal':
                                                  coinHistory.selectedValues[
                                                          'toDateVal'] ??
                                                      "",
                                              'selectedDateRange': coinHistory
                                                          .selectedValues[
                                                      'selectedDateRange'] ??
                                                  "",
                                              'selectedCategory': "",
                                              'redemptionMode': "",
                                            }.obs;
                                            coinHistory.fetchFilteredData(
                                                coinHistory.selectedValues[
                                                        'selectedSaleType'] ??
                                                    "",
                                                coinHistory.selectedValues[
                                                        'selectedTransType'] ??
                                                    "",
                                                coinHistory.selectedValues[
                                                        'CreditType'] ??
                                                    "",
                                                coinHistory.selectedValues[
                                                        'selectCreditTransType'] ??
                                                    "",
                                                coinHistory.selectedValues[
                                                        'selectDebitTransType'] ??
                                                    "",
                                                coinHistory.selectedValues[
                                                        'fromDateVal'] ??
                                                    "",
                                                coinHistory.selectedValues[
                                                        'toDateVal'] ??
                                                    "",
                                                coinHistory.selectedValues[
                                                        'selectedCategory'] ??
                                                    "",
                                                coinHistory.selectedValues[
                                                        'redemptionMode'] ??
                                                    "",
                                                code: codeId);
                                          };
                                        }
                                      }(),
                                child: showTxnTypeWidget(
                                    translation(context).redeemed,
                                    coinHistory.redeemedCoin,
                                    "Debit (${coinHistory.debitCount})",
                                    (coinHistory.selectedValues['selectedTransType'].toString().toLowerCase() == FilterCashCoin.debitCreditType) ||
                                            (coinHistory.selectedValues['selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin.creditDebitType)
                                        ? AppColors.hintColor
                                        : AppColors.errorRed,
                                    (coinHistory.selectedValues['selectedTransType'].toString().toLowerCase() == FilterCashCoin.debitCreditType) ||
                                            (coinHistory.selectedValues['selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin.creditDebitType)
                                        ? AppColors.hintColor
                                        : AppColors.lumiBluePrimary,
                                    (coinHistory.selectedValues['selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin
                                                    .debitCreditType) ||
                                            (coinHistory.selectedValues['selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin.creditDebitType)
                                        ? AppColors.hintColor
                                        : AppColors.darkGrey,
                                    (coinHistory.selectedValues['selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin
                                                    .debitCreditType) ||
                                            (coinHistory
                                                    .selectedValues['selectedTransType']
                                                    .toString()
                                                    .toLowerCase() ==
                                                FilterCashCoin.creditDebitType)
                                        ? AppColors.lumiLight4.withOpacity(0.3)
                                        : AppColors.lumiLight4,
                                    coinHistory.isRedeemEnable.value),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    (coinHistory.isLoading.value &&
                            coinHistory.coinHistoryList.isEmpty)
                        ? loadingWidget(coinHistory.isLoading.value)
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
                                      for (var transaction in transactions) ...[
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              24 * variablePixelWidth,
                                              12 * variablePixelHeight,
                                              24 * variablePixelWidth,
                                              0),
                                          child: InkWell(
                                            onTap: () {
                                              if (transaction.transactionType
                                                      .toLowerCase() ==
                                                  FilterCashCoin.creditType) {
                                                if (transaction.creditStatus
                                                        .toLowerCase() ==
                                                    FilterCashCoin
                                                        .acceptedType) {
                                                  if (transaction.saleType ==
                                                      "Luminous Bonus") {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DebitCoinCashDetailedHistory(
                                                                  state:
                                                                      'Bonus',
                                                                  stateMsg: '',
                                                                  cashOrCoinHistory:
                                                                      'Coin',
                                                                  transactionRemark:
                                                                      '${rupeeNoSign.format(transaction.coins)} coins received and credited to your mPartner coin wallet',
                                                                  points: rupeeNoSign.format(
                                                                      transaction
                                                                          .coins),
                                                                  pointsEarnedMsg:
                                                                      'Coins Earned',
                                                                  listItemData:
                                                                      widget
                                                                          .listItemData,
                                                                  isFromPerformanceScreen:
                                                                      widget
                                                                          .isFromPerformanceScreen,
                                                                  transactionType:
                                                                      "bonus",
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
                                                                          .serial_no
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? transaction
                                                                          .serial_no
                                                                      : '-',
                                                                  finalRemark:
                                                                      '',
                                                                )));
                                                  } else {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CreditTransactionDetailScreen(
                                                                  coinTxnData:
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
                                                                      'Accepted!',
                                                                  cashOrCoinHistory:
                                                                      'Coin',
                                                                  transMsg:
                                                                      '${rupeeNoSign.format(transaction.coins)} coins credited to mPartner coin wallet',
                                                                  points: rupeeNoSign.format(
                                                                      transaction
                                                                          .coins),
                                                                  pointsEarnedMsg:
                                                                      'Coin Earned',
                                                                  remark:
                                                                      transaction
                                                                          .remark,
                                                                  otpRemark:
                                                                      transaction
                                                                          .otpRemark,
                                                                  serialNo: transaction
                                                                          .serial_no
                                                                          .toString()
                                                                          .isNotEmpty
                                                                      ? transaction
                                                                          .serial_no
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
                                                if (transaction.creditStatus
                                                        .toLowerCase() ==
                                                    FilterCashCoin
                                                        .pendingType) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CreditTransactionDetailScreen(
                                                                coinTxnData:
                                                                    transaction,
                                                                saleType:
                                                                    transaction
                                                                        .saleType,
                                                                listItemData: widget
                                                                    .listItemData,
                                                                isFromPerformanceScreen:
                                                                    widget
                                                                        .isFromPerformanceScreen,
                                                                state: transaction
                                                                    .creditStatus,
                                                                stateMsg:
                                                                    'Pending!',
                                                                cashOrCoinHistory:
                                                                    'Coin',
                                                                transMsg:
                                                                    '${rupeeNoSign.format(transaction.coins)} coins credit is pending',
                                                                points: rupeeNoSign
                                                                    .format(transaction
                                                                        .coins),
                                                                pointsEarnedMsg:
                                                                    'Coins Pending',
                                                                remark:
                                                                    transaction
                                                                        .remark,
                                                                otpRemark:
                                                                    transaction
                                                                        .otpRemark,
                                                                serialNo: transaction
                                                                        .serial_no
                                                                        .toString()
                                                                        .isNotEmpty
                                                                    ? transaction
                                                                        .serial_no
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
                                                                        : transaction.saleType ==
                                                                                'Intermediary'
                                                                            ? '${transaction.saleType} Sale to electrician'
                                                                            : '${transaction.saleType}',
                                                                customerName: CashCoinHistoryUtil()
                                                                    .getCustomerName(
                                                                        transaction,
                                                                        widget
                                                                            .isFromPerformanceScreen),
                                                                customerPhone: CashCoinHistoryUtil()
                                                                    .getPhoneNumber(
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
                                                                coinTxnData:
                                                                    transaction,
                                                                saleType:
                                                                    transaction
                                                                        .saleType,
                                                                listItemData: widget
                                                                    .listItemData,
                                                                isFromPerformanceScreen:
                                                                    widget
                                                                        .isFromPerformanceScreen,
                                                                state: transaction
                                                                    .creditStatus,
                                                                stateMsg:
                                                                    'Rejected!',
                                                                cashOrCoinHistory:
                                                                    'Coin',
                                                                transMsg:
                                                                    '${rupeeNoSign.format(transaction.coins)} coins credit is rejected',
                                                                points: rupeeNoSign
                                                                    .format(transaction
                                                                        .coins),
                                                                pointsEarnedMsg:
                                                                    'Coin Rejected',
                                                                remark:
                                                                    transaction
                                                                        .remark,
                                                                otpRemark:
                                                                    transaction
                                                                        .otpRemark,
                                                                serialNo: transaction
                                                                        .serial_no
                                                                        .toString()
                                                                        .isNotEmpty
                                                                    ? transaction
                                                                        .serial_no
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
                                                                        : transaction.saleType ==
                                                                                'Intermediary'
                                                                            ? '${transaction.saleType} Sale to electrician'
                                                                            : '${transaction.saleType}',
                                                                customerName: CashCoinHistoryUtil()
                                                                    .getCustomerName(
                                                                        transaction,
                                                                        widget
                                                                            .isFromPerformanceScreen),
                                                                customerPhone: CashCoinHistoryUtil()
                                                                    .getPhoneNumber(
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
                                              if (transaction.transactionType
                                                      .toLowerCase() ==
                                                  FilterCashCoin.debitType) {
                                                if (transaction.debitStatus
                                                        .toLowerCase() ==
                                                    FilterCashCoin
                                                        .successfulType) {
                                                  if(transaction.redemptionMode
                                                      .toLowerCase() ==
                                                      FilterCashCoin
                                                          .bonus_adjustment){
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                DebitCoinCashDetailedHistory(
                                                                  state:
                                                                  'Successful',
                                                                  stateMsg: "${translation(
                                                                      context)
                                                                      .accepted}!",
                                                                  cashOrCoinHistory:
                                                                  'Coin',
                                                                  transactionRemark:transaction.remark,/* transaction
                                                                      .redemptionMode
                                                                      .toLowerCase() ==
                                                                      FilterCashCoin
                                                                          .tripsType
                                                                      ? '${rupeeNoSign
                                                                      .format(
                                                                      transaction
                                                                          .coins)} coins debited for redeeming via Trips'
                                                                      : '${rupeeNoSign
                                                                      .format(
                                                                      transaction
                                                                          .coins)} coins converted into ₹${rupeeNoSign
                                                                      .format(
                                                                      transaction
                                                                          .convertedCash)} and credited to your mPartner cash wallet',
                                                                 */
                                                                  points: rupeeNoSign
                                                                      .format(
                                                                      transaction
                                                                          .coins),
                                                                  pointsEarnedMsg:
                                                                  'Coin Adjusted',
                                                                  listItemData: widget
                                                                      .listItemData,
                                                                  isFromPerformanceScreen:
                                                                  widget
                                                                      .isFromPerformanceScreen,
                                                                  transactionType:
                                                                  transaction
                                                                      .redemptionMode
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
                                                                      .format(
                                                                      DateTime
                                                                          .parse(
                                                                          transaction
                                                                              .transDate)),
                                                                  transactionId: transaction
                                                                      .serial_no
                                                                      .toString()
                                                                      .isNotEmpty
                                                                      ? transaction
                                                                      .serial_no
                                                                      : '-',
                                                                  finalRemark: '',
                                                                )));

                                                  }
                                                  else {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                DebitCoinCashDetailedHistory(
                                                                  state:
                                                                  'Successful',
                                                                  stateMsg: translation(
                                                                      context)
                                                                      .transactionSuccessfulExclamation,
                                                                  cashOrCoinHistory:
                                                                  'Coin',
                                                                  transactionRemark: transaction
                                                                      .redemptionMode
                                                                      .toLowerCase() ==
                                                                      FilterCashCoin
                                                                          .tripsType
                                                                      ? '${rupeeNoSign
                                                                      .format(
                                                                      transaction
                                                                          .coins)} coins debited for redeeming via Trips'
                                                                      : '${rupeeNoSign
                                                                      .format(
                                                                      transaction
                                                                          .coins)} coins converted into ₹${rupeeNoSign
                                                                      .format(
                                                                      transaction
                                                                          .convertedCash)} and credited to your mPartner cash wallet',
                                                                  points: rupeeNoSign
                                                                      .format(
                                                                      transaction
                                                                          .coins),
                                                                  pointsEarnedMsg:
                                                                  'Coins Redeemed',
                                                                  listItemData: widget
                                                                      .listItemData,
                                                                  isFromPerformanceScreen:
                                                                  widget
                                                                      .isFromPerformanceScreen,
                                                                  transactionType:
                                                                  transaction
                                                                      .redemptionMode
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
                                                                      .format(
                                                                      DateTime
                                                                          .parse(
                                                                          transaction
                                                                              .transDate)),
                                                                  transactionId: transaction
                                                                      .serial_no
                                                                      .toString()
                                                                      .isNotEmpty
                                                                      ? transaction
                                                                      .serial_no
                                                                      : '-',
                                                                  finalRemark: '',
                                                                )));
                                                  }
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
                                                                    'Coin',
                                                                transactionRemark:
                                                                    'We could not process this request. No coins have been deducted for this transaction',
                                                                points: rupeeNoSign
                                                                    .format(transaction
                                                                        .coins),
                                                                pointsEarnedMsg:
                                                                    '',
                                                                listItemData: widget
                                                                    .listItemData,
                                                                isFromPerformanceScreen:
                                                                    widget
                                                                        .isFromPerformanceScreen,
                                                                transactionType:
                                                                    transaction
                                                                        .redemptionMode
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
                                                                        .serial_no
                                                                        .toString()
                                                                        .isNotEmpty
                                                                    ? transaction
                                                                        .serial_no
                                                                    : '-',
                                                                finalRemark: '',
                                                              )));
                                                }
                                                if (transaction.debitStatus
                                                        .toLowerCase() ==
                                                    FilterCashCoin.failedType) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DebitCoinCashDetailedHistory(
                                                                state: 'Failed',
                                                                stateMsg: translation(
                                                                        context)
                                                                    .transactionFailedExclamation,
                                                                cashOrCoinHistory:
                                                                    'Coin',
                                                                transactionRemark:
                                                                    'We could not process this request. No coins have been deducted for this transaction',
                                                                points: rupeeNoSign
                                                                    .format(transaction
                                                                        .coins),
                                                                pointsEarnedMsg:
                                                                    '',
                                                                listItemData: widget
                                                                    .listItemData,
                                                                isFromPerformanceScreen:
                                                                    widget
                                                                        .isFromPerformanceScreen,
                                                                transactionType:
                                                                    transaction
                                                                        .redemptionMode
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
                                                                        .serial_no
                                                                        .toString()
                                                                        .isNotEmpty
                                                                    ? transaction
                                                                        .serial_no
                                                                    : '-',
                                                                finalRemark: '',
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
                                                                state: 'Failed',
                                                                stateMsg: translation(
                                                                        context)
                                                                    .transactionFailedExclamation,
                                                                cashOrCoinHistory:
                                                                    'Coin',
                                                                transactionRemark:
                                                                    'We could not process this request. No coins have been deducted for this transaction',
                                                                points: rupeeNoSign
                                                                    .format(transaction
                                                                        .coins),
                                                                pointsEarnedMsg:
                                                                    '',
                                                                listItemData: widget
                                                                    .listItemData,
                                                                isFromPerformanceScreen:
                                                                    widget
                                                                        .isFromPerformanceScreen,
                                                                transactionType:
                                                                    transaction
                                                                        .redemptionMode
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
                                                                        .serial_no
                                                                        .toString()
                                                                        .isNotEmpty
                                                                    ? transaction
                                                                        .serial_no
                                                                    : '-',
                                                                finalRemark: '',
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
                                                        color:
                                                            AppColors.darkGrey,
                                                        fontSize:
                                                            14 * textMultiplier,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        letterSpacing: 0.10,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        CoinWithImageWidget(
                                                          coin: double.parse(
                                                              transaction.coins
                                                                  .toString()
                                                                  .replaceAll(
                                                                      ',', '')),
                                                          color: () {
                                                            if (transaction
                                                                    .transactionType
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
                                                                    .transactionType
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
                                                                        .transactionType
                                                                        .toLowerCase() ==
                                                                    FilterCashCoin
                                                                        .creditType &&
                                                                transaction
                                                                        .coins !=
                                                                    0) {
                                                              return '+';
                                                            } else if (transaction
                                                                        .transactionType
                                                                        .toLowerCase() ==
                                                                    FilterCashCoin
                                                                        .debitType &&
                                                                transaction
                                                                        .coins !=
                                                                    0) {
                                                              return '-';
                                                            } else {
                                                              return '';
                                                            }
                                                          }(),
                                                          width: 120,
                                                          weight:
                                                              FontWeight.w600,
                                                          size: 14,
                                                        ),
                                                      ],
                                                    )
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
                                                      () {
                                                        if (transaction
                                                                .transactionType
                                                                .toLowerCase() ==
                                                            FilterCashCoin
                                                                .debitType) {
                                                          if (transaction
                                                              .serial_no
                                                              .toString()
                                                              .isNotEmpty) {
                                                            return 'Trans ID- ${transaction.serial_no}';
                                                          } else {
                                                            return 'Trans ID-';
                                                          }
                                                        } else {
                                                          if (transaction
                                                              .serial_no
                                                              .toString()
                                                              .isNotEmpty) {
                                                            return 'Serial No: ${transaction.serial_no}';
                                                          } else {
                                                            return 'Serial No:';
                                                          }
                                                        }
                                                      }(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color:
                                                            AppColors.darkGrey,
                                                        fontSize:
                                                            12 * textMultiplier,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        letterSpacing: 0.10,
                                                      ),
                                                    ),
                                                    Text(
                                                      (transaction.transactionType
                                                                  .toLowerCase() ==
                                                              FilterCashCoin
                                                                  .creditType)
                                                          ? transaction
                                                              .creditStatus
                                                          : transaction
                                                              .debitStatus,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color:
                                                            AppColors.darkGrey,
                                                        fontSize:
                                                            12 * textMultiplier,
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
                                                                  .transactionType
                                                                  .toLowerCase() ==
                                                              FilterCashCoin
                                                                  .debitType) {
                                                            if (transaction
                                                                    .redemptionMode
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                FilterCashCoin
                                                                    .tripsType) {
                                                              return FilterCashCoin
                                                                  .redeemedViaTrip;
                                                            }
                                                            if(transaction.redemptionMode
                                                                .toLowerCase() ==
                                                                FilterCashCoin
                                                                    .bonus_adjustment)
                                                              {
                                                                return "Coin Adjusted";
                                                              }
                                                            if (transaction
                                                                    .redemptionMode
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                FilterCashCoin
                                                                    .cashbackType) {
                                                              return FilterCashCoin
                                                                  .redeemedViaCashback;
                                                            }
                                                            if (transaction
                                                                    .redemptionMode
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                FilterCashCoin
                                                                    .giftsType) {
                                                              return FilterCashCoin
                                                                  .redeemedViaGifts;
                                                            }
                                                            return "-";
                                                          } else {
                                                            if (transaction
                                                                    .saleType
                                                                    .toString() ==
                                                                "Luminous Bonus") {
                                                              return transaction
                                                                  .saleType;
                                                            } else {
                                                              String type = "-";
                                                              String mod = "-";
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
                                                              return "Bonus"
                                                                          .toLowerCase() ==
                                                                      mod
                                                                  ? mod
                                                                  : '$type for $mod';
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
                                                          letterSpacing: 0.10,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      transaction
                                                          .transactionType,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color:
                                                            AppColors.darkGrey,
                                                        fontSize:
                                                            12 * textMultiplier,
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
                                                    color: AppColors.lightGrey2,
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
                                  return (coinHistory.coinHistoryList.isEmpty)
                                      ? loadingWidget(
                                          coinHistory.isLoading.value)
                                      : loadingWidget(
                                          coinHistory.hasMore.value);
                                });
                              }
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget loadingWidget(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ((coinHistory.pageNumber.value == 1 ||
                        coinHistory.filterPageNumber.value == 1) &&
                    coinHistory.coinHistoryList.isEmpty)
                ? Text(translation(context).emptyData)
                : Text(translation(context).noDataFound),
      ),
    );
  }
}
