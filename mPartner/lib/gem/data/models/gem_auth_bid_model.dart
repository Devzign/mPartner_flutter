class GemAuthBidModel {
  int?total;
  int?received;
  int?rejected;
  int?inProgress;

  GemAuthBidModel({required this.total,required this.received,
    required this.rejected, required this.inProgress});
  factory GemAuthBidModel.toJson(Map<String,dynamic> json){
    return GemAuthBidModel(
      total:json["total"]??0,
      received:json["received"]??0,
      rejected:json["rejected"]??0,
      inProgress:json["inProgress"]??0,

    );
  }
}