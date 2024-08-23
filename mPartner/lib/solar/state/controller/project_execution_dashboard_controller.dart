import 'package:get/get.dart';
import '../../data/datasource/solar_remote_data_source.dart';
import '../../network/api_constants.dart';
import '../../utils/solar_app_constants.dart';
// Import your Failure class

class ProjectExecutionDashboardController extends GetxController {
  var totalRequestCount = 0.obs;
  var resolvedCount = 0.obs;
  var inProgressCount = 0.obs;
  var rescheduledCount = 0.obs;
  var isLoading = false.obs;
  var error = ''.obs;

  SolarRemoteDataSource solarRemoteDataSource =
  SolarRemoteDataSource();

  Future<void> fetchProjectExecutionDashboardData(String typeValue) async {
    try {
      isLoading(true);
      String typeValueString="Online";
      if(typeValue==SolarAppConstants.online){
        typeValueString="Online";
      }
      else if (typeValue==SolarAppConstants.onsite){
        typeValueString="Onsite";
      }
      else if (typeValue==SolarAppConstants.endToEnd){
        typeValueString="End-to-end";
      }
      final result = await solarRemoteDataSource.getProjectExecutionDashboardData(typeValueString);
      result.fold(
            (failure) {
          error('Failed to fetch financing requests: $failure');
        },
            (financeRequests) {
              totalRequestCount.value = financeRequests.data[0].totalRequestCount;
              resolvedCount.value = financeRequests.data[0].resolvedCount;
          inProgressCount.value = financeRequests.data[0].inProgressCount;
              rescheduledCount.value = financeRequests.data[0].rescheduledCount;
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

  clearProjectExecutionDashboard() {
    totalRequestCount.value = 0;
    inProgressCount.value = 0;
    resolvedCount.value = 0;
    rescheduledCount.value = 0;
    isLoading(false);
    error("");
  }
}
