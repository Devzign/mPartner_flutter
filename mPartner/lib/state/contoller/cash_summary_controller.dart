import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/cash_summary_model.dart';

class CashSummaryController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;
  String availableCash = "0";
  String earnedCash = "0";
  String redeemedCash = "0";
  String pendingAmt = "0";
  String creditCount = "0";
  String debitCount = "0";
  String fromDate ="";
  String toDate="";

  var cashSummary = const CashSummary(
    brandVoucherAmt: 0,
    paytmAmt: 0,
    transfer_Status: "",
    paytm_Status: "",
    paytm_Msg: "",
    transfer_Msg: "",
    availableCash: 0,
    earnedCash: 0,
    redeemedCash: 0,
    pendingAmt: 0,
    creditCount: 0,
    debitCount: 0,
    fromDate:"",
    toDate:""

  ).obs;


  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchCashSummary({String fromDate="", String toDate="",String? code}) async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postCashSummary(fromDate: fromDate,toDate: toDate,dealerCode: code);
      isLoading.value=false;

      result.fold(
        (failure) {
          // Handle failure (Left)

          error('Failed to fetch Cash Summary information: $failure');
        },
        (cashSummaryData) {
          if (cashSummaryData.props.every((value) => value == 'NA')) {
            error('Not able to convert coins to cashback');
          } else {
            error('');
          }
          cashSummary(cashSummaryData);
          updateAvailableCash(cashSummary.value.availableCash.toString());
          updateEarnedCash(cashSummary.value.earnedCash.toString());
          updateRedeemedCash(cashSummary.value.redeemedCash.toString());
          updatePendingCash(cashSummary.value.pendingAmt.toString());
          // updatePendingCash(cashSummary.value.c.toString());
          updateCreditCount(cashSummary.value.creditCount.toString());
          updateDebitCount(cashSummary.value.debitCount.toString());
          updateFromDate(cashSummary.value.fromDate.toString());
          updateToDate(cashSummary.value.toDate.toString());
        },
      );
    } catch(e) {
      print(e);
    }
    finally{

    }
  }

  @override
  void onInit() async {
    super.onInit();
    update();
  }

  updateAvailableCash(String cash) async {
    availableCash = cash;
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

  updatePendingCash(String cash) async {
    pendingAmt = cash;
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

  updateFromDate(String fromDateVal) async {
    fromDate = fromDateVal;
    update();
  }
  updateToDate(String toDateVal) async {
    toDate = toDateVal;
    update();
  }


  clearCashSummaryData({String? code}){
    fromDate="";
    toDate="";
    availableCash = "0";
    fetchCashSummary(code: code);
    update();
  }

  clearCashSummary() {
    isLoading = false.obs;
    error = ''.obs;
    availableCash = "0";
    earnedCash = "0";
    redeemedCash = "0";
    pendingAmt = "0";
    creditCount = "0";
    debitCount = "0";
    fromDate ="";
    toDate="";
  }
}
