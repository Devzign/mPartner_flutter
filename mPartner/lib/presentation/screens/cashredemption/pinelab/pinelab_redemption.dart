import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/pinelab_get_balance_point_model.dart';
import '../../../../data/models/pinelab_send_otp_model.dart';
import '../../../../data/models/pinelab_verify_mobile_no_gst_model.dart';
import '../../../../data/models/pinelab_verify_mobile_otp_gst.dart';
import '../../../../data/models/pinelab_verify_otp_model.dart';
import '../../../../state/contoller/cash_summary_controller.dart';
import '../../../../state/contoller/pinelab_redemption_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../state/contoller/verify_otp_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_confirmation_alert.dart';
import '../../../widgets/common_divider.dart';
import '../../../widgets/verifySaleOTP/common_verify_otp.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../base_screen.dart';
import '../../ismart/ismart_homepage/ismart_homepage.dart';
import '../../userprofile/user_profile_widget.dart';
import '../../../widgets/headers/header_widget_with_cash_info.dart';
import '../widgets/registered_num_widget.dart';
import '../widgets/transaction_status_screen.dart';
import '../widgets/transfer_amount_textfield.dart';
import '../widgets/verification_failed_alert.dart';

class PinelabRedemption extends StatefulWidget {
  const PinelabRedemption({super.key});

  @override
  State<PinelabRedemption> createState() => _PinelabRedemptionState();
}

class _PinelabRedemptionState extends BaseScreenState<PinelabRedemption> {
  CashSummaryController cashSummaryController= Get.find();
  UserDataController controller = Get.find();
  PinelabRedemptionController pinelabRedemptionController = Get.find();
  VerifyOtpController verifyOtpController = Get.find();
  TextEditingController transferAmountController = TextEditingController();
  bool isButtonEnabledContinue = false;
  String errorText = '';
  int availableCash = 0;
  bool isLoading = true;
  bool verified = true;
  String otpEntered = '';
  bool showLoader = false;
  bool isVerify = false;
  double h=0, w=0, f=0, p=0;
  int retryCount=0;

  @override
  void initState() {
    pinelabRedemptionController.clearPinelabredemptionController();
    initialNumPinelabVerification();
    super.initState();
  }

  String formatDate(DateTime dateTime) {
    String month = DateFormat('MMM').format(dateTime);
    String day = DateFormat('dd').format(dateTime);
    String year = DateFormat('yyyy').format(dateTime);
    String hour = DateFormat('hh').format(dateTime);
    String minute = DateFormat('mm').format(dateTime);
    String period = DateFormat('a').format(dateTime);

    return '$day $month $year, $hour:$minute $period';
  }

  String formatPinelabDate(String date) {
    return DateFormat(AppConstants.cashCoinDateFormatWithTime).format(
        DateFormat('d MMMM y, H:mm')
            .parse(date.replaceAll(RegExp(r' PM| AM'), '')));
  }

  void validateAmount(String amount) {
    int parsedAmount = int.tryParse(amount)??0;
    if (amount.isEmpty) {
      setState(() {
        errorText = '';
        isButtonEnabledContinue = false;
      });
    } else if ( parsedAmount > availableCash) {
      setState(() {
        errorText = translation(context).yourTransferAmountShouldBeLessThanAvailableCash;
        isButtonEnabledContinue = false;
      });
    } else {
      setState(() {
        errorText = '';
        isButtonEnabledContinue = true;
      });
    }
  }

