class PinelabVerifyMobileNoGst {
  final String message;
  final String status;
  final String token;
  final String data;
  final String data1;

  PinelabVerifyMobileNoGst({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory PinelabVerifyMobileNoGst.fromJson(Map<String, dynamic> json) {
    return PinelabVerifyMobileNoGst(
      message: json['message'] ?? "",
      status: json['status'] ?? "",
      token: json['token'] ?? "",
      data: json['data'] ?? "",
      data1: json['data1'] ?? "",
    );
  }
}
