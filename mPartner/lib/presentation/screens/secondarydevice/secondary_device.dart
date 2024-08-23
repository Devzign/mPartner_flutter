import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../network/api_constants.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/utils.dart';
import '../../../state/contoller/language_controller.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/requests.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/textfield_input_handler.dart';
import '../../widgets/headers/header_widget_with_right_align_action_button.dart';
import '../../widgets/common_button.dart';
import '../../widgets/verifyOTP/common_verify_otp.dart';
import '../../widgets/verticalspace/vertical_space.dart';
import '../base_screen.dart';
import '../userprofile/user_profile_widget.dart';
import 'snackbar.dart';

class OtpResponse {
  final String data1;
  final String msg;
  final String error;

  OtpResponse({required this.data1, required this.msg, required this.error});
}

class SecondaryDevice extends StatefulWidget {
  final String secondaryScreenTitle;
  final String primaryNumber;
  final String secondaryNumber;

  SecondaryDevice({Key? key, required this.secondaryScreenTitle, required this.primaryNumber, required this.secondaryNumber})
      : super(key: key);

  @override
  State<SecondaryDevice> createState() => _SecondaryDeviceState();
}

class _SecondaryDeviceState extends BaseScreenState<SecondaryDevice> {
  bool isButtonEnabledContinue = false;
  late String secondaryDevice1;
  late String secondaryDevice2;
  late Map<String, dynamic> responseDataUpdateData;
  bool isValidName = false;
  bool isValidRel = false;
  bool isValidPhone = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _relationController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  FocusNode mobileNumberFocusNode = FocusNode();
  String mobileNumberWithoutPrefix = '';
  UserDataController controller = Get.find();
  LanguageController languageController = Get.find();
  String errorTextName = "";
  String errorTextRelationship = "";

  bool showError = false;
  String prefix = '';

