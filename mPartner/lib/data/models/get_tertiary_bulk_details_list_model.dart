import 'package:equatable/equatable.dart';

class TertiarySaleData extends Equatable{
  final String? code;
  final String? des;
  final String? otpRemark;
  final String productType;
  final String model;
  final DateTime? registeredOn;
  final String serialNo;
  final String? remark;
  final String status;
  final String msgType;
  final int wrsPoint;
  final int tripPoint;
  final int coinPoints;

  TertiarySaleData({
    this.code,
    this.des,
    this.otpRemark,
    required this.productType,
    required this.model,
    this.registeredOn,
    required this.serialNo,
    required this.status,
    this.remark,
    required this.msgType,
    required this.wrsPoint,
    required this.tripPoint,
    required this.coinPoints,
  });

  factory TertiarySaleData.fromJson(Map<String, dynamic> json) {
    return TertiarySaleData(
      code: json['code'] ?? '',
      des: json['des'],
      otpRemark: json['otpRemark'] ?? '',
      productType: json['productType'] ?? '',
      model: json['model'] ?? '',
      registeredOn: DateTime.parse(json['registeredOn']),
      serialNo: json['serialNo'] ?? '',
      status: json['status'] ?? '',
      remark: json['remark'] ?? '',
      msgType: json['msgType'] ?? '',
      wrsPoint: int.tryParse(json['wrsPoint'] ?? '0') ?? 0,
      tripPoint: int.tryParse(json['tripPoint'] ?? '0') ?? 0,
      coinPoints: int.tryParse(json['coin_Points'] ?? '0') ?? 0,
    );
  }

  @override
  List<Object?> get props => [
  code,
  des,
  otpRemark,
  productType,
  model,
  registeredOn,
  serialNo,
  status,
  remark,
  msgType,
  wrsPoint,
  tripPoint,
  coinPoints,
  ];
}