  Future<void> initialNumPinelabVerification() async {
    setState(() {
      isLoading = true;
    });
    await pinelabRedemptionController.fetchPinelabGetBalancePoint().then((_) {
      if (pinelabRedemptionController.pinelabGetBalancePointOutput.isNotEmpty) {
        PinelabBalancePoint result = pinelabRedemptionController.pinelabGetBalancePointOutput.first;
        if(result.status == "200"){
          setState(() {
            verified = true;
          });
        } else {
          setState(() {
            verified = false;
          });
          showVerificationFailedAlert(result.message, context, h, w, f, p);
        }
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void showTimeOutBottomSheet(String msg, double variablePixelWidth, double variablePixelHeight, double textFontMultiplier, double pixelMultiplier){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0 * pixelMultiplier),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:  EdgeInsets.only(top: 16 * variablePixelHeight, bottom: 16 * variablePixelHeight),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Container(
                        height: 5 * variablePixelHeight,
                        width: 50 * variablePixelWidth,
                        decoration: BoxDecoration(
                          color: AppColors.dividerGreyColor,
                          borderRadius: BorderRadius.circular(12 * pixelMultiplier),
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalSpace(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 24 * variablePixelWidth),
                  child: Text(
                    translation(context).alert,
                    style: GoogleFonts.poppins(
                      color: AppColors.titleColor,
                      fontSize: 20 * textFontMultiplier,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.50 * variablePixelWidth,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
                  child: const CustomDivider(color: AppColors.dividerColor),
                ),
                const VerticalSpace(height: 24),
                Padding(
                  padding: EdgeInsets.only(right: 24 * variablePixelWidth, left: 24 * variablePixelWidth),
                  child: Text(
                    msg,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGreyText,
                      fontSize: 14 * textFontMultiplier,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.10 * variablePixelWidth,
                    ),
                  ),
                ),
                const VerticalSpace(height: 24),
                CommonButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  isEnabled: true,
                  buttonText: translation(context).buttonOkay,
                  backGroundColor: AppColors.lumiBluePrimary,
                  textColor: AppColors.white,
                  defaultButton: true,
                  containerBackgroundColor: AppColors.white,
                ),
                const VerticalSpace(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget baseBody(BuildContext context) {
    availableCash = int.tryParse(cashSummaryController.availableCash)??0;
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    h = variablePixelHeight;
    w = variablePixelWidth;
    f = textFontMultiplier;
    p = pixelMultiplier;

    return WillPopScope(
        onWillPop: () async {
        showModalBottomSheet(
          enableDrag: false,
          isDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CommonConfirmationAlert(
                confirmationText1:
                translation(context).goingBackWillRestartProcess,
                confirmationText2:
                translation(context).areYouSureYouWantToLeave,
                onPressedYes: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                        const IsmartHomepage()),
                    ModalRoute.withName(AppRoutes.ismartHomepage),
                  );
                });
          });
      return false;
    },
    child: GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.lightWhite1,
        body: (isLoading)
            ? const Center(child: CircularProgressIndicator())
            : isVerify ?  const Center(child: CircularProgressIndicator())
              :SafeArea(
                child: Stack(
                  children:
                  [
                    Column(
                      children: [
                        HeaderWidgetWithCashInfo(heading: translation(context).pinelabs, icon: Icon(
                          Icons.arrow_back_outlined,
                          color: AppColors.iconColor,
                          size: 24 * pixelMultiplier,
                        ),),
                        UserProfileWidget(top: 8*variablePixelHeight),
                        RegisteredNumberWidget(number: controller.phoneNumber, verified: verified),
                        const VerticalSpace(height: 5),
                        Padding(
                          padding: EdgeInsets.only(right: 24 * variablePixelWidth),
                          child: EnterAmountTextField(
                            controller: transferAmountController,
                            keyboardType: TextInputType.number,
                            labelText: translation(context).transferAmount,
                            hintText: translation(context).enterTransferAmount,
                            onChanged: (value) {
                              validateAmount(transferAmountController.text);
                            },
                            errorText: errorText.isNotEmpty ? errorText : null, validationInfo: errorText,
                            readOnly: verified ? false : true,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        alignment: Alignment.center,
                        child: CommonButton(
                            onPressed: () {
                              int parsedAmount = int.tryParse(transferAmountController.text) ?? 0;
                              pinelabRedemptionController.clearPinelabredemptionController();
                              setState(() {
                                showLoader = true;
                              });
                              pinelabRedemptionController.fetchPinelabVerifyMobileNoGst(transferAmountController.text).then((_){
                                  if (pinelabRedemptionController.pinelabVerifyMobileNoGstOutput.isNotEmpty) {
                                    PinelabVerifyMobileNoGst result = pinelabRedemptionController.pinelabVerifyMobileNoGstOutput.first;
                                    if(result.status == "200"){
                                      pinelabRedemptionController.fetchPinelabSendOTP().then((_) {
                                        if (pinelabRedemptionController.pinelabSendOTPOutput.isNotEmpty) {
                                          PinelabSendOTP result = pinelabRedemptionController.pinelabSendOTPOutput.first;
                                          if (result.status == 'SUCCESS') {
                                            setState(() {
                                              showLoader = false;
                                            });
                                        //    verifyOtpController.updateTimerLimit(result.data1);
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(
                                                  top: Radius.circular(25.0 * pixelMultiplier),
                                                ),
                                              ),
                                              builder: (BuildContext context1) {
                                                return Padding(
                                                  padding:  EdgeInsets.only(bottom: 10 * variablePixelHeight),
                                                  child: VerifyOtpPresentation(
                                                    mobileNumber: controller.phoneNumber,
                                                    mandatoryButton: VerifyOTPButton(
                                                      buttonText: translation(context).verify,
                                                      onClick: () async {
                                                        await pinelabRedemptionController.fetchPinelabVerifyOTP(otpEntered).then((_){
                                                          if (pinelabRedemptionController.pinelabVerifyOTPOutput.isNotEmpty) {
                                                            PinelabVerifyOTP result = pinelabRedemptionController.pinelabVerifyOTPOutput.last;
                                                            if (result.status == 'SUCCESS') {
                                                              verifyOtpController.updateOtpValid(true);
                                                              Navigator.pop(context);
                                                              setState(() {
                                                                isVerify = true;
                                                              });
                                                              pinelabRedemptionController.fetchPinelabVerifyMobileOtpGst(parsedAmount, cashSummaryController.availableCash).then((_){
                                                                if (pinelabRedemptionController.pinelabVerifyMobileOtpGstOutput.isNotEmpty) {
                                                                  PinelabVerifyMobileOtpGst result = pinelabRedemptionController.pinelabVerifyMobileOtpGstOutput.last;
                                                                  TransactionDetail detailsInstance = result.data;
                                                                  Map<String, dynamic> details = {
                                                                    'status': detailsInstance.status,
                                                                    'code': detailsInstance.code,
                                                                    'balancePoints': detailsInstance.balancePoints,
                                                                    'txnStatus': detailsInstance.txnStatus,
                                                                    'txnMessage': detailsInstance.txnMessage,
                                                                    'txnAmount': detailsInstance.txnAmount,
                                                                    'txnDate': detailsInstance.txnDate,
                                                                    'txnID': detailsInstance.txnID,
                                                                  };
                                                                  if (details['txnStatus'] == "Successful") {
                                                                    cashSummaryController.fetchCashSummary();
                                                                       Navigator.of(context).push(MaterialPageRoute(
                                                                        builder: (context) =>  TransactionStatusDetail(
                                                                          status: details['txnStatus'],
                                                                          amount: details['txnAmount'],
                                                                          redeemStatus: 'Cash Redeemed',
                                                                          message: details['txnMessage'],
                                                                          transactionDate: formatPinelabDate(details['txnDate']),
                                                                          transactionId: details['txnID'],
                                                                          transactionMode: 'PineLab',
                                                                          onClickClose: () {  Navigator.pushAndRemoveUntil(
                                                                            context,
                                                                            MaterialPageRoute<void>(
                                                                                builder: (BuildContext context) =>
                                                                                const IsmartHomepage()),
                                                                            ModalRoute.withName(
                                                                                AppRoutes.ismartHomepage),
                                                                          );},
                                                                        )
                                                                      )
                                                                    );
                                                                  } else if(details['txnStatus'] == "Pending"){
                                                                      Navigator.of(context).push(MaterialPageRoute(
                                                                          builder: (context) =>  TransactionStatusDetail(
                                                                            status: details['txnStatus'],
                                                                            amount: details['txnAmount'],
                                                                            redeemStatus: '',
                                                                            message: details['txnMessage'] ?? translation(context).txnPinelabPendingMessage,
                                                                            transactionDate:formatPinelabDate(details['txnDate']),
                                                                            transactionId: details['txnID'],
                                                                            transactionMode: 'PineLab',
                                                                            onClickClose: () {  Navigator.pushAndRemoveUntil(
                                                                              context,
                                                                              MaterialPageRoute<void>(
                                                                                  builder: (BuildContext context) =>
                                                                                  const IsmartHomepage()),
                                                                              ModalRoute.withName(
                                                                                  AppRoutes.ismartHomepage),
                                                                            );  },
                                                                          )
                                                                      )
                                                                      );
                                                                  } else{
                                                                    Navigator.of(context).push(MaterialPageRoute(
                                                                        builder: (context) =>  TransactionStatusDetail(
                                                                          status: details['txnStatus'],
                                                                          amount: details['txnAmount'] == '' || details['txnAmount'] == null ? '0' :  details['txnAmount'],
                                                                          redeemStatus: '',
                                                                          message: details['txnMessage'] ?? translation(context).transactionFailureMessage,
                                                                          transactionDate: formatPinelabDate(details['txnDate']) ?? formatDate(DateTime.now()),
                                                                          transactionId:  details['txnID'] == '' || details['txnID'] == null ? '-' :  details['txnID'],
                                                                          transactionMode: 'PineLab',
                                                                          onClickClose: () { Navigator.pushAndRemoveUntil(
                                                                            context,
                                                                            MaterialPageRoute<void>(
                                                                                builder: (BuildContext context) =>
                                                                                const IsmartHomepage()),
                                                                            ModalRoute.withName(
                                                                                AppRoutes.ismartHomepage),
                                                                          );},
                                                                        )
                                                                    )
                                                                    );
                                                                  }
                                                                }
                                                              });
                                                            } else {
                                                              verifyOtpController.updateOtpValid(false);
                                                            }
                                                          }
                                                          else {
                                                            retryCount++;
                                                            if(retryCount<3){
                                                              Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
                                                            }
                                                            else{
                                                              Navigator.of(context).push(MaterialPageRoute(
                                                                        builder: (context) =>  TransactionStatusDetail(
                                                                          status: 'Failed',
                                                                          amount: transferAmountController.text,
                                                                          redeemStatus: '',
                                                                          message: translation(context).transactionFailureMessage,
                                                                          transactionDate: formatDate(DateTime.now()),
                                                                          transactionId:  '-',
                                                                          transactionMode: 'PineLab',
                                                                          onClickClose: () { Navigator.pushAndRemoveUntil(
                                                                            context,
                                                                            MaterialPageRoute<void>(
                                                                                builder: (BuildContext context) =>
                                                                                const IsmartHomepage()),
                                                                            ModalRoute.withName(
                                                                                AppRoutes.ismartHomepage),
                                                                          );},
                                                                        )
                                                                    ));
                                                            }
                                                            // Utils().showToast('Some error occurred', context);
                                                          }
                                                        });
                                                      },
                                                    ),
                                                    optionalButton: null,
                                                    header: translation(context).verifyOTP,
                                                    instructions: translation(context).enterOtpSentTo,
                                                    resendOtpMethod:() async {
                                                       pinelabRedemptionController.clearPinelabredemptionController();
                                                        await pinelabRedemptionController.fetchPinelabSendOTP();
                                                        PinelabSendOTP result = pinelabRedemptionController.pinelabSendOTPOutput.first;
                                                        if(result.status == 'SUCCESS'){
                                                        //  verifyOtpController.updateTimerLimit(result.data1);
                                                        }
                                                        else {
                                                          Navigator.pop(context);
                                                          showTimeOutBottomSheet(result.message, variablePixelWidth, variablePixelHeight, textFontMultiplier, pixelMultiplier);
                                                          pinelabRedemptionController.clearPinelabredemptionController();
                                                      }
                                                    },
                                                    timerLimit: "",
                                                    showLoader: null,
                                                    showMaximumAttempsMessage: null,
                                                    maxAttempMessage: null,
                                                    updateOtp: (otp) {
                                                      otpEntered = otp;
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            setState(() {
                                              showLoader = false;
                                            });
                                            showTimeOutBottomSheet(result.message, variablePixelWidth, variablePixelHeight, textFontMultiplier, pixelMultiplier);
                                            pinelabRedemptionController.clearPinelabredemptionController();
                                          }
                                        }
                                      });
                                    } else{
                                      setState(() {
                                        showLoader = false;
                                      });
                                      showTimeOutBottomSheet(result.message, variablePixelWidth, variablePixelHeight, textFontMultiplier, pixelMultiplier);
                                    }
                                  }
                                });
                            },
                            isEnabled: isButtonEnabledContinue & !showLoader,
                            showLoader: showLoader,
                            containerBackgroundColor: Colors.white,
                            buttonText: translation(context).continueButtonText
                        ),
                      ),
                    ),
                  ],
                          ),
              ),
        ),
    )
    );
  }
}
