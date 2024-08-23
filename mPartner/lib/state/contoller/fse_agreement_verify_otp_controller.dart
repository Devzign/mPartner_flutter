import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/fse_acknowledge_model.dart';
import '../../data/models/fse_agreement_verify_otp_model.dart';
import '../../utils/app_constants.dart';

class FseAgreementVerifyOtpController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;
  bool correctOtp = false;
  bool isFSEAcknowledgementSuccessfully = false;

  var fseAgreementVerifyOtpResponse = const FseAgreementVerifyOtpResponse(
    message: '',
    status: '',
    token: '',
    data: [],
    data1: null,
  ).obs;

  var fseAcknowledgementResponse = const FseAcknowledgeResponse(
    message: '',
    status: '',
    token: '',
    data: [],
    data1: null,
  ).obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchFseAgreementVerifyOtp(String otp) async {
    try {
      isLoading(true);
      final result =
          await mPartnerRemoteDataSource.getFseAgreementVerifyOtp(otp);
      result.fold((failure) {
        error('Failed to fetch Fse Agreement Verify Otp: $failure');
      }, (fseAgreementVerifyOtpResponseData) {
        fseAgreementVerifyOtpResponse(fseAgreementVerifyOtpResponseData);
        if (fseAgreementVerifyOtpResponseData.data.isNotEmpty &&
            fseAgreementVerifyOtpResponseData.data[0].code == "SUCCESS") {
          correctOtp = true;
        } else {
          correctOtp = false;
        }
      });
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateFseAcknowledgementStatus(String fseId) async {
    try {
      isLoading(true);
      final result =
          await mPartnerRemoteDataSource.updateFseAcknowledgement(fseId);
      result.fold((failure) {
        error('Failed to update FSE Agreement Acknowledgement: $failure');
        logger.i('Failed to update FSE Agreement Acknowledgement: $failure');
      }, (fseAcknowledgeResponse) {
        fseAcknowledgementResponse(fseAcknowledgeResponse);
        logger.i(
            "FSE Acknowledgement updated successfully! ----> ${fseAcknowledgeResponse.data}");
        if (fseAcknowledgeResponse.status == "200") {
          isFSEAcknowledgementSuccessfully = true;
        } else {
          isFSEAcknowledgementSuccessfully = false;
        }
      });
    } finally {
      isLoading(false);
    }
  }

  clearFseAgreementVerifyOtpController() {
    isLoading = true.obs;
    correctOtp = false;
    isFSEAcknowledgementSuccessfully = false;
    update();
  }
}
