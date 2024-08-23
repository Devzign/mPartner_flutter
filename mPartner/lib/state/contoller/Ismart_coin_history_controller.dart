import 'package:get/get.dart';

import '../../../services/services_locator.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/coin_history_model.dart';
import '../../utils/app_constants.dart';

class ISmartCoinHistoryController extends GetxController {
  var isLoading = true.obs;
  var error = ''.obs;
  var showFromToData = false.obs;
  var filterDate = ''.obs;
  var coinHistoryList = <CoinTransHistory>[].obs;
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
    'CreditType':'',
    'selectCreditTransType': '',
    'selectDebitTransType': '',
    'fromDateVal': '',
    'toDateVal': '',
    'selectedDateRange': '',
    'selectedCategory': '',
    'redemptionMode': '',
  }.obs;
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;
  String earnedCoin = "0";
  String redeemedCoin = "0";
  String creditCount = "0";
  String debitCount = "0";
  String fromDateVal ="";
  String toDateVal ="";
  var isDateSelected = false.obs;
  var isEarnEnable = false.obs;
  var isRedeemEnable = false.obs;
  var coinExcelReportUrl = "".obs;
  var isCoinExcelReportUrlExist = false.obs;
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

  fetchCoinHistory({String? code}) async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.getCoinHistory(
          pageNumber.value, pageSize.value,dealerCode: code);
    //  print("cash History data ${result}");
      isLoading.value=false;
      result.fold(
        (l){
          print("Error: $l");},
        (r) async {
          if(r.coinTransHistory.isNotEmpty){
            coinHistoryList.addAll(r.coinTransHistory);
            pageNumber++;
            if (r.coinTransHistory.length < pageSize.value) {
              hasMore = false.obs;
            }
            print(pageNumber);
            print(result);
            print(r);
            if (r.coinTransSummary.every((value) => value == 'NA')) {
              error('Not able to convert coins to cashback');
            } else {
              error('');
            }
            updateEarnedCash(r.coinTransSummary[0].earned.toString());
            updateRedeemedCash(r.coinTransSummary[0].reedemed.toString());
            updateCreditCount(r.coinTransSummary[0].creditCount.toString());
            updateDebitCount(r.coinTransSummary[0].debitCount.toString());
            updateFromDate(r.coinTransSummary[0].fromDate.toString());
            updateToDate(r.coinTransSummary[0].toDate.toString());
          }
          else{
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

          logger.e("Value ${r.coinTransSummary.isNotEmpty}:${paginationNumber}:${filterPageNumber}");
          if(r.coinTransSummary.isNotEmpty&& (paginationNumber-1)<2 ){
            updateEarnedCash(r.coinTransSummary[0].earned.toString());
            updateRedeemedCash(r.coinTransSummary[0].reedemed.toString());
            updateCreditCount(r.coinTransSummary[0].creditCount.toString());
            updateDebitCount(r.coinTransSummary[0].debitCount.toString());
            updateFromDate(r.coinTransSummary[0].fromDate.toString());
            updateToDate(r.coinTransSummary[0].toDate.toString());
          }

        },
      );
    } catch (e) {
      hasMore = false.obs;
      print("Error Captured: ${e}");
    } finally {
      hasMore = false.obs;
      isLoading=false.obs;
    }

  }

  fetchFilteredData(
      String selectedSaleType,
      String selectedTransType,
      String selectCreditType,
      String selectCreditTransType,
      String selectDebitTransType,
      String fromDateVal,
      String toDateVal,
      String categoryType,
      String redemptionModeVal,{String? code}) async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      final result =
          await baseMPartnerRemoteDataSource.getCoinHistoryFilterData(
              selectedSaleType,
              selectedTransType,
              selectCreditType,
              selectCreditTransType,
              selectDebitTransType,
              fromDateVal,
              toDateVal,
              categoryType,
              redemptionModeVal,
              filterPageNumber.value,
              filterPageSize.value,searchKey.value,dealerCode: code);
      isLoading.value=false;
      result.fold(
        (l) {
        print("Error: $l");},
        (r) async {
         if(r.coinTransHistory.isNotEmpty){
           showFromToData(true);
           filterDate('$fromDateVal - $toDateVal');
           coinHistoryList.addAll(r.coinTransHistory);
           filterPageNumber++;
           if (r.coinTransHistory.length < filterPageSize.value) {
             hasMore = false.obs;
           }

           logger.e('PageValue while Applying Filter ${filterPageNumber.value}');
           logger.e('PageNumber while Applying Filter ${filterPageSize.value}');
           print(result);
           print(r);

           updateEarnedCash(r.coinTransSummary[0].earned.toString());
           updateRedeemedCash(r.coinTransSummary[0].reedemed.toString());
           updateCreditCount(r.coinTransSummary[0].creditCount.toString());
           updateDebitCount(r.coinTransSummary[0].debitCount.toString());
           updateFromDate(r.coinTransSummary[0].fromDate.toString());
           updateToDate(r.coinTransSummary[0].toDate.toString());
         }
         else{
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

         logger.e("Value ${r.coinTransSummary.isNotEmpty}:${paginationNumber}:${filterPageNumber}");
         if(r.coinTransSummary.isNotEmpty&& (paginationNumber-1)<2 ){
           updateEarnedCash(r.coinTransSummary[0].earned.toString());

           updateRedeemedCash(r.coinTransSummary[0].reedemed.toString());
           updateCreditCount(r.coinTransSummary[0].creditCount.toString());
           updateDebitCount(r.coinTransSummary[0].debitCount.toString());
           updateFromDate(r.coinTransSummary[0].fromDate.toString());
           updateToDate(r.coinTransSummary[0].toDate.toString());
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

  fetchCoinExcelData(
      String selectedSaleType,
      String selectTransType,
      String selectCreditType,
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
      await baseMPartnerRemoteDataSource.getCoinHistoryExcelData(
        selectedSaleType,
        selectTransType,
        selectCreditType,
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
            coinExcelReportUrl.value = r.data;
            isCoinExcelReportUrlExist = true.obs;
          }
          else{
            coinExcelReportUrl.value = "";
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

  clearIsmartCoinHistory() {
    isLoading = true.obs;
    showFromToData = false.obs;
    filterDate = ''.obs;
    coinHistoryList = <CoinTransHistory>[].obs;
    pageNumber = 1.obs;
    pageSize = 10.obs;
    filterPageNumber = 1.obs;
    filterPageSize = 10.obs;
    hasMore = true.obs;
    filterFlag = false.obs;
    isFilterApplied=false.obs;
    selectedValues = {
      'selectedSaleType': '',
      'selectedTransType': '',
      'CreditType':'',
      'selectCreditTransType': '',
      'selectDebitTransType': '',
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
    coinExcelReportUrl = "".obs;
    isCoinExcelReportUrlExist = false.obs;
    excelReportNotFound = "".obs;
    searchKey = "".obs;
    update();
  }

  clearIsmartCoinHistoryFilterData() {
    filterFlag = true.obs;
    coinHistoryList.clear();
    filterPageNumber = 1.obs;
    filterPageSize = 10.obs;
    pageNumber = 1.obs;
    pageSize = 10.obs;
    hasMore = true.obs;
    selectedValues = {
      'selectedSaleType': '',
      'selectedTransType': '',
      'CreditType':'',
      'selectCreditTransType': '',
      'selectDebitTransType': '',
      'fromDateVal': '',
      'toDateVal': '',
      'selectedDateRange': '',
      'selectedCategory': '',
      'redemptionMode': '',
    }.obs;
    fromDate = DateTime.now().obs;
    toDate = DateTime.now().obs;
    coinExcelReportUrl = "".obs;
    isCoinExcelReportUrlExist = false.obs;
    excelReportNotFound = "".obs;
    update();
  }

  updatePageNumber(){
    filterPageNumber = 1.obs;
    filterPageSize = 10.obs;
    update();
  }

  clearCoinHistoryList(){
    filterFlag = false.obs;
    isFilterApplied.value = false;
    coinHistoryList.clear();
    filterPageNumber = 1.obs;
    filterPageSize = 10.obs;
    pageNumber = 1.obs;
    pageSize = 10.obs;
    hasMore = true.obs;
    coinExcelReportUrl = "".obs;
    isCoinExcelReportUrlExist = false.obs;
    excelReportNotFound = "".obs;
    update();
  }

  updateEarnedCash(String cash) async {
    earnedCoin = cash;
    update();
  }

  updateRedeemedCash(String cash) async {
    redeemedCoin = cash;
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
