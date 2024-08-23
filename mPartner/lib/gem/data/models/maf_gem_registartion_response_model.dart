class MafGemRegistrationResponseModel {
  final String message;
  final String status;
  final String msgs;
  final String token;
  //final PhotoDetails data;
 // final String data1;

  MafGemRegistrationResponseModel({
    required this.message,
    required this.status,
    required this.msgs,
    required this.token,
    //required this.data,
    //required this.data1,
  });

  factory MafGemRegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    return MafGemRegistrationResponseModel(
      message: json['message'] ?? "",
      status: json['status'] ?? "",
      msgs: json['msgs'] ??  "",
      token: json['token'] ?? "",
      //data: PhotoDetails.fromJson(json['data'] ?? {}),
      //data1: json['data1']?? "",
    );
  }
}

class PhotoDetails {
  final String panFront;
  final String frontFilepath;
  final String panBack;
  final String backFilepath;

  PhotoDetails({
    required this.panFront,
    required this.frontFilepath,
    required this.panBack,
    required this.backFilepath,
  });

  factory PhotoDetails.fromJson(Map<String, dynamic> json) {
    return PhotoDetails(
      panFront: json['panFront'] ?? "",
      frontFilepath: json['frontFilepath'] ?? "",
      panBack: json['panBack'] ?? "",
      backFilepath: json['backFilepath'] ?? "",
    );
  }
}
