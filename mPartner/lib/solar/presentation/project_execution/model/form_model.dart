class FormModel {
  final String projectType;
  final String category;
  final String? companyName;
  final String contactPersonName;
  final String contactPersonNumber;
  final String contactPersonEmailId;
  final String? secondaryName;
  final String? secondaryNumber;
  final String? secondaryEmail;
  final String projectName;
  final String projectAddress;
  final String projectLandmark;
  final String projectLocation;
  final String projectPincode;
  final String state;
  final String city;
  final String solutionType;
  final String supportReason;
  final String subCategory;
  final int solutionTypeId;
  final int supportReasonId;
  final int subCategoryId;
  final String preferredDate;
  final String imagePath;


  FormModel({
    required this.projectType,
    required this.category,
    this.companyName,
    required this.contactPersonName,
    required this.contactPersonNumber,
    required this.contactPersonEmailId,
    this.secondaryName,
    this.secondaryNumber,
    this.secondaryEmail,
    required this.projectName,
    required this.projectAddress,
    required this.projectLandmark,
    required this.projectLocation,
    required this.projectPincode,
    required this.state,
    required this.city,
    required this.solutionType,
    required this.supportReason,
    required this.subCategory,
    required this.solutionTypeId,
    required this.supportReasonId,
    required this.subCategoryId,
    required this.preferredDate,
    required this.imagePath});
}