import 'package:equatable/equatable.dart';

class ReportType extends Equatable {
  String? reportType;
  String? description;

  ReportType({
    this.reportType,
    this.description,
  });

  @override
  List<Object?> get props => [
        reportType,
        description,
      ];

  factory ReportType.fromJson(Map<String, dynamic> json) {
    return ReportType(
      reportType: json['reportType'],
      description: json['description'],
    );
  }
}
