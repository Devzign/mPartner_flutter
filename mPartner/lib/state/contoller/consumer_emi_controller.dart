import 'package:get/get.dart';

import '../../../services/services_locator.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/consumer_emi_send_otp.dart';
import '../../data/models/consumer_emi_sm_ro_details.dart';
import '../../data/models/consumer_emi_verify_otp.dart';

class ConsumerEmiController extends GetxController {
  var isLoading = true.obs;
  var consumerEmiSendOTPOutput = <ConsumerEmiSendOTP>[].obs;
  var consumerEmiVerifyOTPOutput = <ConsumerEmiVerifyOTP>[].obs;
  var consumerEmiSmRoDetailsOutput = <SmRoDetails>[].obs;

  @override
  void onInit() async {
    super.onInit();
  }

  fetchConsumerEmiSendOTP(String getPhoneNumber) async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      final result =
          await baseMPartnerRemoteDataSource.consumerEmiSendOTP(getPhoneNumber);
      print("consumer emi send otp:: ${result}");
      result.fold(
        (l) => print("Error: $l"),
        (r) async {
          consumerEmiSendOTPOutput.add(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }

  fetchConsumerEmiVerifyOTP(String otp, String phoneNumber) async {
    print('otp::::${otp}');
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.consumerEmiverifyOTP(
          otp, phoneNumber);
      print("consumer emi verify otp:: ${result}");
      result.fold(
        (l) => print("Error: $l"),
        (r) async {
          consumerEmiVerifyOTPOutput.add(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }

  fetchConsumerEmiSmRoDEtails(String pincode) async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      final result =
          await baseMPartnerRemoteDataSource.consumerEmiRoSmDetails(pincode);
      print("consumer emi sm ro details:: ${result}");
      result.fold(
        (l) => print("Error: $l"),
        (r) async {
          consumerEmiSmRoDetailsOutput.addAll(r);
        },
      );
    } catch (e) {
      print("Error Captured: ${e}");
    } finally {
      isLoading(false);
    }
  }

  clearConsumerEmiController() {
    isLoading = true.obs;
    consumerEmiSendOTPOutput = <ConsumerEmiSendOTP>[].obs;
    consumerEmiVerifyOTPOutput = <ConsumerEmiVerifyOTP>[].obs;
    consumerEmiSmRoDetailsOutput = <SmRoDetails>[].obs;
    update();
  }
}
