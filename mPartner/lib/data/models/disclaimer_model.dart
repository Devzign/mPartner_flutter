class DisclaimerResponse {
  final String message;
  final String status;
  final String token;
  final List<DisclaimerData> data;

  DisclaimerResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
  });

  factory DisclaimerResponse.fromJson(Map<String, dynamic> json) {
    return DisclaimerResponse(
      message: json['message'],
      status: json['status'],
      token: json['token'],
      data: (json['data'] as List)
          .map((item) => DisclaimerData.fromJson(item))
          .toList(),
    );
  }
}

class DisclaimerData {
  final String disclaimerData;

  DisclaimerData({required this.disclaimerData});

  factory DisclaimerData.fromJson(Map<String, dynamic> json) {
    return DisclaimerData(
      disclaimerData: json['disclaimerContent'],
    );
  }
}

