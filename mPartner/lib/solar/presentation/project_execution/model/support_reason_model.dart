import 'dart:convert';

class ProjectExecutionSupportReasonResponse {
  String message;
  String status;
  String token;
  List<SupportReason> data;
  dynamic data1;

  ProjectExecutionSupportReasonResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory ProjectExecutionSupportReasonResponse.fromJson(Map<String, dynamic> json) => ProjectExecutionSupportReasonResponse(
    message: json["message"] ?? "",
    status: json["status"] ?? "",
    token: json["token"] ?? "",
    data: List<SupportReason>.from(json["data"].map((x) => SupportReason.fromJson(x))) ?? [],
    data1: json["data1"] ?? "",
  );


  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "token": token,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "data1": data1,
  };
}

class SupportReason {
  int reasonId;
  String reason;
  bool? isSelected=false;
  List<SubCategory> subCategories;

  SupportReason({
    required this.reasonId,
    required this.reason,
    this.isSelected,
    required this.subCategories,

  });

  factory SupportReason.fromJson(Map<String, dynamic> json) => SupportReason(
    reasonId: json["reasonId"] ?? "",
    reason: json["reason"] ?? "",
    subCategories: List<SubCategory>.from(json["subCategories"].map((x) => SubCategory.fromJson(x))) ?? [],
  );

  Map<String, dynamic> toJson() => {
    "reasonId": reasonId,
    "reason": reason,
    "subCategories": List<dynamic>.from(subCategories.map((x) => x.toJson())),
  };
}



class SubCategory {
  int subCategoryId;
  String subCategory;

  SubCategory({
    required this.subCategoryId,
    required this.subCategory,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    subCategoryId: json["subCategoryId"] ?? "",
    subCategory: json["subCategory"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "subCategoryId": subCategoryId,
    "subCategory": subCategory,
  };
}
