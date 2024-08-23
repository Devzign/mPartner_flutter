import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../state/contoller/alert_notification_controller.dart';
import '../../../../state/contoller/fse_agreement_controller.dart';
import '../../../../state/contoller/fse_agreement_create_otp_controller.dart';
import '../../../../state/contoller/fse_agreement_verify_otp_controller.dart';
import '../../../../state/contoller/survey_question_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../state/contoller/verify_otp_controller.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/verifySaleOTP/common_verify_otp.dart';

class AgreementVerifyOtpWidget extends StatefulWidget {
  final void Function() checkToShowPopUpAlert;
  final void Function() checkToShowSurveyForm;

  AgreementVerifyOtpWidget({
    required this.checkToShowPopUpAlert,
    required this.checkToShowSurveyForm,
  });

  @override
  State<AgreementVerifyOtpWidget> createState() =>
      _AgreementVerifyOtpWidgetState();
}

class _AgreementVerifyOtpWidgetState extends State<AgreementVerifyOtpWidget> {
  UserDataController controller = Get.find();
  FseAgreementController fseAgreementController = Get.find();
  AlertNotificationController alertNotificationController = Get.find();
  SurveyQuestionsController surveyQuestionsController = Get.find();
  FseAgreementCreateOtpController fseAgreementCreateOtpController = Get.find();
  FseAgreementVerifyOtpController fseAgreementVerifyOtpController = Get.find();
  VerifyOtpController verifyOtpController = Get.find();
  String otpEntered = "";
  String phoneNumber = "";
  bool isOtpCorrect = true;

  @override
  void initState() {
    super.initState();
    verifyOtpController.clearVerifyOtpData();
    phoneNumber = controller.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Padding(
      padding: EdgeInsets.only(bottom: 10 * h),
      child: VerifyOtpPresentation(
        mobileNumber: phoneNumber,
        mandatoryButton: VerifyOTPButton(
          buttonText: translation(context).verify,
          onClick: () async {
            if (otpEntered == null || otpEntered.isEmpty) {
              Utils().showToast('Please enter valid OTP', context);
            } else {
              // verify FSE otp
              await fseAgreementVerifyOtpController
                  .fetchFseAgreementVerifyOtp(otpEntered);

              logger.i("verify FSE otp call complete!!");
              if (fseAgreementVerifyOtpController.correctOtp) {
                logger.i("verify FSE otp is 'correctOtp'!!");
                logger
                    .i("FSE ID::> ${fseAgreementController.fseAgreement!.id}");
                // Update FSE Agreement status
                await fseAgreementVerifyOtpController
                    .updateFseAcknowledgementStatus(
                        fseAgreementController.fseAgreement!.id);

                logger.e("-=-=-=-=- FSE status Updated:: ${fseAgreementVerifyOtpController.isFSEAcknowledgementSuccessfully}");

                if (fseAgreementVerifyOtpController.isFSEAcknowledgementSuccessfully) {
                  logger.i(
                      "FSE Agreement Updated status:: ${fseAgreementVerifyOtpController.isFSEAcknowledgementSuccessfully}");
                  controller.updateIsFseAgreementAppeared(true);
                } else {}
                Navigator.pop(context);
                if (controller.isPopUpAppeared != true &&
                    alertNotificationController.showAlerts == true) {
                  widget.checkToShowPopUpAlert();
                } else if (controller.isSurveyFormAppeared != true &&
                    surveyQuestionsController.showSurveyForm == true) {
                  widget.checkToShowSurveyForm();
                }
              } else {
                // verifyOtpController.updateTimerLimit("30");
                verifyOtpController.updateOtpValid(false);
                // setState(() {
                //   isOtpCorrect = false;
                // });
              }
            }
          },
        ),
        optionalButton: null,
        header: translation(context).verifyOTP,
        instructions: translation(context).enterTheOTPSentTo,
        resendOtpMethod: () async {
          verifyOtpController.clearVerifyOtpData();
          // resend OTP
          await fseAgreementCreateOtpController.fetchFseAgreementCreateOtp();
        },
        timerLimit: "30",
        showLoader: null,
        showMaximumAttempsMessage: null,
        maxAttempMessage: null,
        updateOtp: (otp) {
          otpEntered = otp;
        },
        isOtpValid: isOtpCorrect,
      ),
    );
  }
}
