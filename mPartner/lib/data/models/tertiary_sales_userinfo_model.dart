import 'package:equatable/equatable.dart';

class TertiarySalesUserInfo extends Equatable {
  String name;
  String address;
  String mobileNumber;
  String date;
  String saleTime;
  String referralCode;
  String tertiarySaleType;
  
  String otp;
  String transId;

  TertiarySalesUserInfo(
      {
      required this.name,
      required this.address,
      required this.mobileNumber,
      required this.date,
      required this.saleTime,
      required this.referralCode,
      required this.tertiarySaleType,
      required this.otp,
      required this.transId});

  @override
  List<Object?> get props => [
        name,
        address,
        mobileNumber,
        date,
        referralCode,
        tertiarySaleType,

        otp,
        transId,
      ];
}
