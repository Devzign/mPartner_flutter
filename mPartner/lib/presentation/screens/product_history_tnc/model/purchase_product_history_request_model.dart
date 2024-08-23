class PurchaseProductHistoryRequestModel {
  String? userId;
  String? channel;
  String? osType;
  String? appVersion;
  String? deviceId;
  String? phoneNo;
  String? customerMobileNumber;
  int? pageNumber;
  int? pageSize;

  PurchaseProductHistoryRequestModel(
      {this.userId,
        this.channel,
        this.osType,
        this.appVersion,
        this.deviceId,
        this.phoneNo,
        this.customerMobileNumber,
        this.pageNumber,
        this.pageSize});

  PurchaseProductHistoryRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_Id'];
    channel = json['channel'];
    osType = json['os_Type'];
    appVersion = json['app_Version'];
    deviceId = json['device_Id'];
    phoneNo = json['PhoneNo'];
    customerMobileNumber = json['customerMobileNumber'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_Id'] = userId;
    data['channel'] = channel;
    data['os_Type'] = osType;
    data['app_Version'] = appVersion;
    data['device_Id'] = deviceId;
    data['PhoneNo'] = phoneNo;
    data['customerMobileNumber'] = customerMobileNumber;
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    return data;
  }
}
