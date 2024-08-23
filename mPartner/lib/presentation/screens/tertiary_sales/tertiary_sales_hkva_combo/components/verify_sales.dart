import 'dart:math';
 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../state/contoller/verify_otp_controller.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/common_bottom_sheet.dart';
import '../../../tertiarysalessingleproduct/components/confirmation_alert_without_otp.dart';
import '../combo_summary.dart';
import '../../../../../state/contoller/tertiary_sales_combo_controller.dart';
import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../widgets/verifySaleOTP/common_verify_otp.dart';
 
class HkvaVerifySaleSheet extends StatefulWidget {
  HkvaVerifySaleSheet();
  bool shoWithoutVerificationConfimation = false;
  @override
  State<HkvaVerifySaleSheet> createState() => _HkvaVerifySheetState();
}
 
class _HkvaVerifySheetState extends State<HkvaVerifySaleSheet> {
  UserDataController controller = Get.find();
  TertiarySalesHKVAcombo c = Get.find();
  VerifyOtpController _verifyOtpController = Get.find();
  @override
  void initState() {
    super.initState();
    widget.shoWithoutVerificationConfimation = false;
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
  }
 
  @override
  Widget build(BuildContext context) {
    TertiarySalesHKVAcombo c = Get.find();
    int length = c.userInfo.value.mobileNumber.length;
    // print("------>>${c.isOtpCorrect}");
 
    return Obx(
      () => Visibility(
        visible: !widget.shoWithoutVerificationConfimation,
        replacement: ConfirmationAlertWithoutOTP(
          confirmationText1:
              translation(context).continueWithoutOTPVerification,
          confirmationText2: translation(context).sureToContinue,
          onPressedNo: () {
            setState(() {
              widget.shoWithoutVerificationConfimation = false;
            });
          },
          onPressedYes: () {
            Navigator.pop(context);
            Navigator.pop(context);
            //       CommonBottomSheet.show(
            // context,
            // _buildConfirmationAlertBS(
            //     translation(context).confirmationAlert,
            //     translation(context).continueWithoutOTPVerification,
            //     translation(context).sureToContinue,
            //         ()=>_navigateToProductDetailsScreen(transId)),
            // variablePixelHeight,
            // variablePixelWidth);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => hkvaComboSummaryScreen(
                        otp: "", transactionId: c.userInfo.value.transId)));
          },
        ),
        child: VerifyOtpPresentation(
          mobileNumber: c.userInfo.value.mobileNumber
              .substring(max(0, length - 10), length),
          mandatoryButton: VerifyOTPButton(
            buttonText: translation(context).verify,
            onClick: () async {
              if (c.isOtpCorrect.value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => hkvaComboSummaryScreen(
                            otp: c.userInfo.value.otp,
                            transactionId: c.userInfo.value.transId)));
              }
            },
          ),
          optionalButton: VerifyOTPButton(
              buttonText: translation(context).continueWithoutVerification,
              onClick: () async {
                setState(() {
                  widget.shoWithoutVerificationConfimation = true;
                });
                // Navigator.of(context).push<bool?>(
                //   PageRouteBuilder(
                //       opaque: false,
                //       barrierDismissible: true,
                //       pageBuilder: (_, __, ___) => ConfirmationAlertWithoutOTP(
                //             confirmationText1: translation(context)
                //                 .continueWithoutOTPVerification,
                //             confirmationText2:
                //                 translation(context).areYouSureYouWantToContinue,
                //             onPressedNo: () {
                //               Navigator.pop(context);
                //             },
                //             onPressedYes: () {
                //               Navigator.pop(context);
                //               Navigator.pop(context);
                //               Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                       builder: (context) =>
                //                           hkvaComboSummaryScreen(
                //                               otp: "",
                //                               transactionId:
                //                                   c.userInfo.value.transId)));
                //             },
                //           )
                //               ),
                // );
              }),
          header: translation(context).verifyOTP,
          instructions:
              translation(context).enterWarrantyVerificationCodeSentTo,
          resendOtpMethod: () async {
            _verifyOtpController.updateOtpValid(true);
            TertiarySalesHKVAcombo c = Get.find();
            c.postCreateOtp();
          },
          timerLimit: "30",
          showLoader: false,
          showMaximumAttempsMessage: null,
          maxAttempMessage: null,
          updateOtp: (otp) => {
            c.userInfo.value.otp = otp,
            if (otp.toString().length == 6) {c.postVerifyOtp(otp)}
          },
          isOtpValid: c.isOtpCorrect.value || c.userInfo.value.otp.length < 6,
        ),
      ),
    );
  }
}