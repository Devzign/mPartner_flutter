import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_string.dart';
import '../../../../data/models/user_profile_model.dart';
import '../../../../state/contoller/ISmartCashHistoryController.dart';
import '../../../../state/contoller/Ismart_coin_history_controller.dart';
import '../../../../state/contoller/cash_summary_controller.dart';
import '../../../../state/contoller/coins_summary_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/calendar_widget/custom_calendar_view.dart';
import '../../../widgets/coin_with_image_widget.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_white_button.dart';
import '../../../widgets/rupee_with_sign_widget.dart';
import '../../base_screen.dart';
import '../../userprofile/user_profile_widget.dart';

class HistoryFilter extends StatefulWidget {
  final String historyType;
  final String? code;
  final String searchKey;

  const HistoryFilter(
      {super.key,
      required this.historyType,
      this.code,
      required this.searchKey});

  @override
  State<HistoryFilter> createState() => _HistoryFilter();
}

class _HistoryFilter extends BaseScreenState<HistoryFilter> {
  ISmartCashHistoryController cashHistory = Get.find();
  ISmartCoinHistoryController coinHistory = Get.find();
  CashSummaryController cashSummaryController = Get.find();
  CoinsSummaryController coinSummaryController = Get.find();

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  String radioValue = '';
  String saleType = '';
  bool saleTypeCheckBox1 = false;
  bool saleTypeCheckBox2 = false;
  bool saleTypeCheckBox3 = false;
  bool redemptionModeTypeCheckBox1 = false;
  bool redemptionModeTypeCheckBox2 = false;
  bool redemptionModeTypeCheckBox3 = false;
  bool redemptionModeTypeCheckBox4 = false;
  bool categoryTypeCheckBox1 = false;
  bool categoryTypeCheckBox2 = false;
  bool categoryTypeCheckBox3 = false;
  bool categoryTypeCheckBox4 = false;
  bool categoryTypeCheckBox5 = false;
  bool categoryTypeCheckBox6 = false;
  bool categoryTypeCheckBox7 = false;
  bool transTypeCheckBoxEarned = false;
  bool transTypeCheckBoxDebit = false;
  bool statusCheckBox1 = false;
  bool statusCheckBox2 = false;
  bool statusCheckBox3 = false;
  bool statusCheckBox4 = false;
  bool statusCheckBox5 = false;
  bool statusCheckBox6 = false;
  DateTime? fromDate;
  DateTime? toDate;
  String transType = '';
  String status = '';
  List<UserProfile> storedUserProfile = [];
  bool isFilterButtonEnabled = false;
  bool? creditTransType = false;
  bool earnedTransType = false;
  bool transTypeCheckBoxBonus = false;
  bool? debitTransType = false;
  bool redeemedTransType = false;

  void calculateDateRange(String selectedDate) {
    DateTime currentDate = DateTime.now();

    switch (selectedDate) {
      case 'Past 1 month':
        fromDate = currentDate.subtract(const Duration(days: 30));
        toDate = currentDate;
        break;
      case 'Past 3 months':
        fromDate = currentDate.subtract(const Duration(days: 90));
        toDate = currentDate;
        break;
      case 'Past 6 months':
        fromDate = currentDate.subtract(const Duration(days: 180));
        toDate = currentDate;
        break;
      case 'Custom':
        break;
      default:
        break;
    }
  }

