
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../state/contoller/cash_summary_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/common_confirmation_alert.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../userprofile/user_profile_widget.dart';
import '../widgets/alert_bottom_sheet.dart';
import '../widgets/continue_button.dart';
import '../../../widgets/headers/header_widget_with_cash_info.dart';
import '../widgets/registered_num_widget.dart';
import '../widgets/transfer_amount_textfield.dart';
import 'amount_details_screen.dart';

class EnterAmountScreen extends StatefulWidget {
  const EnterAmountScreen(
      {required this.number, required this.isVerified, super.key});

  final String number;
  final bool isVerified;
  @override
  State<EnterAmountScreen> createState() {
    return _EnterAmountScreen();
  }
}

class _EnterAmountScreen extends State<EnterAmountScreen> {
  TextEditingController amountController = TextEditingController();
  String amountValidationMessage = '';
  bool _enableContinue = false;
  UserDataController userController = Get.find();

  void validateAmount(String amount) {
    RegExp amountRegex = RegExp(r'^[1-9][0-9]*$');
    if (amount.isEmpty) {
      setState(() {
        amountValidationMessage = '';
        _enableContinue = false;
      });
    } else if (!amountRegex.hasMatch(amount)) {
      setState(() {
        amountValidationMessage = translation(context).enterValidTransferAmount;
        _enableContinue = false;
      });
    } else {
      setState(() {
        amountValidationMessage = '';
        _enableContinue = true;
      });
    }
  }

  void _onSubmit(double variablePixelHeight, double variablePixelWidth, double textMultiplier, double pixelMultiplier){
    CashSummaryController cashSummaryController = Get.find();

    int availableCash =
        int.tryParse(cashSummaryController.availableCash) ?? 0;
    double parsedAmount =
        double.tryParse(amountController.text) ?? 0.0;
    if (parsedAmount > availableCash) {
      showAlertBottomSheet(
          context, variablePixelHeight, variablePixelWidth, textMultiplier, pixelMultiplier);
    } else {
      //getGSTInformationFromUserDataController

      UserDataController controller = Get.find();
      String gstNumber = controller.userProfile[0].gstNumber;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AmountDetailsScreen(
                number: widget.number,
                amount: amountController.text,
                gstNumber: gstNumber,
                isVerified: widget.isVerified,
              )));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    return WillPopScope(
      onWillPop: () async{
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return CommonConfirmationAlert(
              confirmationText1: translation(context).goingBackWillRestartProcess,
              confirmationText2: translation(context).areYouSureYouWantToLeave,
              onPressedYes: () {
                Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.ismartHomepage));
              },
            );
          },
        );
        return false;
      },
      child: GestureDetector(
onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Stack(
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
                  const VerticalSpace(height: 16),
                  RegisteredNumberWidget(
                    number: widget.number,
                    verified: widget.isVerified,
                  ),
                  const VerticalSpace(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: EnterAmountTextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            labelText: translation(context).transferAmount,
                            hintText: translation(context).enterTransferAmount,
                            onChanged: (value) {
                              validateAmount(amountController.text);
                            },
                            errorText: amountValidationMessage.isNotEmpty
                                ? amountValidationMessage
                                : null,
                            validationInfo: amountValidationMessage,
                            readOnly: !widget.isVerified),
                      ),
                      HorizontalSpace(width: 16 * variablePixelWidth),
                      GestureDetector(
                        onTap:  ()=> _onSubmit(variablePixelHeight, variablePixelWidth, textMultiplier, pixelMultiplier),
                        child: Padding(
                          padding: EdgeInsets.only(top: 6 * variablePixelHeight,right: 24 * variablePixelWidth),
                          child: Container(
                            height: 52 * variablePixelHeight, 
                            width: 52 * variablePixelWidth,
                            decoration: ShapeDecoration(
                              color: _enableContinue? AppColors.lumiBluePrimary: AppColors.arrowButtonGrey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4 * pixelMultiplier),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.15 * variablePixelHeight, horizontal: 14.67 * variablePixelWidth),
                              child: SvgPicture.asset(
                                'assets/mpartner/arrow_forward.svg',
                                color:_enableContinue? AppColors.white: AppColors.greyZeta,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                      onPressed: ()=> _onSubmit(variablePixelHeight, variablePixelWidth, textMultiplier, pixelMultiplier),
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
