class BatteryManagementCityListModel{
  final String message;
  final String status;
  final String token;
  final List<CityData> data;
  final dynamic data1;

  BatteryManagementCityListModel({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory BatteryManagementCityListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonData = json['data'] ?? [];
    List<CityData> cityDataList =
    jsonData.map((item) => CityData.fromJson(item)).toList();

    return BatteryManagementCityListModel(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      data: cityDataList,
      data1: json['data1'],
    );
  }
}

class CityData {
  final String disCity;

  CityData({
    required this.disCity,
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      disCity: json['dis_City'] ?? '',
    );
  }
}
