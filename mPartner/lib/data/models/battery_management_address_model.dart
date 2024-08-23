class BatteryManagementAddressModel{
  final String message;
  final String status;
  final String token;
  final List<AddressData> data;
  final dynamic data1;

  BatteryManagementAddressModel({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory BatteryManagementAddressModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonData = json['data'] ?? [];
    List<AddressData> addressList =
    jsonData.map((item) => AddressData.fromJson(item)).toList();

    return BatteryManagementAddressModel(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      data: addressList,
      data1: json['data1'],
    );
  }
}

class AddressData {
  final String dis_Address1;
  final String dis_Address2;
  final String dis_City;
  final String dis_District;
  final String dis_State;
  final String dis_ContactNo;

  AddressData({
    required this.dis_Address1,
    required this.dis_Address2,
    required this.dis_City,
    required this.dis_District,
    required this.dis_State,
    required this.dis_ContactNo,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) {
    return AddressData(
      dis_Address1: json['dis_Address1'] ?? '',
      dis_Address2: json['dis_Address2'] ?? '',
      dis_City: json['dis_City'] ?? '',
      dis_District: json['dis_District'] ?? '',
      dis_State: json['dis_State'] ?? '',
      dis_ContactNo: json['dis_ContactNo'] ?? '',
    );
  }
}
