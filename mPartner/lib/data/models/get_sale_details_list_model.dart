import 'package:equatable/equatable.dart';

class SaleData extends Equatable{
  final String? status;
  final String? remark;
  final String? primaryDetail;
  final String? productType;
  final String? modelName;
  final String? serialNoCount;
  final int? wrsPoint;
  final int? wrsPointAccepted;
  final int? wrsPointPending;
  final int? wrsPointRejected;
  final String? registeredOn;

  SaleData({
    required this.status,
    required this.remark,
    required this.primaryDetail,
    required this.productType,
    required this.modelName,
    required this.serialNoCount,
    required this.wrsPoint,
    required this.wrsPointAccepted,
    required this.wrsPointPending,
    required this.wrsPointRejected,
    required this.registeredOn,
  });

  factory SaleData.fromJson(Map<String, dynamic> json) {
    return SaleData(
      status: json['status'] as String?? '',
      remark: json['remark'] as String?? '',
      primaryDetail: json['primaryDetail'] as String?,
      productType: json['productType'] as String ?? '',
      modelName: json['modelName'] as String?,
      serialNoCount: json['serialNoCount'] as String ?? '',
      wrsPoint: json['wrsPoint'] as int ?? 0,
      wrsPointAccepted: json['wrsPointAccepted'] as int ?? 0,
      wrsPointPending: json['wrsPointPending'] as int ?? 0,
      wrsPointRejected: json['wrsPointRejected'] as int ?? 0,
      registeredOn: json['registeredOn'] as String ?? '',
    );
  }

  @override
  List<Object?> get props => [
    status,
    remark,
    primaryDetail,
    productType,
    modelName,
    serialNoCount,
    wrsPoint,
    wrsPointAccepted,
    wrsPointPending,
    wrsPointRejected,
  ];
}

