import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/save_terms_condition_model.dart';

class SaveTermsConditionController extends GetxController {
  bool showLoader = true;
  var isLoading = false.obs;
  var error = ''.obs;

  var saveTermsConditionResponse = SaveTermsConditionResponse(
    message: '',
    status: '',
    token: '',
    data: null,
    data1: null,
  ).obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource = MPartnerRemoteDataSource();

  Future<void> fetchSaveTermsCondition(String id) async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.updateTermsCondition(id);

      result.fold(
            (failure) {
          error('Failed to fetch Save Terms Condition: $failure');
        },
            (saveTermsConditionResponseData) {
              saveTermsConditionResponse(saveTermsConditionResponseData);
        },
      );
    } finally {
      showLoader = false;
      isLoading(false);
    }
  }

  clearSaveTermsConditionController() {
    isLoading = true.obs;
    showLoader = true;
    update();
  }
}
