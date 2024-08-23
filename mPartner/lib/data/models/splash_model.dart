import 'package:equatable/equatable.dart';

class Splash extends Equatable {
  String message;
  String status;
  String token;
  List<ImageUrlData>? data;
  String data1;

  Splash({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory Splash.fromJson(Map<String, dynamic> json) => Splash(
    message: json["message"] ?? "",
    status: json["status"] ?? "",
    token: json["token"] ?? "",
    data: json["data"] != null ?
    List<ImageUrlData>.from((json["data"] as List).map((x) => ImageUrlData.fromJson(x))) : null,
    data1: json["data1"] ?? "",
      );

  @override
  List<Object?> get props => [
    message,status,token,data,data1
  ];
}

class ImageUrlData {
  final String imageUrl;

  ImageUrlData({
    required this.imageUrl,
  });

  factory ImageUrlData.fromJson(Map<String, dynamic> json) {
    return ImageUrlData(
      imageUrl: json["image_url"] ?? "",
    );
  }

}
