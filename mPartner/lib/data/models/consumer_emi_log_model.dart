class ConsumerEmiLog {
  final String message;
  final String status;
  final String token;
  final dynamic data;
  final dynamic data1;

  ConsumerEmiLog({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory ConsumerEmiLog.fromJson(Map<String, dynamic> json) {
    return ConsumerEmiLog(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      data: json['data'],
      data1: json['data1'],
    );
  }
}
