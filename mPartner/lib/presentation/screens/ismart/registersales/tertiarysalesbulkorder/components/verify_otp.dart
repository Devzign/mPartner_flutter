import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/utils/app_colors.dart';
import 'package:mpartner/utils/displaymethods/display_methods.dart';
import 'package:mpartner/presentation/widgets/common_button.dart';
import 'package:mpartner/presentation/widgets/common_divider.dart';
import 'package:mpartner/presentation/widgets/verifyOTP/otpInput.dart';
import 'package:mpartner/presentation/widgets/verifyOTP/resendText.dart';
import 'package:mpartner/presentation/widgets/verticalspace/vertical_space.dart';
import 'package:mpartner/state/contoller/verify_otp_controller.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../utils/localdata/language_constants.dart';

class VerifyOTPButton {
  final String buttonText;
  final onClick;

  const VerifyOTPButton({required this.buttonText, required this.onClick});
}

class VerifyOtpPresentationWidget extends StatefulWidget {
  final String mobileNumber;
  final VerifyOTPButton? optionalButton;
  final VerifyOTPButton mandatoryButton;
  final String header;
  final String instructions;
  final resendOtpMethod;
  final String timerLimit;
  final bool? showLoader;
  final bool? showMaximumAttempsMessage;
  final String? maxAttempMessage;
  final updateOtp;
  final bool isOtpValid;

  const VerifyOtpPresentationWidget({
    super.key,
    required this.mobileNumber,
    this.optionalButton,
    required this.mandatoryButton,
    required this.header,
    required this.instructions,
    required this.resendOtpMethod,
    required this.timerLimit,
    this.showLoader,
    this.showMaximumAttempsMessage,
    this.maxAttempMessage,
    required this.updateOtp,
    this.isOtpValid = true,
  });

  @override
  State<VerifyOtpPresentationWidget> createState() => _VerifyOtpPresentationWidgetState();
}

class _VerifyOtpPresentationWidgetState extends State<VerifyOtpPresentationWidget> {
  bool enableVerifyButton = false;
  VerifyOtpController controller = Get.find();
  final GlobalKey<OtpInputState> childKey = GlobalKey<OtpInputState>();

  void resendOtpCall() {
    widget.resendOtpMethod;
  }

  void enableButton() {
    setState(() {
      enableVerifyButton = true;
    });
  }

  void disableButton() {
    setState(() {
      enableVerifyButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelWidth = screenWidth / 393;
    double variablePixelHeight = screenHeight / 852;
    final defaultPinTheme = PinTheme(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.07,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGreyBorder),
        borderRadius: BorderRadius.circular(4),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.lumiBluePrimary),
      borderRadius: BorderRadius.circular(4),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
            color: widget.isOtpValid
                ? AppColors.lumiBluePrimary
                : AppColors.lightRed),
        borderRadius: BorderRadius.circular(4),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(

        border: Border.all(
            color: AppColors.errorRed),
        borderRadius: BorderRadius.circular(4),
      ),
    );

    Widget column;

