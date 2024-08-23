import 'package:equatable/equatable.dart';

class Dealer extends Equatable {
  final String dealerName;
  final String dlr_Sap_Code;
  final String city;
  final String district;
  final String state;
  final String dlr_Address1;
  final String dlr_Address2;
  final String dlr_Phone;
  final String pinCode;
  final String contactName;



  const Dealer(
        {
        required this.dealerName,
        required this.dlr_Sap_Code,
        required this.city,
        required this.district,
        required this.state,
        required this.dlr_Address1,
        required this.dlr_Address2,
        required this.dlr_Phone,required this.pinCode,required this.contactName});

  @override
  List<Object?> get props => [
        dealerName,
        city,
        district,
        state,
        dlr_Address1,
        dlr_Address2,
        dlr_Phone,
        pinCode,
       contactName
      ];

  factory Dealer.fromJson(Map<String, dynamic> json) {
    return Dealer(
      dealerName: json['dlr_Name'] ?? '',
      dlr_Sap_Code: json['dlr_Sap_Code'],
      city: json['dlr_City'] ?? '',
      district: json['dlr_District'] ?? '',
      state: json['dlr_State'] ?? '',
      dlr_Address1: json['dlr_Address1'] ?? '',
      dlr_Address2: json['dlr_Address2'] ?? '',
      dlr_Phone: json['dlr_Phone'] ?? '',
      pinCode: json['pinCode'] ?? '',
      contactName: json['contactName'] ?? '',


    );
  }

  Map<String,dynamic> toJson (){
    return {
      "dlr_code" : dlr_Sap_Code,
      "dlr_name" : dealerName,
      "city" : city
    };
  }
}
