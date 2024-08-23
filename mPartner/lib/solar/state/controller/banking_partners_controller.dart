import 'package:get/get.dart';

import '../../../services/services_locator.dart';
import '../../data/datasource/solar_remote_data_source.dart';
import '../../data/models/get_loan_scheme_model.dart';
import '../../data/models/preferred_bank_response.dart';


class BankingPartnersController extends GetxController {
  var isLoading = true.obs;
  var isSchemeLoading = true.obs;
  var error = ''.obs;
  var errorLoadingPdf = ''.obs;
  var banksData = <PreferredBank>[].obs;
  var loanScheme = <GetLoanSchemeModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
  }

  fetchPreferredBanksList() async {
    try {
      isLoading(true);
      BaseSolarRemoteDataSource baseSolarRemoteDataSource = s2<BaseSolarRemoteDataSource>();
      final result = await baseSolarRemoteDataSource.getPreferredBanksList();

      result.fold(
            (l) => error("Error: $l"),
            (r) async {
              if (r.data.isNotEmpty && r.status == '200') {
                // Sort the data by bank name
                r.data.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                banksData.assignAll(r.data);
              }
        },
      );
    } catch (e) {
      error("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  fetchLoanScheme(int bankId) async {
    try {
      isSchemeLoading(true);
      BaseSolarRemoteDataSource baseSolarRemoteDataSource = s2<BaseSolarRemoteDataSource>();
      final result = await baseSolarRemoteDataSource.getLoanScheme(bankId);

      result.fold(
            (l) => errorLoadingPdf("Error: $l"),
            (r) async {
          loanScheme.add(r);
        },
      );
    } catch (e) {
      errorLoadingPdf("Error: $e");
    } finally {
      isSchemeLoading(false);
    }
  }

  clearBankingPartnersController() {
    isSchemeLoading = true.obs;
    banksData = <PreferredBank>[].obs;
    error = ''.obs;
    errorLoadingPdf = ''.obs;
    loanScheme = <GetLoanSchemeModel>[].obs;
    update();
  }
}
