import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/notification/notification_list_model.dart';
import '../../data/models/notification/read_notification_detail_on_id_model.dart';
import '../../data/models/notification/txn_details_model.dart';
import '../../utils/app_constants.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  var isPromoLoading = false.obs;
  var isReadLoading = false.obs;
  var txnLoading = true.obs;
  var notificationDetailLoading = false.obs;

  var error = ''.obs;
  var promoError = ''.obs;
  var isReadError = ''.obs;
  var txnError = ''.obs;
  var notificationDetailError = ''.obs;
  var currentTabIndex=0;
  NotificationData _notificationDetail = NotificationData(
      notificationId: 0,
      userId: "",
      notificationMessage: "",
      notificationText: "",
      isSent: false,
      fcmId: "",
      fcmIdWeb: "",
      notificationType: "",
      isRead: false,
      isDelete: false,
      createdOn: "",
      createdBy: "",
      modifiedOn: "",
      modifiedBy: "",
      navigationUrl: "",
      imagePath: "",
      isPromotional: true,
      navigationModule: "",
      notificationDetailBody: "",
      enableExplore: true,
      externalLink: "",
      transactionId: "",
      transactionType: "",
      dealerElectricianCode: "");

  List<NotificationData> notificationsList = [];
  List<NotificationData> promoNotificationsList = [];

  TransactionData _transactionData = TransactionData(
      status: "",
      redeemed: "",
      totalAmount: "0",
      transactionId: "",
      message: "",
      transactionDate: "",
      totalCoins: '',
      otpRemark: '',
      serialNumber: '',
      productType: '',
      modelName: '',
      customerName: '',
      customerPhone: '',
      saleRemark: '',
      redemptionMode: '',
      transMsg: '',
      remark: ''
  );

  var readNotificationDetailOnIdResponse = ReadNotificationDetailOnIdResponse(
    message: '',
    status: '',
    token: '',
    data: null,
    data1: null,
  ).obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  get getTransactionData => _transactionData;

  get getNotificationDetail => _notificationDetail;

  Future<void> fetchTransactionDetails({String? txnId, String? txnType}) async {
    try {
      txnLoading.value = true;
      final response = await mPartnerRemoteDataSource
          .fetchingTransactionDetails(txnId!, txnType!);
      response.fold((failure) {
        txnError('Failed to fetch notification details: $failure');
        logger.d('Error: Failed to fetch notification details: $failure');
      }, (txnResponse) {
        logger.i('Success to fetch notification details: ${txnResponse.data}');
        _transactionData = txnResponse.data[0];
        txnLoading.value = false;
      });
    } catch (e) {
      logger.e(e);
      txnLoading.value = false;
    } finally {
      txnLoading.value = false;
    }
  }

  Future<void> fetchNotificationsList({String? notificationType}) async {
    try {
      if (notificationsList.isEmpty) {
        isLoading(true);
      }
      final response = await mPartnerRemoteDataSource
          .fetchNotificationsList(notificationType!);
      response.fold((failure) {
        error('Failed to fetch notification details: $failure');
        logger.d('Error: Failed to fetch notification details: $failure');
      }, (notificationsResponse) {
        logger.i(
            'Success to fetch notification details: ${notificationsResponse.data}');
        notificationsList = notificationsResponse.data;
        isLoading.value = false;
      });
    } catch (e) {
      logger.e(e);
      if (notificationsList.isEmpty) isLoading(false);
    } finally {
      if (notificationsList.isEmpty) isLoading(false);
    }
  }

  Future<void> fetchNotificationsDetails(
      {required String notificationId}) async {
    try {
      notificationDetailLoading.value = true;
      final response = await mPartnerRemoteDataSource
          .fetchNotificationsDetails(notificationId);
      response.fold((failure) {
        error('Failed to fetch notification details: $failure');
        logger.d('Error: Failed to fetch notification details: $failure');
      }, (notificationsResponse) {
        logger.i(
            'Success to fetch notification details: ${notificationsResponse.data}');
        _notificationDetail = notificationsResponse.data;
        notificationDetailLoading.value = false;
      });
    } catch (e) {
      logger.e(e);
      notificationDetailLoading.value = false;
    } finally {
      notificationDetailLoading.value = false;
    }
  }

  Future<void> fetchPromoNotificationsList({String? notificationType}) async {
    try {
      if (promoNotificationsList.isEmpty) {
        isPromoLoading(true);
      }
      final response = await mPartnerRemoteDataSource
          .fetchNotificationsList(notificationType!);
      response.fold((failure) {
        promoError('Failed to fetch notification details: $failure');
        logger.d('Error: Failed to fetch notification details: $failure');
      }, (notificationsResponse) {
        logger.i(
            'Success to fetch notification details: ${notificationsResponse.data}');
        promoNotificationsList = notificationsResponse.data;
        isPromoLoading.value = false;
      });
    } catch (e) {
      logger.e(e);
      if (promoNotificationsList.isEmpty) isPromoLoading(false);
    } finally {
      if (promoNotificationsList.isEmpty) isPromoLoading(false);
    }
  }

  Future<void> updateNotificationAsRead({String? notificationId}) async {
    try {
      final response = await mPartnerRemoteDataSource
          .postReadNotificationDetailOnId(notificationId!);
      response.fold((failure) {
        error(
            'Failed to fetch Read Notification Detail On Id Response: $failure');
        logger.d(
            'Error: Failed to fetch Read Notification Detail On Id Response: $failure');
      }, (response) {
        readNotificationDetailOnIdResponse(response);
        logger.i(
            'Success to fetch Read Notification Detail On Id Response: ${response.message}');
      });
    } catch (e) {
      logger.e(e);
    } finally {
      // isLoading(false);
    }
  }

  Future<bool?> clearNotification({int? notificationDeleteType, bool? isPromotional }) async {
    try {
      final response = await mPartnerRemoteDataSource
          .deleteNotificationByType(notificationDeleteType!,isPromotional!);
      response.fold((failure) {
        error(
            'Failed to fetch Read Notification Detail On Id Response: $failure');
        logger.d(
            'Error: Failed to fetch Read Notification Detail On Id Response: $failure');
      }, (response) {

       // readNotificationDetailOnIdResponse(response);
        logger.i(
            'Success to fetch Read Notification Detail On Id Response: ${response.message}');
      });
    } catch (e) {
      logger.e(e);
    } finally {
      // isLoading(false);
    }
  }


  static String parseNotificationDate(String createdOn) {
    DateTime createdAt = DateTime.parse(createdOn);
    DateTime now = DateTime.now();
    var hours = createdAt.hour > 12 ? createdAt.hour - 12 : createdAt.hour;
    //  logger.d("now year: ${now.year} hours: $hours");
    // Check if it's today
    if (createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day) {
      return '$hours:${createdAt.minute > 9 ? createdAt.minute : '0${createdAt.minute}'} ${createdAt.hour < 12 ? 'AM' : 'PM'}';
    }

    // Check if it's yesterday
    DateTime yesterday = now.subtract(const Duration(days: 1));
    if (createdAt.year == yesterday.year &&
        createdAt.month == yesterday.month &&
        createdAt.day == yesterday.day) {
      return 'Yesterday at ${hours}:${createdAt.minute > 9 ? createdAt.minute : '0${createdAt.minute}'} ${createdAt.hour < 12 ? 'AM' : 'PM'}';
    }

    // Check if it's within the last 7 days
    if (now.difference(createdAt).inDays <= 7) {
      return '${_getDayName(createdAt.weekday)} at ${hours}:${createdAt.minute > 9 ? createdAt.minute : '0${createdAt.minute}'} ${createdAt.hour < 12 ? 'AM' : 'PM'}';
    }

    return '${createdAt.day} ${_getMonthName(createdAt.month)} ${createdAt.year} '
        'at $hours:${createdAt.minute > 9 ? createdAt.minute : '0${createdAt.minute}'} ${(createdAt.hour) < 12 ? 'AM' : 'PM'}';
  }

  static String _getDayName(int day) {
    // logger.d("_getDayName: $day");
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  static String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }

    // final date= createdOn.split('T');
    // try{
    //   logger.e("Otherwise, return in the specified format: $date");
    //   logger.d("Date: $date ${date[0]} Time: ${date[1]}");
    //
    //   var inputDateFormat = DateFormat('yyyy-MM-dd');
    //   var inputDate = inputDateFormat.parse(date[0]);
    //   var outputFormat = DateFormat('dd MMM yyyy');
    //   var displayDate = outputFormat.format(inputDate);
    //   logger.d("Otherwise, return in the specified format: $displayDate");
    //
    //   var inputTimeFormat = DateFormat('hh:mm:ss');
    //   var inputTime = inputTimeFormat.parse(date[1]);
    //   var outputTimeFormat = DateFormat('HH:mm a');
    //   var displayTime = outputTimeFormat.format(inputTime);
    //   logger.e("displayTime: $displayTime");
    //
    //   logger.e("displayTime: '$displayDate at $displayTime'");
    //   // Otherwise, return in the specified format
    //   // return '$displayDate at $displayTime';
    // } catch(e){
    //   e.printError();
    // }
  }

  @override
  void onInit() async {
    super.onInit();
    update();
  }

  clearNotificationController() {
    isLoading = true.obs;
    notificationsList = [];
    update();
  }
}
