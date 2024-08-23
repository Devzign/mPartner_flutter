import 'dart:convert';

class MafRegistrationWiseDetails {
  final String message;
  final String status;
  final List<GemDetails> data;

  MafRegistrationWiseDetails({
    required this.message,
    required this.status,
    required this.data,
  });

  factory MafRegistrationWiseDetails.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonData = json['data'] ?? [];
    List<GemDetails> stateDataList =
    jsonData.map((item) => GemDetails.fromJson(item)).toList();

    return MafRegistrationWiseDetails(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      data: stateDataList,
    );
  }
}

class GemDetails {
  final String firmName;
  final String email_ID;
  final String code;
  final String address;
  final String state;
  final String location;
  final String paN_Number;

  GemDetails({
    required this.firmName,
    required this.email_ID,
    required this.code,
    required this.address,
    required this.state,
    required this.location,
    required this.paN_Number,
  });

  factory GemDetails.fromJson(Map<String, dynamic> json) {
    return GemDetails(
      firmName: json['firmName'].toString()!= "" ?json['firmName'].toString(): "NA",
      email_ID: json['emailId'] .toString()!= "" ?json['emailId'].toString(): "NA",
      code: json['code'] .toString()!= "" ?json['code'].toString(): "NA",
      address: json['address'] .toString()!= "null" ?json['address'].toString(): "NA",
      state: json['state'] .toString()!= "" ?json['state'].toString(): "NA",
      location: json['city'] .toString()!= "" ?json['city'].toString(): "NA",
      paN_Number: json['paN_Number'] .toString()!= "null" ?json['paN_Number'].toString(): "NA",
    );
  }
}
