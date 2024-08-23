import 'package:equatable/equatable.dart';

import '../../utils/app_string.dart';

class CoinHistory extends Equatable {
  String message;
  String status;
  String token;
  List<CoinTransHistory> coinTransHistory;
  List<CoinTransSummary> coinTransSummary;
  CoinHistory({
    required this.message,
    required this.status,
    required this.token,
    required this.coinTransHistory,
    required this.coinTransSummary,
  });

  factory CoinHistory.fromJson(Map<String, dynamic> json) => CoinHistory(
    message: json["message"],
    status: json["status"],
    token: json["token"],
    coinTransHistory: List<CoinTransHistory>.from((json["data"] as List).map((x) => CoinTransHistory.fromJson(x))),
    coinTransSummary: List<CoinTransSummary>.from((json["data1"] as List).map((x) => CoinTransSummary.fromJson(x))),
  );

  @override
  List<Object?> get props => [message,status,token,coinTransHistory,coinTransSummary];

}

class CoinTransHistory {
  final String userId;
  final String transDate;
  final int coins;
  final String serial_no;
  final String creditStatus;
  final String debitStatus;
  final String description;
  final String transactionType;
  final String model;
  final String saleType;
  final int convertedCash;
  final String redemptionMode;
  final String category;
  final String remark;
  final String otpRemark;
  final String customerName;
  final String customerPhone;

  CoinTransHistory({
    required this.userId,
    required this.transDate,
    required this.coins,
    required this.serial_no,
    required this.creditStatus,
    required this.debitStatus,
    required this.description,
    required this.transactionType,
    required this.model,
    required this.saleType,
    required this.convertedCash,
    required this.redemptionMode,
    required this.category,
    required this.remark,
    required this.otpRemark,
    required this.customerName,
    required this.customerPhone,
  });

  factory CoinTransHistory.fromJson(Map<String, dynamic> json) {
    return CoinTransHistory(
      userId: json["userId"] as String? ?? '',
      transDate: json["transDate"] as String? ?? '',
      coins: json["coins"] as int? ?? 0,
      serial_no: json["serial_no"] as String? ?? '',
      creditStatus: json["creditStatus"] as String? ?? '',
      debitStatus: json["debitStatus"] as String? ?? '',
      description: json["description"] as String? ?? '',
      transactionType: json["transactionType"] as String? ?? '',
      model: json["model"] as String? ?? '',
      saleType: json["saleType"] as String? ?? '',
      convertedCash: json["convertedCash"] as int? ?? 0,
      redemptionMode: json["redemptionMode"] as String? ?? '',
      category: json["category"] as String? ?? '',
      remark: json["remark"] as String? ?? '',
      otpRemark: json["otpRemark"] as String? ?? '',
      customerName: json["customerName"] as String? ?? '',
      customerPhone: json["customerPhone"] as String? ?? '',
    );
  }

}
class CoinTransSummary {
  int creditCount;
  int earned;
  int debitCount;
  int reedemed;
  String fromDate;
  String toDate;

  CoinTransSummary({
    required this.creditCount,
    required this.earned,
    required this.debitCount,
    required this.reedemed,
    required this.fromDate,
    required this.toDate,
  });

  factory CoinTransSummary.fromJson(Map<String, dynamic> json) => CoinTransSummary(
    creditCount: json["creditCount"],
    earned: json["earned"],
    debitCount: json["debitCount"],
    reedemed: json["reedemed"],
    fromDate: json["fromDate"],
    toDate: json["toDate"],
  );

}

