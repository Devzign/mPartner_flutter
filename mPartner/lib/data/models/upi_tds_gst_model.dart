class UPITdsGstModel {
  final String message;
  final String status;
  final String token;
  final String tdsValue;
  final String netAmount;
  final String gstStatus;
  final String gstDeductionAmount;
  final String tdsDeductionPercentage;
  final String grossAmountAfterGstDeduction;
  final String gstDeductionPercentage;

  UPITdsGstModel({
    required this.message,
    required this.status,
    required this.token,
    required this.tdsValue,
    required this.netAmount,
    required this.gstStatus,
    required this.gstDeductionAmount,
    required this.grossAmountAfterGstDeduction,
    required this.gstDeductionPercentage,
    required this.tdsDeductionPercentage,
  });

  factory UPITdsGstModel.fromJson(Map<String, dynamic> json) {
    return UPITdsGstModel(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      tdsValue: (json['data1']!='')? json['data1']['tdsValue'] ?? '':'',
      netAmount: (json['data1']!='')?  json['data1']['netAmount'] ?? '':'',
      gstStatus: (json['data1']!='')? json['data1']['gstStatus'] ?? '':'',
      gstDeductionAmount: (json['data1']!='')? json['data1']['gstDeductionAmount'] ?? '':'',
      grossAmountAfterGstDeduction: (json['data1']!='')? json['data1']['grossAmountAfterGstDeduction'] ?? '':'',
      tdsDeductionPercentage: (json['data1']!='')? json['data1']['tdsPercentage'] ?? '':'',
      gstDeductionPercentage: (json['data1']!='')? json['data1']['gstPercentage']  ?? '':'',
    );
  }

  static UPITdsGstModel empty() {
    return UPITdsGstModel(
        message: '',
        status: '',
        token: '',
        tdsValue: '',
        netAmount: '',
        gstStatus: '',
        gstDeductionAmount: '',
        grossAmountAfterGstDeduction: '',
        gstDeductionPercentage: '',
        tdsDeductionPercentage: '');
  }
}
