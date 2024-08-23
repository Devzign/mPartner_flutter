import 'package:get/get.dart';

import '../../data/datasource/solar_remote_data_source.dart';
// Import your Failure class

class SolarFinanceDashboardController extends GetxController {
  var enquiryCount = 0.obs;
  var approvedCount = 0.obs;
  var inProgressCount = 0.obs;
  var rejectedCount = 0.obs;
  var isLoading = false.obs;
  var error = ''.obs;

  SolarRemoteDataSource solarRemoteDataSource =
      SolarRemoteDataSource();

  Future<void> fetchFinancingRequests() async {
    try {
      isLoading(true);

      final result = await solarRemoteDataSource.getEnquiryCounts();
      result.fold(
        (failure) {
          error('Failed to fetch financing requests: $failure');
        },
        (financeRequests) {
          enquiryCount.value = financeRequests.data[0].totalEnQuiryCount;
          approvedCount.value = financeRequests.data[0].totalApprovedCount;
          inProgressCount.value = financeRequests.data[0].totalInProgressCount;
          rejectedCount.value = financeRequests.data[0].totalRejectedCount;
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

  clearSolarFinanceDashboard() {
    enquiryCount.value = 0;
    inProgressCount.value = 0;
    approvedCount.value = 0;
    rejectedCount.value = 0;
    isLoading(false);
    error("");
  }
}
