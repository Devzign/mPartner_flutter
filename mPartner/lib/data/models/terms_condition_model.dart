class TermsConditionsResponse {
  final String message;
  final String status;
  final String token;
  final List<TermsConditionData> data;

  TermsConditionsResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
  });

  factory TermsConditionsResponse.fromJson(Map<String, dynamic> json) {
    return TermsConditionsResponse(
      message: json['message']??"",
      status: json['status']??"",
      token: json['token']??"",
      data: (json['data'] as List)
          .map((item) => TermsConditionData.fromJson(item))
          .toList(),
    );
  }
}

class TermsConditionData {
  final String termsConditionData;
  final int id; // Added id field
  final String tnc_Description;


  TermsConditionData({
    required this.termsConditionData,
    required this.id,
    required this.tnc_Description,

  });

  factory TermsConditionData.fromJson(Map<String, dynamic> json) {
    return TermsConditionData(
      termsConditionData: json['terms_condition_data']??"",
      id: json['id']??0,
      tnc_Description: json['tnc_Description']??"",



    );
  }
}

