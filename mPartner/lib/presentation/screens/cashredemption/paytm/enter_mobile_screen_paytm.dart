import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../network/api_constants.dart';
import '../../../../state/contoller/language_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/requests.dart';
import '../../../widgets/common_confirmation_alert.dart';
import '../widgets/verification_failed_alert.dart';
import 'enter_amount_screen_paytm.dart';
import '../widgets/continue_button.dart';
import '../../../widgets/headers/header_widget_with_cash_info.dart';
import '../../userprofile/user_profile_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../../../state/contoller/user_data_controller.dart';

class EnterMobileScreen extends StatefulWidget {
  const EnterMobileScreen({super.key});
  @override
  State<EnterMobileScreen> createState() {
    return _EnterMobileScreen();
  }
}

class _EnterMobileScreen extends State<EnterMobileScreen> {
  TextEditingController mobileNumberController = TextEditingController();

  bool _enableContinue = false;
  int availableBalance = 0;
  bool isLoading = true;
  String isPaytmNumberExisitsMessage ='';

  initialNumPaytmVerification() async {
    UserDataController controller = Get.find();

    String phoneNumber = controller.phoneNumber;
    bool verified = await PayTMNumberVerified(phoneNumber);
    setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            EnterAmountScreen(number: phoneNumber, isVerified: verified)));
    if(verified==false){
      showVerificationFailedAlert(isPaytmNumberExisitsMessage, context, DisplayMethods(context: context).getVariablePixelHeight(), DisplayMethods(context: context).getVariablePixelWidth(), DisplayMethods(context: context).getTextFontMultiplier(), DisplayMethods(context: context).getPixelMultiplier());
    }
  }

  Future<bool> PayTMNumberVerified(String mobileNumber) async {
    UserDataController userController = Get.find();
    final sapId = userController.sapId;
    final token = userController.token;

    LanguageController languageController = Get.find();

    Map<String, dynamic> body = {
      "user_Id": sapId,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "device_Name": deviceName,
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "language": languageController.language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "mobileNumber": mobileNumber,
      "transactionMode": "",
      "transferAmount": ""
    };
    print('PayTMNumberVerified body: $body');
    try {
      final response = await Requests.sendPostRequest(
        ApiConstants.postPaytmNumberExists,
        body,
      );
      print(response.statusCode);
      if (response is! DioException && response.statusCode == 200) {
        if (response.data['status'] == '200') {
          print(response.data['status']);
          return true;
        }
        else{
          setState(() {
            isPaytmNumberExisitsMessage=response.data['message'];
          });
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }
  
  // void validateNumber(String number) {
  //   final RegExp PhoneRegex = RegExp(r'^[0-9]{10}$');
  //   if (number.isEmpty) {
  //     setState(() {
  //       _enableContinue = false;
  //     });
  //   } else if (!PhoneRegex.hasMatch(number)) {
  //     setState(() {
  //       _enableContinue = false;
  //     });
  //   } else {
  //     setState(() {
  //       _enableContinue = true;
  //     });
  //   }
  // }

  // void verifyAndNavigate() async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     },
  //   );

  //   bool isVerified = await PayTMNumberVerified(mobileNumberController.text);

  //   Navigator.pop(context); // Dismiss the progress indicator dialog

  //   if (isVerified) {
  //     Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) =>
  //           EnterAmountScreen(number: mobileNumberController.text),
  //     ));
  //   } else {
  //     // Show SnackBar if the PayTM number doesn't exist
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           "This PayTM number does not exist!",
  //           style: TextStyle(
  //             color: AppColors.lumiDarkBlack,
  //             fontSize: 14,
  //             fontWeight: FontWeight.w400,
  //             letterSpacing: 0.25,
  //           ),
  //         ),
  //         elevation: 3,
  //         behavior: SnackBarBehavior.floating,
  //         shape: RoundedRectangleBorder(
  //           side: BorderSide(color: AppColors.lightGreen, width: 1),
  //           borderRadius: BorderRadius.circular(4),
  //         ),
  //         backgroundColor: AppColors.errorRed,
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //   }
  // }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initialNumPaytmVerification();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    double textFontMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();
    return WillPopScope(
      onWillPop: () async{
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return CommonConfirmationAlert(
              confirmationText1: translation(context).goingBackWillRestartProcess,
              confirmationText2: translation(context).areYouSureYouWantToLeave,
              onPressedYes: () {
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.ismartHomepage);
              },
            );
          },
        );
        return false;
      },
      child: GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: (isLoading)
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Stack(
            children: [
              Column(
                children: [
                  const VerticalSpace(height: 30),
                  HeaderWidgetWithCashInfo(
                    heading: translation(context).paytm, icon: Icon(
                    Icons.arrow_back_outlined,
                    color: AppColors.iconColor,
                    size: 24 * pixelMultiplier,
                  ),
                  ),
                  UserProfileWidget(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 24 * variablePixelWidth,
                      right: 24 * variablePixelWidth,
                      top: 20 * variablePixelHeight,
                    ),
                    child: Container(
                      height: 65 * variablePixelHeight,
                      child: TextField(
                        controller: mobileNumberController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.poppins(
                          fontSize: 14 * textFontMultiplier,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.50,
                        ),
                        onChanged: (value) {
                          //validateNumber(mobileNumberController.text);
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                              16 * variablePixelWidth, 0, 0, 0),
                          labelText: translation(context).mobileNumber,
                          hintText: translation(context).enterRegisteredMobileNumber,
                          // errorText: mobileValidationMessage.isNotEmpty
                          //     ? mobileValidationMessage
                          //     : null,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  4.0 * pixelMultiplier),
                              borderSide: const BorderSide(color: AppColors.grey)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(4.0 * pixelMultiplier),
                            borderSide: const BorderSide(color: AppColors.grey),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(4.0 * pixelMultiplier),
                            borderSide: const BorderSide(color: AppColors.errorRed),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(4.0 * pixelMultiplier),
                            borderSide: const BorderSide(color: AppColors.errorRed),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14 * textFontMultiplier,
                            fontWeight: FontWeight.w400,
                            height: 0.12,
                            letterSpacing: 0.50,
                          ),
                          errorStyle: GoogleFonts.poppins(
                            color: AppColors.errorRed,
                            fontSize: 12 * textFontMultiplier,
                            fontWeight: FontWeight.w400,
                            height: 0.12,
                            letterSpacing: 0.50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      1 * variablePixelWidth, 0, 1 * variablePixelWidth, 0),
                  alignment: Alignment.center,
                  child: ContinueButton(
                      onPressed: null, // verifyAndNavigate,
                      isEnabled: _enableContinue,
                      containerBackgroundColor: AppColors.white,
                      buttonText: translation(context).continueButtonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}