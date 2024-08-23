class SolarFinanceCustomerProjectDetails {
    String message;
    String status;
    String token;
    List<CustomerProjectDetailsModel> data;
    dynamic data1;

    SolarFinanceCustomerProjectDetails({
        required this.message,
        required this.status,
        required this.token,
        required this.data,
        required this.data1,
    });

    factory SolarFinanceCustomerProjectDetails.fromJson(Map<String, dynamic> json) => SolarFinanceCustomerProjectDetails(
        message: json["message"] ?? "",
        status: json["status"] ?? "",
        token: json["token"] ?? "",
        data: List<CustomerProjectDetailsModel>.from(json["data"].map((x) => CustomerProjectDetailsModel.fromJson(x))) ?? [],
        data1: json["data1"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "token": token,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "data1": data1,
    };
}

class CustomerProjectDetailsModel {
    String projectId;
    String categoryName;
    String contactPersonName;
    String contactPersonMobileNo;
    String contactPersonEmailId;
    String projectName;
    String pincode;
    String state;
    String city;
    String solutionType;
    String projectCapacity;
    int projectCost;
    String preferredBankName;
    String panNumber;
    String status;
    String remarks;
    String firmName;
    String firmGSTINNumber;
    String approvedBank;
    String secondaryContactName;
    String secondaryContactMobileNo;
    String secondaryContactEmailId;
    String requestDate;
    String lastUpdateDate;
    String reason;

    CustomerProjectDetailsModel({
        required this.projectId,
        required this.categoryName,
        required this.contactPersonName,
        required this.contactPersonMobileNo,
        required this.contactPersonEmailId,
        required this.projectName,
        required this.pincode,
        required this.state,
        required this.city,
        required this.solutionType,
        required this.projectCapacity,
        required this.projectCost,
        required this.preferredBankName,
        required this.panNumber,
        required this.status,
        required this.remarks,
        required this.firmName,
        required this.firmGSTINNumber,
        required this.approvedBank,
        required this.secondaryContactName,
        required this.secondaryContactMobileNo,
        required this.secondaryContactEmailId,
        required this.requestDate,
        required this.lastUpdateDate,
        required this.reason
    });

    factory CustomerProjectDetailsModel.fromJson(Map<String, dynamic> json) => CustomerProjectDetailsModel(
        projectId: json["projectId"] ?? "",
        categoryName: json["categoryName"] ?? "",
        contactPersonName: json["contactPersonName"] ?? "",
        contactPersonMobileNo: json["contactPersonMobileNo"] ?? "",
        contactPersonEmailId: json["contactPersonEmailId"] ?? "",
        projectName: json["projectName"] ?? "",
        pincode: json["pincode"] ?? "",
        state: json["state"] ?? "",
        city: json["city"] ?? "",
        solutionType: json["solutionType"] ?? "",
        projectCapacity: json["projectCapacity"] ?? "",
        projectCost: json["projectCost"] ?? 0,
        preferredBankName: json["preferredBankName"] ?? "",
        panNumber: json["panNumber"] ?? "",
        status: json["status"] ?? "",
        remarks: json["remarks"] ?? "",
        firmName: json["firmName"] ?? "",
        firmGSTINNumber: json['firmGSTINNumber'] ?? "",
        approvedBank: json["approvedBank"] ?? "",
        secondaryContactName: json['secondaryContactName'] ?? "",
        secondaryContactEmailId: json['secondaryContactEmailId'] ?? "",
        secondaryContactMobileNo: json['secondaryContactMobileNo'] ?? "",
        requestDate: json['requestDate'] ?? "",
        lastUpdateDate: json['lastUpdateDate'] ?? "",
        reason: json['reason'] ?? ""
    );

    Map<String, dynamic> toJson() => {
        "projectId": projectId,
        "categoryName": categoryName,
        "contactPersonName": contactPersonName,
        "contactPersonMobileNo": contactPersonMobileNo,
        "contactPersonEmailId": contactPersonEmailId,
        "projectName": projectName,
        "pincode": pincode,
        "state": state,
        "city": city,
        "solutionType": solutionType,
        "projectCapacity": projectCapacity,
        "projectCost": projectCost,
        "preferredBankName": preferredBankName,
        "panNumber": panNumber,
        "status": status,
        "remarks": remarks,
        "firmName": firmName,
        "firmGSTINNumber": firmGSTINNumber,
        "approvedBank" : approvedBank,
        "secondaryContactName": secondaryContactName,
        "secondaryContactEmailId": secondaryContactEmailId,
        "secondaryContactMobileNo": secondaryContactMobileNo,
        "requestDate": requestDate,
        "lastUpdateDate": lastUpdateDate,
        "reason": reason
    };
}
