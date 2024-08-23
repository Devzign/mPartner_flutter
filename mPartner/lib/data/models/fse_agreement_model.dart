import 'package:equatable/equatable.dart';

class FseAgreementResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final List<FseAgreementData> data;
  final dynamic data1;

  const FseAgreementResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory FseAgreementResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json["data"] as List;
    List<FseAgreementData> parsedDataList =
    dataList.map((data) => FseAgreementData.fromJson(data)).toList();

    return FseAgreementResponse(
      message: json["message"],
      status: json["status"],
      token: json["token"],
      data: parsedDataList,
      data1: json["data1"],
    );
  }

  @override
  List<Object?> get props => [message, status, token, data, data1];
}

class FseAgreementData extends Equatable {
  final String id;
  final String agreement;
  final String annexure;

  const FseAgreementData({
    required this.id,
    required this.agreement,
    required this.annexure,
  });

  factory FseAgreementData.fromJson(Map<String, dynamic> json) {
    return FseAgreementData(
      id: json["id"],
      agreement: json["agreement"],
      annexure: json["annexure"],
    );
  }

  @override
  List<Object?> get props => [id, agreement, annexure];
}

