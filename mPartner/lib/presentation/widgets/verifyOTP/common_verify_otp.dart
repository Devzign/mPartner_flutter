import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../state/contoller/verify_otp_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../screens/secondarydevice/apiCalls/apiCalls.dart';
import '../common_button.dart';
import '../common_divider.dart';
import '../verticalspace/vertical_space.dart';
import 'otpInput.dart';
import 'resendText.dart';

class VerifyOtpPresentation extends StatefulWidget {
  final String mobileNumber;
  final otpAuthenticatorMethod;

  const VerifyOtpPresentation(
      {super.key,
      required this.mobileNumber,
      required this.otpAuthenticatorMethod});

  @override
  State<VerifyOtpPresentation> createState() => _VerifyOtpPresentationState();
}

class _VerifyOtpPresentationState extends State<VerifyOtpPresentation> {
  late String timerLimit;
  bool showLoader = true;
  String message = '';
  String error = '';
  late bool showMaximumAttempsMessage = false;
  String heading = 'Verify OTP';
  String otp = "";
  bool enableVerifyButton = false;
  bool showError = false;
  final GlobalKey<OtpInputState> childKey = GlobalKey<OtpInputState>();
  VerifyOtpController _verifyOtpController = Get.find();


  @override
  void initState() {
    super.initState();
    otpSendApiRequest();
  }

  void otpSendApiRequest() {
    _verifyOtpController.updateIsResendOtpResponsePending(true);
    SecondaryUserCreateOtp(widget.mobileNumber).then((otpResponse) {
      setState(() {
        timerLimit = otpResponse.data1;
        _verifyOtpController.updateIsResendOtpResponsePending(false);
      //  print(otpResponse.data1);
      //  _verifyOtpController.updateTimerLimit(otpResponse.data1);
        message = otpResponse.msg;
        error = otpResponse.error;
        showLoader = false;
        if (otpResponse.data1 == '') {
          showMaximumAttempsMessage = true;
          heading = "Attempt Alert!";
        }
      });
    });
  }

  void authenticateOTP() {
    SecondaryUserOtpAuth(otp, widget.mobileNumber).then((verifyOtpRes) {
      if (verifyOtpRes.status == "SUCCESS") {
        widget.otpAuthenticatorMethod(true);
        Navigator.of(context).pop();
      } else {
        //Utils().showToast(verifyOtpRes.msg, context);
        setState(() {
          showError = true;
        });
        widget.otpAuthenticatorMethod(false);
      }
    });
  }

  void resendOtpCall() {
    childKey.currentState?.clearText();
    setState(() {
      showError = false;
    });
    otpSendApiRequest();
  }

  void removeIncorrectOTPMessage() {
    setState(() {
      showError = false;
    });
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

  void updateOtp(otpVal) {
    setState(() {
      otp = otpVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    double fontMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final defaultPinTheme = PinTheme(
      margin:  EdgeInsets.symmetric(horizontal: 2.0*variablePixelWidth),
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.07,
      textStyle:  TextStyle(
          fontSize: 20*fontMultiplier,
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
            color: true ? AppColors.lumiBluePrimary : AppColors.lightRed),
        borderRadius: BorderRadius.circular(4*pixelMultiplier),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
            color: AppColors.lightRed),
        borderRadius: BorderRadius.circular(4),
      ),
    );

    Widget column;

    if (showLoader) {
      column = Container(
        color: Colors.white,
        child: SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: EdgeInsets.fromLTRB(172.0 * variablePixelWidth, 50.0*variablePixelHeight,
                172.0 * variablePixelWidth, 100.0*variablePixelHeight),
            child: const CircularProgressIndicator(),
          ),
        ),
      );

      // ignore: dead_code
    } else if (showMaximumAttempsMessage) {
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
              child: Text(message,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
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
                  buttonText: "Okay!",
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
             VerticalSpace(height: 25),
            Container(
              width: double.maxFinite,
              child: Padding(
                padding: EdgeInsets.only(left: 24 * variablePixelWidth),
                child: Row(
                  children: [
                    Text(
                      translation(context).enterTheOTPSentTo,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 14 * variablePixelWidth,
                        fontWeight: FontWeight.w400,
                        //  height: 20 * variablePixelHeight,
                        letterSpacing: 0.25 * variablePixelHeight,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Text(
                      '+91-${widget.mobileNumber.substring(0, 2)}-xxx-xxx-${widget.mobileNumber.substring(widget.mobileNumber.length - 2)}',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 14 * fontMultiplier,
                        fontWeight: FontWeight.w600,
                        //  height: 20 * variablePixelHeight,
                        letterSpacing: 0.25 * variablePixelHeight,
                        fontStyle: FontStyle.normal,
                      ),
                    )
                  ],
                ),
              ),
            ),
             VerticalSpace(height: 20),
            OtpInput(
                key: childKey,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                errorPinTheme: errorPinTheme,
                showError: showError,
                enableVerifyButton: enableButton,
                disableVerifyButton: disableButton,
                updateOtp: updateOtp,
                removeIncorrectOTPMessage: removeIncorrectOTPMessage,),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: [
                  /* GetBuilder<VerifyOtpController>(
                    builder: (_) {
                      return ResendOtptext(
                        screenHeight: screenHeight,
                        timerLimit: _verifyOtpController.timerLimit,
                        resendOtpCall: resendOtpCall);
                    }
                  ),*/
                  VerticalSpace(height: 16 * variablePixelHeight),
                  Expanded(
                    child: !showError
                        ? const SizedBox()
                        : Padding(
                          padding: EdgeInsets.only(right: 24.0 * variablePixelWidth),
                          child: Text(
                              translation(context).incorrectOTP,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.poppins(
                                color: Color(0xFFE20813),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.15,
                              ),
                            ),
                        ),
                  ),
                ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: 16 *
                      DisplayMethods(context: context)
                          .getVariablePixelHeight()),
              child: CommonButton(
                onPressed: () {
                  authenticateOTP();
                },
                isEnabled: enableVerifyButton,
                buttonText: translation(context).verify,
                backGroundColor: AppColors.lumiBluePrimary,
                textColor: AppColors.lightWhite,
                defaultButton: true,
                containerBackgroundColor: Colors.white,
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
                        borderRadius: BorderRadius.circular(12*pixelMultiplier),
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
               VerticalSpace(height: 20),
              Builder(builder: (context) {
                if (showLoader) {
                  return Container();
                }
                return Padding(
                  padding: EdgeInsets.only(left: 24.0 * variablePixelWidth),
                  child: Builder(builder: (context) {
                    return Text(
                       (showMaximumAttempsMessage) ? translation(context).attemptAlert : translation(context).verifyOTP,
                      style: GoogleFonts.poppins(
                        color: AppColors.titleColor,
                        fontSize: 20 * fontMultiplier,
                        fontWeight: FontWeight.w600,
                        height: 0.06,
                        letterSpacing: 0.50,
                      ),
                    );
                  }),
                );
              }),
              VerticalSpace(height: 10),
              Builder(builder: (context) {
                if (showLoader) {
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

Future<void> commonVerifyOtp(context, mobileNumber, otpAuthenticatorMethod, double variablePixelHeight) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0 * variablePixelHeight),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10 * variablePixelHeight),
          child: VerifyOtpPresentation(
            mobileNumber: mobileNumber,
            otpAuthenticatorMethod: otpAuthenticatorMethod,
          ),
        );
      });
}
