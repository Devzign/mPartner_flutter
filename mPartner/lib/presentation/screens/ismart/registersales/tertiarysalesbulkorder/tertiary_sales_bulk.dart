import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../../../../widgets/common_bottom_sheet.dart';
import '../../../../widgets/common_button.dart';
import '../../../../widgets/common_confirmation_alert.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../../base_screen.dart';
import '../../../userprofile/user_profile_widget.dart';
import '../components/custom_alert_widget.dart';
import '../components/custom_bs_header.dart';
import '../../../../widgets/headers/sales_header_widget.dart';
import '../components/multi_qr_widget.dart';
import '../uimodels/customer_info.dart';
import 'components/file_upload_widget.dart';

class TertiarySalesBulk extends StatefulWidget {
  final CustomerInfo customerInfo;

  const TertiarySalesBulk({super.key,
    required  this.customerInfo,
  });

  @override
  State<TertiarySalesBulk> createState() => _TertiarySalesBulkState();
}

class _TertiarySalesBulkState extends BaseScreenState<TertiarySalesBulk> {
  bool isFirstUploadValid = false; bool isSecondUploadValid = false;
  String _filePath = "";
  UserDataController controller = Get.find();

  void _handleFirstFileUpload(bool isEnabled, String filePath) {
    setState(() {
      _filePath = filePath;
      isFirstUploadValid=isEnabled;
    });
  }

  void _handleSecondFileUpload(bool isEnabled, String filePath) {
    setState(() {
      _filePath = filePath;
      isSecondUploadValid = isEnabled;
    });
  }

  Widget _buildConfirmationAlertBS(title, description, promptQues, onPressedYes,
      {isSingleButton = false}) {
    return Column(
      children: [
        CustomBSHeaderWidget(
          title: title,
          onClose: () => Navigator.of(context).pop(),
        ),
        SizedBox(
          height: 8 * DisplayMethods(context: context).getVariablePixelHeight(),
        ),
        CustomAlertWidget(
          description: description,
          promptQues: promptQues,
          onPressedYes: onPressedYes,
          isSingleButton: isSingleButton,
          onPressedNo: () => Navigator.of(context).pop(),
        )
      ],
    );
  }

  void _showConfirmationBSOnContinue(context) {
    CommonBottomSheet.show(
        context,
        _buildConfirmationAlertBS(
            translation(context).confirmationAlert,
            translation(context).docUploadWarning,
            translation(context).sureToContinue,
            _navigateToQRScanner),
        DisplayMethods(context: context).getVariablePixelHeight(),
        DisplayMethods(context: context).getVariablePixelWidth());
  }

  void _navigateToQRScanner() {
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MultiQRScanner(
              saleType: 'Tertiary',
                customer: widget.customerInfo,)));
  }


  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double variableTextFontMultiplier =
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
                    .pop();
                     Navigator.of(context)
                    .pop();
              },
            );
          },
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HeadingRegisterSales(
                icon: Icon(
                  Icons.arrow_back_outlined,
                  color: AppColors.iconColor,
                  size: 24 * variablePixelMultiplier,
                ),
                heading: "${translation(context).bulkCorporateSales}",
                headingSize: AppConstants.FONT_SIZE_LARGE,
                onPressed: () async {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return CommonConfirmationAlert(
                        confirmationText1:
                            translation(context).goingBackWillRestartProcess,
                        confirmationText2:
                            translation(context).areYouSureYouWantToLeave,
                        onPressedYes: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                  return false;
                }),
            UserProfileWidget(top: 8 * variablePixelHeight),
            ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                Container(
              padding: EdgeInsets.fromLTRB(
                24 * variablePixelWidth,
                0*variablePixelHeight,
                24 * variablePixelWidth,
                16*variablePixelHeight,
              ),
              width: variablePixelWidth * 393,
              child: Text(
                translation(context).uploadValidPurchaseOrder,
                style: GoogleFonts.poppins(
                  color: AppColors.darkGreyText,
                  fontStyle: FontStyle.normal,
                  fontSize: 14 * variablePixelMultiplier,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            FileUploadWidget(
                onFileUpload: (isEnabled, filePath) => _handleFirstFileUpload(
                    isEnabled,
                    filePath),
                    title: translation(context).uploadPurchaseOrder,
                    fileType: 'PurchaseOrder',
            ),
            FileUploadWidget(
                onFileUpload: (isEnabled, filePath) => _handleSecondFileUpload(
                    isEnabled,
                    filePath),
                title: translation(context).uploadTaxInvoice,
                fileType: 'TaxInvoice',
            ),
            Padding(
                padding: EdgeInsets.only(
                    left: 24 * variablePixelWidth,
                    right: 24 * variablePixelWidth),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${translation(context).note}*",
                        style: GoogleFonts.inter(
                            color: AppColors.errorRed,
                            fontSize: 12*variableTextFontMultiplier,
                            fontWeight: FontWeight.w600),
                      ),
                      VerticalSpace(height: 8),
                      Row(
                        children: [
                          Text(
                            translation(context).supportedformatPDFFile,
                            style: GoogleFonts.inter(
                                fontSize: 12 * variableTextFontMultiplier,
                                fontWeight: FontWeight.w400,
                                color: AppColors.darkGreyText),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            translation(context).maxFileSize5MB,
                            style: GoogleFonts.inter(
                                fontSize: 12 * variableTextFontMultiplier,
                                fontWeight: FontWeight.w400,
                                color: AppColors.darkGreyText
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              ],
            ),              
          ]),
        ),
        bottomNavigationBar:CommonButton(
            containerBackgroundColor: AppColors.lightWhite1,
            backGroundColor: isFirstUploadValid && isSecondUploadValid
                ? AppColors.lumiBluePrimary
                : AppColors.lightButtonBackground,
            onPressed: (){isFirstUploadValid && isSecondUploadValid ? _showConfirmationBSOnContinue(context) : null;},
            isEnabled: isFirstUploadValid && isSecondUploadValid,
            buttonText: translation(context).continueButtonText) ,
      ),
    );
  }
}
