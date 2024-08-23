import 'package:get/get.dart';

import '../../../services/services_locator.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/pinelab_get_balance_point_model.dart';
import '../../data/models/pinelab_send_otp_model.dart';
import '../../data/models/pinelab_verify_mobile_no_gst_model.dart';
import '../../data/models/pinelab_verify_mobile_otp_gst.dart';
import '../../data/models/pinelab_verify_otp_model.dart';

class PinelabRedemptionController extends GetxController {
  var isLoading = true.obs;
  var pinelabSendOTPOutput = <PinelabSendOTP>[].obs;
  var pinelabVerifyOTPOutput = <PinelabVerifyOTP>[].obs;
  var pinelabVerifyMobileNoGstOutput = <PinelabVerifyMobileNoGst>[].obs;
  var pinelabGetBalancePointOutput = <PinelabBalancePoint>[].obs;
  var pinelabVerifyMobileOtpGstOutput = <PinelabVerifyMobileOtpGst>[].obs;

  @override
  void onInit() async {
    super.onInit();
  }

  fetchPinelabSendOTP() async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource = sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.pinelabSendOTP();
      result.fold(
            (l) => print("Error: $l"),
            (r) async {
              pinelabSendOTPOutput.add(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }

  fetchPinelabVerifyOTP(String otp) async {
    print('otp::::${otp}');
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource = sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.pinelabverifyOTP(otp);
      result.fold(
            (l) => print("Error: $l"), 
            (r) async {
              pinelabVerifyOTPOutput.add(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }

  fetchPinelabVerifyMobileNoGst(String transferAmount) async {
    print('amount::::${transferAmount}');
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource = sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.pinelabVerifyMobileNoGst(transferAmount);
      result.fold(
            (l) => print("Error: $l"),
            (r) async {
              pinelabVerifyMobileNoGstOutput.add(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }

  fetchPinelabGetBalancePoint() async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource = sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.pinelabGetBalancePoint();
      result.fold(
            (l) => print("Error: $l"),
            (r) async {
              pinelabGetBalancePointOutput.add(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }

  fetchPinelabVerifyMobileOtpGst(int transferAmount, String availableBalance) async {
    print('amount::::${transferAmount}, availableBalance:::${availableBalance}');
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource = sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.pinelabVerifyMobileOtpGst(transferAmount, availableBalance);
      result.fold(
            (l) => print("Error: $l"),
            (r) async {
              pinelabVerifyMobileOtpGstOutput.add(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }


  clearPinelabredemptionController() {
    isLoading = true.obs;
    pinelabSendOTPOutput = <PinelabSendOTP>[].obs;
    pinelabVerifyOTPOutput = <PinelabVerifyOTP>[].obs;
    pinelabVerifyMobileNoGstOutput = <PinelabVerifyMobileNoGst>[].obs;
    pinelabGetBalancePointOutput = <PinelabBalancePoint>[].obs;
    pinelabVerifyMobileOtpGstOutput = <PinelabVerifyMobileOtpGst>[].obs;
    update();
  }
}
