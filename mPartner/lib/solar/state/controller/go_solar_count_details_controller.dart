import 'package:get/get.dart';

import '../../../utils/app_constants.dart';
import '../../data/datasource/solar_remote_data_source.dart';
import '../../data/models/go_solar_count_details_model.dart';

class GoSolarCountDetailsController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;
  var totalFinanceRequests = 0.obs;
  var totalDesignRequests = 0.obs;
  var totalExecutionRequests = 0.obs;

  var goSolarCountDetailsResponse = GoSolarCountDetailsResponse(
    message: '',
    status: 0,
    token: '',
    data: {},
    data1: null,
  ).obs;


  SolarRemoteDataSource solarRemoteDataSource = SolarRemoteDataSource();

  Future<void> fetchGoSolarCountDetails() async {
    try {
      isLoading(true);
      final result = await solarRemoteDataSource.postGoSolarCountDetails();
      result.fold(
            (failure) {
          error('Failed to fetch go Solar Count details: $failure');
        },
            (response) {
          goSolarCountDetailsResponse(response);
          if (response.data != null && response.data.isNotEmpty) {
            GoSolarCountDetailsResponse resultData = response;
            totalFinanceRequests.value = resultData.data['totalFinanceRequests'] ?? 0;
            totalDesignRequests.value = resultData.data['totalDesignRequests'] ?? 0;
            totalExecutionRequests.value = resultData.data['totalExecutionRequests'] ?? 0;
          } else {
            error("Error: Empty result data");
          }
        },
      );
    } catch (e) {
      error('Failed to fetch go Solar Count details');
    } finally {
      isLoading(false);
    }
  }

  clearGoSolarCountDetailsController() {
    isLoading.value = false;
    error.value = '';
    totalFinanceRequests.value = 0;
    totalDesignRequests.value = 0;
    totalExecutionRequests.value = 0;
    update();
  }
}
