import 'dart:convert';

class ProjectExecutionDashboardResponse {
  String message;
  String status;
  String token;
  List<DashboardData> data;
  dynamic data1;

  ProjectExecutionDashboardResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory ProjectExecutionDashboardResponse.fromJson(Map<String, dynamic> json) => ProjectExecutionDashboardResponse(
    message: json["message"] ?? "",
    status: json["status"] ?? "",
    token: json["token"] ?? "",
    data: List<DashboardData>.from(json["data"].map((x) => DashboardData.fromJson(x))) ?? [],
    data1: json["data1"] ?? "",
  );


  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "token": token,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "data1": data1,
  };
}

class DashboardData {
  int totalRequestCount;
  int resolvedCount;
  int inProgressCount;
  int rescheduledCount;

  DashboardData({
    required this.totalRequestCount,
    required this.resolvedCount,
    required this.inProgressCount,
    required this.rescheduledCount,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
    totalRequestCount: json["totalRequestCount"] ?? 0,
    resolvedCount: json["resolvedCount"] ?? 0,
    inProgressCount: json["inProgressCount"] ?? 0,
    rescheduledCount: json["rescheduledCount"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "totalRequestCount": totalRequestCount,
    "resolvedCount": resolvedCount,
    "inProgressCount": inProgressCount,
    "rescheduledCount": rescheduledCount,
  };
}
