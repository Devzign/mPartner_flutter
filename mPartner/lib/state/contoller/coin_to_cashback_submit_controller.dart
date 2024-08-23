import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/coin_to_cashback_conversion_submit.dart';

class CoinToCashbackSubmitController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;
  String remarks = "";
  String status = "";
  String transactionDate = "";
  String transactionId = "";
  int amount = 0;

  var coinToCashbackSubmit = const CoinToCashbackConversionSubmit(
          remarks: '',
          conversion_msg: '',
          html_Msg: '',
          status: '',
          amount: 0,
          transactionDate: '',
          tranId: '')
      .obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchCoinToCashbackSubmit(
      int coinsForCashback, int conversionRate) async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postCoinToCashbackSubmit(
          coinsForCashback, conversionRate);
      print("ERROR RESULT !! -> ${result}");

      result.fold(
        (failure) {
          // Handle failure (Left)
          print("INSIDE ERROR CASE !");
          error('$failure');
          print(error.value);
        },
        (coinToCashbackSubmitData) {
          print(
              "Coin to cashback submit data from api call $coinToCashbackSubmitData");
          if (coinToCashbackSubmitData.props.every((value) => value == 'NA')) {
            error('Not able to convert coins to cashback');
          } else {
            error('');
          }
          coinToCashbackSubmit(coinToCashbackSubmitData);
          print("COIN TO CASHBACK ID ${coinToCashbackSubmit.value.tranId}");
          updateCoinToCashbackSubmitDetails(
              coinToCashbackSubmit.value.remarks,
              coinToCashbackSubmit.value.status,
              coinToCashbackSubmit.value.transactionDate,
              coinToCashbackSubmit.value.tranId,
              coinToCashbackSubmit.value.amount);
        },
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    update();
  }

  updateCoinToCashbackSubmitDetails(
      String transactionRemarks,
      String transactionStatus,
      String date,
      String id,
      int transactionAmount) async {
    remarks = transactionRemarks;
    status = transactionStatus;
    transactionDate = date;
    transactionId = id;
    amount = transactionAmount;
    update();
  }
}
