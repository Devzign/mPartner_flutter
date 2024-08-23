import 'package:equatable/equatable.dart';

class GetHkvaResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final List<HkvaItemModel> data;
  final dynamic data1;

  GetHkvaResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory GetHkvaResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataJson = json['data'];
    List<HkvaItemModel> dataList =
        dataJson.map((item) => HkvaItemModel.fromJson(item)).toList();

    return GetHkvaResponse(
      message: json['message']??'',
      status: json['status']??'',
      token: json['token']??'',
      data: dataList??[],
      data1: json['data1'],
    );
  }
  @override
  List<Object?> get props => [message, status, token, data, data1];
}

class HkvaItemModel extends Equatable {
  final int id;
  final String modDate;
  final String status;
  final String productType;
  final String serial;
  final String model;
  final int tentativePoints;
  final int capacity;
  final String readMore;
  final int tentativeCoins;

  HkvaItemModel({
    required this.id,
    required this.modDate,
    required this.status,
    required this.productType,
    required this.serial,
    required this.model,
    required this.tentativePoints,
    required this.capacity,
    required this.readMore,
    required this.tentativeCoins,
  });

  factory HkvaItemModel.fromJson(Map<String, dynamic> json) {
    return HkvaItemModel(
      id: json['id']??0,
      modDate: json['modDate']??'',
      status: json['status']??'',
      productType: json['productType']??'',
      serial: json['serial']??'',
      model: json['model']??'',
      tentativePoints: json['tentativePoints']??0,
      capacity: json['capacity']??0,
      readMore: json['readMore']??'',
      tentativeCoins: json['tentativeCoins']??0,
    );
  }

  @override
  List<Object> get props => [
        id,
        modDate,
        status,
        productType,
        serial,
        model,
        tentativePoints,
        capacity,
        readMore,
        tentativeCoins,
      ];
}
