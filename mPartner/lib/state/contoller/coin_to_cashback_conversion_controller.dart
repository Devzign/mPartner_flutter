import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/coin_to_cashback_conversion_model.dart';

class CoinToCashbackConversionController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;
  int coinsForCashback = 0;
  int conversionRate = 0;
  List<dynamic>? rateList = [];

  var coinToCashbackConversion = CoinToCashbackConversion(
          applicableRate: "",
          conversionRate: 0,
          nearest_Slab_Note: "",
          rateList: [],
          finalCoins: 0,
          totalCashReward: 0)
      .obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  void fetchCoinToCashbackConversion(
      String coins, String available, int redeemable) async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource
          .postCoinsToCashbackConversion(coins, available, redeemable);

      result.fold(
        (failure) {
          // Handle failure (Left)
          error('Failed to fetch Cashback information: $failure');
        },
        (coinToCashbackConversionData) {
          print("Cashback data from api call $coinToCashbackConversionData");

          if (coinToCashbackConversionData.props
              .every((value) => value == 'NA')) {
            error('Not able to convert coins to cashback');
          } else {
            error('');
          }
          rateList = coinToCashbackConversionData.rateList;
          coinToCashbackConversion(coinToCashbackConversionData);
          updateCoinsForCashback(coinToCashbackConversion.value.finalCoins);
          updateConversionRate(coinToCashbackConversion.value.conversionRate);
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

  updateCoinsForCashback(int coins) async {
    coinsForCashback = coins;
    update();
  }

  updateConversionRate(int coins) async {
    conversionRate = coins;
    update();
  }
}
