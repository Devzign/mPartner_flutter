import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/utils.dart';
import '../../../data/models/consumer_emi_send_otp.dart';
import '../../../data/models/consumer_emi_verify_otp.dart';
import '../../../state/contoller/consumer_emi_controller.dart';
import '../../../state/contoller/verify_otp_controller.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../widgets/headers/header_widget_with_right_align_action_button.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_divider.dart';
import '../../widgets/verifySaleOTP/common_verify_otp.dart';
import '../../widgets/verticalspace/vertical_space.dart';
import '../base_screen.dart';
import '../userprofile/user_profile_widget.dart';
import 'component/custom_text_widget.dart';
import 'component/header_consumer_emi.dart';
import 'component/mobile_number_textfield.dart';
import 'consumer_emi_search_rep.dart';

class ConsumerEmi extends StatefulWidget {
  const ConsumerEmi({super.key});

  @override
  State<ConsumerEmi> createState() => _ConsumerEmiState();
}

class _ConsumerEmiState extends BaseScreenState<ConsumerEmi> {
  ConsumerEmiController consumerEmiController = Get.find();
  VerifyOtpController verifyOtpController = Get.find();
  bool isButtonEnabled = false;
  FocusNode mobileNumberFocusNode = FocusNode();
  String mobileNumberWithoutPrefix = '';
  final TextEditingController _mobileNumberController = TextEditingController();
  String otpEntered = '';

  bool showLoader = false;
  String prefix = '';

  @override
  void initState() {
    verifyOtpController.clearVerifyOtpData();
    super.initState();
  }

  void validateMobileNumber(String mobileNumber) {
    RegExp regex = RegExp(r'^[0-9]{10}$');
    if (mobileNumber.isEmpty) {
      setState(() {
        isButtonEnabled = false;
      });
    } else if (!regex.hasMatch(mobileNumber)) {
      setState(() {
        isButtonEnabled = false;
      });
    } else {
      setState(() {
        isButtonEnabled = true;
      });
    }
  }

