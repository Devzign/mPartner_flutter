import 'package:equatable/equatable.dart';

class GoSolarCountDetailsResponse {
  final String message;
  final int status;
  final String token;
  final Map<String, int> data;
  final dynamic data1;

  GoSolarCountDetailsResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory GoSolarCountDetailsResponse.fromJson(Map<String, dynamic> json) {
    return GoSolarCountDetailsResponse(
      message: json['message'] ?? '',
      status: int.parse(json['status'] ?? '0'),
      token: json['token'] ?? '',
      data: {
        'totalFinanceRequests': json['data'][0]['totalFinanceRequests'] ?? 0,
        'totalDesignRequests': json['data'][0]['totalDesignRequests'] ?? 0,
        'totalExecutionRequests': json['data'][0]['totalExecutionRequests'] ?? 0,
      },
      data1: json['data1'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status.toString(),
      'token': token,
      'data': [
        {
          'totalFinanceRequests': data['totalFinanceRequests'],
          'totalDesignRequests': data['totalDesignRequests'],
          'totalExecutionRequests': data['totalExecutionRequests'],
        }
      ],
      'data1': data1,
    };
  }
}
