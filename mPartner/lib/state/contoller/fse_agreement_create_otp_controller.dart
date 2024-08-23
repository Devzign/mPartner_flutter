import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/fse_agreement_create_otp_model.dart';
import '../../utils/app_constants.dart';

class FseAgreementCreateOtpController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;
  bool otpSentSuccessfully = false;

  var fseAgreementCreateOtpResponse = FseAgreementCreateOtpResponse(
    message: '',
    status: '',
    token: '',
    data: DataItem(code: '', desc: ''),
    data1: null,
  ).obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchFseAgreementCreateOtp() async {
    try {
      isLoading(true);
      final result = await mPartnerRemoteDataSource.getFseAgreementCreateOtp();
      result.fold((failure) {
        error('Failed to fetch Fse Agreement Create Otp: $failure');
      }, (fseAgreementCreateOtpResponseData) {
        fseAgreementCreateOtpResponse(fseAgreementCreateOtpResponseData);
        logger.e(
            "FSE otp Sent Successfully! ----> ${fseAgreementCreateOtpResponseData.data}");
        if (fseAgreementCreateOtpResponseData.data.code == "SUCCESS") {
          otpSentSuccessfully = true;
        }
      });
    } finally {
      isLoading(false);
    }
  }
}
