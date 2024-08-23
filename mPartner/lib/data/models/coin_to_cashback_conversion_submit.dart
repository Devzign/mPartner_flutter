import 'package:equatable/equatable.dart';

class CoinToCashbackConversionSubmit extends Equatable {
  final String remarks;
  final String conversion_msg;
  final String html_Msg;
  final String status;
  final int amount;
  final String transactionDate;
  final String tranId;

  const CoinToCashbackConversionSubmit({
    required this.remarks,
    required this.conversion_msg,
    required this.html_Msg,
    required this.status,
    required this.amount,
    required this.transactionDate,
    required this.tranId,
  });

  @override
  List<Object> get props => [
    remarks,
    conversion_msg,
    html_Msg,
    status,
    amount,
    transactionDate,
    tranId
  ];

  factory CoinToCashbackConversionSubmit.fromJson(Map<String, dynamic> json) => CoinToCashbackConversionSubmit(
    remarks: json["remarks"],
    conversion_msg: json["conversion_msg"],
    html_Msg: json["html_Msg"],
    status: json["status"],
    amount: json["amount"],
    transactionDate: json["transactionDate"],
    tranId: json["tranId"],
  );
}