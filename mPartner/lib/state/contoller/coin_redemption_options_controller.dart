import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/coin_redemption_options_model.dart';

class CoinRedemptionOptionsController extends GetxController {
  List<String?> iconKeys = [];
  List<String?> iconURLs = [];
  List<String> gifURLs = [];
  List<String> headings = [];
  List<String> subHeadings = [];
  int redeemableBalance = 0;
  String redeemText = "";

  var isLoading = false.obs;
  var error = ''.obs;

  var coinRedemptionOptions = CoinRedemptionOptions(
    nextPage_TripMsg: "",
    availableCoinsBalance: 0,
    redeemableCoinsBalance: 0,
    redeemText : "",
    redeemOptions: [],
  ).obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchCoinRedemptionOptions() async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postCoinRedemptionOptions();
      result.fold(
        (failure) {
          // Handle failure (Left)
          error(
              'Failed to fetch cash redemption options information: $failure');
        },
        (coinRedemptionOptionsData) async {
          for (var option in coinRedemptionOptionsData.redeemOptions ?? []) {
            if (option.props.every((value) => value == 'NA')) {
              error('No coin redemption available.');
            } else {
              error('');
            }

            if (!iconURLs.contains(option.url)) iconURLs.add(option.url);
            if (!iconKeys.contains(option.type)) iconKeys.add(option.type);
            if (!gifURLs.contains(option.urlGif)) gifURLs.add(option.urlGif);
            if (!headings.contains(option.label)) headings.add(option.label);
            if (!subHeadings.contains(option.remarks))
              subHeadings.add(option.remarks);
          }

          coinRedemptionOptions(coinRedemptionOptionsData);
          updateRedemptionOptions(
              coinRedemptionOptions.value.redeemableCoinsBalance ?? 0, coinRedemptionOptions.value.redeemText ?? "");
        },
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await fetchCoinRedemptionOptions();
    update();
  }

  updateRedemptionOptions(int coins, String text) async {
    redeemableBalance = coins;
    redeemText = text;
    update();
  }
}
