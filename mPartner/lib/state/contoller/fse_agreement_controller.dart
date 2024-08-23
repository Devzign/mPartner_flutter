import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/fse_agreement_model.dart';
import '../../utils/app_constants.dart';

class FseAgreementController extends GetxController {
  FseAgreementData? fseAgreement;
  bool showLoader = true;
  bool isFseAgreementPresent = false;
  var isLoading = false.obs;
  var error = ''.obs;

  var fseAgreementResponse = const FseAgreementResponse(
    message: '',
    status: '',
    token: '',
    data: [],
    data1: null,
  ).obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource = MPartnerRemoteDataSource();

  Future<void> fetchFseAgreement() async {
    try {
      isLoading(true);
      final result = await mPartnerRemoteDataSource.postFseAgreement();
      result.fold(
            (failure) {
          error('Failed to fetch FSE agreement: $failure');
        },
            (fseAgreementResponseData) {
          fseAgreementResponse(fseAgreementResponseData);
          FseAgreementData? resultData = fseAgreementResponseData.data.isNotEmpty
              ? fseAgreementResponseData.data[0]
              : null;

          if (resultData != null) {
            isFseAgreementPresent = true;
            fseAgreement = resultData;
            logger.i("Fse Agreement ID: ${fseAgreement?.id}");
            logger.i("***** FSE Agreement Data *****");
            logger.i(fseAgreement);
          } else {
            isFseAgreementPresent = false;
            error("Error: Empty result data");
          }
        },
      );
    } catch(e){
      showLoader = false;
      isLoading(false);
      error('Failed to fetch FSE agreement');
    }finally {
      showLoader = false;
      isLoading(false);
    }
  }

  clearFseAgreementController() {
    isLoading = true.obs;
    showLoader = true;
    isFseAgreementPresent = false;
    update();
  }
}

