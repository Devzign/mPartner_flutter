class UserGstUploadModel {
  final String message;
  final String status;
  final String token;
  final PhotoDetails data;
  final String data1;

  UserGstUploadModel({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory UserGstUploadModel.fromJson(Map<String, dynamic> json) {
    return UserGstUploadModel(
      message: json['message'] ?? "",
      status: json['status'] ?? "",
      token: json['token'] ?? "",
      data: PhotoDetails.fromJson(json['data'] ?? {}),
      data1: json['data1']?? "",
    );
  }
}

class PhotoDetails {
  final String filename;
  final String filepath;

  PhotoDetails({
    required this.filename,
    required this.filepath,
  });

  factory PhotoDetails.fromJson(Map<String, dynamic> json) {
    return PhotoDetails(
      filename: json['filename'] ?? "",
      filepath: json['filepath'] ?? "",
    );
  }
}
