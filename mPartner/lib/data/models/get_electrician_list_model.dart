import 'package:equatable/equatable.dart';

class Electrician extends Equatable {
  final int id;
  final String disCode;
  final String electricianName;
  final String city;
  final String district;
  final String state;
  final String country;
  final String dlr_Address1;
  final String dlr_Address2;
  final String dlr_Phone;

  const Electrician({
    required this.id,
    required this.disCode,
    required this.electricianName,
    required this.city,
    required this.district,
    required this.state,
    required this.country,
    required this.dlr_Address1,
    required this.dlr_Address2,
    required this.dlr_Phone,
  });

  @override
  List<Object?> get props => [
        id,
        disCode,
        electricianName,
        city,
        district,
        state,
        country,
        dlr_Address1,
        dlr_Address2,
        dlr_Phone
      ];

  factory Electrician.fromJson(Map<String, dynamic> json) {
    return Electrician(
      id: json['id'] ?? -1,
      disCode: json['elec_Sap_Code'] ?? '',
      electricianName: json['elec_Name'] ?? '',
      city: json['elec_City'] ?? '',
      district: json['elec_District'] ?? '',
      state: json['elec_State'] ?? '',
      country: json['country'] ?? 'India',
      dlr_Address1: json['elec_Address1'] ?? '',
      dlr_Address2: json['elec_Address2'] ?? '',
      dlr_Phone: json['elec_Phone'] ?? '',
    );
  }
}
