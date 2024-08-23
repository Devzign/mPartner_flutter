import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String sap_Code;
  final String name;
  final String address1;
  final String address2;
  final String city;
  final String district;
  final String state;
  final String phone;
  final String email;
  final String userType;
  final String psb;
  final String profileImg;
  final String panImg;
  final String gstCerImg;
  final String passportFront;
  final String passportBack;
  final String authCertImg;
  final String authCert_IssuedDate;
  final String certOfApprectiationImg;
  final String certOfAppreciation_IssuedDate;
  final String panStatus;
  final String panRemarks;
  final String passportNo;
  final String passportStatus;
  final String passportRemarks;
  final String gstStatus;
  final String gstRemarks;
  final String anniversary;
  final String birthday;
  final String businessName;
  final String secondaryDevice1;
  final String secondaryDevice2;
  final String customerType;
  final String dealer_Name;
  final String pincode;
  final String owner_Name;
  final String permanentAccountNumber;
  final int handshakeFlag;
  final String secondaryName;
  final String relationShip;
  final String createdOn;
  final String gstNumber;
  final int tC_Accepted;
  const UserProfile(
      {required this.sap_Code,
      required this.name,
      required this.address1,
      required this.address2,
      required this.city,
      required this.district,
      required this.state,
      required this.phone,
      required this.email,
      required this.userType,
      required this.psb,
      required this.profileImg,
      required this.anniversary,
      required this.birthday,
      required this.businessName,
      required this.secondaryDevice1,
      required this.secondaryDevice2,
      required this.customerType,
      required this.dealer_Name,
      required this.pincode,
      required this.owner_Name,
      required this.permanentAccountNumber,
      required this.handshakeFlag,
      required this.relationShip,
      required this.secondaryName,
      required this.createdOn,
      required this.gstNumber,
      required this.panImg,
      required this.gstCerImg,
      required this.passportFront,
      required this.passportBack,
      required this.authCertImg,
      required this.authCert_IssuedDate,
      required this.certOfApprectiationImg,
      required this.certOfAppreciation_IssuedDate,
      required this.panStatus,
      required this.panRemarks,
      required this.passportNo,
      required this.passportStatus,
      required this.passportRemarks,
      required this.gstStatus,
      required this.gstRemarks,
      required this.tC_Accepted
      });

  @override
  List<Object> get props => [
        sap_Code,
        name,
        address1,
        address2,
        city,
        district,
        state,
        phone,
        email,
        userType,
        psb,
        profileImg,
        anniversary,
        birthday,
        businessName,
        secondaryDevice1,
        secondaryDevice2,
        customerType,
        dealer_Name,
        pincode,
        owner_Name,
        permanentAccountNumber,
        handshakeFlag,
        secondaryName,
        relationShip,
        createdOn,
        gstNumber,
        panImg,
        gstCerImg,
        passportFront,
        passportBack,
        authCertImg,
        authCert_IssuedDate,
        certOfApprectiationImg,
        certOfAppreciation_IssuedDate,
        panStatus,
        panRemarks,
        passportNo,
        passportStatus,
        passportRemarks,
        gstStatus,
        gstRemarks,
        tC_Accepted
      ];

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        sap_Code: json["sap_Code"] as String? ?? '',
        name: json["name"] as String? ?? '',
        phone: json["phone"] as String? ?? '',
        address1: json["address1"] as String? ?? '',
        address2: json["address2"] as String? ?? '',
        district: json["district"] as String? ?? '',
        state: json["state"] as String? ?? '',
        email: json["email"] as String? ?? '',
        userType: json["userType"] as String? ?? '',
        psb: json["psb"] as String? ?? '',
        profileImg: json["profileImg"] as String? ?? '',
        anniversary: json["anniversary"] as String? ?? '',
        birthday: json["birthday"] as String? ?? '',
        businessName: json["businessName"] as String? ?? '',
        city: json["city"] as String? ?? '',
        secondaryDevice1: json["secondaryDevice1"] as String? ?? '',
        secondaryDevice2: json["secondaryDevice2"] as String? ?? '',
        customerType: json["customerType"] as String? ?? '',
        dealer_Name: json["dealer_Name"] as String? ?? '',
        pincode: json["pincode"] as String? ?? '',
        owner_Name: json["owner_Name"] as String? ?? '',
        permanentAccountNumber: json["permanentAccountNumber"] as String? ?? '',
        handshakeFlag: json["handshake_Flag"] as int? ?? 0,
        secondaryName: json["secondaryName"] as String? ?? '',
        relationShip: json["relationShip"] as String? ?? '',
        createdOn: json["createdOn"] as String? ?? '',
        gstNumber: json['gsT_Number'] as String? ?? '',
        panImg: json['panImg']  as String? ?? '',
        gstCerImg: json['gstCerImg']  as String? ?? '',
        passportFront: json['passportFront']  as String? ?? '',
        passportBack: json['passportBack']  as String? ?? '',
        authCertImg: json['authCertImg']  as String? ?? '',
        authCert_IssuedDate: json['authCert_IssuedDate']  as String? ?? '',
        certOfApprectiationImg: json['certOfApprectiationImg']  as String? ?? '',
        certOfAppreciation_IssuedDate: json['certOfAppreciation_IssuedDate']  as String? ?? '',
        panStatus: json['panStatus']  as String? ?? '',
        panRemarks: json['panRemarks']  as String? ?? '',
        passportNo: json['passportNo']  as String? ?? '',
        passportStatus: json['passportStatus']  as String? ?? '',
        passportRemarks: json['passportRemarks']  as String? ?? '',
        gstStatus: json['gstStatus']  as String? ?? '',
        gstRemarks: json['gstRemarks']  as String? ?? '',
        tC_Accepted: json['tC_Accepted']  as int? ?? 0,
      );
  Map<String, dynamic> toJson() => {
        "sap_Code": sap_Code,
        "name": name,
        "address1": address1,
        "address2": address2,
        "city": city,
        "district": district,
        "state": state,
        "phone": phone,
        "email": email,
        "userType": userType,
        "psb": psb,
        "profileImg": profileImg,
        "anniversary": anniversary,
        "birthday": birthday,
        "businessName": businessName,
        "secondaryDevice1": secondaryDevice1,
        "secondaryDevice2": secondaryDevice2,
        "customerType": customerType,
        "dealer_Name": dealer_Name,
        "pincode": pincode,
        "owner_Name": owner_Name,
        "permanentAccountNumber": permanentAccountNumber,
        "handshake_Flag": handshakeFlag,
        "secondaryName": secondaryName,
        "relationShip": relationShip,
        "createdOn": createdOn,
        "gstNumber": gstNumber,
        "panImg": panImg,
        "gstCerImg" : gstCerImg,
        "passportFront" : passportFront,
        "passportBack" : passportBack,
        "authCertImg": authCertImg,
        "authCert_IssuedDate" : authCert_IssuedDate,
        "certOfApprectiationImg": certOfApprectiationImg,
        "certOfAppreciation_IssuedDate": certOfAppreciation_IssuedDate,
        "panStatus": panStatus,
        "panRemarks": panRemarks,
        "passportNo": passportNo,
        "passportStatus":passportStatus,
        "passportRemarks": passportRemarks,
        "gstStatus": gstStatus,
        "gstRemarks": gstRemarks,
        "tC_Accepted": tC_Accepted
  };
}
