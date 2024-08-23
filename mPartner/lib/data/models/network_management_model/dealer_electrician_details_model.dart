import 'package:equatable/equatable.dart';

import '../../../presentation/screens/network_management/dealer_electrician/components/common_network_utils.dart';
import '../../../utils/utils.dart';

class DealerElectricianDetail extends Equatable {
  final String? name;
  final String? code;
  final String? phoneNo;
  final String? emailId;
  final String? pan;
  final String? blockRedumption;
  final String? requestStatus;
  final String? id;
  final String? remarks;
  final String? createdOn;
  final String? updatedOn;
  final String? status;
  final String? userId;
  final String? panNumber;
  final String? ownerName;
  final String? firmName;
  final String? dob;
  final String? address1;
  final String? address2;
  final String? city;
  final String? district;
  final String? state;
  final String? pincode;
  final int? blocked;
  final String? electricianId;
  final String?dealerRemovalMessage;
  final String?ambmStatus;
  final String?dealerUnmappedStatus;
  final String?dealerBlockRedemptionStatus;
  final String?ambmBlockRedemptionStatusForDealer;
  final String?blockRedemptionMessage;



  const DealerElectricianDetail(
      {this.name,
      this.phoneNo,
      this.emailId,
      this.pan,
      this.blockRedumption,
      this.createdOn,
      this.id,
      this.code,
      this.remarks,
      this.requestStatus,
      this.updatedOn,
      this.status,
      this.userId,
      this.panNumber,
      this.ownerName,
      this.firmName,
      this.dob,
      this.address1,
      this.address2,
      this.city,
      this.district,
      this.state,
      this.pincode,
      this.blocked,
      this.electricianId,
        this.dealerRemovalMessage,
        this.ambmStatus,
        this.dealerUnmappedStatus,
        this.dealerBlockRedemptionStatus,
        this.ambmBlockRedemptionStatusForDealer,
        this.blockRedemptionMessage
      });

  @override
  List<Object> get props => [
        name ?? "",
        phoneNo ?? "",
        emailId ?? "",
        pan ?? "",
        blockRedumption ?? "",
        createdOn ?? "",
        id ?? "",
        remarks ?? "",
        requestStatus ?? "",
        updatedOn ?? "",
        code ?? "",
        status ?? "",
        userId ?? "",
        panNumber ?? "",
        ownerName ?? "",
        firmName ?? "",
        dob ?? "",
        address1 ?? "",
        address2 ?? "",
        city ?? "",
        district ?? "",
        state ?? "",
        pincode ?? "",
        blocked ?? "",
        electricianId ?? "",
        dealerRemovalMessage??"",
        ambmStatus??"",
        dealerUnmappedStatus??"",
        dealerBlockRedemptionStatus??"",
        ambmBlockRedemptionStatusForDealer??"",
        blockRedemptionMessage??""

       ];

  factory DealerElectricianDetail.fromJson(
      Map<String, dynamic> json, String userType) {
    return (userType == UserType.dealer)
        ? DealerElectricianDetail(
            name: json.containsKey("dealerName")
                ? json["dealerName"]
                : json["firmName"],
            phoneNo: (json.containsKey("dealerMobile"))
                ? json["dealerMobile"]
                : json["mobile_No"],
            emailId: (json.containsKey("dealerEmail"))
                ? json["dealerEmail"]
                : json["email_Id"],
            blocked: json["blocked"] ?? 0,
            pan: json["panurl"],
            blockRedumption: json["blockRedemption"],
            createdOn: json.containsKey("createdOn")
                ? convertDateStringToFormatDate(json["createdOn"])
                : "",
            id: (json.containsKey("dealerId"))
                ? json["dealerId"] ?? "".toString()
                : json["id"] ?? "".toString(),
            remarks: json["remarks"],
            requestStatus:
                ((json["dealerStatus"] ?? "").toString().toLowerCase() ==
                        "active")
                    ? "Active"
                    : json["dealerStatus"],
            updatedOn: json["updatedOn"] == null
                ? ""
                : convertDateStringToFormatDate(json["updatedOn"]),
            code: (json.containsKey("dealerCode"))
                ? (json["dealerCode"] ?? json["dealerId"] ?? "".toString())
                : json["request_No"],
            status: json.containsKey("dealerStatus")
                ? ((json["dealerStatus"] ?? "").toString().toLowerCase() ==
                        "active")
                    ? "Active"
                    : json["dealerStatus"]
                : json["status"] ?? "".toString(),
            userId: json["distributor_Code"],
            panNumber: json["panNumber"],
            ownerName: json["ownerName"],
            firmName: json["dealer_Firm_Name"],
            dob: json["dateofBirth"],
            address1: (json["address1"] ?? "") +
                ", " +
                (json["address2"] ?? "") +
                ", " +
                (json["city"] ?? "") +
                ", " +
                (json["district"] ?? "") +
                ", " +
                (json["state"] ?? "") +
                ", " +
                (json["pincode"] ?? ""),
            address2: json["address2"] ?? "",
            city: json["city"],
            district: json["district"],
            state: json["state"],
            pincode: json["pincode"],
            dealerRemovalMessage:json["dealerRemovalMessage"]??"",
            ambmStatus:json["ambmStatus"]??"",
            dealerUnmappedStatus:json["dealerUnmappedStatus"]??"",
            dealerBlockRedemptionStatus:json["dealerBlockRedemptionStatus"]??"",
            ambmBlockRedemptionStatusForDealer:json["ambmBlockRedemptionStatusForDealer"]??"",
            blockRedemptionMessage:json["blockRedemptionMessage"]??"",



          )
        : DealerElectricianDetail(
            name: json.containsKey("name")
                ? json["name"].toString()
                : json["electrician_Name"].toString(),
            phoneNo: (json.containsKey("electricianMobile"))
                ? json["electricianMobile"]
                : json["mobile_no"],
            emailId: (json.containsKey("emailId"))
                ? json["emailId"]
                : json["email_id"],
            blocked: json["flag"] ?? 0,
            pan: json["img1_one"],
            blockRedumption: json["blockRedemption"],
            createdOn: (json["createdon"] == null
                ? ""
                : convertDateStringToFormatDate(json["createdon"])),
            id: json.containsKey("electricianId")
                ? json["electricianId"].toString()
                : json["request_no"],
            remarks: json["remarks"],
            requestStatus: json["request_status"],
            updatedOn: json["updatedon"] == null
                ? ""
                : convertDateStringToFormatDate(json["updatedon"]),
            code: json.containsKey("electricianCode")
                ? json["electricianCode"].toString()
                : json["request_no"],
            status: (json.containsKey("status"))
                ? json["status"].toString()
                : json["electricianStatus"],
            userId: json["sap_code"],
            panNumber: json["document_no1"],
            ownerName: json["electrician_Name"],
            firmName: json["electrician_Name"],
            dob: json["dateofBirth"],
            address1: (json["address1"] ?? "") +
                ", " +
                (json["address2"] ?? "") +
                ", " +
                (json["city"] ?? "") +
                ", " +
                (json["district"] ?? "") +
                ", " +
                (json["state"] ?? "") +
                ", " +
                (json["pincode"] ?? ""),
            address2: json["address2"],
            city: json["city"],
            district: json["district"],
            state: json["state"],
            pincode: json["pincode"],
            electricianId: (json["id"]??"").toString(),


          );
  }
}
