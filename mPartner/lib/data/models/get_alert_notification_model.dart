import 'package:equatable/equatable.dart';

enum ImageType {
  image,
  video,
  unknown,
}

class GetAlertNotificationResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final GetAlertNotificationData data;
  final dynamic data1;

  GetAlertNotificationResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory GetAlertNotificationResponse.fromJson(Map<String, dynamic> json) {
    return GetAlertNotificationResponse(
      message: json["message"],
      status: json["status"],
      token: json["token"],
      data: GetAlertNotificationData.fromJson(json["data"]),
      data1: json["data1"],
    );
  }

  @override
  List<Object?> get props => [message, status, token, data, data1];
}

class GetAlertNotificationData extends Equatable {
  final List<AlertNotification> result;
  final int id;
  final dynamic exception;
  final int status;
  final bool isCanceled;
  final bool isCompleted;
  final bool isCompletedSuccessfully;
  final int creationOptions;
  final dynamic asyncState;
  final bool isFaulted;

  GetAlertNotificationData({
    required this.result,
    required this.id,
    required this.exception,
    required this.status,
    required this.isCanceled,
    required this.isCompleted,
    required this.isCompletedSuccessfully,
    required this.creationOptions,
    required this.asyncState,
    required this.isFaulted,
  });

  factory GetAlertNotificationData.fromJson(Map<String, dynamic> json) {
    var resultList = json["result"] as List;
    List<AlertNotification> parsedResultList =
    resultList.map((result) => AlertNotification.fromJson(result)).toList();

    return GetAlertNotificationData(
      result: parsedResultList,
      id: json["id"],
      exception: json["exception"],
      status: json["status"],
      isCanceled: json["isCanceled"],
      isCompleted: json["isCompleted"],
      isCompletedSuccessfully: json["isCompletedSuccessfully"],
      creationOptions: json["creationOptions"],
      asyncState: json["asyncState"],
      isFaulted: json["isFaulted"],
    );
  }

  @override
  List<Object?> get props => [
    result,
    id,
    exception,
    status,
    isCanceled,
    isCompleted,
    isCompletedSuccessfully,
    creationOptions,
    asyncState,
    isFaulted,
  ];
}

class AlertNotification extends Equatable {
  final int id;
  final String text;
  final bool isread;
  final String imagename;
  final String imagepath;
  final String date;
  final String type;
  final int showFlag;
  String? imageFilePath;

  AlertNotification({
    required this.id,
    required this.text,
    required this.isread,
    required this.imagename,
    required this.imagepath,
    required this.date,
    required this.type,
    required this.showFlag,
    this.imageFilePath
  });

  void updateFilePath(String path) {
    imageFilePath = path;
  }

  factory AlertNotification.fromJson(Map<String, dynamic> json) {
    return AlertNotification(
      id: json["id"],
      text: json["text"],
      isread: json["isread"],
      imagename: json["imagename"],
      imagepath: json["imagepath"],
      date: json["date"],
      type: json["type"],
      showFlag: json["show_flag"],
    );
  }

  ImageType get imageType {
    return type == "image" ? ImageType.image : type == "video" ? ImageType.video : ImageType.unknown;
  }

  @override
  List<Object?> get props => [
    id,
    text,
    isread,
    imagename,
    imagepath,
    date,
    type,
    showFlag,
  ];
}

