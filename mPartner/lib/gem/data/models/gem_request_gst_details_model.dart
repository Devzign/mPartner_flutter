class GemRequestGstDetailsModel {
  String? message;
  String? status;
  String? token;
  String? isValidityExpired;
  String? gstStatus;
  String? authorizationCode;
  String? validity;
  GemRequestGstDetailsModel(
      {required this.message,
      required this.status,
      required this.token,
      required this.isValidityExpired,
      this.authorizationCode,
      this.validity,
      this.gstStatus});
  factory GemRequestGstDetailsModel.fromJson(Map<String, dynamic> map) {
    return GemRequestGstDetailsModel(
      message: map["message"] ?? "",
      status: map["status"] ?? "",
      token: map["token"] ?? "",
      isValidityExpired: map["isValidityExpired"] ?? "",
      authorizationCode: map["authorizationCode"] ?? "",
      validity: map["validity"] ?? "",
      gstStatus: map["gstStatus"] ?? "",
    );
  }
}
