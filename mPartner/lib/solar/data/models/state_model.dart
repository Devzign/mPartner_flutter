class SolarStateDataResponse {
  final String message;
  final String status;
  final String token;
  final List<SolarStateData> data;
  final dynamic data1;

  SolarStateDataResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    this.data1,
  });

  factory SolarStateDataResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<SolarStateData> stateDataList = dataList.map((i) => SolarStateData.fromJson(i)).toList();

    return SolarStateDataResponse(
      message: json['message'],
      status: json['status'],
      token: json['token'],
      data: stateDataList,
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

class SolarStateData {
  final String stateId;
  final String stateName;

  SolarStateData({
    required this.stateId,
    required this.stateName,
  });

  factory SolarStateData.fromJson(Map<String, dynamic> json) {
    return SolarStateData(
      stateId: json['stateId'],
      stateName: json['stateName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stateId': stateId,
      'stateName': stateName,
    };
  }
}