  @override
  void initState() {
    _mobileNumberController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  Future<String> updateData(String secondaryDevice1, String secondaryDevice2, String secDevName, String secDevRelationShip) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String phone = controller.phoneNumber;
    String language = languageController.language;
    if (widget.secondaryScreenTitle != translation(context).secondaryDevice1) {
      secondaryDevice1 = '';
    } else {
      secondaryDevice2 = '';
    }
    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "channel": AppConstants.channel,
      "os_Type": Platform.isAndroid ? "android":"ios",
      "app_Version": AppConstants.appVersionName,
      "device_Id": "",
      "DOB": "",
      "anniversaryDate": "",
      "secondaryDevice1": secondaryDevice1,
      "secondaryDevice2": secondaryDevice2,
      "businessName": "",
      "Name": secDevName,
      "RelationShip": secDevRelationShip,
      "message": "",
      "profileImg": null,
      "phoneNumber": phone,
      "token": token,
    };
    try {
      final response = await Requests.sendPostRequest(
        ApiConstants.postUpadteProfileEndPoint,
        body
      );
      if (response is! DioException && response.statusCode == 200) {
        return response.data['status'];
      } else {
        return response.data['status'];
      }
    } catch (error) {
      return "";
    }
  }

  void checkTextfieldStatus() {
    setState(() {
      if (_nameController.text.isNotEmpty && _relationController.text.isNotEmpty && _mobileNumberController.text.isNotEmpty &&
          isValidName && isValidRel && isValidPhone) {
        isButtonEnabledContinue = true;
      } else {
        isButtonEnabledContinue = false;
      }
    });
  }

  void validateName(String name) {
    RegExp regex = AppConstants.VALIDATE_NAME_REGEX;
    if (name.isEmpty) {
      setState(() {
        isValidName = false;
        errorTextName = "";
      });
    } else if (!regex.hasMatch(name)) {
      setState(() {
        isValidName = false;
        errorTextName = "Field can’t contain number or special characters";
      });
    } else {
      setState(() {
        isValidName = true;
        errorTextName = "";
      });
    }
  }

  void validateRelationship(String relationship) {
    RegExp regex = AppConstants.VALIDATE_NAME_REGEX;
    if (relationship.isEmpty) {
      setState(() {
        isValidRel = false;
        errorTextRelationship = "";
      });
    } else if (!regex.hasMatch(relationship)) {
      setState(() {
        isValidRel = false;
        errorTextRelationship = "Field can’t contain number or special characters";
      });
    } else {
      setState(() {
        isValidRel = true;
        errorTextRelationship = "";
      });
    }
  }

  void validateMobileNumber(String mobileNumber) {
    RegExp regex = RegExp(r'^[0-9]{10}$');
    setState(() {
      if (mobileNumber.isEmpty) {
        isValidPhone = false;
      } else if (mobileNumber.length > 10) {
        if (!regex.hasMatch(mobileNumber)) {
          isValidPhone = false;
        } else {
          isValidPhone = true;
        }
      } else {
        if (regex.hasMatch(mobileNumber)) {
          isValidPhone = true;
        } else {
          isValidPhone = false;
        }
      }
    });
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double labelFontSize = DisplayMethods(context: context).getLabelFontSize();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    final OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
      borderSide: const BorderSide(color: AppColors.lumiBluePrimary),
    );

    final OutlineInputBorder enabledOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
      borderSide: const BorderSide(color: AppColors.dividerColor),
    );

    final OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0 * pixelMultiplier),
      borderSide: const BorderSide(color: AppColors.errorRed),
    );

    final OutlineInputBorder focusedErrorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
      borderSide: const BorderSide(color: AppColors.errorRed),
    );

    final TextStyle customHintStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w400,
      height: 0.12,
      letterSpacing: 0.50,
    );

    final TextStyle customPrefixStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w500,
      height: 0.12,
      letterSpacing: 0.50,
    );

    final TextStyle textStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.50,
    );

    final TextStyle errorTextStyle = GoogleFonts.poppins(
      color: AppColors.errorRed,
      fontSize: 12 * textFontMultiplier,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.40,
    );

    return GestureDetector(
    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Builder(builder: (BuildContext scaffoldContext) {
            return Column(
              children: [
                HeaderWidgetWithRightAlignActionButton(text: widget.secondaryScreenTitle),
                UserProfileWidget(top: 8*variablePixelHeight),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const VerticalSpace(height: 10),
                          Text(
                            translation(context).information,
                            style: GoogleFonts.poppins(
                              fontSize: 16 * textFontMultiplier,
                              fontWeight: FontWeight.w600,
                              height: 0.09,
                              letterSpacing: 0.10,
                            ),
                          ),
                          const VerticalSpace(height: 30),
                          TextField(
                            controller: _nameController,
                            style: textStyle,
                            maxLength: AppConstants.nameInputMaxLength,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: <TextInputFormatter>[
                              HandleFirstSpaceAndDotInputFormatter(),
                              HandleMultipleDotsInputFormatter(),
                              FilteringTextInputFormatter.allow(AppConstants.VALIDATE_NAME_REGEX),
                            ],
                            onTap: (){
                              if(_mobileNumberController.text.isEmpty){
                                setState(() {
                                  prefix = '';
                                });
                              }
                            },
                            onChanged: (value) {
                              validateName(value);
                              checkTextfieldStatus();
                            },
                            decoration: InputDecoration(
                              counterText: "",
                              labelText: translation(context).name,
                              errorText: errorTextName.isNotEmpty ? errorTextName : null,
                              hintText: translation(context).enterName,
                              focusedBorder: focusedOutlineInputBorder,
                              enabledBorder: enabledOutlineInputBorder,
                              labelStyle: GoogleFonts.poppins(
                                color: _nameController.text.isEmpty
                                    ? AppColors.darkGreyText
                                    :  errorTextName.isNotEmpty ? AppColors.errorRed : AppColors.lumiBluePrimary,
                                fontSize: labelFontSize,
                                fontWeight: FontWeight.w400,
                                height: 0.11,
                                letterSpacing: 0.40,
                              ),
                              errorStyle: errorTextStyle,
                              errorBorder: errorBorder,
                              focusedErrorBorder: focusedErrorBorder,
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintStyle: customHintStyle,
                              prefixStyle: customPrefixStyle,
                            ),
                          ),
                          const VerticalSpace(height: 30),
                          TextField(
                            controller: _relationController,
                            style: textStyle,
                            maxLength: AppConstants.nameInputMaxLength,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: <TextInputFormatter>[
                              HandleFirstSpaceAndDotInputFormatter(),
                              HandleMultipleDotsInputFormatter(),
                              FilteringTextInputFormatter.allow(AppConstants.VALIDATE_NAME_REGEX),
                            ],
                            onChanged: (value) {
                              validateRelationship(value);
                              checkTextfieldStatus();
                            },
                            onTap: (){
                              if(_mobileNumberController.text.isEmpty){
                                setState(() {
                                  prefix = '';
                                });
                              }
                            },
                            decoration: InputDecoration(
                              counterText: "",
                              labelText: translation(context).relationshipWithOwner,
                              errorText: errorTextRelationship.isNotEmpty ? errorTextRelationship : null,
                              hintText: translation(context).fatherSonEmployee,
                              focusedBorder: focusedOutlineInputBorder,
                              enabledBorder: enabledOutlineInputBorder,
                              labelStyle: GoogleFonts.poppins(
                                color: _relationController.text.isEmpty
                                    ? AppColors.darkGreyText
                                    :  errorTextRelationship.isNotEmpty ? AppColors.errorRed : AppColors.lumiBluePrimary,
                                fontSize: labelFontSize,
                                fontWeight: FontWeight.w400,
                                height: 0.11,
                                letterSpacing: 0.40,
                              ),
                              errorStyle: errorTextStyle,
                              errorBorder: errorBorder,
                              focusedErrorBorder: focusedErrorBorder,
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintStyle: customHintStyle,
                              prefixStyle: customPrefixStyle,
                            ),
                          ),
                          const VerticalSpace(height: 30),
                          TextField(
                            controller: _mobileNumberController,
                            focusNode: mobileNumberFocusNode,
                            inputFormatters: <TextInputFormatter>[
                              HandleFirstDigitInMobileTextFieldFormatter(),
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            style: textStyle,
                            onChanged: (value) {
                              setState(() {
                                showError = false;
                              });
                              mobileNumberWithoutPrefix =
                              value.startsWith('+91 - ')
                                  ? value.substring('+91 - '.length)
                                  : value;
                                validateMobileNumber(mobileNumberWithoutPrefix);
                                checkTextfieldStatus();
                            },
                            onTap: () {
                              setState(() {
                                prefix = '+91 - ';
                              });
                            },
                            decoration: InputDecoration(

                              errorText: (showError ? translation(context).noAlreadyExists : null),
                              labelText: translation(context).mobileNumber,
                              hintText: translation(context).enterConMobNo,
                              focusedBorder: focusedOutlineInputBorder,
                              enabledBorder: enabledOutlineInputBorder,
                              labelStyle: GoogleFonts.poppins(

                                color: showError
                                    ? AppColors.errorRed
                                    : _mobileNumberController.text.isEmpty
                                    ? AppColors.darkGreyText
                                    : AppColors.lumiBluePrimary,
                                fontSize: labelFontSize,
                                fontWeight: FontWeight.w400,
                                height: 0.11,
                                letterSpacing: 0.40,
                              ),

                              errorStyle: GoogleFonts.poppins(
                                color: AppColors.errorRed,
                                fontSize: 12 * textFontMultiplier,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.50,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0 * pixelMultiplier),
                                borderSide: const BorderSide(color: AppColors.errorRed),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
                                borderSide: const BorderSide(color: AppColors.errorRed),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintStyle: customHintStyle,
                              counterText: '',
                              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                              prefixIcon: Padding(padding:EdgeInsets.only(left: 10 * variablePixelWidth),child: Text(prefix,style: customPrefixStyle)),
                            ),
                          ),
                          const VerticalSpace(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                CommonButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if(widget.primaryNumber == mobileNumberWithoutPrefix || widget.secondaryNumber == mobileNumberWithoutPrefix){
                      setState(() {
                        showError = true;
                      });
                      Utils().showToast(translation(context).noAlreadyExists, context);
                    } else {
                      commonVerifyOtp(scaffoldContext, mobileNumberWithoutPrefix,
                              (verified) {
                            if (verified) {
                              // call the update function
                              setState(() {
                                secondaryDevice1 = mobileNumberWithoutPrefix;
                                secondaryDevice2 = mobileNumberWithoutPrefix;
                              });
                              updateData(
                                secondaryDevice1,
                                secondaryDevice2,
                                _nameController.text,
                                _relationController.text,
                              ).then((status) {
                                if (status == '200') {
                                  Navigator.of(context).pop();
                                  Navigator.popAndPushNamed(context, AppRoutes.userprofile);
                                  ScaffoldMessenger.of(context).showSnackBar(MySnackBar.createSnackBar(context));
                                } else if (status == '0') {
                                  setState(() {
                                    showError = true;
                                  });
                                  Utils().showToast(translation(context).noAlreadyExists, context);
                                }
                              });
                            }
                          }, variablePixelHeight);
                    }
                  },
                  isEnabled: isButtonEnabledContinue,
                  buttonText: translation(context).continueButtonText,
                  backGroundColor: AppColors.lumiBluePrimary,
                  containerBackgroundColor: AppColors.white,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
