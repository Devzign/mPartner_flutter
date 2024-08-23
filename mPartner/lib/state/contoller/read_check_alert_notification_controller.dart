import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/read_check_alert_notification_model.dart';

class ReadCheckAlertNotificationController extends GetxController {
  bool showLoader = true;
  var isLoading = false.obs;
  var error = ''.obs;

  var readCheckAlertNotificationResponse = ReadCheckAlertNotificationResponse(
    message: '',
    status: '',
    token: '',
    data: null,
    data1: null,
  ).obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource = MPartnerRemoteDataSource();

  Future<void> fetchReadCheckAlertNotification(String id) async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postReadCheckAlertNotification(id);

      result.fold(
            (failure) {
          error('Failed to fetch ReadCheckAlertNotification: $failure');
        },
            (readCheckAlertNotificationResponseData) {
          readCheckAlertNotificationResponse(readCheckAlertNotificationResponseData);
        },
      );
    } finally {
      showLoader = false;
      isLoading(false);
    }
  }
}
