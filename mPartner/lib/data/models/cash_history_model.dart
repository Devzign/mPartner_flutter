import 'package:equatable/equatable.dart';

class CashHistory extends Equatable {
  String message;
  String status;
  String token;
  List<CashTransHistory> cashTransHistory;
  List<CashTransSummary> cashTransSummary;

  CashHistory({
    required this.message,
    required this.status,
    required this.token,
    required this.cashTransHistory,
    required this.cashTransSummary,
  });

  factory CashHistory.fromJson(Map<String, dynamic> json) => CashHistory(
        message: json["message"],
        status: json["status"],
        token: json["token"],
        cashTransHistory: List<CashTransHistory>.from(
            (json["data"] as List).map((x) => CashTransHistory.fromJson(x))),
        cashTransSummary: List<CashTransSummary>.from(
            (json["data1"] as List).map((x) => CashTransSummary.fromJson(x))),
      );

  @override
  List<Object?> get props =>
      [message, status, token, cashTransHistory, cashTransSummary];
}

class CashTransHistory {
  String acccode;
  String transDate;
  String saleType;
  String serial;
  String label;
  String model;
  String schemeType;
  String creditType;
  String creditStatus;
  String debitStatus;
  String remark;
  int points;
  String category;
  String otpRemark;
  String customerName;
  String customerPhone;
  String redemptionmode;

  CashTransHistory({
    required this.acccode,
    required this.transDate,
    required this.saleType,
    required this.serial,
    required this.label,
    required this.model,
    required this.schemeType,
    required this.creditType,
    required this.creditStatus,
    required this.debitStatus,
    required this.remark,
    required this.points,
    required this.category,
    required this.otpRemark,
    required this.customerName,
    required this.customerPhone,
    required this.redemptionmode,
  });

  factory CashTransHistory.fromJson(Map<String, dynamic> json) {
    return CashTransHistory(
      acccode: json["acccode"] as String? ?? '',
      transDate: json["transDate"] as String? ?? '',
      saleType: json["saleType"] as String? ?? '',
      serial: json["serial"] as String? ?? '',
      label: json["label"] as String? ?? '',
      model: json["model"] as String? ?? '',
      schemeType: json["schemeType"] as String? ?? '',
      creditType: json["creditType"] as String? ?? '',
      creditStatus: json["creditStatus"] as String? ?? '',
      debitStatus: json["debitStatus"] as String? ?? '',
      remark: json["remark"] as String? ?? '',
      points: json["points"] as int? ?? 0,
      category: json["category"] as String? ?? '',
      otpRemark: json["otpRemark"] as String? ?? '',
      customerName: json["customerName"] as String? ?? '',
      customerPhone: json["customerPhone"] as String? ?? '',
      redemptionmode: json["redemptionmode"] as String? ?? '',
    );
  }
}

class CashTransSummary {
  int creditCount;
  int earned;
  int debitCount;
  int reedemed;
  String fromDate;
  String toDate;

  CashTransSummary({
    required this.creditCount,
    required this.earned,
    required this.debitCount,
    required this.reedemed,
    required this.fromDate,
    required this.toDate,
  });

  factory CashTransSummary.fromJson(Map<String, dynamic> json) =>
      CashTransSummary(
        creditCount: json["creditCount"],
        earned: json["earned"],
        debitCount: json["debitCount"],
        reedemed: json["reedemed"],
        fromDate: json["fromDate"],
        toDate: json["toDate"],
      );
}
