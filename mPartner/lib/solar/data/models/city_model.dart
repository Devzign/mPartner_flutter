class SolarCityDataResponse {
  final String message;
  final String status;
  final String token;
  final List<SolarCityData> data;
  final dynamic data1;

  SolarCityDataResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    this.data1,
  });

  factory SolarCityDataResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<SolarCityData> cityDataList = dataList.map((i) => SolarCityData.fromJson(i)).toList();

    return SolarCityDataResponse(
      message: json['message'],
      status: json['status'],
      token: json['token'],
      data: cityDataList,
      data1: json['data1'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'token': token,
      'data': data.map((e) => e.toJson()).toList(),
      'data1': data1,
    };
  }
}

class SolarCityData {
  final String districtId;
  final String districtName;

  SolarCityData({
    required this.districtId,
    required this.districtName,
  });

  factory SolarCityData.fromJson(Map<String, dynamic> json) {
    return SolarCityData(
      districtId: json['districtId'],
      districtName: json['districtName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'districtId': districtId,
      'districtName': districtName,
    };
  }
}
