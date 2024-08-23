import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../data/models/user_gst_upload_model.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../services/services_locator.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/headers/header_widget_with_right_align_action_button.dart';
import '../../widgets/common_button.dart';
import '../../widgets/verticalspace/vertical_space.dart';
import '../base_screen.dart';
import 'common_upload_bottom_sheet.dart';
import 'components/show_alert_bottom_sheet.dart';
import 'upperCaseFormatter.dart';
import 'user_profile.dart';
import 'user_profile_widget.dart';

class GstCertificateUpload extends StatefulWidget {
  const GstCertificateUpload({super.key});

  @override
  State<GstCertificateUpload> createState() => _GstCertificateUploadState();
}

class _GstCertificateUploadState extends BaseScreenState<GstCertificateUpload> {
  bool isPhotoClicked = false;
  String imagePath = '';
  TextEditingController gstCertificateController = TextEditingController();
  bool isTextFilled = false;
  UserDataController controller = Get.find();
  var userUploadGstOutput = <UserGstUploadModel>[];
  bool isValidGstNo = false;
  String errorTextGstNo = '';

  void validateGstNo(String gstNo) {
    RegExp regex =
        RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
    if (gstNo.isEmpty) {
      setState(() {
        isValidGstNo = false;
        errorTextGstNo = "";
      });
    } else if (!regex.hasMatch(gstNo)) {
      setState(() {
        isValidGstNo = false;
        errorTextGstNo = translation(context).gstValidation;
      });
    } else {
      setState(() {
        isValidGstNo = true;
        errorTextGstNo = "";
      });
    }
  }

  postUserGstDetails(String gstNumber, String imagePath) async {
    try {
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.userGstUpload(
          imagePath, gstNumber);
      result.fold((l) {
        print("Error: $l");
      }, (r) async {
        if (r.status == "200") {
          userUploadGstOutput.clear();
          userUploadGstOutput.add(r);
          final getUserProfileResult =
              await baseMPartnerRemoteDataSource.getUserProfile();
          getUserProfileResult.fold(
            (l) {
              print("Error: $l");
            },
            (r) async {
              final List<UserProfile> userProfileData = [];
              userProfileData.addAll(r);
              if(userProfileData.isNotEmpty && controller.isPrimaryNumberLogin){
                if(userProfileData[0].phone.isNotEmpty){
                  logger.d("[userProfileData[0].phone]:: ${userProfileData[0].phone}");
                  controller.updatePhoneNumber(userProfileData[0].phone);
                }
              }
              final userProfileJson = jsonEncode(userProfileData);
              controller.updateUserProfile(userProfileJson);
            },
          );
        } else {
          print("Error PP upload");
        }
      });
    } catch (e) {
      print("Error Captured: ${e}");
    }
  }

  @override
  Widget baseBody(BuildContext context) {
    double labelFontSize = DisplayMethods(context: context).getLabelFontSize();
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    final OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
      borderSide: const BorderSide(color: AppColors.lumiBluePrimary),
    );

