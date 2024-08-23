import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/utils.dart';
import '../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../data/models/consumer_emi_log_model.dart';
import '../../../data/models/consumer_emi_sm_ro_details.dart';
import '../../../services/services_locator.dart';
import '../../../state/contoller/consumer_emi_controller.dart';
import '../../../utils/app_string.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../widgets/headers/header_widget_with_right_align_action_button.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_divider.dart';
import '../../widgets/verticalspace/vertical_space.dart';
import '../base_screen.dart';
import '../userprofile/user_profile_widget.dart';
import 'component/custom_list_tile.dart';
import 'component/custom_text_widget.dart';
import 'component/header_consumer_emi.dart';
import 'component/pincode_textfield.dart';

class ConsumerEmiSearchRep extends StatefulWidget {
  ConsumerEmiSearchRep({
    super.key,
  });

  @override
  State<ConsumerEmiSearchRep> createState() => _ConsumerEmiSearchRep();
}

class _ConsumerEmiSearchRep extends BaseScreenState<ConsumerEmiSearchRep> {
  ConsumerEmiController consumerEmiController = Get.find();
  bool isButtonEnabled = false;

  bool showLoader = false;
  TextEditingController pincodeController = TextEditingController();
  var userActivityOutput = <ConsumerEmiLog>[];

  @override
  void initState() {
    consumerEmiController.clearConsumerEmiController();
    super.initState();
  }

  void openWhatsAppChat(String phoneNo) async {
    String whatsappUrl = "https://wa.me/$phoneNo";
    if (Platform.isAndroid) {
      whatsappUrl = "https://wa.me/$phoneNo";
    } else {
      if (phoneNo.startsWith("+91-")) {
        String shortenedPhNo = phoneNo.substring(4);
        whatsappUrl = "https://wa.me/$shortenedPhNo";
      }
    }
    if (await canLaunchUrlString(whatsappUrl)) {
      await launchUrl(Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication);
    } else {
      print("Error launching WhatsApp");
    }
  }

  void openDialPad(String phoneNo) async {
    String dialPadUrl = "tel:$phoneNo";
    if (await canLaunchUrlString(dialPadUrl)) {
      await launchUrlString(dialPadUrl);
    } else {
      print("Error opening dialpad");
    }
  }

  void validatePinCode(String pinCode) {
    RegExp regex = RegExp(r'^[0-9]{6}$');
    setState(() {
      if (pinCode.isEmpty) {
        isButtonEnabled = false;
      } else if (!regex.hasMatch(pinCode)) {
        isButtonEnabled = false;
      } else {
        isButtonEnabled = true;
      }
    });
  }

  postUserActivity(
      String pincode, String mobileNumber, String name, String callMode) async {
    try {
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.consumerEmiLog(
          pincode, mobileNumber, name, callMode);
      result.fold((l) {
        print("Error: $l");
      }, (r) async {
        if (r.status == "200") {
          userActivityOutput.clear();
          userActivityOutput.add(r);
        }
      });
    } catch (e) {
      print("Error Captured: ${e}");
    }
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
                        title: translation(context).searchNearbyRepresentative,
                        description: translation(context)
                            .enterPincodeToSearchRepresentative),
                    PincodeTextField(
                      controller: pincodeController,
                      onChanged: (value) {
                        validatePinCode(pincodeController.text);
                      },
                    ),
                  ],
                ),
              ),
            ),
            CommonButton(
                onPressed: () {
                  consumerEmiController.clearConsumerEmiController();
                  setState(() {
                    showLoader = true;
                  });
                  consumerEmiController
                      .fetchConsumerEmiSmRoDEtails(pincodeController.text)
                      .then((_) {
                    if (consumerEmiController
                        .consumerEmiSmRoDetailsOutput.isNotEmpty) {
                      SmRoDetails result = consumerEmiController
                          .consumerEmiSmRoDetailsOutput.first;
                      setState(() {
                        showLoader = false;
                      });
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0 * pixelMultiplier),
                          ),
                        ),
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Wrap(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    8 * variablePixelWidth,
                                    8 * variablePixelHeight,
                                    8 * variablePixelWidth,
                                    8 * variablePixelHeight),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const VerticalSpace(height: 16),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        consumerEmiController
                                            .clearConsumerEmiController();
                                      },
                                      child: Center(
                                        child: Container(
                                          height: 5 * variablePixelHeight,
                                          width: 50 * variablePixelWidth,
                                          decoration: BoxDecoration(
                                            color: AppColors.dividerGreyColor,
                                            borderRadius: BorderRadius.circular(
                                                12 * pixelMultiplier),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const VerticalSpace(height: 10),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        consumerEmiController
                                            .clearConsumerEmiController();
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        size: 28 * pixelMultiplier,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    const VerticalSpace(height: 20),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 16.0 * variablePixelWidth),
                                      child: Text(
                                        translation(context)
                                            .representativeDetails,
                                        style: GoogleFonts.poppins(
                                          color: AppColors.titleColor,
                                          fontSize: 20 * textFontMultiplier,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing:
                                              0.50 * variablePixelWidth,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 16 * variablePixelWidth),
                                      child: const CustomDivider(
                                          color: AppColors.dividerColor),
                                    ),
                                    const VerticalSpace(height: 16),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: 24 * variablePixelWidth,
                                          left: 16 * variablePixelWidth),
                                      child: Container(
                                        width: 345 * variablePixelWidth,
                                        height: 40 * variablePixelHeight,
                                        child: Text(
                                          result.bankBottomInfo,
                                          style: GoogleFonts.poppins(
                                            color: AppColors.darkGreyText,
                                            fontSize: 12 * textFontMultiplier,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing:
                                                0.10 * variablePixelWidth,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const VerticalSpace(height: 20),
                                    CustomListTile(
                                      name: result.smName,
                                      phoneNo: result.smPhoneNo,
                                      designation:
                                          result.designation.toUpperCase(),
                                      onTapWhatsApp: () {
                                        openWhatsAppChat('${result.smPhoneNo}');
                                        postUserActivity(
                                            pincodeController.text,
                                            result.smPhoneNo,
                                            result.smName,
                                            ConsumerEmiLogStrings.whatsApp);
                                      },
                                      onTapCall: () {
                                        openDialPad(result.smPhoneNo);
                                        postUserActivity(
                                            pincodeController.text,
                                            result.smPhoneNo,
                                            result.smName,
                                            ConsumerEmiLogStrings.call);
                                      },
                                    ),
                                    CustomListTile(
                                      name: result.roName,
                                      phoneNo: result.roPhoneNo,
                                      designation:
                                          result.designation2.toUpperCase(),
                                      onTapWhatsApp: () {
                                        openWhatsAppChat('${result.roPhoneNo}');
                                        postUserActivity(
                                            pincodeController.text,
                                            result.roPhoneNo,
                                            result.roName,
                                            ConsumerEmiLogStrings.whatsApp);
                                      },
                                      onTapCall: () {
                                        openDialPad(result.roPhoneNo);
                                        postUserActivity(
                                            pincodeController.text,
                                            result.roPhoneNo,
                                            result.roName,
                                            ConsumerEmiLogStrings.call);
                                      },
                                    ),
                                    const VerticalSpace(height: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      setState(() {
                        showLoader = false;
                      });
                      Utils().showToast("No data on this pincode!!", context);
                    }
                  });
                },
                isEnabled: isButtonEnabled & !showLoader,
                showLoader: showLoader,
                containerBackgroundColor: AppColors.white,
                buttonText: translation(context).submit),
          ],
        )),
      ),
    );
  }
}
