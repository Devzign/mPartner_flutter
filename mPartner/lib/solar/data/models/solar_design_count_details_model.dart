import 'package:equatable/equatable.dart';

class SolarDesignCountDetailsResponse {
  final String message;
  final String status;
  final String? token;
  final Map<String, int> data;
  final dynamic data1;

  SolarDesignCountDetailsResponse({
    required this.message,
    required this.status,
    this.token,
    required this.data,
    this.data1,
  });

  factory SolarDesignCountDetailsResponse.fromJson(Map<String, dynamic> json) {
    return SolarDesignCountDetailsResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'],
      data: {
        'totalDesignsRequestCount': json['data']['totalDesignsRequestCount'] ?? 0,
        'totalDesignsSharedCount': json['data']['totalDesignsSharedCount'] ?? 0,
        'totalDesignsPendingCount': json['data']['totalDesignsPendingCount'] ?? 0,
        'totalDesignsReassignedCount': json['data']['totalDesignsReassignedCount'] ?? 0,
      },
      data1: json['data1'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'token': token,
      'data': data,
      'data1': data1,
    };
  }
}