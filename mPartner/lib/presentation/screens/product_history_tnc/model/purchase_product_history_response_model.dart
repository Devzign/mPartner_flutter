class PurchaseProductHistoryResponseModel {
  String? message;
  String? status;
  String? token;
  Data? data;
  List<PastProductData>? data1;

  PurchaseProductHistoryResponseModel(
      {this.message, this.status, this.token, this.data, this.data1});

  PurchaseProductHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    token = json['token'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    if (json['data1'] != null) {
      data1 = <PastProductData>[];
      json['data1'].forEach((v) {
        data1!.add(PastProductData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['token'] = token;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (data1 != null) {
      data['data1'] = data1!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? discriptionMessage;

  Data({this.discriptionMessage});

  Data.fromJson(Map<String, dynamic> json) {
    discriptionMessage = json['discriptionMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['discriptionMessage'] = discriptionMessage;
    return data;
  }
}

class PastProductData {
  String? productSerialNumber;
  String? purchaseDate;
  String? productModel;

  PastProductData({this.productSerialNumber, this.purchaseDate, this.productModel});

  PastProductData.fromJson(Map<String, dynamic> json) {
    productSerialNumber = json['productSerialNumber'];
    purchaseDate = json['purchaseDate'];
    productModel = json['productModel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productSerialNumber'] = productSerialNumber;
    data['purchaseDate'] = purchaseDate;
    data['productModel'] = productModel;
    return data;
  }
}
