import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/get_alert_notification_model.dart';
import '../../utils/app_constants.dart';

class AlertNotificationController extends GetxController {
  List<AlertNotification> readAlertNotifications = [];
  bool showLoader = true;
  bool showAlerts = false;

  var isLoading = false.obs;
  var error = ''.obs;

  var getAlertNotificationResponse = GetAlertNotificationResponse(
    message: '',
    status: '',
    token: '',
    data: GetAlertNotificationData(
      result: [],
      id: 0,
      exception: null,
      status: 0,
      isCanceled: false,
      isCompleted: true,
      isCompletedSuccessfully: true,
      creationOptions: 0,
      asyncState: null,
      isFaulted: false,
    ),
    data1: null,
  ).obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource = MPartnerRemoteDataSource();

  Future<String> saveImageFile(AlertNotification notification) async {
    String url = notification.imagepath;
    String imageName = notification.imagename;
    Dio dio = Dio();
    
    var documentDirectory = await getApplicationDocumentsDirectory();
    var filePathAndName = '${documentDirectory.path}/images/$imageName'; 
    await dio.download(
      url,
      filePathAndName);
    return filePathAndName;
  }

  Future<void> fetchAlertNotifications() async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postAlertNotification();

      result.fold(
            (failure) {
          error('Failed to fetch alert notifications: $failure');
        },
            (getAlertNotificationResponseData) {
          getAlertNotificationResponse(getAlertNotificationResponseData);
          List<AlertNotification> resultList =
              getAlertNotificationResponseData.data.result;
          if (resultList.isNotEmpty) {
            readAlertNotifications =
                resultList.where((alert) => alert.isread == true).toList();
            if (readAlertNotifications.isEmpty) {
              showAlerts = false;
            } else {
              showAlerts = true;
            }
            logger.d(readAlertNotifications);
          } else {
            showAlerts = false;
            error("Error: Empty result list");
          }
        },
      );
    } finally {
      showLoader = false;
      isLoading(false);
    }
  }

  updateImageFile(int index) async{
    // We are going to download only 4 image banners after the respective index
    // If the final index i.e. index + 4 is smaller than the total length of the readAlertNotifications than we can traverse till index + 4
    // otherwise we will traverse only remaining elements from index + 1 to readAlertNotifications.length
    int traversalTill = ((index + AppConstants.bufferCount) < (readAlertNotifications.length - 1))
        ? (index + AppConstants.bufferCount)
        : (readAlertNotifications.length - 1);
    for (int i = index + 1; i <= traversalTill; i++) {
      var element = readAlertNotifications[i];
      if (element.imageFilePath != "") {
        if (element.imageType == ImageType.image) {
          String path = await saveImageFile(element);
          readAlertNotifications[i].imageFilePath = path;
        } else {
          readAlertNotifications[i].imageFilePath = "";
        }
        update();
      }
    }
  }

  removeFilePath(String path) {
    for (int i = 0; i < readAlertNotifications.length; i++) {
      if (readAlertNotifications[i].imageFilePath == path) {
        readAlertNotifications[i].imageFilePath = "";
        update();
        break;
      }
    }
  }
}

