import 'package:equatable/equatable.dart';

class ApiResponse {
  final String message;
  final String status;
  final String token;
  final List<ApiResponseDataItem> data;
  final String data1;

  ApiResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json["message"]??'',
      status: json["status"]??'',
      token: json["token"]??'',
      data: (json["data"] as List)
          .map((item) => ApiResponseDataItem.fromJson(item))
          .toList()??[],
      data1: json["data1"]??'',
    );
  }
}

class ApiResponseDataItem {
  final String wrsEntryStatus;
  final String wrsPrimaryDetails;
  final int serialsNoCount;
  final String modelName;

  ApiResponseDataItem({
    required this.wrsEntryStatus,
    required this.wrsPrimaryDetails,
    required this.serialsNoCount,
    required this.modelName,
  });

  factory ApiResponseDataItem.fromJson(Map<String, dynamic> json) {
    return ApiResponseDataItem(
      wrsEntryStatus: json["wrs_entry_status"]??'',
      wrsPrimaryDetails: json["wrs_primary_details"]??'',
      serialsNoCount: json["serialsNoCount"]??0,
      modelName: json["modelName"]??"",

    );
  }
}
