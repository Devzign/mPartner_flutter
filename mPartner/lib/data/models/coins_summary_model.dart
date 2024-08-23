import 'package:equatable/equatable.dart';

class CoinsSummary extends Equatable {
  final String userID;
  final String availableCoins;
  final String creditCoins;
  final String debitCoins;
  final String pendingCoins;
  final String rejectedCoins;
  final String bonusCoins;
  final int creditCount;
  final int debitCount;
  final String fromDate;
  final String toDate;

  const CoinsSummary({
    required this.userID,
    required this.availableCoins,
    required this.creditCoins,
    required this.debitCoins,
    required this.pendingCoins,
    required this.rejectedCoins,
    required this.bonusCoins,
    required this.creditCount,
    required this.debitCount,
    required this.fromDate,
    required this.toDate
  });

  @override
  List<Object> get props => [
    userID,
    availableCoins,
    creditCoins,
    debitCoins,
    pendingCoins,
    rejectedCoins,
    bonusCoins,
    creditCount,
    debitCount,
    fromDate,
    toDate
  ];

  factory CoinsSummary.fromJson(Map<String, dynamic> json) => CoinsSummary(
    userID: json["userID"],
    availableCoins: json["availableCoins"],
    creditCoins: json["creditCoins"],
    debitCoins: json["debitCoins"],
    pendingCoins: json["pendingCoins"],
    rejectedCoins: json["rejectedCoins"],
    bonusCoins: json["bonusCoins"],
    creditCount: json["creditCount"],
    debitCount: json["debitCount"],
    fromDate: json["fromdate"],
    toDate: json["todate"],
  );
}