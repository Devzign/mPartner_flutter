import 'package:equatable/equatable.dart';
class Traveller extends Equatable {
  final String name;
  final String mobileNo;
  final String email;
  final String relation;
  final String passport;

  Traveller({
    required this.name,
    required this.mobileNo,
    required this.relation,
    required this.passport,
    required this.email,
  });

  @override
  List<Object?> get props => [
        name,
        mobileNo,
        relation,
        passport,
        email,
      ];

  factory Traveller.fromJson(Map<String, dynamic> json) {
    return Traveller(
        name: json['traveller_Name'] ?? "",
        mobileNo: json['mobileNo'] ?? "",
        relation: json['relation'] ?? "",
        passport: json['passport'] ?? "",
        email: json['emailId'] ?? "");
  }
}
