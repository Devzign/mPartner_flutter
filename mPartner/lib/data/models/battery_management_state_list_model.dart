class BatteryManagementStateListModel{
  final String message;
  final String status;
  final String token;
  final List<StateData> data;
  final dynamic data1;

  BatteryManagementStateListModel({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory BatteryManagementStateListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonData = json['data'] ?? [];
    List<StateData> stateDataList =
    jsonData.map((item) => StateData.fromJson(item)).toList();

    return BatteryManagementStateListModel(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      data: stateDataList,
      data1: json['data1'],
    );
  }
}

class StateData {
  final String disState;

  StateData({
    required this.disState,
  });

  factory StateData.fromJson(Map<String, dynamic> json) {
    return StateData(
      disState: json['dis_State'] ?? '',
    );
  }
}
