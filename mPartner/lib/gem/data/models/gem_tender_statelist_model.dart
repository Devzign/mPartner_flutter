class GemTenderStateListModel{
  final String message;
  final String status;
  final String token;
  final List<ListStateData> data;
  final dynamic data1;

  GemTenderStateListModel({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory GemTenderStateListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonData = json['data'] ?? [];
    List<ListStateData> stateDataList =
    jsonData.map((item) => ListStateData.fromJson(item)).toList();

    return GemTenderStateListModel(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      data: stateDataList,
      data1: json['data1'],
    );
  }
}

class ListStateData {
  final String stateName;
  final String stateID;

  ListStateData({
    required this.stateName,
    required this.stateID,
  });

  factory ListStateData.fromJson(Map<String, dynamic> json) {
    return ListStateData(
      stateName: json['stateName'] ?? '',
      stateID: json['stateID'] ?? '',
    );
  }
}
