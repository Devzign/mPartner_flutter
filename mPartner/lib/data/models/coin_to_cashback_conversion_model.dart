import 'package:equatable/equatable.dart';

class RateList extends Equatable {
  int? rangeStart;
  int? rangeEnd;
  String? range;
  String? conversionRate;

  RateList({
    this.rangeStart,
    this.rangeEnd,
    this.range,
    this.conversionRate
  });

  @override
  List<Object?> get props => [rangeStart, rangeEnd,range, conversionRate];

  factory RateList.fromJson(Map<String, dynamic> json) {
    return RateList(
      rangeStart: json['rangeStart'],
      rangeEnd: json['rangeEnd'],
      range: json['range'],
      conversionRate: json['conversionRate']
    );
  }
}

class CoinToCashbackConversion extends Equatable {
  String? applicableRate;
  int conversionRate;
  String? nearest_Slab_Note;
  List<dynamic>? rateList;
  int finalCoins;
  int? totalCashReward;



  CoinToCashbackConversion({
    this.applicableRate,
    required this.conversionRate,
    this.nearest_Slab_Note,
    this.rateList,
    required this.finalCoins,
    this.totalCashReward,
  });

  @override
  List<Object?> get props => [
        applicableRate,
        conversionRate,
        nearest_Slab_Note,
        rateList,
        finalCoins,
        totalCashReward,
      ];

  factory CoinToCashbackConversion.fromJson(Map<String, dynamic> json) {
    return CoinToCashbackConversion(
      applicableRate: json['applicableRate'],
      conversionRate: json['conversionRate'] ?? 0,
      nearest_Slab_Note: json['nearest_Slab_Note'],
      rateList: json['rateList'],
      finalCoins: json['finalCoins'] ?? 0,
      totalCashReward : json['totalCashReward']
    );
  }
}