  void applyFilterOnData(bool isReset) {
    if (widget.searchKey.length >= 3) {
      widget.historyType.toLowerCase() == FilterCashCoin.cashType
          ? cashHistory.searchKey.value = widget.searchKey
          : coinHistory.searchKey.value = widget.searchKey;
    }

    String selectedSaleType = saleTypeCheckBox1 ? FilterCashCoin.secondary : '';
    selectedSaleType += saleTypeCheckBox2
        ? (selectedSaleType.isNotEmpty
            ? ',${FilterCashCoin.tertiary}'
            : FilterCashCoin.tertiary)
        : '';
    selectedSaleType += saleTypeCheckBox3
        ? (selectedSaleType.isNotEmpty
            ? ',${FilterCashCoin.intermediary}'
            : FilterCashCoin.intermediary)
        : '';

    String selectedTransType =
        (transTypeCheckBoxEarned || transTypeCheckBoxBonus)
            ? FilterCashCoin.credit
            : '';
    selectedTransType += transTypeCheckBoxDebit
        ? (selectedTransType.isNotEmpty
            ? ',${FilterCashCoin.debit}'
            : FilterCashCoin.debit)
        : '';

    String selectCreditType =
        transTypeCheckBoxEarned ? FilterCashCoin.earned : '';
    selectCreditType += transTypeCheckBoxBonus
        ? (selectCreditType.isNotEmpty
            ? ',${FilterCashCoin.bonus}'
            : FilterCashCoin.bonus)
        : '';

    //Credit
    String selectCreditTransType =
        statusCheckBox1 ? FilterCashCoin.accepted : '';
    selectCreditTransType += statusCheckBox2
        ? (selectCreditTransType.isNotEmpty
            ? ',${FilterCashCoin.pending}'
            : FilterCashCoin.pending)
        : '';
    selectCreditTransType += statusCheckBox3
        ? (selectCreditTransType.isNotEmpty
            ? ',${FilterCashCoin.rejected}'
            : FilterCashCoin.rejected)
        : '';

    //Debit
    String selectDebitTransType = statusCheckBox4
        ? (widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? FilterCashCoin.successful
            : FilterCashCoin.successful)
        : '';

    selectDebitTransType += statusCheckBox6
        ? (selectDebitTransType.isNotEmpty
            ? ',${FilterCashCoin.pending}'
            : FilterCashCoin.pending)
        : '';

    selectDebitTransType += statusCheckBox5
        ? (selectDebitTransType.isNotEmpty
            ? ',${widget.historyType.toLowerCase() == FilterCashCoin.cashType ? FilterCashCoin.failed : FilterCashCoin.failed}'
            : widget.historyType.toLowerCase() == FilterCashCoin.cashType
                ? FilterCashCoin.failed
                : FilterCashCoin.failed)
        : '';

    String selectedCategory = '';
    selectedCategory += categoryTypeCheckBox1
        ? (selectedCategory.isNotEmpty
            ? ',${FilterCashCoin.solarBatteryType}'
            : FilterCashCoin.solarBatteryType)
        : '';
    selectedCategory += categoryTypeCheckBox2
        ? (selectedCategory.isNotEmpty
            ? ',${FilterCashCoin.battery}'
            : FilterCashCoin.battery)
        : '';
    selectedCategory += categoryTypeCheckBox3
        ? (selectedCategory.isNotEmpty
            ? ',${FilterCashCoin.solarPanelType}'
            : FilterCashCoin.solarPanelType)
        : '';
    selectedCategory += categoryTypeCheckBox4
        ? (selectedCategory.isNotEmpty
            ? ',${FilterCashCoin.hups}'
            : FilterCashCoin.hups)
        : '';
    selectedCategory += categoryTypeCheckBox5
        ? (selectedCategory.isNotEmpty
            ? ',${FilterCashCoin.hkva}'
            : FilterCashCoin.hkva)
        : '';
    selectedCategory += categoryTypeCheckBox6
        ? (selectedCategory.isNotEmpty
            ? ',${FilterCashCoin.gti}'
            : FilterCashCoin.gti)
        : '';
    selectedCategory += categoryTypeCheckBox7
        ? (selectedCategory.isNotEmpty
            ? ',${FilterCashCoin.solarInvertersType}'
            : FilterCashCoin.solarInvertersType)
        : '';

    String redemptionMode = redemptionModeTypeCheckBox1
        ? (widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? FilterCashCoin.paytmType
            : FilterCashCoin.cashbackType)
        : '';
    redemptionMode += redemptionModeTypeCheckBox2
        ? (widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? (redemptionMode.isNotEmpty
                ? ',${FilterCashCoin.pinelabType}'
                : FilterCashCoin.pinelabType)
            : (redemptionMode.isNotEmpty
                ? ',${FilterCashCoin.tripsType}'
                : FilterCashCoin.tripsType))
        : '';
    redemptionMode += redemptionModeTypeCheckBox3
        ? (widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? (redemptionMode.isNotEmpty
                ? ',${FilterCashCoin.upiType}'
                : FilterCashCoin.upiType)
            : (redemptionMode.isNotEmpty
                ? ',${FilterCashCoin.giftsType}'
                : FilterCashCoin.giftsType))
        : '';
    redemptionMode += redemptionModeTypeCheckBox4
        ? (redemptionMode.isNotEmpty
            ? ',${FilterCashCoin.creditNoteType}'
            : FilterCashCoin.creditNoteType)
        : '';

    if (selectedTransType.isEmpty) {
      selectDebitTransType = "";
      selectCreditTransType = "";
      redemptionMode = "";
      selectedCategory = "";
      selectedSaleType = "";
    }
    if (selectedTransType == FilterCashCoin.credit) {
      selectDebitTransType = "";
      redemptionMode = "";
    }
    if (selectedTransType == FilterCashCoin.debit) {
      selectCreditTransType = "";
      selectedCategory = "";
      selectedSaleType = "";
    }

    String fromDateVal = '';
    String toDateVal = '';
    if (radioValue == 'Custom' && fromDate != null && toDate != null) {
      fromDateVal = DateFormat('dd/MM/yyyy').format(fromDate!);
      toDateVal = DateFormat('dd/MM/yyyy').format(toDate!);
    } else {
      calculateDateRange(radioValue);
      if (radioValue == 'Past 1 month' && fromDate != null && toDate != null) {
        fromDateVal = DateFormat('dd/MM/yyyy').format(fromDate!);
        toDateVal = DateFormat('dd/MM/yyyy').format(toDate!);
      }
      if (radioValue == 'Past 3 months' && fromDate != null && toDate != null) {
        fromDateVal = DateFormat('dd/MM/yyyy').format(fromDate!);
        toDateVal = DateFormat('dd/MM/yyyy').format(toDate!);
      }
      if (radioValue == 'Past 6 months' && fromDate != null && toDate != null) {
        fromDateVal = DateFormat('dd/MM/yyyy').format(fromDate!);
        toDateVal = DateFormat('dd/MM/yyyy').format(toDate!);
        print(fromDateVal);
        print(toDateVal);
      }
    }

    widget.historyType == 'Cash'
        ? cashHistory.clearIsmartCashHistoryFilterData()
        : coinHistory.clearIsmartCoinHistoryFilterData();

    widget.historyType == 'Cash'
        ? (radioValue.isNotEmpty
            ? cashHistory.isDateSelected.value = true
            : cashHistory.isDateSelected.value = false)
        : (radioValue.isNotEmpty
            ? coinHistory.isDateSelected.value = true
            : coinHistory.isDateSelected.value = false);

    print(
        'Sale Type: $selectedSaleType\nTransaction Type: $selectedTransType\selectCreditTransType: $selectCreditTransType\selectDebitTransType: $selectDebitTransType\nFromDate: $fromDateVal\ntomDate: $toDateVal\nCategory: $selectedCategory\nRedemptionMode: $redemptionMode');

    if (!isReset) {
      widget.historyType == 'Cash'
          ? cashHistory.isFilterApplied.value = true
          : coinHistory.isFilterApplied.value = true;
    }

    widget.historyType == 'Cash'
        ? cashSummaryController.fetchCashSummary(
            fromDate: fromDateVal, toDate: toDateVal, code: widget.code)
        : coinSummaryController.fetchCoinsSummary(
            fromDate: fromDateVal, toDate: toDateVal, code: widget.code);

    if (isReset) {
      widget.historyType == 'Cash'
          ? cashHistory.isFilterApplied.value = false
          : coinHistory.isFilterApplied.value = false;

      widget.historyType == 'Cash'
          ? cashHistory.filterFlag = false.obs
          : coinHistory.filterFlag = false.obs;
      widget.historyType == 'Cash'
          ? cashHistory.fetchCashHistory(code: widget.code)
          : coinHistory.fetchCoinHistory(code: widget.code);
      widget.historyType == 'Cash'
          ? cashHistory.isEarnEnable = false.obs
          : coinHistory.isEarnEnable = false.obs;
      widget.historyType == 'Cash'
          ? cashHistory.isRedeemEnable = false.obs
          : coinHistory.isRedeemEnable = false.obs;
    } else {
      widget.historyType == 'Cash'
          ? cashHistory.fetchFilteredData(
              selectedSaleType,
              selectedTransType,
              selectCreditTransType,
              selectDebitTransType,
              fromDateVal,
              toDateVal,
              selectedCategory,
              redemptionMode,
              code: widget.code)
          : coinHistory.fetchFilteredData(
              selectedSaleType,
              selectedTransType,
              selectCreditType,
              selectCreditTransType,
              selectDebitTransType,
              fromDateVal,
              toDateVal,
              selectedCategory,
              redemptionMode,
              code: widget.code);
    }

    widget.historyType.toLowerCase() == FilterCashCoin.cashType
        ? cashHistory.selectedValues = {
            'selectedSaleType': selectedSaleType,
            'selectedTransType': selectedTransType,
            'selectCreditTransType': selectCreditTransType,
            'selectDebitTransType': selectDebitTransType,
            'fromDateVal': fromDateVal,
            'toDateVal': toDateVal,
            'selectedDateRange': radioValue,
            'selectedCategory': selectedCategory,
            'redemptionMode': redemptionMode,
          }.obs
        : coinHistory.selectedValues = {
            'selectedSaleType': selectedSaleType,
            'selectedTransType': selectedTransType,
            'selectCreditTransType': selectCreditTransType,
            'CreditType': selectCreditType,
            'selectDebitTransType': selectDebitTransType,
            'fromDateVal': fromDateVal,
            'toDateVal': toDateVal,
            'selectedDateRange': radioValue,
            'selectedCategory': selectedCategory,
            'redemptionMode': redemptionMode,
          }.obs;

    widget.historyType.toLowerCase() == FilterCashCoin.cashType
        ? cashHistory.setFromDate(fromDate!)
        : coinHistory.setFromDate(fromDate!);
    widget.historyType.toLowerCase() == FilterCashCoin.cashType
        ? cashHistory.setToDate(toDate!)
        : coinHistory.setToDate(toDate!);

    if (coinHistory.selectedValues['selectedTransType'] == "Credit" ||
        cashHistory.selectedValues['selectedTransType'] == "Credit") {
      widget.historyType.toLowerCase() == FilterCashCoin.cashType
          ? cashHistory.isEarnEnable = true.obs
          : coinHistory.isEarnEnable = true.obs;
      widget.historyType.toLowerCase() == FilterCashCoin.cashType
          ? cashHistory.isRedeemEnable = false.obs
          : coinHistory.isRedeemEnable = false.obs;
    } else if (coinHistory.selectedValues['selectedTransType'] == "Debit" ||
        cashHistory.selectedValues['selectedTransType'] == "Debit") {
      widget.historyType.toLowerCase() == FilterCashCoin.cashType
          ? cashHistory.isEarnEnable = false.obs
          : coinHistory.isEarnEnable = false.obs;
      widget.historyType.toLowerCase() == FilterCashCoin.cashType
          ? cashHistory.isRedeemEnable = true.obs
          : coinHistory.isRedeemEnable = true.obs;
    } else {
      widget.historyType.toLowerCase() == FilterCashCoin.cashType
          ? cashHistory.isEarnEnable = false.obs
          : coinHistory.isEarnEnable = false.obs;
      widget.historyType.toLowerCase() == FilterCashCoin.cashType
          ? cashHistory.isRedeemEnable = false.obs
          : coinHistory.isRedeemEnable = false.obs;
    }

    if (((coinHistory.selectedValues['selectedTransType']
                    .toString()
                    .toLowerCase() ==
                FilterCashCoin.debitCreditType) ||
            (coinHistory.selectedValues['selectedTransType']
                    .toString()
                    .toLowerCase() ==
                FilterCashCoin.creditDebitType)) ||
        ((cashHistory.selectedValues['selectedTransType']
                    .toString()
                    .toLowerCase() ==
                FilterCashCoin.debitCreditType) ||
            (cashHistory.selectedValues['selectedTransType']
                    .toString()
                    .toLowerCase() ==
                FilterCashCoin.creditDebitType))) {
      widget.historyType.toLowerCase() == FilterCashCoin.cashType
          ? cashHistory.isEarnEnable = false.obs
          : coinHistory.isEarnEnable = false.obs;
      widget.historyType.toLowerCase() == FilterCashCoin.cashType
          ? cashHistory.isRedeemEnable = false.obs
          : coinHistory.isRedeemEnable = false.obs;
    }

    Navigator.pop(context);
  }

  void resetFilters() {
    widget.historyType.toLowerCase() == FilterCashCoin.cashType
        ? cashHistory.selectedValues = {
            'selectedSaleType': '',
            'selectedTransType': '',
            'selectCreditTransType': '',
            'selectDebitTransType': '',
            'fromDateVal': '',
            'toDateVal': '',
            'selectedDateRange': '',
            'selectedCategory': '',
            'redemptionMode': '',
          }.obs
        : coinHistory.selectedValues = {
            'selectedSaleType': '',
            'selectedTransType': '',
            'CreditType': '',
            'selectCreditTransType': '',
            'selectDebitTransType': '',
            'fromDateVal': '',
            'toDateVal': '',
            'selectedDateRange': '',
            'selectedCategory': '',
            'redemptionMode': '',
          }.obs;
    cashHistory.isDateSelected.value = false;
    coinHistory.isDateSelected.value = false;
    widget.historyType.toLowerCase() == FilterCashCoin.cashType
        ? cashHistory.searchKey = "".obs
        : coinHistory.searchKey = "".obs;

    setState(() {
      saleTypeCheckBox1 = false;
      saleTypeCheckBox2 = false;
      saleTypeCheckBox3 = false;
      redemptionModeTypeCheckBox1 = false;
      redemptionModeTypeCheckBox2 = false;
      redemptionModeTypeCheckBox3 = false;
      redemptionModeTypeCheckBox4 = false;
      categoryTypeCheckBox1 = false;
      categoryTypeCheckBox2 = false;
      categoryTypeCheckBox3 = false;
      categoryTypeCheckBox4 = false;
      categoryTypeCheckBox5 = false;
      categoryTypeCheckBox6 = false;
      categoryTypeCheckBox7 = false;
      transTypeCheckBoxEarned = false;
      transTypeCheckBoxDebit = false;
      transTypeCheckBoxBonus = false;
      statusCheckBox1 = false;
      statusCheckBox2 = false;
      statusCheckBox3 = false;
      statusCheckBox4 = false;
      statusCheckBox5 = false;
      statusCheckBox6 = false;
      radioValue = '';
      fromDate = DateTime.now();
      toDate = DateTime.now();

      isFilterButtonEnabled = false;
    });

    applyFilterOnData(true);
  }