    if (widget.showLoader != null && widget.showLoader == true) {
      column = Container(
        color: Colors.white,
        child: SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: EdgeInsets.fromLTRB(172.0 * variablePixelWidth, 50.0,
                172.0 * variablePixelWidth, 100.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      );

      // ignore: dead_code
    } else if (widget.showMaximumAttempsMessage != null &&
        widget.showMaximumAttempsMessage == true) {
      column = Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                24 * variablePixelWidth,
                24 * variablePixelHeight,
                24 * variablePixelWidth,
                0 * variablePixelHeight,
              ),
              child: Text(widget.maxAttempMessage!,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF393939),
                    fontSize: 14 * variablePixelHeight,
                    fontWeight: FontWeight.w400,
                    //  height: 20 * variablePixelHeight,
                    letterSpacing: 0.1 * variablePixelWidth,
                    fontStyle: FontStyle.normal,
                  )),
            ),
            VerticalSpace(height: 20),
            Padding(
              padding: EdgeInsets.only(
                  bottom: 16 *
                      DisplayMethods(context: context)
                          .getVariablePixelHeight()),
              child: CommonButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  isEnabled: true,
                  buttonText: translation(context).buttonOkay,
                  backGroundColor: AppColors.lumiBluePrimary,
                  textColor: AppColors.lightWhite,
                  defaultButton: true,
                  containerBackgroundColor: Colors.white),
            )
          ],
        ),
      );
    } else {
      column = Container(
        color: Colors.white,
        child: Column(
          children: [
            const VerticalSpace(height: 25),
            Container(
              width: double.maxFinite,
              child: Padding(
                padding: EdgeInsets.only(left: 24 * variablePixelWidth),
                child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(children: [
                      TextSpan(
                        text: widget.instructions,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF393939),
                          fontSize: 14 * variablePixelWidth,
                          fontWeight: FontWeight.w400,
                          //  height: 20 * variablePixelHeight,
                          letterSpacing: 0.25 * variablePixelHeight,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      TextSpan(
                          text:
                              ' +91-${widget.mobileNumber.substring(0, 2)}-XXX-XXX-${widget.mobileNumber.substring(widget.mobileNumber.length - 2)}',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF393939),
                            fontSize: 14 * variablePixelWidth,
                            fontWeight: FontWeight.w600,
                            //  height: 20 * variablePixelHeight,
                            letterSpacing: 0.25 * variablePixelHeight,
                            fontStyle: FontStyle.normal,
                          ))
                    ])),
              ),
            ),
            const VerticalSpace(height: 20),
            GetBuilder<VerifyOtpController>(
              builder: (_) {
                return OtpInput(
                  key: childKey,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  showError: !controller.isOtpValid,
                  enableVerifyButton: enableButton,
                  disableVerifyButton: disableButton,
                  updateOtp: widget.updateOtp,
                  errorPinTheme: errorPinTheme,
                  removeIncorrectOTPMessage: (){
                    controller.updateOtpValid(true);
                  },
                );
              }
            ),
            Row(
              children: [
                /* GetBuilder<VerifyOtpController>(
                  builder: (_) {
                    return ResendOtptext(
                      screenHeight: screenHeight,
                      timerLimit: controller.timerLimit,
                      resendOtpCall: () {
                        childKey.currentState?.clearText();
                        widget.resendOtpMethod();
                      }
                    );
                  }
                ), */
                VerticalSpace(height: 16 * variablePixelHeight),
                GetBuilder<VerifyOtpController>(
                  builder: (_) {
                    return Expanded(
                      child: controller.isOtpValid
                          ? SizedBox()
                          : Padding(
                            padding: EdgeInsets.only(right: 16.0 * variablePixelWidth),
                            child: Text(
                                translation(context).incorrectOTP,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.poppins(
                                  color: Color(0xFFE20813),
                                  fontSize: 14 * variablePixelWidth,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.15,
                                ),
                              ),
                          ),
                    );
                  }
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: 16 *
                      DisplayMethods(context: context)
                          .getVariablePixelHeight()),
              child: Column(
                children: [
                  CommonButton(
                    onPressed: () {
                      widget.mandatoryButton.onClick();
                    },
                    isEnabled: enableVerifyButton,
                    buttonText: widget.mandatoryButton.buttonText,
                    backGroundColor: AppColors.lumiBluePrimary,
                    textColor: AppColors.lightWhite,
                    defaultButton: true,
                    containerBackgroundColor: Colors.white,
                  ),
                  Builder(builder: (context) {
                    if (widget.optionalButton == null) {
                      return Container();
                    }
                    return CommonButton(
                      onPressed: () {
                        widget.optionalButton!.onClick();
                      },
                      isEnabled: true,
                      buttonText: widget.optionalButton!.buttonText,
                      backGroundColor: AppColors.lightWhite1,
                      textColor: AppColors.lumiBluePrimary,
                      defaultButton: false,
                      containerBackgroundColor: Colors.white,
                    );
                  }),
                ],
              ),
            )
          ],
        ),
      );
    }
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16 * variablePixelHeight),
                    child: Container(
                      height: 5 * variablePixelHeight,
                      width: 50 * variablePixelWidth,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 8 * variablePixelHeight, left: 8 * variablePixelWidth),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 28 * variablePixelHeight,
                  ),
                ),
              ),
              const VerticalSpace(height: 20),
              Builder(builder: (context) {
                if (widget.showLoader != null && widget.showLoader == true) {
                  return Container();
                }
                return Padding(
                  padding: EdgeInsets.only(left: 24.0 * variablePixelWidth),
                  child: Builder(builder: (context) {
                    return Text(
                      widget.header,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF39393C),
                        fontSize: 20 * variablePixelWidth,
                        fontWeight: FontWeight.w600,
                        height: 0.06,
                        letterSpacing: 0.50,
                      ),
                    );
                  }),
                );
              }),
              const VerticalSpace(height: 10),
              Builder(builder: (context) {
                if (widget.showLoader != null && widget.showLoader == true) {
                  return Container();
                }
                return Padding(
                  padding: EdgeInsets.only(
                      left: 24 * variablePixelWidth,
                      right: 24 * variablePixelWidth,
                      top: 16 * variablePixelHeight),
                  child: const CustomDivider(color: AppColors.dividerColor),
                );
              }),
              column,
            ],
          ),
        ]));
  }
}

// Future<void> verifySaleOtp(
//     context,
//     mobileNumber,
//     mandatoryButton,
//     optionalButton,
//     header,
//     instructions,
//     updateOtp,
//     resendOtpMethod,
//     timerLimit,
//     showLoader,
//     showMaximumAttempsMessage,
//     maxAttempMessage,
//     isOtpValid) {
//   return showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(25.0),
//         ),
//       ),
//       builder: (BuildContext context) {
//         return VerifyOtpPresentationWidget(
//             mobileNumber: mobileNumber,
//             mandatoryButton: mandatoryButton,
//             optionalButton: optionalButton,
//             header: header,
//             instructions: instructions,
//             resendOtpMethod: resendOtpMethod,
//             timerLimit: timerLimit,
//             showLoader: showLoader,
//             showMaximumAttempsMessage: showMaximumAttempsMessage,
//             maxAttempMessage: maxAttempMessage,
//             updateOtp: updateOtp,
//             isOtpValid: isOtpValid);
//       });
// }