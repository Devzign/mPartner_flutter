import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../services/services_locator.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/cash_history_model.dart';
import '../../utils/app_constants.dart';

class ISmartCashHistoryController extends GetxController {
  var isLoading = true.obs;
  var error = ''.obs;
  var showFromToData = false.obs;
  var filterDate = ''.obs;
  var cashHistoryList = <CashTransHistory>[].obs;
  var pageNumber = 1.obs;
  var pageSize = 10.obs;
  var filterPageNumber = 1.obs;
  var filterPageSize = 10.obs;
  var filterFlag = false.obs;
  var isFilterApplied = false.obs;
  var hasMore = true.obs;
  var selectedValues = {
    'selectedSaleType': '',
    'selectedTransType': '',
    'selectCreditTransType': "",
    'selectDebitTransType': "",
    'fromDateVal': '',
    'toDateVal': '',
    'selectedDateRange': '',
    'selectedCategory': '',
    'redemptionMode': '',
  }.obs;
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;
  var type = "";
  String earnedCash = "0";
  String redeemedCash = "0";
  String creditCount = "0";
  String debitCount = "0";
  String fromDateVal = "";
  String toDateVal = "";
  var isDateSelected = false.obs;
  var isEarnEnable = false.obs;
  var isRedeemEnable = false.obs;
  var cashExcelReportUrl = "".obs;
  var isCashExcelReportUrlExist = false.obs;
  var excelReportNotFound = "".obs;
  var searchKey = "".obs;


  void setFromDate(DateTime date) {
    fromDate.value = date;
  }

  void setToDate(DateTime date) {
    toDate.value = date;
  }

  @override
  void onInit() async {
    super.onInit();
  }

  fetchCashHistory({String? code}) async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.getCashHistory(
          pageNumber.value, pageSize.value,dealerCode: code);
      print("Rest of Cash----->${result}");
      print("cash History data ${result}");
      isLoading.value=false;
      result.fold(
        (l){
          print("Error: $l");},
        (r) async {
          if (r.cashTransHistory.isNotEmpty) {
            cashHistoryList.addAll(r.cashTransHistory);
            pageNumber++;

            if (r.cashTransHistory.length < pageSize.value) {
              hasMore = false.obs;
            }
            print(r);
            if (r.cashTransSummary.every((value) => value == 'NA')) {
              error('Not able to convert coins to cashback');
            } else {
              error('');
            }
            updateEarnedCash(r.cashTransSummary[0].earned.toString());
            updateRedeemedCash(r.cashTransSummary[0].reedemed.toString());
            updateCreditCount(r.cashTransSummary[0].creditCount.toString());
            updateDebitCount(r.cashTransSummary[0].debitCount.toString());
            updateFromDate(r.cashTransSummary[0].fromDate.toString());
            updateToDate(r.cashTransSummary[0].toDate.toString());
          } else {
            hasMore = false.obs;
            pageNumber++;
            update();
          }

          var paginationNumber=0;
          if(isFilterApplied.value){
            paginationNumber=filterPageNumber.value;
          }
          else{
            paginationNumber=pageNumber.value;
          }

          logger.e("Value ${r.cashTransSummary.isNotEmpty}:${paginationNumber}:${filterPageNumber}");
          if(r.cashTransSummary.isNotEmpty&& (paginationNumber-1)<2 ){
            updateEarnedCash(r.cashTransSummary[0].earned.toString());
            updateRedeemedCash(r.cashTransSummary[0].reedemed.toString());
            updateCreditCount(r.cashTransSummary[0].creditCount.toString());
            updateDebitCount(r.cashTransSummary[0].debitCount.toString());
            updateFromDate(r.cashTransSummary[0].fromDate.toString());
            updateToDate(r.cashTransSummary[0].toDate.toString());
          }
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
      hasMore = false.obs;
    } finally {
      hasMore = false.obs;
      isLoading=false.obs;
    }
  }

  fetchFilteredData(
      String selectedSaleType,
      String selectTransType,
      String selectCreditTransType,
      String selectDebitTransType,
      String fromDateVal,
      String toDateVal,
      String categoryType,
      String redemptionModeVal,
      {String? code}) async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      final result =
          await baseMPartnerRemoteDataSource.getCashHistoryFilterData(
              selectedSaleType,
              selectTransType,
              selectCreditTransType,
              selectDebitTransType,
              fromDateVal,
              toDateVal,
              categoryType,
              redemptionModeVal,
              filterPageNumber.value,
              filterPageSize.value,
              searchKey.value,
              dealerCode: code);
      isLoading.value=false;

