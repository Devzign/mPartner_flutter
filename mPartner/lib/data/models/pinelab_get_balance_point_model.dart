class PinelabBalancePoint {
  final String message;
  final String status;
  final String token;
  final dynamic data;
  final String data1;

  PinelabBalancePoint({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory PinelabBalancePoint.fromJson(Map<String, dynamic> json) {
    return PinelabBalancePoint(
      message: json['message'] ?? "",
      status: json['status'] ?? "",
      token: json['token'] ?? "",
      data: (json['data'] is String)? '' : AccountSummary.fromJson(json['data']),
      data1: json['data1'] ?? "",
    );
  }
}

class AccountSummary {
  final String cardNumber;
  final String cardBalance;

  AccountSummary({
    required this.cardNumber,
    required this.cardBalance,
  });

  factory AccountSummary.fromJson(Map<String, dynamic> json) {
    return AccountSummary(
      cardNumber: json['cardNumber'] ?? "",
      cardBalance: json['cardBalance'] ?? "",
    );
  }
}
