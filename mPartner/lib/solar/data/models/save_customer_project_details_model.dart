class SaveCustomerProjectDetailsResponse {
  final String message;
  final String status;
  final String token;
  final RequestId? data;

  SaveCustomerProjectDetailsResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
  });

  factory SaveCustomerProjectDetailsResponse.fromJson(Map<String, dynamic> json) {
    return SaveCustomerProjectDetailsResponse(
      message: json['message'] ?? "",
      status: json['status'] ?? "",
      token: json['token'] ?? "",
      data: json['data'] != null ? RequestId.fromJson(json['data']) : null,
    );
  }
}

class RequestId {
  final String requestId;

  RequestId({
    required this.requestId,
  });

  factory RequestId.fromJson(Map<String, dynamic> json) {
    return RequestId(
      requestId: json['requestId']??"",
    );
  }
}
