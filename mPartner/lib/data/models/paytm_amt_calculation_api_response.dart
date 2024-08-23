class ApiResponseWithGST {
  final String Message;
  final String Status;
  final String gstDeductionAmount;
  final String gstDeductionPercentage;
  final String grossAmountAfterGstDeduction;
  final String tdsDeduction;
  final String tdsDeductionPercentage;
  final String netAmount;
  final String Paytm_init_id;

  ApiResponseWithGST({
    required this.Message,
    required this.Status,
    required this.netAmount,
    required this.gstDeductionAmount,
    required this.grossAmountAfterGstDeduction,
    required this.gstDeductionPercentage,
    required this.tdsDeduction,
    required this.tdsDeductionPercentage,
    required this.Paytm_init_id,
  });

  factory ApiResponseWithGST.fromJson(Map<String, dynamic> data) =>
      ApiResponseWithGST(
        Message: data['message'],
        Status: data['status'],
        gstDeductionAmount: data['data']['gstDeductionAmount'],
        gstDeductionPercentage: data['data']['gstDeductionPercentage'],
        grossAmountAfterGstDeduction: data['data']
            ['grossAmountAfterGstDeduction'],
        tdsDeduction: data['data']['tdsValue'],
        tdsDeductionPercentage: data['data']['tdsPercentage'],
        netAmount: data['data']['netAmount'],
        Paytm_init_id: data['Data']['Paytm_init_id'],
      );

      
 static ApiResponseWithGST empty() {
    return ApiResponseWithGST(
      Message: '',
      Status: '',
      netAmount: '',
      gstDeductionAmount: '',
      grossAmountAfterGstDeduction: '',
      gstDeductionPercentage: '',
      tdsDeduction: '',
      tdsDeductionPercentage: '',
      Paytm_init_id: '');
  }
}

class ApiResponseWithoutGST {
  final String Message;
  final String Status;
  final String tdsDeduction;
  final String tdsDeductionPercentage;
  final String netAmount;
  final String Paytm_init_id;

  ApiResponseWithoutGST({
    required this.Message,
    required this.Status,
    required this.tdsDeduction,
    required this.tdsDeductionPercentage,
    required this.netAmount,
    required this.Paytm_init_id,
  });

  factory ApiResponseWithoutGST.fromJson(Map<String, dynamic> data) =>
      ApiResponseWithoutGST(
        Message: data['message'],
        Status: data['status'],
        tdsDeduction: data['data']['tdsValue'],
        netAmount: data['data']['netAmount'],
        tdsDeductionPercentage: data['data']['tdsPercentage'],
        Paytm_init_id: data['data']['paytm_init_id'],
      );

  static ApiResponseWithoutGST empty() {
    return ApiResponseWithoutGST(
      Message: '',
      Status: '',
      tdsDeduction: '',
      tdsDeductionPercentage: '',
      netAmount: '',
      Paytm_init_id: '',
    );
  }
}
