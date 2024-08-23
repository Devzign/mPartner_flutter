import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/cash_redemption_options_model.dart';

class CashRedemptionOptionsController extends GetxController {
  List<String?> iconKeys = [];
  List<String?> iconURLs = [];
  bool isPayTmAvailable = false;
  bool isPinelabAvailable = false;
  bool isUpiAvailable = false;

  var isLoading = false;
  var error = '';

  var cashRedemptionOptions =
      CashRedemptionOptions(id: 0, name: "", key: "", icon: "", message: "", displayText: "", expendedImage: "", description: "");

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  void fetchCashRedemptionOptions() async {
    try {
      isLoading = true;

      final result = await mPartnerRemoteDataSource.postCashRedemptionOptions();

      result.fold(
        (failure) {
          // Handle failure (Left)
          error =
              'Failed to fetch cash redemption options information: $failure';
        },
        (cashRedemptionOptionsData) async {
          for (var option in cashRedemptionOptionsData) {
            if (option.props.every((value) => value == 'NA')) {
              error = 'No cash redemption available.';
            } else {
              error = '';
            }
            iconKeys =
                cashRedemptionOptionsData.map((option) => option.displayText).toList();

            if (option.key?.toLowerCase() == 'upi') isUpiAvailable = true;
            if (option.key?.toLowerCase() == 'paytm') isPayTmAvailable = true;
            if (option.key?.toLowerCase() == 'pinelab')
              isPinelabAvailable = true;

            iconURLs =
                cashRedemptionOptionsData.map((option) => option.icon).toList();
            cashRedemptionOptions = option;
          }
          update();
        },
      );
    } catch (e) {
      isLoading = false;
      error = 'Failed to fetch Cash redemption options';
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  clearCashRedemptionOptionsState() {
    iconKeys = [];
    iconURLs = [];

    isLoading = false;
    error = '';

    cashRedemptionOptions =
        CashRedemptionOptions(id: 0, name: "", key: "", icon: "", message: "");
    update();
  }
}
