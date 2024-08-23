// The text for the resend OTP
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../state/contoller/verify_otp_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/localdata/language_constants.dart';

class ResendOtptext extends StatefulWidget {
  const ResendOtptext(
      {super.key,
        required this.screenHeight,
        required this.timerLimit,
        this.paddingLeft=24,
        required this.resendOtpCall});

  final double screenHeight;
  final String timerLimit;
  final int  paddingLeft;
  final Function() resendOtpCall;

  @override
  State<ResendOtptext> createState() => _ResendOtptextState();
}

class _ResendOtptextState extends State<ResendOtptext> {
  String timerString = "";
  late Timer _timer;
  int _secondsRemaining = 0;
  bool restartTimer = false;
  final VerifyOtpController _controller = Get.find();

  void getTimerString() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(!mounted)
      {
        return;
      }
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining = _secondsRemaining - 1;
          timerString = "${_secondsRemaining}s";
        } else {
          _timer.cancel();
          timerString = "";
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    if (widget.timerLimit != "") {
      _secondsRemaining = int.parse(widget.timerLimit);
    }
    getTimerString();
  }

  @override
  void didUpdateWidget(covariant ResendOtptext oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Perform actions or update state based on changes in the new widget
    if (_secondsRemaining == 0 && !_controller.isResendOtpResponsePending && restartTimer) {
      startTimer();
      setState(() {
        restartTimer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelWidth = screenWidth / 393;
    double variablePixelHeight = widget.screenHeight / 852;
    return Padding(
      padding: EdgeInsets.only(
        left: widget.paddingLeft * variablePixelWidth,
        right: 24 * variablePixelWidth,
        bottom: 10 * variablePixelHeight,
        top: 16 * variablePixelHeight,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Builder(builder: (context) {
                    if (timerString == "" || _secondsRemaining > 90) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            restartTimer = true;
                          });
                          widget.resendOtpCall();
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                          child: Text(
                            translation(context).resendOTP,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                fontSize: 14 * variablePixelHeight,
                                decoration: TextDecoration.underline,
                                color: AppColors.lumiBluePrimary),
                          ),
                        ),
                      );
                    }
                    else {
                    return Text(
                      "${translation(context).resendOTPin} $timerString",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                        fontSize: 14 * variablePixelHeight,
                      ),
                    );
                  }}),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
