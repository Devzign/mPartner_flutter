import 'package:equatable/equatable.dart';

class EwarrantyOption {
  final String message;
  final String status;
  final String token;
  final List<EwarrantyOptionItem> data;

  EwarrantyOption({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
  });

  factory EwarrantyOption.fromJson(Map<String, dynamic> json) {
    return EwarrantyOption(
      message: json["message"],
      status: json["status"],
      token: json["token"],
      data: (json["data"] as List)
          .map((item) => EwarrantyOptionItem.fromJson(item))
          .toList(),
    );
  }
}

class EwarrantyOptionItem {
  final String name;
  final int status;

  EwarrantyOptionItem({
    required this.name,
    required this.status,
  });

  factory EwarrantyOptionItem.fromJson(Map<String, dynamic> json) {
    return EwarrantyOptionItem(
      name: json["name"],
      status: json["status"],
    );
  }
}
