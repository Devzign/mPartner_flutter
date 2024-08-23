import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../../../state/contoller/create_dealer_electrician_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/common_bottom_sheet.dart';
import '../new_dealer_electrician_status_screen.dart';
import 'custom_dialog.dart';
import 'search_header.dart';
import 'submit_button.dart';
import 'submit_success_bottomsheet.dart';

class VerifyOTPWidget extends StatefulWidget {
  final Function(String) onItemSelected;
  final String? contentTiltle;
  final String? mobileNumber;
  final BuildContext? context;
  final String? userType;
  final String? content;

  const VerifyOTPWidget(
      {required this.onItemSelected,
      this.contentTiltle,
      this.mobileNumber,
      this.context,
      this.userType,
      this.content,
      super.key});

  @override
  State<VerifyOTPWidget> createState() => _VerifyOTPWidgetState();
}

class _VerifyOTPWidgetState extends State<VerifyOTPWidget> {
  TextEditingController _searchController = TextEditingController();
  String enteredPin = "";

  String contentTiltle = "";
  CreateDealerElectricianController controller = Get.find();
  TextEditingController pInputController = TextEditingController();

  clearText() {
    pInputController.clear();
  }

  @override
  void initState() {
    contentTiltle = widget.contentTiltle!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    var variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    final defaultPinTheme = PinTheme(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.07,
      textStyle: TextStyle(
          fontSize: 20 * textMultiplier,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGreyBorder),
        borderRadius: BorderRadius.circular(4 * variablePixelMultiplier),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.lumiBluePrimary),
      borderRadius: BorderRadius.circular(4 * variablePixelMultiplier),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.errorRed),
      borderRadius: BorderRadius.circular(4 * variablePixelMultiplier),
    );
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
            color: true ? AppColors.lumiBluePrimary : AppColors.lightRed),
        borderRadius: BorderRadius.circular(4 * variablePixelMultiplier),
      ),
    );
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      margin: EdgeInsets.only(left: 10 * variablePixelWidth),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        SearchHeaderWidget(
          title: contentTiltle,
          onClose: () => Navigator.of(context).pop(),
        ),
        Container(
          width: variablePixelHeight * 392,
          padding: EdgeInsets.symmetric(horizontal: 10 * variablePixelHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20 * variablePixelHeight,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: variablePixelHeight * 40,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: translation(context).enterOtpSentTo,
                        style: GoogleFonts.poppins(
                          color: AppColors.blackText.withOpacity(0.8),
                          fontStyle: FontStyle.normal,
                          fontSize: 14 * textMultiplier,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        ),
                      ),
                      TextSpan(
                          text: widget.content!.split("to")[1],
                          style: GoogleFonts.poppins(
                            color: AppColors.blackText.withOpacity(0.8),
                            fontStyle: FontStyle.normal,
                            fontSize: 14 * textMultiplier,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20 * variablePixelHeight,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Pinput(
                  controller: pInputController,
                  length: 6,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  defaultPinTheme: !controller.isvalidOtp.value
                      ? errorPinTheme
                      : defaultPinTheme,
                  focusedPinTheme: !controller.isvalidOtp.value
                      ? errorPinTheme
                      : focusedPinTheme,
                  submittedPinTheme: !controller.isvalidOtp.value
                      ? errorPinTheme
                      : submittedPinTheme,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onTap: () {},
                  onCompleted: (pin) {
                    enteredPin = pin.toString();
                    setState(() {});
                  },
                  onSubmitted: (pin) {
                    enteredPin = pin.toString();
                  },
                  onChanged: (pin) {
                    enteredPin = pin.toString();
                    setState(() {
                      controller.isvalidOtp.value = true;
                      controller.isOtpPinValid.value = false;
                      if (pin.length == 6) {
                        controller.isOtpPinValid.value = true;
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15 * variablePixelHeight,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: !controller.isvalidOtp.value,
                    child: Text(
                      translation(context).incorrectOTP,
                      style: GoogleFonts.poppins(
                        color: AppColors.errorRed,
                        fontStyle: FontStyle.normal,
                        fontSize: 14 * textMultiplier,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  )
                ],
              ),
              submitButtonWidget(),
              SizedBox(
                height: 16 * variablePixelHeight,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void resendOtpCall(BuildContext context) {
    controller.createOtp(context, widget.userType!);
    setState(() {});
  }

  Widget submitButtonWidget() {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double fontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixcelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    return Obx(() => Container(
          height: 100 * variablePixelHeight,
          padding: EdgeInsets.fromLTRB(
              1 * variablePixelWidth, 0, 1 * variablePixelWidth, 0),
          alignment: Alignment.center,
          child: SubmitButton(
              onPressed: () async {
                await controller.verifyOtp(enteredPin, context);
                if (controller.isvalidOtp.value ?? false) {
                  controller.isOtpPinValid.value = true;
                  Navigator.of(context).pop();
                  callSubmitAPI();
                } else {
                  setState(() {
                    controller.isOtpPinValid.value = false;
                  });
                }
              },
              isEnabled: controller.isOtpPinValid.value,
              containerBackgroundColor: AppColors.white,
              paddingLR: 0,
              buttonText: translation(context).verify),
        ));
  }

  void callSubmitAPI() async {
    CustomDialog.showLoadingDialog();
    await controller.createDealerElectrician(context);
    CustomDialog.hideDialog();
    if (controller.isSuccess) {
      showSuccessBottomSheet();
    } else {
      showFailureBottomSheet();
    }
  }

  void showSuccessBottomSheet() {
    var variablePixelHeight =
        DisplayMethods(context: widget.context!).getVariablePixelHeight();
    var variablePixelWidth =
        DisplayMethods(context: widget.context!).getVariablePixelWidth();
    CommonBottomSheet.show(
        widget.context!,
        SubmitSuccessWidget(
          onItemSelected: () {
            // controller.dispose();
            Navigator.of(widget.context!).pop();
            Navigator.of(widget.context!).pop();
            Navigator.of(widget.context!).pop();
            //  Navigator.of(context).pop();
            Navigator.pushReplacement(
                widget.context!,
                MaterialPageRoute(
                    builder: (context) => NewDealerElectricianStatusScreen(
                        selectedUserType: controller.userType)));
          },
          contentTiltle: translation(widget.context!).submittedSuccessfully,
        ),
        variablePixelHeight,
        variablePixelWidth,
        isDragEnabled: false);
  }

  void showFailureBottomSheet() {
    var variablePixelHeight =
        DisplayMethods(context: widget.context!).getVariablePixelHeight();
    var variablePixelWidth =
        DisplayMethods(context: widget.context!).getVariablePixelWidth();
    CommonBottomSheet.show(
        widget.context!,
        SubmitSuccessWidget(
          content: controller.errorMessage,
          onItemSelected: () {
            Navigator.of(widget.context!).pop();
            Navigator.of(widget.context!).pop();
            Navigator.of(widget.context!).pop();
            Navigator.of(widget.context!).pop();
          },
          contentTiltle: translation(widget.context!).errorText,
        ),
        variablePixelHeight,
        variablePixelWidth,
        isDragEnabled: false);
  }
}
