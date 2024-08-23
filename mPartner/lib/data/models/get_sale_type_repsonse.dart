

class GetSaleTypeResponse {
  final String message;
  final String status;
  final String token;
  final List<SaleType> data;
  final dynamic data1;

  GetSaleTypeResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    this.data1,
  });

  factory GetSaleTypeResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<SaleType> saleTypeList = dataList.map((i) => SaleType.fromJson(i)).toList();

    return GetSaleTypeResponse(
      message: json['message'],
      status: json['status'],
      token: json['token'],
      data: saleTypeList,
      data1: json['data1'],
    );
  }
}

class SaleType{
  final String saleType;
  final String description;

  SaleType({required this.saleType,required this.description});

  factory SaleType.fromJson(Map<String, dynamic> json) {
    return SaleType(
      saleType: json['saleType'],
      description: json['description'],
    );
  }
}
