class GemAuthDetailModel {
  String? firmName;
  String? mobile_Number;
  String? email_ID;
  String? address;
  String? city;
  String? state;
  String? gstiN_Number;
  String? authCodeStatus;
  String? validity;
  String? reason;
  String? emailId;
  String paN_Number;
  String code;

  GemAuthDetailModel(
      {required this.firmName,
      required this.mobile_Number,
      required this.email_ID,
      required this.address,
      required this.city,
      required this.state,
      required this.gstiN_Number,
      required this.authCodeStatus,
      required this.validity,
      required this.reason,
      required this.paN_Number,
      required this.code,
      required this.emailId});

  factory GemAuthDetailModel.toJson(Map<String, dynamic> json) {
    return GemAuthDetailModel(
      firmName: json["firmName"].toString()!=""?json["firmName"].toString(): "NA",
      mobile_Number: json["mobile_Number"].toString()!=""?json["mobile_Number"].toString(): "NA",
      email_ID: json["email_ID"].toString()!=""?json["email_ID"].toString(): "NA",
      address: json["address"].toString()!="null"?json["address"].toString(): "NA",
      city: json["city"].toString()!=""?json["city"].toString(): "NA",
      state: json["state"].toString()!=""?json["state"].toString(): "NA",
      gstiN_Number: json["gstiN_Number"].toString()!=""?json["gstiN_Number"].toString(): "NA",
      authCodeStatus: json["authCodeStatus"].toString()!=""?json["authCodeStatus"].toString(): "NA",
      validity: json["validity"].toString()!=""?json["validity"].toString(): "NA",
      reason: json["reason"].toString()!=""?json["reason"].toString(): "NA",
      emailId: json["emailId"].toString()!=""?json["emailId"].toString(): "NA",
      code: json["code"].toString()!=""?json["code"].toString(): "NA",
      paN_Number: json["paN_Number"].toString()!="null"?json["paN_Number"].toString(): "NA",
    );
  }
}

class GemCustomerDetailModel {
  String? firmName;
  String? mobileNumber;
  String? emailId;
  String? code;
  String? address;
  String? city;
  String? state;

  String? location;
  String? paN_Number;
  String? gstNumber;

  GemCustomerDetailModel({
    required this.firmName,
    required this.mobileNumber,
    required this.emailId,
    required this.code,
    required this.address,
    required this.city,
    required this.state,
    required this.location,
    required this.paN_Number,
    required this.gstNumber,
  });

  factory GemCustomerDetailModel.toJson(Map<String, dynamic> json) {
    return GemCustomerDetailModel(
      firmName: json["firmName"].toString() != "" ? json["firmName"] : "NA",
      mobileNumber: json["mobileNumber"] .toString() != "null" ? json["mobileNumber"] : "NA",
      emailId: json["emailId"].toString() != "" ? json["emailId"] : "NA",
      code: json["code"].toString() != "" ? json["code"] : "NA",
      address: json["address"] .toString() != "null" ? json["address"] : "NA",
      city: json["city"].toString() != "" ? json["city"] : "NA",
      state: json["state"] .toString() != "" ? json["state"] : "NA",
      location: json["location"] .toString() != "" ? json["location"] : "NA",
      paN_Number: json["paN_Number"] .toString() != "null" ? json["paN_Number"] : "NA",
      gstNumber: json["gstNumber"] .toString() != "" ? json["gstNumber"] : "NA",
    );
  }
}
