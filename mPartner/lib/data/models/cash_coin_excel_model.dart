class CashCoinExcelModel {
  String message;
  String status;
  String token;
  String data;
  String data1;

  CashCoinExcelModel({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory CashCoinExcelModel.fromJson(Map<String, dynamic> json) => CashCoinExcelModel(
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
