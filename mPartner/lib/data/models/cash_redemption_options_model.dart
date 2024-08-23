import 'package:equatable/equatable.dart';

class CashRedemptionOptions extends Equatable {
  int? id;
  String? name;
  String? key;
  String? icon;
  String? message;
  String? displayText;
  String? expendedImage;
  String? description;

  CashRedemptionOptions({
    this.id,
    this.name,
    this.key,
    this.icon,
    this.message,
    this.displayText,
    this.expendedImage,
    this.description
  });

  @override
  List<Object?> get props => [
        id,
        name,
        key,
        icon,
        message,
        displayText,
        expendedImage,
        description
      ];

  factory CashRedemptionOptions.fromJson(Map<String, dynamic> json) {
    return CashRedemptionOptions(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      key: json['key'] ?? "",
      icon: json['icon'] ?? "",
      message: json['message'] ?? "",
      displayText: json['displayText'] ?? "",
      expendedImage: json['expendedImage'] ?? "",
      description: json['description'] ?? ""
    );
  }
}
