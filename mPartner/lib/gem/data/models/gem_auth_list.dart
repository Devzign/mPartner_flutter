
class GemAuthList {
  int?id;
  String? authorizationCode;
  String? mobile_Number;
  String? validity;
  String?email;
  String?status;
  GemAuthList({required this.id,required this.authorizationCode,
    required this.mobile_Number, required this.validity, required this.email,required this.status });
  factory GemAuthList.toJson(Map<String,dynamic> json){
    return GemAuthList(
      id:json["id"],
      authorizationCode:json["authorizationCode"].toString()!="null"?json["authorizationCode"].toString():"Code not created",
      mobile_Number:json["mobile_Number"],
      validity:json["validity"].toString()!="null"?json["validity"].toString(): "",
      email:json["email"],
      status:json["status"],

    );
  }
}
