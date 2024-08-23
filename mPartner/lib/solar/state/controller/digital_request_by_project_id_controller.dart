import 'package:get/get.dart';

import '../../../utils/app_constants.dart';
import '../../data/datasource/solar_remote_data_source.dart';
import '../../data/models/digital_request_by_project_id_model.dart';

class DigitalRequestByProjectIdController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;
  var digitalRequestDataList = <DigitalRequestData>[].obs;

  SolarRemoteDataSource solarRemoteDataSource = SolarRemoteDataSource();

  Future<void> fetchDigitalRequestByProjectId(String projectId) async {
    try {
      isLoading(true);
      final result = await solarRemoteDataSource.postDigitalRequestByProjectId(projectId);
      result.fold(
            (failure) {
          error('Failed to fetch Digital Request By Project Id: $failure');
        },
            (response) {
          digitalRequestDataList.assignAll(response.data);
        },
      );
    } catch (e) {
      isLoading(false);
      error('Failed to fetch Digital Request By Project Id');
    } finally {
      isLoading(false);
    }
  }

  clearDigitalRequestByProjectId() {
    isLoading = true.obs;
    error = ''.obs;
    digitalRequestDataList.clear();
    update();
  }
}
