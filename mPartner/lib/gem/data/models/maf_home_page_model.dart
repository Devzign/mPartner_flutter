class MafHomePageModel {
  int?total;
  int?received;
  int?rejected;
  int?inProgress;

  MafHomePageModel({required this.total,required this.received,
    required this.rejected, required this.inProgress});
  factory MafHomePageModel.toJson(Map<String,dynamic> json){
    return MafHomePageModel(
      total:json["total"]??0,
      received:json["received"]??0,
      rejected:json["rejected"]??0,
      inProgress:json["inProgress"]??0,

    );
  }
}