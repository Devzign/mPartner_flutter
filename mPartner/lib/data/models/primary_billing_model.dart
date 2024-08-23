import 'dart:convert';

class PrimaryBilling {
    String message;
    String status;
    String token;
    String data;
    dynamic data1;

    PrimaryBilling({
        required this.message,
        required this.status,
        required this.token,
        required this.data,
        required this.data1,
    });

    List<Object?> get props => [message, status, token, data, data1];

    factory PrimaryBilling.fromJson(Map<String, dynamic> json) => PrimaryBilling(
        message: json["message"] ?? "",
        status: json["status"] ?? "",
        token: json["token"] ?? "",
        data: json["data"] ??"",
        data1: json["data1"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "token": token,
        "data": data,
        "data1": data1,
    };
}
