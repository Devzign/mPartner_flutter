import 'package:equatable/equatable.dart';

class NewWarranty extends Equatable {
  final String status;
  final String message;
  final String serialNo;
  final String imgUrl;
  final String modelName;
  final String primaryDate;
  final String primarySoldTo;
  final String secondaryDate;
  final String secondarySoldTo;
  final String intermediateDate;
  final String intermediateSoldBy;
  final String intermediateSoldTo;
  final String tertiaryDate;
  final String tertiarySoldBy;
  final String tertiarySoldTo;
  final String finalStatus;
  final String mfgDate;

  NewWarranty({
    required this.status,
    required this.message,
    required this.serialNo,
    required this.imgUrl,
    required this.modelName,
    required this.primaryDate,
    required this.primarySoldTo,
    required this.secondaryDate,
    required this.secondarySoldTo,
    required this.intermediateDate,
    required this.intermediateSoldBy,
    required this.intermediateSoldTo,
    required this.tertiaryDate,
    required this.tertiarySoldBy,
    required this.tertiarySoldTo,
    required this.finalStatus,
    required this.mfgDate,
  });

  factory NewWarranty.fromJson(Map<String, dynamic> json) {
    return NewWarranty(
      status: json['status'] ?? "",
      message: json['message'] ?? "",
      serialNo: json['serialNo'] ?? "",
      imgUrl: json['imgUrl'] ?? "",
      modelName: json['modelName'] ?? "",
      primaryDate: json['primaryDate'] ?? "",
      primarySoldTo: json['primarySoldTo'] ?? "",
      secondaryDate: json['secondaryDate'] ?? "",
      secondarySoldTo: json['secondarySoldTo'] ?? "",
      intermediateDate: json['intermediateDate'] ?? "",
      intermediateSoldBy: json['intermediateSoldBy'] ?? "",
      intermediateSoldTo: json['intermediateSoldTo'] ?? "",
      tertiaryDate: json['tertiaryDate'] ?? "",
      tertiarySoldBy: json['tertiarySoldBy'] ?? "",
      tertiarySoldTo: json['tertiarySoldTo'] ?? "",
      finalStatus: json["finalStatus"] ?? "",
      mfgDate: json["mfgDate"] ?? "",

    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        serialNo,
        imgUrl,
        modelName,
        primaryDate,
        primarySoldTo,
        secondaryDate,
        secondarySoldTo,
        intermediateDate,
        intermediateSoldBy,
        intermediateSoldTo,
        tertiaryDate,
        tertiarySoldBy,
        tertiarySoldTo,
        finalStatus,
        mfgDate,
      ];
}