    final OutlineInputBorder enabledOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
      borderSide: const BorderSide(color: AppColors.dividerColor),
    );

    final TextStyle customHintStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w400,
      height: 0.12 * variablePixelHeight,
      letterSpacing: 0.50,
    );

    final TextStyle customPrefixStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w500,
      height: 0.12 * variablePixelHeight,
      letterSpacing: 0.50,
    );

    final TextStyle textStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.50,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            child: Column(
              children: [
                HeaderWidgetWithRightAlignActionButton(text: translation(context).gstCertificate),
                UserProfileWidget(top: 8*variablePixelHeight),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const VerticalSpace(height: 10),
                          Container(
                            margin: EdgeInsets.only(
                                left: 24 * variablePixelWidth,
                                right: 24 * variablePixelWidth),
                            child: TextField(
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [
                                UpperCaseTextFormatter(),
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9a-zA-Z]"))
                              ],
                              maxLength: 15,
                              controller: gstCertificateController,
                              onChanged: (value) {
                                validateGstNo(gstCertificateController.text);
                                setState(() {
                                  if (gstCertificateController
                                      .text.isNotEmpty) {
                                    isTextFilled = true;
                                  } else {
                                    isTextFilled = false;
                                  }
                                });
                              },
                              style: textStyle,
                              decoration: InputDecoration(
                                  label: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: translation(context)
                                              .gstCertificate,
                                          style: GoogleFonts.poppins(
                                            color: AppColors.darkGreyText,
                                            fontSize: 12 * textFontMultiplier,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.40,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '*',
                                          style: GoogleFonts.poppins(
                                            color: AppColors.errorRed,
                                            fontSize: 12 * textFontMultiplier,
                                            fontWeight: FontWeight.w400,
                                            height: 0.11 * variablePixelHeight,
                                            letterSpacing: 0.40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  counterText: "",
                                  errorText: errorTextGstNo.isNotEmpty
                                      ? errorTextGstNo
                                      : null,
                                  hintText: translation(context).enterGstNumber,
                                  focusedBorder: focusedOutlineInputBorder,
                                  enabledBorder: enabledOutlineInputBorder,
                                  labelStyle: GoogleFonts.poppins(
                                    color: gstCertificateController.text.isEmpty
                                        ? AppColors.darkGreyText
                                        : AppColors.lumiBluePrimary,
                                    fontSize: labelFontSize,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.40,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintStyle: customHintStyle,
                                  prefixStyle: customPrefixStyle,
                                  errorStyle: GoogleFonts.poppins(
                                    color: AppColors.errorRed,
                                    fontSize: 12 * textFontMultiplier,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.40,
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(4.0 * pixelMultiplier)),
                                    borderSide: const BorderSide(
                                        color: AppColors.errorRed),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        4.0 * pixelMultiplier),
                                    borderSide: const BorderSide(
                                        color: AppColors.errorRed),
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      16 * variablePixelWidth,
                                      16 * variablePixelHeight,
                                      8 * variablePixelWidth,
                                      8 * variablePixelHeight)),
                            ),
                          ),
                          const VerticalSpace(height: 16),
                          Container(
                            margin: EdgeInsets.only(
                                left: 24 * variablePixelWidth,
                                right: 24 * variablePixelWidth),
                            child: Text(
                              translation(context).uploadGstCertificate,
                              style: GoogleFonts.poppins(
                                color: AppColors.hintColor,
                                fontSize: 12 * textFontMultiplier,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.10,
                              ),
                            ),
                          ),
                          const VerticalSpace(height: 12),
                          Container(
                            margin: EdgeInsets.only(
                                left: 24 * variablePixelWidth,
                                right: 24 * variablePixelWidth),
                            height: 222 * variablePixelHeight,
                            color: AppColors.lumiLight5,
                            child: Stack(
                              children: [
                                DottedBorder(
                                  color: AppColors.lumiBluePrimary,
                                  strokeWidth: 1 * variablePixelWidth,
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(4 * pixelMultiplier),
                                  dashPattern: const [6, 3],
                                  child: Container(),
                                ),
                                !isPhotoClicked
                                    ? Positioned(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.add,
                                                  size: 24 * pixelMultiplier,
                                                  color:
                                                      AppColors.lumiBluePrimary,
                                                ),
                                                onPressed: () {
                                                  showUploadBottomSheet(
                                                      context,
                                                      translation(context)
                                                          .uploadGstCertificate,
                                                      (String imageCaptured) {
                                                    setState(() {
                                                      imagePath = imageCaptured;
                                                    });
                                                    if (imagePath.isNotEmpty) {
                                                      isPhotoClicked = true;
                                                      // postUserUploadProfileImage(imagePath);
                                                    }
                                                  });
                                                },
                                              ),
                                              Text(
                                                translation(context)
                                                    .uploadGstCertificate,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      AppColors.lumiBluePrimary,
                                                  fontSize:
                                                      14 * textFontMultiplier,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.50,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Stack(
                                        children: [
                                          Positioned(
                                            child: Center(
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    10 * variablePixelWidth,
                                                    10 * variablePixelHeight,
                                                    10 * variablePixelWidth,
                                                    10 * variablePixelHeight),
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: Image.file(
                                                  File(imagePath),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 20 * variablePixelHeight,
                                            right: 20 * variablePixelWidth,
                                            child: InkWell(
                                                onTap: () {
                                                  showUploadBottomSheet(
                                                      context,
                                                      translation(context)
                                                          .uploadGstCertificate,
                                                      (String imageCaptured) {
                                                    setState(() {
                                                      imagePath = imageCaptured;
                                                    });
                                                    if (imagePath.isNotEmpty) {
                                                      isPhotoClicked = true;
                                                      // postUserUploadProfileImage(imagePath);
                                                    }
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                    "assets/mpartner/network/image_edit.svg")),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          const VerticalSpace(height: 8),
                          Container(
                            margin: EdgeInsets.only(
                                left: 24 * variablePixelWidth,
                                right: 24 * variablePixelWidth),
                            child: Text(
                              imagePath.isNotEmpty
                                  ? File(imagePath).path.split("/").last
                                  : "Untitled.jpeg",
                              style: GoogleFonts.poppins(
                                color: AppColors.grayText,
                                fontSize: 12 * textFontMultiplier,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.10,
                              ),
                            ),
                          ),
                          const VerticalSpace(height: 20),
                        ]),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: CommonButton(
                      onPressed: () {
                        showConfirmationAlertBottomSheet(
                            context,
                            translation(context).alert,
                            translation(context).gstUploadAlertText,
                            translation(context).sureToContinue, () async {
                          await postUserGstDetails(
                              gstCertificateController.text, imagePath);
                          // Navigator.of(context).popUntil(
                          //     ModalRoute.withName(AppRoutes.userprofile));
                          // Navigator.of(context)
                          //     .popAndPushNamed(AppRoutes.userprofile);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProfileScreen()),
                          );
                        });
                      },
                      isEnabled: isTextFilled && isPhotoClicked && isValidGstNo,
                      containerBackgroundColor: Colors.white,
                      buttonText: translation(context).submit),
                ),
              ],
            ),
          )),
    );
  }
}