      result.fold(
        (l) {
          print("Error: $l");},
        (r) async {
          if (r.cashTransHistory.isNotEmpty) {
            showFromToData(true);
            filterDate('$fromDateVal - $toDateVal');
            cashHistoryList.addAll(r.cashTransHistory);
            filterPageNumber++;
            if (r.cashTransHistory.length < filterPageSize.value) {
              hasMore = false.obs;
            }
            print('PageValue while Applying Filter ${filterPageNumber.value}');
            print('PageNumber while Applying Filter ${filterPageSize.value}');
            print(result);
            print(r);
            updateEarnedCash(r.cashTransSummary[0].earned.toString());
            updateRedeemedCash(r.cashTransSummary[0].reedemed.toString());
            updateCreditCount(r.cashTransSummary[0].creditCount.toString());
            updateDebitCount(r.cashTransSummary[0].debitCount.toString());
            updateFromDate(r.cashTransSummary[0].fromDate.toString());
            updateToDate(r.cashTransSummary[0].toDate.toString());


          } else {
            hasMore = false.obs;
            filterPageNumber++;
            update();
          }

          var paginationNumber=0;
          if(isFilterApplied.value){
            paginationNumber=filterPageNumber.value;
          }
          else{
            paginationNumber=pageNumber.value;
          }

          logger.e("Value ${r.cashTransSummary.isNotEmpty}:${paginationNumber}:${filterPageNumber}");
          if(r.cashTransSummary.isNotEmpty&& (paginationNumber-1)<2 ){
            updateEarnedCash(r.cashTransSummary[0].earned.toString());
            updateRedeemedCash(r.cashTransSummary[0].reedemed.toString());
            updateCreditCount(r.cashTransSummary[0].creditCount.toString());
            updateDebitCount(r.cashTransSummary[0].debitCount.toString());
            updateFromDate(r.cashTransSummary[0].fromDate.toString());
            updateToDate(r.cashTransSummary[0].toDate.toString());
          }

        },
      );
      print("Values using the filter: $result");
    } catch (e) {
        hasMore = false.obs;
        print("Error Captured: $e");
    } finally {
      isLoading=false.obs;
      hasMore = false.obs;
    }
  }

  fetchCashExcelData(
      String selectedSaleType,
      String selectTransType,
      String selectCreditTransType,
      String selectDebitTransType,
      String fromDateVal,
      String toDateVal,
      String categoryType,
      String redemptionModeVal,
      {String? code}) async {
    try {
      isLoading(true);
      var excelPageNumber=0;
      if(isFilterApplied.value){
        excelPageNumber=filterPageNumber.value;
      }
      else{
        excelPageNumber=pageNumber.value;
      }
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
      sl<BaseMPartnerRemoteDataSource>();
      final result =
      await baseMPartnerRemoteDataSource.getCashHistoryExcelData(
          selectedSaleType,
          selectTransType,
          selectCreditTransType,
          selectDebitTransType,
          fromDateVal,
          toDateVal,
          categoryType,
          redemptionModeVal,
          excelPageNumber,
          filterPageSize.value,searchKey.value,dealerCode: code);
      isLoading.value=false;

      result.fold(
            (l) {
          print("Error: $l");},
            (r) async {
              if(r.status == "200" && r.data.isNotEmpty){
                cashExcelReportUrl.value = r.data;
                isCashExcelReportUrlExist = true.obs;
              }
              else{
                cashExcelReportUrl.value = "";
                excelReportNotFound.value = r.message;
              }
        },
      );
      print("Values using the filter: $result");
    } catch (e) {
      hasMore = false.obs;
      print("Error Captured: $e");
    } finally {
      isLoading=false.obs;
      hasMore = false.obs;
    }
  }

  clearIsmartCashHistory() {
    earnedCash = "0";
    redeemedCash = "0";
    creditCount = "0";
    debitCount = "0";
    fromDateVal = "";
    toDateVal = "";
    isLoading = true.obs;
    showFromToData = false.obs;
    filterDate = ''.obs;
    cashHistoryList = <CashTransHistory>[].obs;
    isFilterApplied=false.obs;
    pageNumber = 1.obs;
    pageSize = 10.obs;
    hasMore = true.obs;
    creditCount = "0";
    debitCount = "0";
    filterPageNumber = 1.obs;
    filterPageSize = 10.obs;
    filterFlag = false.obs;
    selectedValues = {
      'selectedSaleType': '',
      'selectedTransType': '',
      'selectCreditTransType': "",
      'selectDebitTransType': "",
      'fromDateVal': '',
      'toDateVal': '',
      'selectedDateRange': '',
      'selectedCategory': '',
      'redemptionMode': '',
    }.obs;
    fromDate = DateTime.now().obs;
    toDate = DateTime.now().obs;
    isDateSelected = false.obs;
    isEarnEnable = false.obs;
    isRedeemEnable = false.obs;
    cashExcelReportUrl = "".obs;
    isCashExcelReportUrlExist = false.obs;
    excelReportNotFound = "".obs;
    searchKey = "".obs;
    update();
  }

  clearIsmartCashHistoryFilterData() {
     filterFlag = true.obs;
     isFilterApplied=false.obs;
     cashHistoryList.clear();
    filterPageNumber = 1.obs;
    filterPageSize = 10.obs;
     pageNumber = 1.obs;
     pageSize = 10.obs;
    hasMore = true.obs;
    creditCount = "0";
    debitCount = "0";
    selectedValues = {
      'selectedSaleType': '',
      'selectedTransType': '',
      'selectCreditTransType': "",
      'selectDebitTransType': "",
      'fromDateVal': '',
      'toDateVal': '',
      'selectedDateRange': '',
      'selectedCategory': '',
      'redemptionMode': '',
    }.obs;
    fromDate = DateTime.now().obs;
    toDate = DateTime.now().obs;
     cashExcelReportUrl = "".obs;
     isCashExcelReportUrlExist = false.obs;
     excelReportNotFound = "".obs;
    update();
  }

  clearCashHistoryList() {
    filterFlag = false.obs;
    isFilterApplied.value = false;
    cashHistoryList.clear();
    filterPageNumber = 1.obs;
    filterPageSize = 10.obs;
    pageNumber = 1.obs;
    pageSize = 10.obs;
    hasMore = true.obs;
    cashExcelReportUrl = "".obs;
    isCashExcelReportUrlExist = false.obs;
    excelReportNotFound = "".obs;
    update();
  }

  updateEarnedCash(String cash) async {
    earnedCash = cash;
    update();
  }

  updateRedeemedCash(String cash) async {
    redeemedCash = cash;
    update();
  }

  updateCreditCount(String count) async {
    creditCount = count;
    update();
  }

  updateDebitCount(String count) async {
    debitCount = count;
    update();
  }

  updateFromDate(String val) async {
    fromDateVal = val;
    update();
  }

  updateToDate(String val) async {
    toDateVal = val;
    update();
  }
}
