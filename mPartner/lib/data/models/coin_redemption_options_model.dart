import 'package:equatable/equatable.dart';

class RedeemOption extends Equatable {
  String? url;
  String? type;
  String? urlGif;
  String? label;
  String? remarks;

  RedeemOption({
    this.url,
    this.type,
    this.urlGif,
    this.label,
    this.remarks
  });

  @override
  List<Object?> get props => [url, type, urlGif, label, remarks];

  factory RedeemOption.fromJson(Map<String, dynamic> json) {
    return RedeemOption(
      url: json['url'],
      type: json['type'],
      urlGif: json['urlGif'],
      label: json['label'],
      remarks: json['remarks']
    );
  }
}

class CoinRedemptionOptions extends Equatable {
  String? nextPage_TripMsg;
  int? availableCoinsBalance;
  int? redeemableCoinsBalance;
  String? redeemText;
  List<RedeemOption>? redeemOptions;

  CoinRedemptionOptions({
    this.nextPage_TripMsg,
    this.availableCoinsBalance,
    this.redeemableCoinsBalance,
    this.redeemText,
    this.redeemOptions,
  });

  @override
  List<Object?> get props => [
        nextPage_TripMsg,
        availableCoinsBalance,
        redeemableCoinsBalance,
        redeemText,
        redeemOptions,
      ];

  factory CoinRedemptionOptions.fromJson(Map<String, dynamic> json) {
    var redeemOptionsJsonList = json['redeemOptions'] as List;
    List<RedeemOption> redeemOptionsList =
        redeemOptionsJsonList.map((e) => RedeemOption.fromJson(e)).toList();

    return CoinRedemptionOptions(
      nextPage_TripMsg: json['nextPage_TripMsg'] ?? "",
      availableCoinsBalance: json['availableCoinsBalance'] ?? 0,
      redeemableCoinsBalance: json['redeemableCoinsBal'] ?? 0, 
      redeemText: json['redeemtext'] ?? "",
      redeemOptions: redeemOptionsList,
    );
  }
}
