class SolarRequestTracking {
    String message;
    String status;
    String token;
    List<RequestTrackingDetails> data;
    dynamic data1;

    SolarRequestTracking({
        required this.message,
        required this.status,
        required this.token,
        required this.data,
        required this.data1,
    });

    factory SolarRequestTracking.fromJson(Map<String, dynamic> json) => SolarRequestTracking(
        message: json["message"] ?? "",
        status: json["status"] ?? "",
        token: json["token"] ?? "",
       data: (json["data"] != null &&  json["data"] != "")
            ? List<RequestTrackingDetails>.from(json["data"].map((x) => RequestTrackingDetails.fromJson(x)))
            : [],
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

class RequestTrackingDetails {
    String createdOn;
    String status;
    String reason;

    RequestTrackingDetails({
        required this.createdOn,
        required this.status,
        required this.reason,
    });

    factory RequestTrackingDetails.fromJson(Map<String, dynamic> json) => RequestTrackingDetails(
        createdOn:json["createdOn"] ?? "",
        status: json["status"] ?? "",
        reason: json["reason"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "createdOn": createdOn,
        "status": status,
        "reason": reason,
    };
}