  void maintainSelection() {
    transTypeCheckBoxEarned =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectedTransType']!
                .contains(FilterCashCoin.credit)
            : coinHistory.selectedValues['CreditType']!
                .contains(FilterCashCoin.earned);
    transTypeCheckBoxBonus = coinHistory.selectedValues['CreditType']!
        .contains(FilterCashCoin.bonus);
    creditTransType = (transTypeCheckBoxEarned && transTypeCheckBoxBonus)
        ? true
        : ((transTypeCheckBoxEarned || transTypeCheckBoxBonus)
            ? (coinSummaryController.bonusCoins == "0" ? true : null)
            : false);
    transTypeCheckBoxDebit =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectedTransType']!
                .contains(FilterCashCoin.debit)
            : coinHistory.selectedValues['selectedTransType']!
                .contains(FilterCashCoin.debit);

    saleTypeCheckBox1 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectedSaleType']!
                .contains(FilterCashCoin.secondary)
            : coinHistory.selectedValues['selectedSaleType']!
                .contains(FilterCashCoin.secondary);
    saleTypeCheckBox2 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectedSaleType']!
                .contains(FilterCashCoin.tertiary)
            : coinHistory.selectedValues['selectedSaleType']!
                .contains(FilterCashCoin.tertiary);
    saleTypeCheckBox3 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectedSaleType']!
                .contains(FilterCashCoin.intermediary)
            : coinHistory.selectedValues['selectedSaleType']!
                .contains(FilterCashCoin.intermediary);
    statusCheckBox1 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectCreditTransType']!
                .contains(FilterCashCoin.accepted)
            : coinHistory.selectedValues['selectCreditTransType']!
                .contains(FilterCashCoin.accepted);
    statusCheckBox2 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectCreditTransType']!
                .contains(FilterCashCoin.pending)
            : coinHistory.selectedValues['selectCreditTransType']!
                .contains(FilterCashCoin.pending);
    statusCheckBox3 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectCreditTransType']!
                .contains(FilterCashCoin.rejected)
            : coinHistory.selectedValues['selectCreditTransType']!
                .contains(FilterCashCoin.rejected);
    statusCheckBox4 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectDebitTransType']!
                .contains(FilterCashCoin.successful)
            : coinHistory.selectedValues['selectDebitTransType']!
                .contains(FilterCashCoin.successful);
    statusCheckBox5 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectDebitTransType']!
                .contains(FilterCashCoin.failed)
            : coinHistory.selectedValues['selectDebitTransType']!
                .contains(FilterCashCoin.failed);
    statusCheckBox6 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectDebitTransType']!
                .contains(FilterCashCoin.pending)
            : coinHistory.selectedValues['selectDebitTransType']!
                .contains(FilterCashCoin.pending);
    categoryTypeCheckBox1 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectedCategory']!
                .contains(FilterCashCoin.solarBatteryType)
            : coinHistory.selectedValues['selectedCategory']!
                .contains(FilterCashCoin.solarBatteryType);
    categoryTypeCheckBox2 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? (cashHistory.selectedValues['selectedCategory']!
                        .contains(FilterCashCoin.battery) &&
                    !cashHistory.selectedValues['selectedCategory']!
                        .contains(FilterCashCoin.solarBatteryType)) ||
                ((cashHistory.selectedValues['selectedCategory']!
                    .contains(FilterCashCoin.batteryComma)))
            : (coinHistory.selectedValues['selectedCategory']!
                        .contains(FilterCashCoin.battery) &&
                    !coinHistory.selectedValues['selectedCategory']!
                        .contains(FilterCashCoin.solarBatteryType)) ||
                ((coinHistory.selectedValues['selectedCategory']!
                    .contains(FilterCashCoin.batteryComma)));
    categoryTypeCheckBox3 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectedCategory']!
                .contains(FilterCashCoin.solarPanelType)
            : coinHistory.selectedValues['selectedCategory']!
                .contains(FilterCashCoin.solarPanelType);
    categoryTypeCheckBox4 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectedCategory']!
                .contains(FilterCashCoin.hups)
            : coinHistory.selectedValues['selectedCategory']!
                .contains(FilterCashCoin.hups);
    categoryTypeCheckBox5 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectedCategory']!
                .contains(FilterCashCoin.hkva)
            : coinHistory.selectedValues['selectedCategory']!
                .contains(FilterCashCoin.hkva);
    categoryTypeCheckBox6 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectedCategory']!
                .contains(FilterCashCoin.gti)
            : coinHistory.selectedValues['selectedCategory']!
                .contains(FilterCashCoin.gti);
    categoryTypeCheckBox7 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['selectedCategory']!
                .contains(FilterCashCoin.solarInvertersType)
            : coinHistory.selectedValues['selectedCategory']!
                .contains(FilterCashCoin.solarInvertersType);

    redemptionModeTypeCheckBox1 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['redemptionMode']!
                .contains(FilterCashCoin.paytmType)
            : coinHistory.selectedValues['redemptionMode']!
                .contains(FilterCashCoin.cashbackType);
    redemptionModeTypeCheckBox2 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['redemptionMode']!
                .contains(FilterCashCoin.pinelabType)
            : coinHistory.selectedValues['redemptionMode']!
                .contains(FilterCashCoin.tripsType);
    redemptionModeTypeCheckBox3 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['redemptionMode']!
                .contains(FilterCashCoin.upiType)
            : coinHistory.selectedValues['redemptionMode']!
                .contains(FilterCashCoin.giftsType);
    redemptionModeTypeCheckBox4 =
        widget.historyType.toLowerCase() == FilterCashCoin.cashType
            ? cashHistory.selectedValues['redemptionMode']!
                .contains(FilterCashCoin.creditNoteType)
            : coinHistory.selectedValues['redemptionMode']!
                .contains(FilterCashCoin.creditNoteType);

    radioValue = (widget.historyType.toLowerCase() == FilterCashCoin.cashType
        ? cashHistory.selectedValues['selectedDateRange']
        : coinHistory.selectedValues['selectedDateRange'])!;

    fromDate = widget.historyType.toLowerCase() == FilterCashCoin.cashType
        ? cashHistory.fromDate.value
        : coinHistory.fromDate.value;

    toDate = widget.historyType.toLowerCase() == FilterCashCoin.cashType
        ? cashHistory.toDate.value
        : coinHistory.toDate.value;

    if (transTypeCheckBoxEarned ||
        transTypeCheckBoxDebit ||
        transTypeCheckBoxBonus) {
      isFilterButtonEnabled = true;
    }

    if (fromDate != null) {
      startDateController.text = DateFormat("dd/MM/yyyy").format(fromDate!);
    } else {
      startDateController.text = "";
    }
    if (toDate != null) {
      endDateController.text = DateFormat("dd/MM/yyyy").format(toDate!);
    } else {
      endDateController.text = "";
    }
  }

  @override
  void initState() {
    loadData();
    maintainSelection();
    super.initState();
  }

