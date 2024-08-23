import 'package:equatable/equatable.dart';

class PrimaryReportTypeModel extends Equatable {
  String? primaryReportType;

  PrimaryReportTypeModel({
    this.primaryReportType,
  });

  @override
  List<Object?> get props => [
        primaryReportType,
      ];

  factory PrimaryReportTypeModel.fromJson(Map<String, dynamic> json) {
    return PrimaryReportTypeModel(
      primaryReportType: json['primaryReportType'],
    );
  }
}
