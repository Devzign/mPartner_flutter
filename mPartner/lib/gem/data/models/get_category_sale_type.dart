

class GetCategorySaleTypeResponse {
  final String message;
  final String status;
  final String token;
  final List<CategorySaleType> data;
  final dynamic data1;

  GetCategorySaleTypeResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    this.data1,
  });

  factory GetCategorySaleTypeResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<CategorySaleType> saleTypeList = dataList.map((i) => CategorySaleType.fromJson(i)).toList();

    return GetCategorySaleTypeResponse(
      message: json['message'],
      status: json['status'],
      token: json['token'],
      data: saleTypeList,
      data1: json['data1'],
    );
  }
}

class CategorySaleType{
  final String sGEMMODULE;
  final String sGEMMODULE_Desc;

  CategorySaleType({required this.sGEMMODULE,required this.sGEMMODULE_Desc});

  factory CategorySaleType.fromJson(Map<String, dynamic> json) {
    return CategorySaleType(
      sGEMMODULE: json['sGEMMODULE'],
      sGEMMODULE_Desc: json['sGEMMODULE_Desc'],
    );
  }
}
