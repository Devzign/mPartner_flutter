class GetUnitsResponse {
  final String message;
  final String status;
  final String token;
  final List<Unit> data;

  GetUnitsResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
  });

  factory GetUnitsResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<Unit> units =
    dataList.map((item) => Unit.fromJson(item)).toList();

    return GetUnitsResponse(
      message: json['message']??"",
      status: json['status']??"",
      token: json['token']??"",
      data: units,
    );
  }
}

class Unit {
  final int unitId;
  final String unitName;

  Unit({
    required this.unitId,
    required this.unitName,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      unitId: json['unitId']??"",
      unitName: json['unitName']??"",
    );
  }
}
