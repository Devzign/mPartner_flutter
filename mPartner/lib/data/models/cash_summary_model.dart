

import 'package:equatable/equatable.dart';

class CashSummary extends Equatable {
  final int brandVoucherAmt;
  final int paytmAmt;
  final String transfer_Status;
  final String paytm_Status;
  final String paytm_Msg;
  final String transfer_Msg;
  final int availableCash;
  final int earnedCash;
  final int redeemedCash;
  final int pendingAmt;
  final int creditCount;
  final int debitCount;
  final String fromDate;
  final String toDate;

  const CashSummary({
    required this.brandVoucherAmt,
    required this.paytmAmt,
    required this.transfer_Status,
    required this.paytm_Status,
    required this.paytm_Msg,
    required this.transfer_Msg,
    required this.availableCash,
    required this.earnedCash,
    required this.redeemedCash,
    required this.pendingAmt,
    required this.creditCount,
    required this.debitCount,
    required this.fromDate,
    required this.toDate
  });

  @override
  List<Object> get props => [
   brandVoucherAmt,
   paytmAmt,
   transfer_Status,
   paytm_Status,
   paytm_Msg,
   transfer_Msg,
   availableCash,
   earnedCash,
   redeemedCash,
    pendingAmt,
    creditCount,
    debitCount,
    fromDate,
    toDate
  ];

  factory CashSummary.fromJson(Map<String, dynamic> json) => CashSummary(
    brandVoucherAmt: json["brandVoucherAmt"],
    paytmAmt: json["paytmAmt"],
    transfer_Status: json["transfer_Satus"],
    paytm_Status: json["paytm_Status"],
    paytm_Msg: json["paytm_Msg"],
    transfer_Msg: json['transfer_Msg'],
    availableCash: json["availableAmt"],
    earnedCash: json['earnedAmt'],
    redeemedCash: json["redeemedAmt"],
    pendingAmt: json["pendingAmt"],
    creditCount: json["creditCount"],
    debitCount: json["debitCount"],
    fromDate: json["fromdate"],
    toDate: json["todate"],
  );
}