  void showTimeOutBottomSheet(
      String msg,
      double variablePixelWidth,
      double variablePixelHeight,
      double textFontMultiplier,
      double pixelMultiplier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0 * pixelMultiplier),
        ),
      ),
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 16 * variablePixelHeight,
                      bottom: 16 * variablePixelHeight),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Container(
                        height: 5 * variablePixelHeight,
                        width: 50 * variablePixelWidth,
                        decoration: BoxDecoration(
                          color: AppColors.dividerGreyColor,
                          borderRadius:
                              BorderRadius.circular(12 * pixelMultiplier),
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalSpace(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 24 * variablePixelWidth),
                  child: Text(
                    translation(context).alert,
                    style: GoogleFonts.poppins(
                      color: AppColors.titleColor,
                      fontSize: 20 * textFontMultiplier,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.50 * variablePixelWidth,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 24 * variablePixelWidth,
                      right: 24 * variablePixelWidth),
                  child: const CustomDivider(color: AppColors.dividerColor),
                ),
                const VerticalSpace(height: 24),
                Padding(
                  padding: EdgeInsets.only(
                      right: 24 * variablePixelWidth,
                      left: 24 * variablePixelWidth),
                  child: Container(
                    width: 345 * variablePixelWidth,
                    height: 40 * variablePixelHeight,
                    child: Text(
                      msg,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 12 * textFontMultiplier,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.10 * variablePixelWidth,
                      ),
                    ),
                  ),
                ),
                const VerticalSpace(height: 24),
                CommonButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  isEnabled: true,
                  buttonText: translation(context).buttonOkay,
                  backGroundColor: AppColors.lumiBluePrimary,
                  textColor: AppColors.white,
                  defaultButton: true,
                  containerBackgroundColor: AppColors.white,
                ),
                const VerticalSpace(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    return Scaffold(
        backgroundColor: AppColors.white,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
              child: Column(
            children: [
              HeaderWidgetWithRightAlignActionButton(text: translation(context).consumerEmi),
              UserProfileWidget(top: 8*variablePixelHeight),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VerticalSpace(height: 4),
                      const HeaderConsumerEmi(),
                      CustomTextWidget(
                          title: translation(context).consumerEmiRequest,
                          description:
                              translation(context).enterConMobNoToRaiseReq),
                      MobileNumberTextField(
                        prefix: prefix,
                        controller: _mobileNumberController,
                        focusNode: mobileNumberFocusNode,
                        onChanged: (value) {
                          mobileNumberWithoutPrefix = value.startsWith('+91 - ')
                              ? value.substring('+91 - '.length)
                              : value;
                          validateMobileNumber(mobileNumberWithoutPrefix);
                        },
                        onTap: () {
                          setState(() {
                            prefix = '+91 - ';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const VerticalSpace(height: 24),
              Container(
                alignment: Alignment.center,
                child: CommonButton(
                    onPressed: () {
                      consumerEmiController.clearConsumerEmiController();
                      verifyOtpController.clearVerifyOtpData();

                      setState(() {
                        showLoader = true;
                      });
                      consumerEmiController
                          .fetchConsumerEmiSendOTP(mobileNumberWithoutPrefix)
                          .then((_) {
                        if (consumerEmiController
                            .consumerEmiSendOTPOutput.isNotEmpty) {
                          ConsumerEmiSendOTP result = consumerEmiController
                              .consumerEmiSendOTPOutput.first;
                          if (result.status == 'SUCCESS') {
                            setState(() {
                              showLoader = false;
                            });
                            //  verifyOtpController.updateTimerLimit(result.data);
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0 * pixelMultiplier),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 10 * variablePixelHeight),
                                  child: VerifyOtpPresentation(
                                    mobileNumber: mobileNumberWithoutPrefix,
                                    mandatoryButton: VerifyOTPButton(
                                      buttonText: translation(context).verify,
                                      onClick: () async {
                                        await consumerEmiController
                                            .fetchConsumerEmiVerifyOTP(
                                                otpEntered,
                                                mobileNumberWithoutPrefix);
                                        if (consumerEmiController
                                            .consumerEmiVerifyOTPOutput
                                            .isNotEmpty) {
                                          ConsumerEmiVerifyOTP result =
                                              consumerEmiController
                                                  .consumerEmiVerifyOTPOutput
                                                  .last;
                                          if (result.status == 'SUCCESS') {
                                            verifyOtpController
                                                .clearVerifyOtpData();
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ConsumerEmiSearchRep()));
                                          } else {
                                            verifyOtpController
                                                .updateOtpValid(false);
                                            //Utils().showToast(result.message, context);
                                          }
                                        } else {
                                          Utils().showToast(
                                              'Otp not verified or an error occurred.',
                                              context);
                                        }
                                      },
                                    ),
                                    optionalButton: null,
                                    header: translation(context).verifyOTP,
                                    instructions:
                                        translation(context).enterOtpSentTo,
                                    resendOtpMethod: () async {
                                      verifyOtpController.updateOtpValid(true);
                                      verifyOtpController
                                          .updateIsResendOtpResponsePending(
                                              true);
                                      consumerEmiController
                                          .clearConsumerEmiController();
                                      await consumerEmiController
                                          .fetchConsumerEmiSendOTP(
                                              mobileNumberWithoutPrefix);
                                      ConsumerEmiSendOTP result =
                                          consumerEmiController
                                              .consumerEmiSendOTPOutput.first;
                                      verifyOtpController
                                          .updateIsResendOtpResponsePending(
                                              false);
                                      if (result.status == 'SUCCESS') {
                                        //  verifyOtpController.updateTimerLimit(result.data);
                                      } else {
                                        Navigator.pop(context);
                                        showTimeOutBottomSheet(
                                            result.message,
                                            variablePixelWidth,
                                            variablePixelHeight,
                                            textFontMultiplier,
                                            pixelMultiplier);
                                        consumerEmiController
                                            .clearConsumerEmiController();
                                      }
                                    },
                                    timerLimit: "",
                                    showLoader: null,
                                    showMaximumAttempsMessage: null,
                                    maxAttempMessage: null,
                                    updateOtp: (otp) {
                                      otpEntered = otp;
                                    },
                                  ),
                                );
                              },
                            );
                          } else {
                            showTimeOutBottomSheet(
                                result.message,
                                variablePixelWidth,
                                variablePixelHeight,
                                textFontMultiplier,
                                pixelMultiplier);

                            setState(() {
                              showLoader = false;
                            });
                            consumerEmiController.clearConsumerEmiController();
                          }
                        } else {
                          Utils().showToast(
                              'No data received or an error occurred.',
                              context);
                        }
                      });
                    },
                    isEnabled: isButtonEnabled & !showLoader,
                    showLoader: showLoader,
                    containerBackgroundColor: AppColors.white,
                    buttonText: translation(context).sendOTP),
              ),
            ],
          )),
        ));
  }
}
