class MafBidDetailsResponseModel {
  String? firmName;
  String? emailId;
  String? code;
  String? address;
  String? state;
  String? location;
  String? bidNumber;
  String? bidPublishDate;
  String? bidDueDate;
  String? gstNumber;
  String? panNumber;
  String tenderDocument;
  String mafDocumentUrl;
  String mafDocumentShareUrl;
  String status;
  String bidStatus;
  String reason;

  MafBidDetailsResponseModel({
    required this.firmName,
    required this.emailId,
    required this.code,
    required this.address,
    required this.state,
    required this.location,
    required this.bidNumber,
    required this.bidPublishDate,
    required this.bidDueDate,
    required this.gstNumber,
    required this.panNumber,
    required this.tenderDocument,
    required this.mafDocumentUrl,
    required this.mafDocumentShareUrl,
    required this.status,
    required this.bidStatus,
    required this.reason,
  });

  factory MafBidDetailsResponseModel.toJson(Map<String, dynamic> json) {
    return MafBidDetailsResponseModel(
      firmName: json["firmName"].toString() != ""
          ? json['firmName'].toString()
          : "NA",
      emailId:
          json["emailId"].toString() != "" ? json['emailId'].toString() : "NA",
      code: json["code"].toString() != "" ? json['code'].toString() : "NA",
      address: json["address"].toString() != "null"
          ? json['address'].toString()
          : "NA",
      state: json["state"].toString() != "" ? json['state'].toString() : "NA",
      location: json["location"].toString() != ""
          ? json['location'].toString()
          : "NA",
      bidNumber: json["bidNumber"].toString() != ""
          ? json['bidNumber'].toString()
          : "NA",
      bidPublishDate: json["bidPublishDate"].toString() != ""
          ? json['bidPublishDate'].toString()
          : "NA",
      bidDueDate: json["bidDueDate"].toString() != ""
          ? json['bidDueDate'].toString()
          : "NA",
      gstNumber: json["gstNumber"].toString() != ""
          ? json['gstNumber'].toString()
          : "NA",
      panNumber: json["panNumber"].toString() != "null"
          ? json['panNumber'].toString()
          : "NA",
      tenderDocument: json["tenderDocument"].toString(),
      mafDocumentUrl: json["mafDocumentUrl"].toString(),
      mafDocumentShareUrl: json["mafDocumentShareUrl"].toString(),
      status:
          json["status"].toString() != "" ? json['status'].toString() : "NA",
      bidStatus: json["bidStatus"].toString() != ""
          ? json['bidStatus'].toString()
          : "NA",
      reason:
          json["reason"].toString() != "" ? json['reason'].toString() : "NA",
    );
  }
}
