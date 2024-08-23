// OTP input
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';


class OtpInput extends StatefulWidget {
   OtpInput(
      {required this.key,
      required this.defaultPinTheme,
      required this.focusedPinTheme,
      required this.submittedPinTheme,
      required this.errorPinTheme,
      required this.enableVerifyButton,
      required this.disableVerifyButton,
      required this.updateOtp,
      this.showError = false,
      required this.removeIncorrectOTPMessage});

  final Key key;
  final PinTheme defaultPinTheme;
  final PinTheme errorPinTheme;
  final PinTheme focusedPinTheme;
  final PinTheme submittedPinTheme;
  final bool showError;
  final enableVerifyButton;
  final disableVerifyButton;
  final updateOtp;
  final removeIncorrectOTPMessage;

  @override
  State<OtpInput> createState() => OtpInputState();
}

class OtpInputState extends State<OtpInput> {
  TextEditingController pInputController = TextEditingController();

  clearText() {
    pInputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelWidth = screenWidth / 393;

    //  double variablePixelHeight = screenWidth / 852;
    return Container(
      width: double.maxFinite,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            24 * variablePixelWidth, 0, 24 * variablePixelWidth, 0),
        child: Pinput(
          length: 6,
          defaultPinTheme: widget.defaultPinTheme,
          focusedPinTheme: widget.focusedPinTheme,
          submittedPinTheme: widget.submittedPinTheme,
          errorPinTheme: widget.errorPinTheme,
          forceErrorState: widget.showError,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(
                RegExp(r'[0-9]')),
          ],
          showCursor: true,
          onCompleted: (pin) {
            widget.updateOtp(pin);
            widget.enableVerifyButton();
          },
          onChanged: (pin) {
            widget.disableVerifyButton();
            widget.removeIncorrectOTPMessage();
          },
          controller: pInputController,
        ),
      ),
    );
  }
}
