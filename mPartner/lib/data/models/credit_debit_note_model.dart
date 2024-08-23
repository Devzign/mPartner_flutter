import 'dart:convert';

class CreditDebitNote {
    String message;
    String status;
    String token;
    String data;
    String data1;

    CreditDebitNote({
        required this.message,
        required this.status,
        required this.token,
        required this.data,
        required this.data1,
    });

    List<Object?> get props => [message, status, token, data, data1];

    factory CreditDebitNote.fromJson(Map<String, dynamic> json) => CreditDebitNote(
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
