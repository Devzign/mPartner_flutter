class UPITransactionModel {
  final String message;
  final String status;
  final String token;
  final TransactionDataModel data;

  UPITransactionModel({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
  });

  factory UPITransactionModel.fromJson(Map<String, dynamic> json) {
    return UPITransactionModel(
      message: json['message'] ?? '',
      status: json['Status'] ?? '',
      token: json['token'] ?? '',
      data: TransactionDataModel.fromJson(json['data']),
    );
  }
}

class TransactionDataModel {
  final String seqNumber;
  final String pgMerchantId;
  final String errorCode;
  final String message;
  final String senderVpa;
  final String amount;
  final String responseCode;
  final String transactionStatus;
  final String orderNumber;
  final String drAccNo;
  final String drIfsc;
  final String drName;
  final String drAccType;
  final String crAccNo;
  final String crIfsc;
  final String crName;
  final String crAccType;
  final String txnId;
  final String receiverVpa;
  final String mapperId;
  final String txnDate;
  final String txnMessage;
  final String txnStatus;

  TransactionDataModel({
    required this.seqNumber,
    required this.pgMerchantId,
    required this.errorCode,
    required this.message,
    required this.senderVpa,
    required this.amount,
    required this.responseCode,
    required this.transactionStatus,
    required this.orderNumber,
    required this.drAccNo,
    required this.drIfsc,
    required this.drName,
    required this.drAccType,
    required this.crAccNo,
    required this.crIfsc,
    required this.crName,
    required this.crAccType,
    required this.txnId,
    required this.receiverVpa,
    required this.mapperId,
    required this.txnDate,
    required this.txnMessage,
    required this.txnStatus,
  });

  factory TransactionDataModel.fromJson(Map<String, dynamic> json) {
    return TransactionDataModel(
      seqNumber: json['seq_number'] ?? '',
      pgMerchantId: json['pgmerchant_Id'] ?? '',
      errorCode: json['error_code'] ?? '',
      message: json['message'] ?? '',
      senderVpa: json['sender_vpa'] ?? '',
      amount: json['amount'] ?? '',
      responseCode: json['responseCode'] ?? '',
      transactionStatus: json['transaction_status'] ?? '',
      orderNumber: json['order_number'] ?? '',
      drAccNo: json['dr_acc_no'] ?? '',
      drIfsc: json['dr_ifsc'] ?? '',
      drName: json['dr_name'] ?? '',
      drAccType: json['dr_acc_type'] ?? '',
      crAccNo: json['cr_acc_no'] ?? '',
      crIfsc: json['cr_ifsc'] ?? '',
      crName: json['cr_name'] ?? '',
      crAccType: json['cr_acc_type'] ?? '',
      txnId: json['txn_id'] ?? '',
      receiverVpa: json['reciever_vpa'] ?? '',
      mapperId: json['mapper_id'] ?? '',
      txnDate: json['txn_date']??'',
      txnMessage: json['txn_Msg']??'',
      txnStatus: json['txn_Status']??'',
    );
  }
}
