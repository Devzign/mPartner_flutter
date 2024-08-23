class PaytmResponseModel {
  final String message;
  final String status;
  final String token;
  final PaytmOrderDetails data;
  final dynamic data1;

  PaytmResponseModel({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory PaytmResponseModel.fromJson(Map<String, dynamic> json) {
    return PaytmResponseModel(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      data: PaytmOrderDetails.fromJson(json['data'] ?? {}),
      data1: json['data1'],
    );
  }
}

class PaytmOrderDetails {
  final String orderId;
  final String paytmOrderId;
  final String amount;
  final String balance;
  final String? commissionAmount;
  final String? tax;
  final String? beneficiaryName;
  final String? reversalReason;
  final String processedOn;
  final String createdOn;
  final String status;
  final String message;
  final String redeemStatus;

  PaytmOrderDetails({
    required this.orderId,
    required this.paytmOrderId,
    required this.amount,
    required this.balance,
    this.commissionAmount,
    this.tax,
    this.beneficiaryName,
    this.reversalReason,
    required this.processedOn,
    required this.createdOn,
    required this.status,
    required this.message,
    required this.redeemStatus,
  });

  factory PaytmOrderDetails.fromJson(Map<String, dynamic> json) {
    return PaytmOrderDetails(
      orderId: json['orderId'] ?? '',
      paytmOrderId: json['paytmOrderId'] ?? '',
      amount: json['amount'] ?? '',
      balance: json['balance'] ?? '',
      commissionAmount: json['commissionAmount'],
      tax: json['tax'],
      beneficiaryName: json['beneficiaryName'],
      reversalReason: json['reversalReason'],
      processedOn: json['processedOn'] ?? '',
      createdOn: json['createdOn'] ?? '',
      status: json['status'] ?? '',
      message: json['message']??'',
      redeemStatus: json['redeemstatus'] ?? '',
    );
  }
}
