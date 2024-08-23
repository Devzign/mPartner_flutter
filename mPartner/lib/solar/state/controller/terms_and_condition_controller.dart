import 'package:get/get.dart';

import '../../../data/models/terms_condition_model.dart';
import '../../../services/services_locator.dart';
import '../../data/datasource/solar_remote_data_source.dart';

class TermsAndConditionController extends GetxController {
  var isLoading = true.obs;
  var error = ''.obs;
  var termsAndConditionRes = <TermsConditionsResponse>{}.obs;

  fetchTermsAndCondition(String pageName) async {
    try {
      isLoading(true);
      BaseSolarRemoteDataSource baseSolarRemoteDataSource = s2<BaseSolarRemoteDataSource>();
      final result = await baseSolarRemoteDataSource.getTermsAndConditionList(pageName);

      result.fold(
            (l) => error("Error: $l"),
            (r) async {
          if (r.data.isNotEmpty && r.status == '200') {
            termsAndConditionRes.assign(r);
          }
        },
      );
    } catch (e) {
      error("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  clearTermsAndConditionController() {
    isLoading = true.obs;
    error = ''.obs;
    termsAndConditionRes = <TermsConditionsResponse>{}.obs;
    update();
  }
}
