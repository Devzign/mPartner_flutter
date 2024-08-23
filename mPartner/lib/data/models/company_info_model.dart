class CompanyInfoModel{
  final String message;
  final String status;
  final String token;
  final List<CompanyData> data;
  final dynamic data1;

  CompanyInfoModel({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory CompanyInfoModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonData = json['data'] ?? [];
    List<CompanyData> companyData =
    jsonData.map((item) => CompanyData.fromJson(item)).toList();

    return CompanyInfoModel(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      data: companyData,
      data1: json['data1'],
    );
  }
}

class CompanyData {
  final String contactus_title;
  final String address;
  final String phoneno;
  final String sales_support_phoneno;
  final String email;

  CompanyData({
    required this.contactus_title,
    required this.address,
    required this.phoneno,
    required this.sales_support_phoneno,
    required this.email,
  });

  factory CompanyData.fromJson(Map<String, dynamic> json) {
    return CompanyData(
      contactus_title: json['contactus_title'] ?? '',
      address: json['address'] ?? '',
      phoneno: json['phoneno'] ?? '',
      sales_support_phoneno: json['sales_support_phoneno'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
