import 'package:equatable/equatable.dart';

import '../../../presentation/screens/network_management/dealer_electrician/components/common_network_utils.dart';
import '../../../utils/utils.dart';

class StatusData extends Equatable {
  final String? dealerName;
  final String? dealerCode;
  final String? phoneNo;
  final String? emailId;
  final String? pan;
  final String? blockRedumption;
  final String? requestStatus;
  final String? dealerId;
  final String? remarks;
  final String? createdOn;
  final String? updatedOn;
  final String? status;

  const StatusData(
      {required this.dealerName,
      required this.phoneNo,
      required this.emailId,
      required this.pan,
      required this.blockRedumption,
      required this.createdOn,
      required this.dealerId,
      required this.dealerCode,
      required this.remarks,
      required this.requestStatus,
      required this.updatedOn,
      required this.status});

  @override
  List<Object> get props => [
        dealerName ?? "",
        phoneNo ?? "",
        emailId ?? "",
        pan ?? "",
        blockRedumption ?? "",
        createdOn ?? "",
        dealerId ?? "",
        remarks ?? "",
        requestStatus ?? "",
        updatedOn ?? "",
        dealerCode ?? "",
        status ?? "",
      ];

  factory StatusData.fromJson(Map<String, dynamic> json, String userType) {
    return (userType == UserType.dealer)
        ? StatusData(
            dealerName: json["dealerName"].toString(),
            phoneNo: json["dealerMobile"],
            emailId: json["emailId"],
            pan: json["paN_CARD_Number"],
            blockRedumption: json["blockRedemption"],
            createdOn: convertDateStringToFormatDate(json["created_On"]),
            dealerId: json["dealerId"].toString(),
            remarks: json["dealerRemarks"],
            requestStatus: json["emailId"],
            updatedOn: json["updated_On"] == null
                ? ""
                : convertDateStringToFormatDate(json["updated_On"]),
            dealerCode: json["dealerCode"] ?? json["dealerId"].toString(),
            status: json["dealerStatus"],
          )
        : StatusData(
            dealerName: json["electricianName"].toString(),
            phoneNo: json["electricianMobile"],
            emailId: json["emailId"],
            pan: json["electricianAddress"],
            blockRedumption: json["blockRedemption"],
            createdOn: convertDateStringToFormatDate(json["created_On"]),
            dealerId: json["electricianId"].toString(),
            remarks: json["electricianRemarks"],
            requestStatus: json["emailId"],
            updatedOn: json["updatedOn"] == null
                ? ""
                : convertDateStringToFormatDate(json["updatedOn"]),
            dealerCode: (json["electricianCode"] != null &&
                    json["electricianCode"].toString().isNotEmpty)
                ? json["electricianCode"]
                : json["electricianId"].toString(),
            status: json["electricianStatus"],
          );
  }
}
