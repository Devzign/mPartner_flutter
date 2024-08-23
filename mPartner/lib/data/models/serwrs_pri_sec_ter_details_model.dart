import 'package:equatable/equatable.dart';

class SerWRS_Primary_Sec_Ter_Detail_V2_Response {
  final String message;
  final String status;
  final String token;
  final List<SerWRS_Primary_Sec_Ter_Detail_V2_Data> data;
  final dynamic data1;

  SerWRS_Primary_Sec_Ter_Detail_V2_Response({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory SerWRS_Primary_Sec_Ter_Detail_V2_Response.fromJson(
      Map<String, dynamic> json) {
    var dataList = json["data"] as List;
    List<SerWRS_Primary_Sec_Ter_Detail_V2_Data> parsedDataList = dataList
        .map((data) => SerWRS_Primary_Sec_Ter_Detail_V2_Data.fromJson(data))
        .toList();

    return SerWRS_Primary_Sec_Ter_Detail_V2_Response(
      message: json["message"],
      status: json["status"],
      token: json["token"],
      data: parsedDataList,
      data1: json["data1"],
    );
  }
}

class SerWRS_Primary_Sec_Ter_Detail_V2_Data extends Equatable {
  final String manufacturingDate;
  final String productType;
  final String modelName;
  final String primaryCustomer;
  final String primaryBilledDate;
  final String tertiaryDealerName;
  final String tertiaryCustomerName;
  final String tertiaryCustomerNo;
  final String tertiaryDate;
  final String tertiaryCity;
  final String imgUrl;
  final String pdfUrl;
  final String invoiceNumber;
  final String warrantyExpiryDate;

  SerWRS_Primary_Sec_Ter_Detail_V2_Data({
    required this.manufacturingDate,
    required this.productType,
    required this.modelName,
    required this.primaryCustomer,
    required this.primaryBilledDate,
    required this.tertiaryDealerName,
    required this.tertiaryCustomerName,
    required this.tertiaryCustomerNo,
    required this.tertiaryDate,
    required this.tertiaryCity,
    required this.imgUrl,
    required this.pdfUrl,
    required this.invoiceNumber,
    required this.warrantyExpiryDate,
  });

  factory SerWRS_Primary_Sec_Ter_Detail_V2_Data.fromJson(
      Map<String, dynamic> json) {
    return SerWRS_Primary_Sec_Ter_Detail_V2_Data(
      manufacturingDate: json["manufacturing_Date"],
      productType: json["product_Type"],
      modelName: json["model_Name"],
      primaryCustomer: json["primary_Customer"],
      primaryBilledDate: json["primary_Billed_Date"],
      tertiaryDealerName: json["tertiary_Dealer_Name"],
      tertiaryCustomerName: json["tertiary_Customer_Name"],
      tertiaryCustomerNo: json["tertiary_Customer_No"],
      tertiaryDate: json["tertiary_Date"],
      tertiaryCity: json["tertiary_City"],
      imgUrl: json["img_url"],
      pdfUrl: json["pdf_url"],
      invoiceNumber: json["invoicenumber"],
      warrantyExpiryDate: json["warrantyexpirydate"],
    );
  }

  @override
  List<Object?> get props => [
        manufacturingDate,
        productType,
        modelName,
        primaryCustomer,
        primaryBilledDate,
        tertiaryDealerName,
        tertiaryCustomerName,
        tertiaryCustomerNo,
        tertiaryDate,
        tertiaryCity,
        imgUrl,
        pdfUrl,
        invoiceNumber,
        warrantyExpiryDate,
      ];
}
