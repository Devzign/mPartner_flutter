import 'package:get/get.dart';
import '../../data/datasource/solar_remote_data_source.dart';
import '../../data/models/request_tracking_model.dart';

class FinanceRequestTrackingController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;
  var requestTrackingDetails = <RequestTrackingDetails>[].obs;

  SolarRemoteDataSource solarRemoteDataSource = SolarRemoteDataSource();

  Future<void> fetchRequestTrackingStatus(String projectId) async {
    try {
      isLoading(true);
      final result = await solarRemoteDataSource.postRequestTracking(projectId);
      result.fold(
        (failure) {
          error('Failed to fetch request tracking details: $failure');
        },
        (response) {
          requestTrackingDetails.assignAll(response.data);
        },
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    update();
  }

  void clearRequestTrackingDetails() {
    isLoading(false);
    error("");
    requestTrackingDetails.clear();
  }
}
