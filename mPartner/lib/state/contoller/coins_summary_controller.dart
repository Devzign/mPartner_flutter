import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/coins_summary_model.dart';

class CoinsSummaryController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;
  var availableCoins = "0";
  var earnedCoins = "0";
  var redeemedCoins = "0";
  var pendingCoins = "0";
  var fromDate = "";
  var toDate = "";
  String creditCount = "0";
  String debitCount = "0";
  var bonusCoins = "0".obs;

  var coinsSummary = const CoinsSummary(
          userID: "",
          availableCoins: "",
          creditCoins: "",
          debitCoins: "",
          pendingCoins: "",
          rejectedCoins: "",
          bonusCoins: " ",
          creditCount: 0,
          debitCount: 0,
          fromDate: "",
          toDate: "")
      .obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();
  void fetchCoinsSummary(
      {String fromDate = "", String toDate = "", String? code}) async {
    try {
      isLoading.value = true;
      final result = await mPartnerRemoteDataSource.postCoinsSummary(
          fromDate: fromDate, toDate: toDate, dealerCode: code);
      isLoading.value = false;

      result.fold(
        (failure) {
          // Handle failure (Left)
          error('Failed to fetch Coins Summary information: $failure');
        },
        (coinsSummaryData) {
          if (coinsSummaryData.props.every((value) => value == 'NA')) {
            error('Not able to convert coins to cashback');
          } else {
            error('');
          }
          coinsSummary(coinsSummaryData);
          updateAvailableCoins(coinsSummary.value.availableCoins);
          updateEarnedCoins(coinsSummary.value.creditCoins);
          updateRedeemedCoins(coinsSummary.value.debitCoins);
          updateBonusCoins(coinsSummary.value.bonusCoins);
          updatePendingCoins(coinsSummary.value.pendingCoins);
          updateCreditCount(coinsSummary.value.creditCount.toString());
          updateDebitCount(coinsSummary.value.debitCount.toString());
          updateFromDate(coinsSummary.value.fromDate.toString());
          updateToDate(coinsSummary.value.toDate.toString());
        },
      );
    } catch (e) {
      print(e);
    } finally {}
  }

  @override
  void onInit() async {
    super.onInit();
    update();
  }

  updateAvailableCoins(String coins) async {
    availableCoins = coins;
    update();
  }

  updateEarnedCoins(String coins) async {
    earnedCoins = coins;
    update();
  }

  updateRedeemedCoins(String coins) async {
    redeemedCoins = coins;
    update();
  }

  updateBonusCoins(String coins) async {
    bonusCoins.value = coins;
    update();
  }

  updatePendingCoins(String coins) async {
    pendingCoins = coins;
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

  clearCoinSummaryData({String? code}) {
    fetchCoinsSummary(code: code);
    update();
  }

  clearCoinSummary() {
    fromDate = "";
    toDate = "";
    isLoading = false.obs;
    error = ''.obs;
    availableCoins = "0";
    earnedCoins = "0";
    redeemedCoins = "0";
    bonusCoins.value = "0";
    pendingCoins = "0";
    update();
  }
}
