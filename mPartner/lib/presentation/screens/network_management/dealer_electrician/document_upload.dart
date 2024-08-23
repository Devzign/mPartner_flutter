import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../state/contoller/create_dealer_electrician_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/common_bottom_sheet.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_divider.dart';
import '../../../widgets/headers/network_mgmnt_header_widget.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../base_screen.dart';
import '../../userprofile/user_profile_widget.dart';
import 'components/common_network_utils.dart';
import 'components/submit_button.dart';
import 'components/upload_document_form.dart';
import 'components/verify_sale_otp_screen.dart';

class DocumentUpload extends StatefulWidget {
  final String selectedUserType;

  const DocumentUpload({super.key, required this.selectedUserType});

  @override
  State<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends BaseScreenState<DocumentUpload> {
  late double variablePixelHeight;
  late double variablePixelWidth;
  late double variablePixelMultiplier;
  late double textMultiplier;
  CreateDealerElectricianController controller = Get.find();


  @override
  Widget baseBody(BuildContext context) {
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.lightWhite1,
        bottomNavigationBar: submitButtonWidget(context),
        body: SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            NetworkManagementHeaderWidget(
              heading: widget.selectedUserType == UserType.dealer
                  ? translation(context).newDealer
                  : translation(context).newElectrician,
            ),
            UserProfileWidget(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24*variablePixelWidth),
              child: titleWidget(textMultiplier, variablePixelMultiplier),
            ),
            Expanded(
              child:
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 24*variablePixelWidth),
                      child: DocumentUploadForm(widget.selectedUserType)),
            )
          ]),
        ),
      ),
    );
  }

  Widget titleWidget(double textMultiplier, double variablePixelMultiplier) {
    return Container(
      height: 40 * variablePixelMultiplier,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            translation(context).uploadDocuments,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.darkText2,
              fontSize: 16 * textMultiplier,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "${translation(context).step} 3 of 3",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.hintColor,
              fontSize: 14 * textMultiplier,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget submitButtonWidget(BuildContext context) {
    return Obx(() {
      return Container(
        height: 50 * variablePixelHeight,
        margin: EdgeInsets.only(bottom: 15),
        alignment: Alignment.center,
        child: SubmitButton(
            containerHeight: 55 * variablePixelHeight,
            isLoading:controller.isButtonClicked.value,
            onPressed: () async {
              double fontMultiplier =
                  DisplayMethods(context: context).getTextFontMultiplier();
              double pixcelMultiplier =
                  DisplayMethods(context: context).getPixelMultiplier();
              controller.isvalidOtp.value=true;
              if (controller.enableDocSubmit.value) {
                bool isValidated = controller.validateGovtIdField(context);
                if (isValidated) {
                  if(!controller.isButtonClicked.value){
                    controller.isButtonClicked.value=true;
                  String? response = await controller.createOtp(
                      context, widget.selectedUserType);


                  if (controller.otpValidationMessage.contains("Enter the OTP sent to")) {
                    controller.isButtonClicked.value=false;
                    CommonBottomSheet.show(
                        context,
                        VerifyOTPWidget(
                            mobileNumber: controller.mobileNumberController.text
                                .trim()
                                .replaceAll("+91 - ", ""),
                            onItemSelected: (pin) async {},
                            contentTiltle: translation(context).verifyOTP,
                            context: context,
                            content:controller.otpValidationMessage,
                            userType: controller.userType),
                        variablePixelHeight,
                        variablePixelWidth);
                  } else if(controller.otpValidationMessage.toLowerCase().contains("already registered")) {
                    controller.isButtonClicked.value=false;
                    showAlertBottomSheet(
                        "This mobile number is already registered. Please provide valid mobile number",
                        context,
                        variablePixelHeight,
                        variablePixelWidth,
                        fontMultiplier,
                        pixcelMultiplier);
                  }
                  else{
                    controller.isButtonClicked.value=false;
                    showAlertBottomSheet(
                        controller.otpValidationMessage,
                        context,
                        variablePixelHeight,
                        variablePixelWidth,
                        fontMultiplier,
                        pixcelMultiplier);
                  }
                  }
                }
              } else {
                //  controller.emptyValidation();
              }
            },
            isEnabled: controller.enableDocSubmit.value,
            containerBackgroundColor: AppColors.white,
            buttonText: (widget.selectedUserType == UserType.dealer)
                ? translation(context).verifyDealer
                : translation(context).verifyElectrician),
      );
    });
  }

  void showAlertBottomSheet(
      String msg,
      BuildContext context,
      double variablePixelHeight,
      double variablePixelWidth,
      double textFontMultiplier,
      double pixelMultiplier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
            Padding(
              padding: EdgeInsets.all(
                  8*variablePixelMultiplier),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Container(
                        height: 5 * variablePixelHeight,
                        width: 50 * variablePixelWidth,
                        decoration: BoxDecoration(
                          color: AppColors.grayText,
                          borderRadius:
                              BorderRadius.circular(12 * pixelMultiplier),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.black,
                    ),
                  ),
                  const VerticalSpace(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                    child: Text(
                      translation(context).alert,
                      style: GoogleFonts.poppins(
                        color: AppColors.titleColor,
                        fontSize: 20 * textFontMultiplier,
                        fontWeight: FontWeight.w600,
                        height: 0.06,
                        letterSpacing: 0.50,
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 16),
                  Padding(
                    padding: EdgeInsets.only(left: 16 * pixelMultiplier),
                    child: const CustomDivider(color: AppColors.dividerColor),
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
                        msg,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkGrey,
                          fontSize: 14 * textFontMultiplier,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.10,
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 24),
                  CommonButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    isEnabled: true,
                    buttonText: translation(context).cancel,
                    containerBackgroundColor: AppColors.white,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
