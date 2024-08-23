import 'package:get/get.dart';

class VerifyOtpController extends GetxController {
//  String timerLimit = "30";
  bool isOtpValid = true;
  bool isResendOtpResponsePending = false;
  bool showButtonLoader = false;

/* updateTimerLimit(String newTimerLimit) {
    timerLimit = newTimerLimit;
    update();
  }   */

  updateOtpValid(bool val) {
    isOtpValid = val;
    update();
  }

  updateIsResendOtpResponsePending(bool val) {
    isResendOtpResponsePending = val;
    update();
  }

  updateShowButtonLoader(bool val) {
    showButtonLoader = val;
    update();
  }
  
  clearVerifyOtpData() {
    //timerLimit = "30";
    isOtpValid = true;
    isResendOtpResponsePending = false;
    update();
  }
}
