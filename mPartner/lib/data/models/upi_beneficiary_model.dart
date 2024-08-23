class UPIBeneficiaryModel {
  final String apimessage;
  final String message;
  final String status;
  final String ifsc;
  final String vpa;
  final String bankDetails;
  final String beneficiaryName;
  final String token;
  final String seqnumber;
  final String pgmerchantid;
  final String handleavailable;
  final String deviceid;
  final String cmid;
  final String upiMessage;

  UPIBeneficiaryModel({
    required this.apimessage,
    required this.message,
    required this.status,
    required this.ifsc,
    required this.vpa,
    required this.bankDetails,
    required this.beneficiaryName,
    required this.token,
    required this.seqnumber,
    required this.pgmerchantid,
    required this.handleavailable,
    required this.deviceid,
    required this.cmid,
    required this.upiMessage,
  });

  factory UPIBeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return UPIBeneficiaryModel(
      apimessage: json['message'] ?? '',
      message: (json['data'] != null && json['data'] != "")
          ? json['data']['message'] ?? ''
          : '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      seqnumber: (json['data'] != null && json['data'] != "")
          ? json['data']['seq_number'] ?? ''
          : '',
      pgmerchantid: (json['data'] != null && json['data'] != "")
          ? json['data']['pgmerchant_Id'] ?? ''
          : '',
      beneficiaryName: (json['data'] != null && json['data'] != "")
          ? json['data']['data']['name'] ?? ''
          : '',
      handleavailable: (json['data'] != null && json['data'] != "")
          ? json['data']['data']['handle_available'] ?? ''
          : '',
      deviceid: (json['data'] != null && json['data'] != "")
          ? json['data']['device_id'] ?? ''
          : '',
      ifsc: (json['data'] != null && json['data'] != "")
          ? json['data']['ifsc'] ?? ''
          : '',
      vpa: (json['data'] != null && json['data'] != "")
          ? json['data']['vpa'] ?? ''
          : '',
      cmid: (json['data'] != null && json['data'] != "")
          ? json['data']['cmid']
          : '',
      bankDetails: (json['data'] != null && json['data'] != "")
          ? json['data']['bankdetails'] ?? ''
          : '',
      upiMessage: (json['data'] != null && json['data'] != "")
          ? json['data']['upi_message'] ?? ''
          : '',
    );
  }

  static UPIBeneficiaryModel empty() {
    return UPIBeneficiaryModel(
        apimessage: '',
        message: '',
        status: '',
        ifsc: '',
        vpa: '',
        bankDetails: '',
        beneficiaryName: '',
        token: '',
        seqnumber: '',
        pgmerchantid: '',
        handleavailable: '',
        deviceid: '',
        cmid: '',
        upiMessage: '');
  }
}