  Future<void> loadData() async {
    UserDataController controller = Get.find();
    storedUserProfile = controller.userProfile;
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    CoinsSummaryController coinsSummaryController = Get.find();
    CashSummaryController cashSummaryController = Get.find();

    if (transTypeCheckBoxEarned &&
        (!(transTypeCheckBoxEarned && transTypeCheckBoxDebit))) {
      statusCheckBox4 = false;
      statusCheckBox5 = false;
      statusCheckBox6 = false;
      redemptionModeTypeCheckBox1 = false;
      redemptionModeTypeCheckBox2 = false;
      redemptionModeTypeCheckBox3 = false;
      redemptionModeTypeCheckBox4 = false;
    }
    if (transTypeCheckBoxDebit &&
        (!(transTypeCheckBoxEarned && transTypeCheckBoxDebit))) {
      statusCheckBox1 = false;
      statusCheckBox3 = false;
      saleTypeCheckBox1 = false;
      saleTypeCheckBox2 = false;
      saleTypeCheckBox3 = false;
      categoryTypeCheckBox1 = false;
      categoryTypeCheckBox2 = false;
      categoryTypeCheckBox3 = false;
      categoryTypeCheckBox4 = false;
      categoryTypeCheckBox5 = false;
      categoryTypeCheckBox6 = false;
      categoryTypeCheckBox7 = false;
    }
    if (radioValue.isNotEmpty) {
      isFilterButtonEnabled = true;
    }

    return Scaffold(
      backgroundColor: AppColors.lightWhite1,
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(14 * variablePixelWidth,
                        24 * variablePixelHeight, 20 * variablePixelWidth, 0),
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
                              translation(context).filter,
                              style: GoogleFonts.poppins(
                                color: AppColors.iconColor,
                                fontSize: AppConstants.FONT_SIZE_LARGE *
                                    textFontMultiplier,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        widget.historyType == 'Cash'
                            ? Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lumiLight4,
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
                                      GetBuilder<CashSummaryController>(
                                        builder: (_) {
                                          return RupeeWithSignWidget(
                                              cash: double.tryParse(
                                                      cashSummaryController
                                                          .availableCash) ??
                                                  0,
                                              color: AppColors.lumiBluePrimary,
                                              size: 12,
                                              weight: FontWeight.w500,
                                              width: 120);
                                        },
                                      ),
                                      Text(
                                        " ${translation(context).available}",
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
                                              coin: double.tryParse(
                                                      coinsSummaryController
                                                          .availableCoins
                                                          .replaceAll(
                                                              ",", "")) ??
                                                  0,
                                              color: AppColors.pendingYellow,
                                              size: 12,
                                              weight: FontWeight.w600,
                                              width: 120);
                                        },
                                      ),
                                      Text(
                                        " ${translation(context).available}",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: AppColors.pendingYellow,
                                          fontSize: 12 * variablePixelWidth,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    )),
                UserProfileWidget(),
              ],
            ),
            Expanded(
                child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Theme(
                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.centerLeft,
                    initiallyExpanded: true,
                    title: Padding(
                      padding: EdgeInsets.fromLTRB(14 * variablePixelWidth, 0,
                          14 * variablePixelWidth, 0),
                      child: Text(
                        translation(context).date,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkText2,
                          fontSize: 16 * variablePixelWidth,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                14 * variablePixelWidth,
                                0,
                                14 * variablePixelWidth,
                                0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  radioValue = 'Past 1 month'.toString();
                                });
                              },
                              child: SizedBox(
                                width: variablePixelWidth * 245,
                                height: variablePixelHeight * 40,
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 'Past 1 month',
                                      groupValue: radioValue,
                                      activeColor: AppColors.lumiBluePrimary,
                                      onChanged: (value) {
                                        setState(() {
                                          radioValue = value.toString();
                                        });
                                      },
                                    ),
                                    Text(
                                      'Past 1 month',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.darkGrey,
                                        fontSize: 16 * variablePixelWidth,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                14 * variablePixelWidth,
                                0,
                                14 * variablePixelWidth,
                                0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  radioValue = 'Past 3 months'.toString();
                                });
                              },
                              child: Container(
                                width: variablePixelWidth * 245,
                                height: variablePixelHeight * 40,
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 'Past 3 months',
                                      groupValue: radioValue,
                                      activeColor: AppColors.lumiBluePrimary,
                                      onChanged: (value) {
                                        setState(() {
                                          radioValue = value.toString();
                                        });
                                      },
                                    ),
                                    Text(
                                      'Past 3 months',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.darkGrey,
                                        fontSize: 16 * variablePixelWidth,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                14 * variablePixelWidth,
                                0,
                                14 * variablePixelWidth,
                                0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  radioValue = 'Past 6 months'.toString();
                                });
                              },
                              child: Container(
                                width: variablePixelWidth * 245,
                                height: variablePixelHeight * 40,
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 'Past 6 months',
                                      groupValue: radioValue,
                                      activeColor: AppColors.lumiBluePrimary,
                                      onChanged: (value) {
                                        setState(() {
                                          radioValue = value.toString();
                                        });
                                      },
                                    ),
                                    Text(
                                      'Past 6 months',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.darkGrey,
                                        fontSize: 16 * variablePixelWidth,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                14 * variablePixelWidth,
                                0,
                                14 * variablePixelWidth,
                                0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  radioValue = 'Custom'.toString();
                                });
                              },
                              child: Container(
                                width: variablePixelWidth * 245,
                                height: variablePixelHeight * 40,
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 'Custom',
                                      groupValue: radioValue,
                                      activeColor: AppColors.lumiBluePrimary,
                                      onChanged: (value) {
                                        setState(() {
                                          startDateController.text = "";
                                          endDateController.text = "";
                                          radioValue = value.toString();
                                        });
                                      },
                                    ),
                                    Text(
                                      'Custom',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.darkGrey,
                                        fontSize: 16 * variablePixelWidth,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: variablePixelHeight * 10,
                ),
                radioValue == 'Custom'
                    ? Container(
                        margin: EdgeInsets.fromLTRB(30 * variablePixelWidth, 0,
                            30 * variablePixelWidth, 15 * variablePixelHeight),
                        child: CustomCalendarView(
                          labelText: translation(context).dob,
                          hintText: translation(context).selectDateFormat,
                          icon: Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.grey,
                          ),
                          calendarType: AppConstants.rangeSelectionCalenderType,
                          dateFormat: "dd/MM/yyyy",
                          errorText: "",
                          calendarStartDate: DateTime(1950, 1, 1),
                          calendarEndDate: DateTime.now(),
                          startDateEditController: startDateController,
                          endDateEditController: endDateController,
                          onDateSelected: (selectedDate) {
                            print("view1 ${selectedDate}");
                          },
                          onDateRangeSelected: (startDate, endDate) {
                            print("view2 ${startDate}- ${endDate}");
                            var inputFormat = DateFormat('dd/MM/yyyy');
                            var startDateObject = inputFormat
                                .parse(startDate); // <-- dd/MM 24H format
                            var endDateObject = inputFormat
                                .parse(endDate); // <-- dd/MM 24H format

                            setState(() {
                              fromDate = startDateObject;
                              cashHistory.fromDate.value = startDateObject;
                              toDate = endDateObject;
                              cashHistory.toDate.value = endDateObject;
                            });
                          },
                        ))
                    : Container(),
                SizedBox(
                  height: variablePixelHeight * 10,
                ),
                Theme(
                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.centerLeft,
                    initiallyExpanded: true,
                    title: Padding(
                      padding: EdgeInsets.fromLTRB(14 * variablePixelWidth, 0,
                          14 * variablePixelWidth, 0),
                      child: Text(
                        translation(context).transactionType,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkText2,
                          fontSize: 16 * variablePixelWidth,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                    children: [
                      widget.historyType.toLowerCase() ==
                              FilterCashCoin.cashType
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      14 * variablePixelWidth,
                                      0,
                                      14 * variablePixelWidth,
                                      0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            transTypeCheckBoxEarned =
                                                !transTypeCheckBoxEarned;
                                            if (transTypeCheckBoxEarned) {
                                              isFilterButtonEnabled = true;
                                            } else {
                                              if (transTypeCheckBoxDebit) {
                                                isFilterButtonEnabled = true;
                                              } else {
                                                isFilterButtonEnabled = false;
                                              }
                                            }
                                          });
                                        },
                                        child: Container(
                                          height: variablePixelHeight * 40,
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                value: transTypeCheckBoxEarned,
                                                activeColor:
                                                    AppColors.lumiBluePrimary,
                                                onChanged: (value) {
                                                  setState(() {
                                                    transTypeCheckBoxEarned =
                                                        value ?? false;
                                                    if (transTypeCheckBoxEarned) {
                                                      isFilterButtonEnabled =
                                                          true;
                                                    } else {
                                                      if (transTypeCheckBoxDebit) {
                                                        isFilterButtonEnabled =
                                                            true;
                                                      } else {
                                                        isFilterButtonEnabled =
                                                            false;
                                                      }
                                                      statusCheckBox1 = false;
                                                      statusCheckBox2 = false;
                                                      statusCheckBox3 = false;
                                                      saleTypeCheckBox1 = false;
                                                      saleTypeCheckBox2 = false;
                                                      saleTypeCheckBox3 = false;
                                                      categoryTypeCheckBox1 =
                                                          false;
                                                      categoryTypeCheckBox2 =
                                                          false;
                                                      categoryTypeCheckBox3 =
                                                          false;
                                                      categoryTypeCheckBox4 =
                                                          false;
                                                      categoryTypeCheckBox5 =
                                                          false;
                                                      categoryTypeCheckBox6 =
                                                          false;
                                                      categoryTypeCheckBox7 =
                                                          false;
                                                    }
                                                  });
                                                },
                                              ),
                                              Text(
                                                'Credit (Earned)',
                                                style: GoogleFonts.poppins(
                                                  color: AppColors.darkGrey,
                                                  fontSize:
                                                      16 * variablePixelWidth,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.50,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            transTypeCheckBoxDebit =
                                                !transTypeCheckBoxDebit;
                                            if (transTypeCheckBoxDebit) {
                                              isFilterButtonEnabled = true;
                                            } else {
                                              if (transTypeCheckBoxEarned) {
                                                isFilterButtonEnabled = true;
                                              } else {
                                                isFilterButtonEnabled = false;
                                              }
                                            }
                                          });
                                        },
                                        child: Container(
                                          height: variablePixelHeight * 40,
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                activeColor:
                                                    AppColors.lumiBluePrimary,
                                                value: transTypeCheckBoxDebit,
                                                onChanged: (value) {
                                                  setState(() {
                                                    transTypeCheckBoxDebit =
                                                        value ?? false;
                                                    if (transTypeCheckBoxDebit) {
                                                      isFilterButtonEnabled =
                                                          true;
                                                    } else {
                                                      if (transTypeCheckBoxEarned) {
                                                        isFilterButtonEnabled =
                                                            true;
                                                      } else {
                                                        isFilterButtonEnabled =
                                                            false;
                                                      }
                                                      statusCheckBox4 = false;
                                                      statusCheckBox5 = false;
                                                      statusCheckBox6 = false;
                                                      redemptionModeTypeCheckBox1 =
                                                          false;
                                                      redemptionModeTypeCheckBox2 =
                                                          false;
                                                      redemptionModeTypeCheckBox3 =
                                                          false;
                                                    }
                                                  });
                                                },
                                              ),
                                              Text(
                                                'Debit (Redeemed)',
                                                style: GoogleFonts.poppins(
                                                  color: AppColors.darkGrey,
                                                  fontSize:
                                                      16 * variablePixelWidth,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.50,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      14 * variablePixelWidth,
                                      0,
                                      14 * variablePixelWidth,
                                      0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: creditTransType,
                                                    tristate:
                                                        coinSummaryController
                                                                    .bonusCoins ==
                                                                "0"
                                                            ? false
                                                            : true,
                                                    activeColor: AppColors
                                                        .lumiBluePrimary,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        creditTransType = value;
                                                        if (creditTransType ==
                                                            true) {
                                                          transTypeCheckBoxEarned =
                                                              true;
                                                          if (coinSummaryController
                                                                  .bonusCoins ==
                                                              "0") {
                                                            transTypeCheckBoxBonus =
                                                                false;
                                                          } else {
                                                            transTypeCheckBoxBonus =
                                                                true;
                                                          }
                                                          isFilterButtonEnabled =
                                                              true;
                                                        } else {
                                                          if (transTypeCheckBoxDebit) {
                                                            isFilterButtonEnabled =
                                                                true;
                                                          } else {
                                                            isFilterButtonEnabled =
                                                                false;
                                                          }
                                                          transTypeCheckBoxEarned =
                                                              false;
                                                          transTypeCheckBoxBonus =
                                                              false;
                                                          statusCheckBox1 =
                                                              false;
                                                          statusCheckBox2 =
                                                              false;
                                                          statusCheckBox3 =
                                                              false;
                                                          saleTypeCheckBox1 =
                                                              false;
                                                          saleTypeCheckBox2 =
                                                              false;
                                                          saleTypeCheckBox3 =
                                                              false;
                                                          categoryTypeCheckBox1 =
                                                              false;
                                                          categoryTypeCheckBox2 =
                                                              false;
                                                          categoryTypeCheckBox3 =
                                                              false;
                                                          categoryTypeCheckBox4 =
                                                              false;
                                                          categoryTypeCheckBox5 =
                                                              false;
                                                          categoryTypeCheckBox6 =
                                                              false;
                                                          categoryTypeCheckBox7 =
                                                              false;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    'Credit',
                                                    style: GoogleFonts.poppins(
                                                      color: AppColors.darkGrey,
                                                      fontSize: 16 *
                                                          variablePixelWidth,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 0.50,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 24 *
                                                        variablePixelWidth),
                                                child: GetBuilder<
                                                        CoinsSummaryController>(
                                                    builder: (_) {
                                                  return Visibility(
                                                    // Visibility widget for Earned and Bonus coins
                                                    visible: true,
                                                    // Show only when Credit is selected
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                            width: 10 *
                                                                variablePixelWidth),
                                                        // Add some spacing
                                                        Row(
                                                          children: [
                                                            Checkbox(
                                                              // Checkbox for Earned coins
                                                              value:
                                                                  transTypeCheckBoxEarned,
                                                              activeColor: AppColors
                                                                  .lumiBluePrimary,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  transTypeCheckBoxEarned =
                                                                      value ??
                                                                          false;
                                                                  if (transTypeCheckBoxEarned ==
                                                                          true &&
                                                                      (coinSummaryController.bonusCoins ==
                                                                              "0" ||
                                                                          transTypeCheckBoxBonus ==
                                                                              true)) {
                                                                    creditTransType =
                                                                        true;
                                                                    isFilterButtonEnabled =
                                                                        true;
                                                                  } else {
                                                                    if (transTypeCheckBoxEarned ==
                                                                            false &&
                                                                        transTypeCheckBoxBonus ==
                                                                            false) {
                                                                      creditTransType =
                                                                          false;
                                                                      if (transTypeCheckBoxDebit) {
                                                                        isFilterButtonEnabled =
                                                                            true;
                                                                      } else {
                                                                        isFilterButtonEnabled =
                                                                            false;
                                                                      }
                                                                    } else if (coinSummaryController.bonusCoins ==
                                                                            "0" &&
                                                                        transTypeCheckBoxEarned ==
                                                                            false) {
                                                                      creditTransType =
                                                                          false;
                                                                      if (transTypeCheckBoxDebit) {
                                                                        isFilterButtonEnabled =
                                                                            true;
                                                                      } else if (transTypeCheckBoxBonus) {
                                                                        isFilterButtonEnabled =
                                                                            true;
                                                                      } else {
                                                                        isFilterButtonEnabled =
                                                                            false;
                                                                      }
                                                                    } else {
                                                                      creditTransType =
                                                                          null;
                                                                      if (transTypeCheckBoxEarned) {
                                                                        isFilterButtonEnabled =
                                                                            true;
                                                                      } else if (transTypeCheckBoxDebit) {
                                                                        isFilterButtonEnabled =
                                                                            true;
                                                                      } else if (transTypeCheckBoxBonus) {
                                                                        isFilterButtonEnabled =
                                                                            true;
                                                                      } else {
                                                                        isFilterButtonEnabled =
                                                                            false;
                                                                      }
                                                                    }
                                                                    statusCheckBox1 =
                                                                        false;
                                                                    statusCheckBox2 =
                                                                        false;
                                                                    statusCheckBox3 =
                                                                        false;
                                                                    saleTypeCheckBox1 =
                                                                        false;
                                                                    saleTypeCheckBox2 =
                                                                        false;
                                                                    saleTypeCheckBox3 =
                                                                        false;
                                                                    categoryTypeCheckBox1 =
                                                                        false;
                                                                    categoryTypeCheckBox2 =
                                                                        false;
                                                                    categoryTypeCheckBox3 =
                                                                        false;
                                                                    categoryTypeCheckBox4 =
                                                                        false;
                                                                    categoryTypeCheckBox5 =
                                                                        false;
                                                                    categoryTypeCheckBox6 =
                                                                        false;
                                                                    categoryTypeCheckBox7 =
                                                                        false;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                            Text(
                                                              'Earned coins',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                // Style for Earned text
                                                                color: AppColors
                                                                    .darkGrey,
                                                                fontSize: 14 *
                                                                    variablePixelWidth,
                                                                // Adjust font size for subsection
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                letterSpacing:
                                                                    0.50,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            width: 10 *
                                                                variablePixelWidth),
                                                        // Add some spacing
                                                        coinSummaryController
                                                                    .bonusCoins ==
                                                                "0"
                                                            ? const SizedBox()
                                                            : Row(
                                                                children: [
                                                                  Checkbox(
                                                                      // Checkbox for Bonus coins
                                                                      value:
                                                                          transTypeCheckBoxBonus,
                                                                      activeColor:
                                                                          AppColors
                                                                              .lumiBluePrimary,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          transTypeCheckBoxBonus =
                                                                              value ?? false;
                                                                          if (transTypeCheckBoxEarned == true &&
                                                                              transTypeCheckBoxBonus == true) {
                                                                            creditTransType =
                                                                                true;
                                                                            isFilterButtonEnabled =
                                                                                true;
                                                                          } else {
                                                                            if (transTypeCheckBoxEarned == false &&
                                                                                transTypeCheckBoxBonus == false) {
                                                                              creditTransType = false;
                                                                              if (transTypeCheckBoxDebit) {
                                                                                isFilterButtonEnabled = true;
                                                                              } else if (transTypeCheckBoxBonus) {
                                                                                isFilterButtonEnabled = true;
                                                                              } else {
                                                                                isFilterButtonEnabled = false;
                                                                              }
                                                                            } else {
                                                                              creditTransType = null;
                                                                              if (transTypeCheckBoxEarned) {
                                                                                isFilterButtonEnabled = true;
                                                                              } else if (transTypeCheckBoxDebit) {
                                                                                isFilterButtonEnabled = true;
                                                                              } else if (transTypeCheckBoxBonus) {
                                                                                isFilterButtonEnabled = true;
                                                                              } else {
                                                                                isFilterButtonEnabled = false;
                                                                              }
                                                                            }
                                                                            statusCheckBox1 =
                                                                                false;
                                                                            statusCheckBox2 =
                                                                                false;
                                                                            statusCheckBox3 =
                                                                                false;
                                                                            saleTypeCheckBox1 =
                                                                                false;
                                                                            saleTypeCheckBox2 =
                                                                                false;
                                                                            saleTypeCheckBox3 =
                                                                                false;
                                                                            categoryTypeCheckBox1 =
                                                                                false;
                                                                            categoryTypeCheckBox2 =
                                                                                false;
                                                                            categoryTypeCheckBox3 =
                                                                                false;
                                                                            categoryTypeCheckBox4 =
                                                                                false;
                                                                            categoryTypeCheckBox5 =
                                                                                false;
                                                                            categoryTypeCheckBox6 =
                                                                                false;
                                                                            categoryTypeCheckBox7 =
                                                                                false;
                                                                          }
                                                                        });
                                                                      }),
                                                                  Text(
                                                                    'Bonus coins',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      // Style for Bonus text
                                                                      color: AppColors
                                                                          .darkGrey,
                                                                      fontSize: 14 *
                                                                          variablePixelWidth,
                                                                      // Adjust font size for subsection
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      letterSpacing:
                                                                          0.50,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ]),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            transTypeCheckBoxDebit =
                                                !transTypeCheckBoxDebit;
                                            if (transTypeCheckBoxDebit) {
                                              isFilterButtonEnabled = true;
                                            } else {
                                              if (transTypeCheckBoxEarned) {
                                                isFilterButtonEnabled = true;
                                              } else {
                                                isFilterButtonEnabled = false;
                                              }
                                            }
                                          });
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Checkbox(
                                                  activeColor:
                                                      AppColors.lumiBluePrimary,
                                                  value: transTypeCheckBoxDebit,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      transTypeCheckBoxDebit =
                                                          value ?? false;
                                                      if (transTypeCheckBoxDebit) {
                                                        isFilterButtonEnabled =
                                                            true;
                                                      } else {
                                                        if (transTypeCheckBoxEarned) {
                                                          isFilterButtonEnabled =
                                                              true;
                                                        } else if (transTypeCheckBoxBonus) {
                                                          isFilterButtonEnabled =
                                                              true;
                                                        } else {
                                                          isFilterButtonEnabled =
                                                              false;
                                                        }
                                                        statusCheckBox4 = false;
                                                        statusCheckBox5 = false;
                                                        statusCheckBox6 = false;
                                                        redemptionModeTypeCheckBox1 =
                                                            false;
                                                        redemptionModeTypeCheckBox2 =
                                                            false;
                                                        redemptionModeTypeCheckBox3 =
                                                            false;
                                                      }
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  'Debit',
                                                  style: GoogleFonts.poppins(
                                                    color: AppColors.darkGrey,
                                                    fontSize:
                                                        16 * variablePixelWidth,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left:
                                                      24 * variablePixelWidth),
                                              child: GetBuilder<
                                                      CoinsSummaryController>(
                                                  builder: (_) {
                                                return Visibility(
                                                  // Visibility widget for Earned and Bonus coins
                                                  visible: true,
                                                  // Show only when Credit is selected
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(width: 10),
                                                      // Add some spacing
                                                      Row(
                                                        children: [
                                                          Checkbox(
                                                            // Checkbox for Earned coins
                                                            value:
                                                                transTypeCheckBoxDebit,
                                                            activeColor: AppColors
                                                                .lumiBluePrimary,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                transTypeCheckBoxDebit =
                                                                    value ??
                                                                        false;
                                                                if (transTypeCheckBoxDebit) {
                                                                  isFilterButtonEnabled =
                                                                      true;
                                                                } else {
                                                                  if (transTypeCheckBoxEarned) {
                                                                    isFilterButtonEnabled =
                                                                        true;
                                                                  } else if (transTypeCheckBoxBonus) {
                                                                    isFilterButtonEnabled =
                                                                        true;
                                                                  } else {
                                                                    isFilterButtonEnabled =
                                                                        false;
                                                                  }
                                                                  statusCheckBox4 =
                                                                      false;
                                                                  statusCheckBox5 =
                                                                      false;
                                                                  statusCheckBox6 =
                                                                      false;
                                                                  redemptionModeTypeCheckBox1 =
                                                                      false;
                                                                  redemptionModeTypeCheckBox2 =
                                                                      false;
                                                                  redemptionModeTypeCheckBox3 =
                                                                      false;
                                                                }
                                                              });
                                                            },
                                                          ),
                                                          Text(
                                                            'Redeemed coins',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              // Style for Earned text
                                                              color: AppColors
                                                                  .darkGrey,
                                                              fontSize: 14 *
                                                                  variablePixelWidth,
                                                              // Adjust font size for subsection
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              letterSpacing:
                                                                  0.50,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                (!transTypeCheckBoxBonus &&
                        !transTypeCheckBoxEarned &&
                        !transTypeCheckBoxDebit)
                    ? Container(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30 * variablePixelWidth,
                              24, 30 * variablePixelWidth, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Status for Credit",
                                style: GoogleFonts.poppins(
                                  color: AppColors.txtColor,
                                  fontSize: 16 * variablePixelWidth,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.50,
                                ),
                              ),
                              SizedBox(
                                height: 20 * variablePixelHeight,
                              ),
                              Text(
                                "Status for Debit",
                                style: GoogleFonts.poppins(
                                  color: AppColors.txtColor,
                                  fontSize: 16 * variablePixelWidth,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.50,
                                ),
                              ),
                              SizedBox(
                                height: 20 * variablePixelHeight,
                              ),
                              Text(
                                translation(context).saleType,
                                style: GoogleFonts.poppins(
                                  color: AppColors.txtColor,
                                  fontSize: 16 * variablePixelWidth,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.50,
                                ),
                              ),
                              SizedBox(
                                height: 20 * variablePixelHeight,
                              ),
                              Text(
                                translation(context).category,
                                style: GoogleFonts.poppins(
                                  color: AppColors.txtColor,
                                  fontSize: 16 * variablePixelWidth,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.50,
                                ),
                              ),
                              SizedBox(
                                height: 20 * variablePixelHeight,
                              ),
                              Text(
                                translation(context).redemptionMode,
                                style: GoogleFonts.poppins(
                                  color: AppColors.txtColor,
                                  fontSize: 16 * variablePixelWidth,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.50,
                                ),
                              ),
                              SizedBox(
                                height: 20 * variablePixelHeight,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                (transTypeCheckBoxEarned || transTypeCheckBoxBonus)
                    ? Theme(
                        data: ThemeData()
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          expandedAlignment: Alignment.centerLeft,
                          initiallyExpanded: true,
                          title: Padding(
                            padding: EdgeInsets.fromLTRB(
                                14 * variablePixelWidth,
                                0,
                                14 * variablePixelWidth,
                                0),
                            child: Text(
                              "Status for Credit",
                              style: GoogleFonts.poppins(
                                color: AppColors.darkText2,
                                fontSize: 16 * variablePixelWidth,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.50,
                              ),
                            ),
                          ),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (transTypeCheckBoxEarned ||
                                        transTypeCheckBoxBonus)
                                    ? Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            14 * variablePixelWidth,
                                            0,
                                            14 * variablePixelWidth,
                                            0),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              statusCheckBox1 =
                                                  !statusCheckBox1;
                                            });
                                          },
                                          child: Container(
                                            width: variablePixelWidth * 245,
                                            height: variablePixelHeight * 40,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: statusCheckBox1,
                                                  activeColor:
                                                      AppColors.lumiBluePrimary,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      statusCheckBox1 =
                                                          value ?? false;
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  'Accepted',
                                                  style: GoogleFonts.poppins(
                                                    color: AppColors.darkGrey,
                                                    fontSize:
                                                        16 * variablePixelWidth,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                (transTypeCheckBoxEarned ||
                                        transTypeCheckBoxBonus)
                                    ? Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            14 * variablePixelWidth,
                                            0,
                                            14 * variablePixelWidth,
                                            0),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              statusCheckBox2 =
                                                  !statusCheckBox2;
                                            });
                                          },
                                          child: Container(
                                            width: variablePixelWidth * 245,
                                            height: variablePixelHeight * 40,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: statusCheckBox2,
                                                  activeColor:
                                                      AppColors.lumiBluePrimary,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      statusCheckBox2 =
                                                          value ?? false;
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  'Pending',
                                                  style: GoogleFonts.poppins(
                                                    color: AppColors.darkGrey,
                                                    fontSize:
                                                        16 * variablePixelWidth,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                (transTypeCheckBoxEarned ||
                                        transTypeCheckBoxBonus)
                                    ? Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            14 * variablePixelWidth,
                                            0,
                                            14 * variablePixelWidth,
                                            0),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              statusCheckBox3 =
                                                  !statusCheckBox3;
                                            });
                                          },
                                          child: Container(
                                            width: variablePixelWidth * 245,
                                            height: variablePixelHeight * 40,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: statusCheckBox3,
                                                  activeColor:
                                                      AppColors.lumiBluePrimary,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      statusCheckBox3 =
                                                          value ?? false;
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  'Rejected',
                                                  style: GoogleFonts.poppins(
                                                    color: AppColors.darkGrey,
                                                    fontSize:
                                                        16 * variablePixelWidth,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            )
                          ],
                        ),
                      )
                    : Container(),
                !transTypeCheckBoxDebit
                    ? Container()
                    : Theme(
                        data: ThemeData()
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          expandedAlignment: Alignment.centerLeft,
                          initiallyExpanded: true,
                          title: Padding(
                            padding: EdgeInsets.fromLTRB(
                                14 * variablePixelWidth,
                                0,
                                14 * variablePixelWidth,
                                0),
                            child: Text(
                              "Status for Debit",
                              style: GoogleFonts.poppins(
                                color: AppColors.darkText2,
                                fontSize: 16 * variablePixelWidth,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.50,
                              ),
                            ),
                          ),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                !transTypeCheckBoxDebit
                                    ? Container()
                                    : Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            14 * variablePixelWidth,
                                            0,
                                            14 * variablePixelWidth,
                                            0),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              statusCheckBox4 =
                                                  !statusCheckBox4;
                                            });
                                          },
                                          child: Container(
                                            width: variablePixelWidth * 245,
                                            height: variablePixelHeight * 40,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: statusCheckBox4,
                                                  activeColor:
                                                      AppColors.lumiBluePrimary,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      statusCheckBox4 =
                                                          value ?? false;
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  'Successful',
                                                  style: GoogleFonts.poppins(
                                                    color: AppColors.darkGrey,
                                                    fontSize:
                                                        16 * variablePixelWidth,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                !transTypeCheckBoxDebit
                                    ? Container()
                                    : Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            14 * variablePixelWidth,
                                            0,
                                            14 * variablePixelWidth,
                                            0),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              statusCheckBox6 =
                                                  !statusCheckBox6;
                                            });
                                          },
                                          child: Container(
                                            width: variablePixelWidth * 245,
                                            height: variablePixelHeight * 40,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: statusCheckBox6,
                                                  activeColor:
                                                      AppColors.lumiBluePrimary,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      statusCheckBox6 =
                                                          value ?? false;
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  'Pending',
                                                  style: GoogleFonts.poppins(
                                                    color: AppColors.darkGrey,
                                                    fontSize:
                                                        16 * variablePixelWidth,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                !transTypeCheckBoxDebit
                                    ? Container()
                                    : Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            14 * variablePixelWidth,
                                            0,
                                            14 * variablePixelWidth,
                                            0),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              statusCheckBox5 =
                                                  !statusCheckBox5;
                                            });
                                          },
                                          child: Container(
                                            width: variablePixelWidth * 245,
                                            height: variablePixelHeight * 40,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: statusCheckBox5,
                                                  activeColor:
                                                      AppColors.lumiBluePrimary,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      statusCheckBox5 =
                                                          value ?? false;
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  'Failed',
                                                  style: GoogleFonts.poppins(
                                                    color: AppColors.darkGrey,
                                                    fontSize:
                                                        16 * variablePixelWidth,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            )
                          ],
                        ),
                      ),
                !transTypeCheckBoxEarned
                    ? Container()
                    : Theme(
                        data: ThemeData()
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          expandedAlignment: Alignment.centerLeft,
                          initiallyExpanded: true,
                          title: Padding(
                            padding: EdgeInsets.fromLTRB(
                                14 * variablePixelWidth,
                                0,
                                14 * variablePixelWidth,
                                0),
                            child: Text(
                              translation(context).saleType,
                              style: GoogleFonts.poppins(
                                color: AppColors.darkText2,
                                fontSize: 16 * variablePixelWidth,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.50,
                              ),
                            ),
                          ),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                storedUserProfile[0].userType.toLowerCase() ==
                                        FilterCashCoin.distributorType
                                    ? Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            14 * variablePixelWidth,
                                            0,
                                            14 * variablePixelWidth,
                                            0),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              saleTypeCheckBox1 =
                                                  !saleTypeCheckBox1;
                                            });
                                          },
                                          child: Container(
                                            width: variablePixelWidth * 245,
                                            height: variablePixelHeight * 40,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: saleTypeCheckBox1,
                                                  activeColor:
                                                      AppColors.lumiBluePrimary,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      saleTypeCheckBox1 =
                                                          value ?? false;
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  'Secondary',
                                                  style: GoogleFonts.poppins(
                                                    color: AppColors.darkGrey,
                                                    fontSize:
                                                        16 * variablePixelWidth,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      14 * variablePixelWidth,
                                      0,
                                      14 * variablePixelWidth,
                                      0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        saleTypeCheckBox2 = !saleTypeCheckBox2;
                                      });
                                    },
                                    child: Container(
                                      width: variablePixelWidth * 245,
                                      height: variablePixelHeight * 40,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: saleTypeCheckBox2,
                                            activeColor:
                                                AppColors.lumiBluePrimary,
                                            onChanged: (value) {
                                              setState(() {
                                                saleTypeCheckBox2 =
                                                    value ?? false;
                                              });
                                            },
                                          ),
                                          Text(
                                            'Tertiary',
                                            style: GoogleFonts.poppins(
                                              color: AppColors.darkGrey,
                                              fontSize: 16 * variablePixelWidth,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                !transTypeCheckBoxEarned
                    ? Container()
                    : Theme(
                        data: ThemeData()
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          expandedAlignment: Alignment.centerLeft,
                          initiallyExpanded: true,
                          title: Padding(
                            padding: EdgeInsets.fromLTRB(
                                14 * variablePixelWidth,
                                0,
                                14 * variablePixelWidth,
                                0),
                            child: Text(
                              translation(context).category,
                              style: GoogleFonts.poppins(
                                color: AppColors.darkText2,
                                fontSize: 16 * variablePixelWidth,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.50,
                              ),
                            ),
                          ),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      14 * variablePixelWidth,
                                      0,
                                      14 * variablePixelWidth,
                                      0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        categoryTypeCheckBox1 =
                                            !categoryTypeCheckBox1;
                                      });
                                    },
                                    child: Container(
                                      width: variablePixelWidth * 245,
                                      height: variablePixelHeight * 40,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: categoryTypeCheckBox1,
                                            activeColor:
                                                AppColors.lumiBluePrimary,
                                            onChanged: (value) {
                                              setState(() {
                                                categoryTypeCheckBox1 =
                                                    value ?? false;
                                              });
                                            },
                                          ),
                                          Text(
                                            'Solar Battery',
                                            style: GoogleFonts.poppins(
                                              color: AppColors.darkGrey,
                                              fontSize: 16 * variablePixelWidth,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      14 * variablePixelWidth,
                                      0,
                                      14 * variablePixelWidth,
                                      0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        categoryTypeCheckBox2 =
                                            !categoryTypeCheckBox2;
                                      });
                                    },
                                    child: Container(
                                      width: variablePixelWidth * 245,
                                      height: variablePixelHeight * 40,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: categoryTypeCheckBox2,
                                            activeColor:
                                                AppColors.lumiBluePrimary,
                                            onChanged: (value) {
                                              setState(() {
                                                categoryTypeCheckBox2 =
                                                    value ?? false;
                                              });
                                            },
                                          ),
                                          Text(
                                            'Battery',
                                            style: GoogleFonts.poppins(
                                              color: AppColors.darkGrey,
                                              fontSize: 16 * variablePixelWidth,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      14 * variablePixelWidth,
                                      0,
                                      14 * variablePixelWidth,
                                      0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        categoryTypeCheckBox3 =
                                            !categoryTypeCheckBox3;
                                      });
                                    },
                                    child: Container(
                                      width: variablePixelWidth * 245,
                                      height: variablePixelHeight * 40,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: categoryTypeCheckBox3,
                                            activeColor:
                                                AppColors.lumiBluePrimary,
                                            onChanged: (value) {
                                              setState(() {
                                                categoryTypeCheckBox3 =
                                                    value ?? false;
                                              });
                                            },
                                          ),
                                          Text(
                                            'Solar panel',
                                            style: GoogleFonts.poppins(
                                              color: AppColors.darkGrey,
                                              fontSize: 16 * variablePixelWidth,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      14 * variablePixelWidth,
                                      0,
                                      14 * variablePixelWidth,
                                      0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        categoryTypeCheckBox4 =
                                            !categoryTypeCheckBox4;
                                      });
                                    },
                                    child: Container(
                                      width: variablePixelWidth * 245,
                                      height: variablePixelHeight * 40,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: categoryTypeCheckBox4,
                                            activeColor:
                                                AppColors.lumiBluePrimary,
                                            onChanged: (value) {
                                              setState(() {
                                                categoryTypeCheckBox4 =
                                                    value ?? false;
                                              });
                                            },
                                          ),
                                          Text(
                                            'HUPS',
                                            style: GoogleFonts.poppins(
                                              color: AppColors.darkGrey,
                                              fontSize: 16 * variablePixelWidth,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      14 * variablePixelWidth,
                                      0,
                                      14 * variablePixelWidth,
                                      0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        categoryTypeCheckBox5 =
                                            !categoryTypeCheckBox5;
                                      });
                                    },
                                    child: Container(
                                      width: variablePixelWidth * 245,
                                      height: variablePixelHeight * 40,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: categoryTypeCheckBox5,
                                            activeColor:
                                                AppColors.lumiBluePrimary,
                                            onChanged: (value) {
                                              setState(() {
                                                categoryTypeCheckBox5 =
                                                    value ?? false;
                                              });
                                            },
                                          ),
                                          Text(
                                            'HKVA',
                                            style: GoogleFonts.poppins(
                                              color: AppColors.darkGrey,
                                              fontSize: 16 * variablePixelWidth,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      14 * variablePixelWidth,
                                      0,
                                      14 * variablePixelWidth,
                                      0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        categoryTypeCheckBox6 =
                                            !categoryTypeCheckBox6;
                                      });
                                    },
                                    child: Container(
                                      width: variablePixelWidth * 245,
                                      height: variablePixelHeight * 40,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: categoryTypeCheckBox6,
                                            activeColor:
                                                AppColors.lumiBluePrimary,
                                            onChanged: (value) {
                                              setState(() {
                                                categoryTypeCheckBox6 =
                                                    value ?? false;
                                              });
                                            },
                                          ),
                                          Text(
                                            'GTI',
                                            style: GoogleFonts.poppins(
                                              color: AppColors.darkGrey,
                                              fontSize: 16 * variablePixelWidth,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      14 * variablePixelWidth,
                                      0,
                                      14 * variablePixelWidth,
                                      0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        categoryTypeCheckBox7 =
                                            !categoryTypeCheckBox7;
                                      });
                                    },
                                    child: Container(
                                      width: variablePixelWidth * 245,
                                      height: variablePixelHeight * 40,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: categoryTypeCheckBox7,
                                            activeColor:
                                                AppColors.lumiBluePrimary,
                                            onChanged: (value) {
                                              setState(() {
                                                categoryTypeCheckBox7 =
                                                    value ?? false;
                                              });
                                            },
                                          ),
                                          Text(
                                            'Solar Inverters',
                                            style: GoogleFonts.poppins(
                                              color: AppColors.darkGrey,
                                              fontSize: 16 * variablePixelWidth,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                !transTypeCheckBoxDebit
                    ? Container()
                    : Theme(
                        data: ThemeData()
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          expandedAlignment: Alignment.centerLeft,
                          initiallyExpanded: true,
                          title: Padding(
                            padding: EdgeInsets.fromLTRB(
                                14 * variablePixelWidth,
                                0,
                                14 * variablePixelWidth,
                                0),
                            child: Text(
                              translation(context).redemptionMode,
                              style: GoogleFonts.poppins(
                                color: AppColors.darkText2,
                                fontSize: 16 * variablePixelWidth,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.50,
                              ),
                            ),
                          ),
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: 40 * variablePixelHeight),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  widget.historyType == FilterCashCoin.coin
                                      ? Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              14 * variablePixelWidth,
                                              0,
                                              14 * variablePixelWidth,
                                              0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                redemptionModeTypeCheckBox1 =
                                                    !redemptionModeTypeCheckBox1;
                                              });
                                            },
                                            child: Container(
                                              width: variablePixelWidth * 245,
                                              height: variablePixelHeight * 40,
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    value:
                                                        redemptionModeTypeCheckBox1,
                                                    activeColor: AppColors
                                                        .lumiBluePrimary,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        redemptionModeTypeCheckBox1 =
                                                            value ?? false;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    'Cashback',
                                                    style: GoogleFonts.poppins(
                                                      color: AppColors.darkGrey,
                                                      fontSize: 16 *
                                                          variablePixelWidth,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 0.50,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              14 * variablePixelWidth,
                                              0,
                                              14 * variablePixelWidth,
                                              0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                redemptionModeTypeCheckBox1 =
                                                    !redemptionModeTypeCheckBox1;
                                              });
                                            },
                                            child: Container(
                                              width: variablePixelWidth * 245,
                                              height: variablePixelHeight * 40,
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    value:
                                                        redemptionModeTypeCheckBox1,
                                                    activeColor: AppColors
                                                        .lumiBluePrimary,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        redemptionModeTypeCheckBox1 =
                                                            value ?? false;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    'Paytm wallet',
                                                    style: GoogleFonts.poppins(
                                                      color: AppColors.darkGrey,
                                                      fontSize: 16 *
                                                          variablePixelWidth,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 0.50,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  widget.historyType == FilterCashCoin.coin
                                      ? Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              14 * variablePixelWidth,
                                              0,
                                              14 * variablePixelWidth,
                                              0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                redemptionModeTypeCheckBox2 =
                                                    !redemptionModeTypeCheckBox2;
                                              });
                                            },
                                            child: Container(
                                              width: variablePixelWidth * 245,
                                              height: variablePixelHeight * 40,
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    value:
                                                        redemptionModeTypeCheckBox2,
                                                    activeColor: AppColors
                                                        .lumiBluePrimary,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        redemptionModeTypeCheckBox2 =
                                                            value ?? false;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    'Trips',
                                                    style: GoogleFonts.poppins(
                                                      color: AppColors.darkGrey,
                                                      fontSize: 16 *
                                                          variablePixelWidth,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 0.50,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              14 * variablePixelWidth,
                                              0,
                                              14 * variablePixelWidth,
                                              0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                redemptionModeTypeCheckBox2 =
                                                    !redemptionModeTypeCheckBox2;
                                              });
                                            },
                                            child: Container(
                                              width: variablePixelWidth * 245,
                                              height: variablePixelHeight * 40,
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    value:
                                                        redemptionModeTypeCheckBox2,
                                                    activeColor: AppColors
                                                        .lumiBluePrimary,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        redemptionModeTypeCheckBox2 =
                                                            value ?? false;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    'Pine lab wallet',
                                                    style: GoogleFonts.poppins(
                                                      color: AppColors.darkGrey,
                                                      fontSize: 16 *
                                                          variablePixelWidth,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 0.50,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  widget.historyType == FilterCashCoin.coin
                                      ? Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              14 * variablePixelWidth,
                                              0,
                                              14 * variablePixelWidth,
                                              0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                redemptionModeTypeCheckBox3 =
                                                    !redemptionModeTypeCheckBox3;
                                              });
                                            },
                                            child: Container(
                                              width: variablePixelWidth * 245,
                                              height: variablePixelHeight * 40,
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    value:
                                                        redemptionModeTypeCheckBox3,
                                                    activeColor: AppColors
                                                        .lumiBluePrimary,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        redemptionModeTypeCheckBox3 =
                                                            value ?? false;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    'Gifts',
                                                    style: GoogleFonts.poppins(
                                                      color: AppColors.darkGrey,
                                                      fontSize: 16 *
                                                          variablePixelWidth,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 0.50,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              14 * variablePixelWidth,
                                              0,
                                              14 * variablePixelWidth,
                                              0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                redemptionModeTypeCheckBox3 =
                                                    !redemptionModeTypeCheckBox3;
                                              });
                                            },
                                            child: Container(
                                              width: variablePixelWidth * 245,
                                              height: variablePixelHeight * 40,
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    value:
                                                        redemptionModeTypeCheckBox3,
                                                    activeColor: AppColors
                                                        .lumiBluePrimary,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        redemptionModeTypeCheckBox3 =
                                                            value ?? false;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    'UPI',
                                                    style: GoogleFonts.poppins(
                                                      color: AppColors.darkGrey,
                                                      fontSize: 16 *
                                                          variablePixelWidth,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 0.50,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  widget.historyType == FilterCashCoin.coin
                                      ? Container()
                                      : transTypeCheckBoxDebit
                                          ? Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  14 * variablePixelWidth,
                                                  0,
                                                  14 * variablePixelWidth,
                                                  0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    redemptionModeTypeCheckBox4 =
                                                        !redemptionModeTypeCheckBox4;
                                                  });
                                                },
                                                child: Container(
                                                  width:
                                                      variablePixelWidth * 245,
                                                  height:
                                                      variablePixelHeight * 40,
                                                  child: Row(
                                                    children: [
                                                      Checkbox(
                                                        value:
                                                            redemptionModeTypeCheckBox4,
                                                        activeColor: AppColors
                                                            .lumiBluePrimary,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            redemptionModeTypeCheckBox4 =
                                                                value ?? false;
                                                          });
                                                        },
                                                      ),
                                                      Text(
                                                        'Credit Note (CN)',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: AppColors
                                                              .darkGrey,
                                                          fontSize: 16 *
                                                              variablePixelWidth,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          letterSpacing: 0.50,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            )),
            Container(
              color: AppColors.lightWhite1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24 * variablePixelWidth, 0,
                    24 * variablePixelWidth, 24 * variablePixelHeight),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 165 * variablePixelWidth,
                      height: 50 * variablePixelHeight,
                      child: CommonWhiteButton(
                        onPressed: resetFilters,
                        isEnabled: isFilterButtonEnabled,
                        buttonText: translation(context).reset,
                        backGroundColor: AppColors.lightWhite1,
                        textColor: AppColors.blackText,
                        isGreyColor: isFilterButtonEnabled,
                      ),
                    ),
                    SizedBox(
                        width: 165 * variablePixelWidth,
                        height: 50 * variablePixelHeight,
                        child: CommonButton(
                          onPressed: () => applyFilterOnData(false),
                          isEnabled: isFilterButtonEnabled,
                          buttonText: translation(context).apply,
                          withContainer: false,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
