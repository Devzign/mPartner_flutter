import 'package:equatable/equatable.dart';

enum NotificationType {
  myActivity,
  promotional,
  unknown,
}

NotificationType parseNotificationType(String type) {
  switch (type) {
    case "myactivity":
      return NotificationType.myActivity;
    case "promotional":
      return NotificationType.promotional;
    default:
      return NotificationType.unknown;
  }
}

class NotificationListResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final List<NotificationData> data;
  final dynamic data1;

  const NotificationListResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json["data"] as List;
    List<NotificationData> parsedDataList =
        dataList.map((data) => NotificationData.fromJson(data)).toList();

    return NotificationListResponse(
      message: json["message"],
      status: json["status"],
      token: json["token"],
      data: parsedDataList,
      data1: json["data1"],
    );
  }

  @override
  List<Object?> get props => [message, status, token, data, data1];
}

class NotificationData extends Equatable {
  int notificationId;
  String userId;
  String notificationMessage;
  String notificationText;
  bool isSent;
  String fcmId;
  String fcmIdWeb;
  String notificationType;
  bool isRead;
  bool isDelete;
  String createdOn;
  String createdBy;
  String modifiedOn;
  String modifiedBy;
  String navigationUrl;
  String imagePath;
  bool isPromotional;
  String navigationModule;
  String notificationDetailBody;
  bool enableExplore;
  String externalLink;
  String transactionId;
  String transactionType;
  String dealerElectricianCode;

  NotificationData({
    required this.notificationId,
    required this.userId,
    required this.notificationMessage,
    required this.notificationText,
    required this.isSent,
    required this.fcmId,
    required this.fcmIdWeb,
    required this.notificationType,
    required this.isRead,
    required this.isDelete,
    required this.createdOn,
    required this.createdBy,
    required this.modifiedOn,
    required this.modifiedBy,
    required this.navigationUrl,
    required this.imagePath,
    required this.isPromotional,
    required this.navigationModule,
    required this.notificationDetailBody,
    required this.enableExplore,
    required this.externalLink,
    required this.transactionId,
    required this.transactionType,
    required this.dealerElectricianCode,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
        notificationId: json["notificationId"] ?? 0,
        userId: json["userId"] ?? "",
        notificationMessage: json["notificationMessage"] ?? "",
        notificationText: json["notificationText"] ?? "",
        isSent: json["isSent"],
        fcmId: json["fcmId"] ?? "",
        fcmIdWeb: json["fcmId_Web"] ?? "",
        notificationType: json["notificationType"] ?? "",
        isRead: json["isRead"],
        isDelete: json["isDelete"],
        createdOn: json["createdOn"] ?? "",
        createdBy: json["createdBy"] ?? "",
        modifiedOn: json["modifiedOn"] ?? "",
        modifiedBy: json["modifiedBy"] ?? "",
        navigationUrl: json["navigationUrl"] ?? "",
        imagePath: json["imagePath"] ?? "",
        isPromotional: json["isPromotional"] ?? false,
        navigationModule: json["navigationModule"] ?? "",
        notificationDetailBody: json["notificationDetailBody"] ?? "",
        enableExplore: json["enableExplore"] ?? false,
        externalLink: json["externalLink"] ?? "",
        transactionId: json["transactionId"] ?? "",
        transactionType: json["transactionType"] ?? "",
        dealerElectricianCode: json["userCode"] ?? "");
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        notificationId,
        userId,
        notificationMessage,
        notificationText,
        isSent,
        fcmId,
        fcmIdWeb,
        notificationType,
        isRead,
        isDelete,
        createdOn,
        createdBy,
        modifiedOn,
        modifiedBy,
        navigationUrl,
        imagePath,
        isPromotional,
        navigationModule,
        notificationDetailBody,
        enableExplore,
        externalLink,
        transactionId,
        transactionType,
        dealerElectricianCode
      ];
}
