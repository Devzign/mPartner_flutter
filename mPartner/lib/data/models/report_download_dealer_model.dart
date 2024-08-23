import 'dart:convert';

class ReportDownloadDealer {
    String message;
    String status;
    String token;
    String data;
    dynamic data1;

    ReportDownloadDealer({
        required this.message,
        required this.status,
        required this.token,
        required this.data,
        required this.data1,
    });

    List<Object?> get props => [
      message,
      status,
      token,
      data,
      data1
    ];

    factory ReportDownloadDealer.fromJson(Map<String, dynamic> json) => ReportDownloadDealer(
        message: json["message"] ?? "",
        status: json["status"] ?? "",
        token: json["token"] ?? "",
        data: json["data"] ?? "",
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
