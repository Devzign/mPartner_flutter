class PreferredBankResponse {
  final String message;
  final String status;
  final String token;
  final List<PreferredBank> data;

  PreferredBankResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
  });

  factory PreferredBankResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<PreferredBank> preferredBank =
    dataList.map((item) => PreferredBank.fromJson(item)).toList();

    return PreferredBankResponse(
      message: json['message']??"",
      status: json['status']??"",
      token: json['token']??"",
      data: preferredBank,
    );
  }
}

class PreferredBank {
  final int id;
  final String name;

  PreferredBank({
    required this.id,
    required this.name,
  });

  factory PreferredBank.fromJson(Map<String, dynamic> json) {
    return PreferredBank(
      id: json['bankId']??"",
      name: json['bankName']??"",
    );
  }
}
