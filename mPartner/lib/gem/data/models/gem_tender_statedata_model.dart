import 'dart:ffi';

class GemTenderStateDataModel {
  final String message;
  final String status;
  final String token;
  final List<TenderStateData> data;
  //final dynamic data1;

  GemTenderStateDataModel({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    //required this.data1,
  });

  factory GemTenderStateDataModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonData = json['data'] ?? [];
    List<TenderStateData> addressList =
        jsonData.map((item) => TenderStateData.fromJson(item)).toList();

    return GemTenderStateDataModel(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      data: addressList,
      // data1: json['data1'],
    );
  }
}

class TenderStateData {
  final int nTenderID;
  final String nTetnderTitle;
  final String sBidNumber;
  final String dBidPublishDate;
  final String dBidDueDate;
  final int nStateID;
  final String dPostedOn;
  final String category;

  TenderStateData({
    required this.nTenderID,
    required this.nTetnderTitle,
    required this.sBidNumber,
    required this.dBidPublishDate,
    required this.dBidDueDate,
    required this.dPostedOn,
    required this.nStateID,
    required this.category,
  });

  factory TenderStateData.fromJson(Map<String, dynamic> json) {
    return TenderStateData(
      nTenderID: json['nTenderID'] ?? '',
      nTetnderTitle: json['nTetnderTitle'] ?? '',
      sBidNumber: json['sBidNumber'] ?? '',
      dBidPublishDate: json['dBidPublishDate'] ?? '',
      dBidDueDate: json['dBidDueDate'] ?? '',
      dPostedOn: json['dPostedOn'] ?? '',
      nStateID: json['nStateID'] ?? '',
      category: json['category'] ?? '',
    );
  }
}
