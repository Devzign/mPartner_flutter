class MafListingHomePageModel {
  String? sBidNumber;
  String? dBidPublishDate;
  String? dBidDueDate;
  String? sBidStatus;
  String? sStatus;
  MafListingHomePageModel(
      {required this.sBidNumber,
      required this.dBidPublishDate,
      required this.dBidDueDate,
      required this.sBidStatus,
      required this.sStatus});
  factory MafListingHomePageModel.toJson(Map<String, dynamic> json) {
    return MafListingHomePageModel(
      sBidNumber: json["sBidNumber"],
      dBidPublishDate: json["dBidPublishDate"],
      sBidStatus: json["sBidStatus"],
      dBidDueDate: json["dBidDueDate"],
      sStatus: json["sStatus"],
    );
  }
}
