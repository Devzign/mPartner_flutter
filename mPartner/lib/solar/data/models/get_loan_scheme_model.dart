class GetLoanSchemeModel {
  final String message;
  final String status;
  final String token;
  final List<LoanScheme> data;

  GetLoanSchemeModel({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
  });

  factory GetLoanSchemeModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<LoanScheme> loanScheme =
    dataList.map((item) => LoanScheme.fromJson(item)).toList();

    return GetLoanSchemeModel(
      message: json['message']??"",
      status: json['status']??"",
      token: json['token']??"",
      data: loanScheme,
    );
  }
}

class LoanScheme {
  final String thumbnail;
  final String pdf;
  final String lastUpdatedOn;
  final String title;

  LoanScheme({
    required this.thumbnail,
    required this.pdf,
    required this.lastUpdatedOn,
    required this.title,

  });

  factory LoanScheme.fromJson(Map<String, dynamic> json) {
    return LoanScheme(
      thumbnail: json['loan_scheme_banner_Thumbnail']??"",
      pdf: json['loan_scheme_banner_PDF']??"",
      lastUpdatedOn: json['lastUpdatedOn']??"",
      title: json['title']??"",
    );
  }
}
