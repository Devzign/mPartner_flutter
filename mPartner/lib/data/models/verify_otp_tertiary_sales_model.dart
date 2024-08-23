class VerifyOtpTertiarySales {
  String message;
  String status;
  String token;
  VerifyOtpHkvaData data;
  String data1;

  VerifyOtpTertiarySales({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory VerifyOtpTertiarySales.fromJson(Map<String, dynamic> json) {
    return VerifyOtpTertiarySales(
      message: json['message'] ?? "",
      status: json['status'] ?? "",
      token: json['token'] ?? "",
      data: VerifyOtpHkvaData.fromJson(json['data'] ?? {}),
      data1: json['data1'] ?? "",
    );
  }
}

class VerifyOtpHkvaData {
  // Assuming 'code' and 'des' are of type String,
  // update the types accordingly if they have a different data type.
  String code;
  String des;

  VerifyOtpHkvaData({
    required this.code,
    required this.des,
  });

  factory VerifyOtpHkvaData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpHkvaData(
      code: json['code'] ?? "",
      des: json['des'] ?? "",
    );
  }
}
