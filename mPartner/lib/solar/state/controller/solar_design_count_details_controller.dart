import 'package:get/get.dart';

import '../../../utils/app_constants.dart';
import '../../data/datasource/solar_remote_data_source.dart';
import '../../data/models/solar_design_count_details_model.dart';


class SolarDesignCountDetailsController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;
  var totalDesignRequestsCount = 0.obs;
  var designsSharedCount = 0.obs;
  var designsPendingCount = 0.obs;
  var designReassignedCount = 0.obs;

  var solarDesignCountDetailsResponse = SolarDesignCountDetailsResponse(
    message: '',
    status: '',
    token: '',
    data: {},
    data1: null,
  ).obs;

  SolarRemoteDataSource solarRemoteDataSource = SolarRemoteDataSource();

  Future<void> fetchSolarDesignCountDetails(bool isDigital) async {
    SolarDesignCountDetailsResponse? solarDesignCountDetails;
    try {
      isLoading(true);
      final result = await solarRemoteDataSource.postSolarDesignCountDetails(isDigital);
      result.fold(
            (failure) {
          error('Failed to fetch solar design count details: $failure');
        },
            (response) {
          solarDesignCountDetailsResponse(response);
          SolarDesignCountDetailsResponse? resultData = response.data.isNotEmpty
              ? response
              : null;
          logger.d('Solar Design Count Result ${resultData?.data}');
          if (resultData != null) {
            solarDesignCountDetails = resultData;
            totalDesignRequestsCount.value = solarDesignCountDetails?.data['totalDesignsRequestCount'] ?? 0;
            designsSharedCount.value = solarDesignCountDetails?.data['totalDesignsSharedCount'] ?? 0;
            designsPendingCount.value = solarDesignCountDetails?.data['totalDesignsPendingCount'] ?? 0;
            designReassignedCount.value = solarDesignCountDetails?.data['totalDesignsReassignedCount'] ?? 0;
          } else {
            error("Error: Empty result data");
          }
        },
      );
    } catch (e) {
      isLoading(false);
      error('Failed to fetch solar design count details');
    } finally {
      isLoading(false);
    }
  }

  clearSolarDesignCountDetailsController() {
    isLoading.value = false;
    error = ''.obs;
    totalDesignRequestsCount.value = 0;
    designsSharedCount.value = 0;
    designsPendingCount.value = 0;
    designReassignedCount.value = 0;
    update();
  }
}