class SolarFinanceExistingLeads {
    String message;
    String status;
    String token;
    Data data;
    dynamic data1;

    SolarFinanceExistingLeads({
        required this.message,
        required this.status,
        required this.token,
        required this.data,
        required this.data1,
    });

    factory SolarFinanceExistingLeads.fromJson(Map<String, dynamic> json) => SolarFinanceExistingLeads(
        message: json["message"] ?? "",
        status: json["status"] ?? "",
        token: json["token"] ?? "",
        data: json["data"] != null ? Data.fromJson(json["data"]) : Data(data: [], totalCount: 0),
        data1: json["data1"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "token": token,
        "data": data.toJson(),
        "data1": data1,
    };
}

class Data {
    List<SolarFinanceRequests> data;
    int totalCount;

    Data({
        required this.data,
        required this.totalCount,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] != null ? List<SolarFinanceRequests>.from(json["data"].map((x) => SolarFinanceRequests.fromJson(x))) : [],
        totalCount: json["totalCount"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalCount": totalCount,
    };
}

class SolarFinanceRequests {
    String projectId;
    String contactPersonName;
    String projectCapacity;
    int projectCost;
    String approvedBankName;
    String status;

    SolarFinanceRequests({
        required this.projectId,
        required this.contactPersonName,
        required this.projectCapacity,
        required this.projectCost,
        required this.approvedBankName,
        required this.status,
    });

    factory SolarFinanceRequests.fromJson(Map<String, dynamic> json) => SolarFinanceRequests(
        projectId: json["projectId"] ?? "",
        contactPersonName: json["contactPersonName"] ?? "",
        projectCapacity: json["projectCapacity"] ?? "",
        projectCost: json["projectCost"] ?? 0,
        approvedBankName: json["approvedBank"] ?? "",
        status: json["status"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "projectId": projectId,
        "contactPersonName": contactPersonName,
        "projectCapacity": projectCapacity,
        "projectCost": projectCost,
        "approvedBank": approvedBankName,
        "status": status,
    };
}
