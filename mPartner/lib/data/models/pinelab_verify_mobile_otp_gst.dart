class PinelabVerifyMobileOtpGst {
  final String message;
  final String status;
  final String token;
  final TransactionDetail data;
  final String data1;

  PinelabVerifyMobileOtpGst({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory PinelabVerifyMobileOtpGst.fromJson(Map<String, dynamic> json) {
    return PinelabVerifyMobileOtpGst(
      message: json['message'] ?? "",
      status: json['status'] ?? "",
      token: json['token'] ?? "",
      data: TransactionDetail.fromJson(json['data'] ?? {}),
      data1: json['data1'] ?? "",
    );
  }
}

class TransactionDetail {
  final String status;
  final String code;
  final String balancePoints;
  final String txnMessage;
  final String txnStatus;
  final String txnAmount;
  final String txnDate;
  final String txnID;

  TransactionDetail({
    required this.status,
    required this.code,
    required this.balancePoints,
    required this.txnMessage,
    required this.txnStatus,
    required this.txnAmount,
    required this.txnDate,
    required this.txnID,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      status: json['status'] ?? "",
      code: json['code'] ?? "",
      balancePoints: json['balancePoints'] ?? "",
      txnMessage: json['txnMessage'] ?? "",
      txnStatus: json['txnStatus'] ?? "",
      txnAmount: json['txnAmount'] ?? "",
      txnDate: json['txnDate'] ?? "",
      txnID: json['txnID'] ?? "",
    );
  }
}
