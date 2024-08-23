import 'dart:convert';

class FinanceDashboard {
    String message;
    String status;
    String token;
    List<EnquiryCount> data;
    dynamic data1;

    FinanceDashboard({
        required this.message,
        required this.status,
        required this.token,
        required this.data,
        required this.data1,
    });

    factory FinanceDashboard.fromJson(Map<String, dynamic> json) => FinanceDashboard(
        message: json["message"] ?? "",
        status: json["status"] ?? "",
        token: json["token"] ?? "",
        data: List<EnquiryCount>.from(json["data"].map((x) => EnquiryCount.fromJson(x))) ?? [],
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

class EnquiryCount {
    int totalEnQuiryCount;
    int totalApprovedCount;
    int totalInProgressCount;
    int totalRejectedCount;

    EnquiryCount({
        required this.totalEnQuiryCount,
        required this.totalApprovedCount,
        required this.totalInProgressCount,
        required this.totalRejectedCount,
    });

    factory EnquiryCount.fromJson(Map<String, dynamic> json) => EnquiryCount(
        totalEnQuiryCount: json["totalEnQuiryCount"] ?? 0,
        totalApprovedCount: json["totalApprovedCount"] ?? 0,
        totalInProgressCount: json["totalInProgressCount"] ?? 0,
        totalRejectedCount: json["totalRejectedCount"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "totalEnQuiryCount": totalEnQuiryCount,
        "totalApprovedCount": totalApprovedCount,
        "totalInProgressCount": totalInProgressCount,
        "totalRejectedCount": totalRejectedCount,
    };
}
