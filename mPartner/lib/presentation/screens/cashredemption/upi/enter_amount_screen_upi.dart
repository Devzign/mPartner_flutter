import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../data/models/upi_beneficiary_model.dart';
import '../../../../data/models/upi_tds_gst_model.dart';
import '../../../../data/models/upi_transaction_model.dart';
import '../../../../services/services_locator.dart';
import '../../../../state/contoller/cash_summary_controller.dart';
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
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../widgets/something_went_wrong_widget.dart';
import '../../../widgets/verifySaleOTP/common_verify_otp.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../base_screen.dart';
import '../../ismart/ismart_homepage/ismart_homepage.dart';
import '../../userprofile/user_profile_widget.dart';
import '../paytm/api_error_redirection.dart';
import '../../../widgets/headers/header_widget_with_cash_info.dart';
import '../widgets/transaction_status_screen.dart';
import '../widgets/transfer_amount_card.dart';
import '../widgets/transfer_amount_textfield.dart';
import '../widgets/transferring_to.dart';
import '../widgets/verification_failed_alert.dart';

class EnterAmountUPIScreen extends StatefulWidget {
  const EnterAmountUPIScreen({required this.beneficiaryDetails, super.key});

  final UPIBeneficiaryModel beneficiaryDetails;

  @override
  State<EnterAmountUPIScreen> createState() {
    return _EnterAmountUPIScreen();
  }
}

class _EnterAmountUPIScreen extends BaseScreenState<EnterAmountUPIScreen> {
  TextEditingController amountController = TextEditingController();
  CashSummaryController cashSummaryController = Get.find();
  bool _showContinue = false;
  String amountValidationMessage = '';
  bool _enableArrow = false;
  String enteredAmount = '0';
  bool isloading = false;
  String enteredOTP = '';
  bool otpsent = false;
  bool isOtpCorrect = true;
  bool showLoader = false;
  bool isLoading = true;
  VerifyOtpController verifyOtpController = Get.find();
  UPITdsGstModel UPITdsGstCalculations = UPITdsGstModel.empty();
  bool somethingWentWrong = false;
  final FocusNode amountFocusNode = FocusNode();
  int retryCount=0;

  String formatResponseDate(String date) {
    return DateFormat(AppConstants.cashCoinDateFormatWithTime).format(
        DateFormat('d MMMM y, H:mm')
            .parse(date.replaceAll(RegExp(r' PM| AM'), '')));
  }

  void validateAmount(String amount) {
    //RegExp amountRegex = RegExp(r'^[1-9][0-9]*$');
    // CashSummaryController cashSummaryController = Get.find();
    int availableCash = int.tryParse(cashSummaryController.availableCash)??0;
    int parsedAmount = int.tryParse(amountController.text) ?? 0;
    if (amount.isEmpty) {
      setState(() {
        amountValidationMessage = '';
        _enableArrow = false;
        _showContinue = false;
      });
    } 
    else if (parsedAmount>availableCash && parsedAmount<50000){
      setState(() {
        amountValidationMessage = translation(context).yourTransferAmountShouldBeLessThanAvailableCash;
        _enableArrow=false;
        _showContinue=false;
      });
    }
    else if (parsedAmount>50000){
      setState(() {
        amountValidationMessage = translation(context).maxAmountLimitMessage;
        _enableArrow=false;
        _showContinue=false;
      });
    }
    else {
      setState(() {
        amountValidationMessage = '';
        _enableArrow = true;
        _showContinue = false;
      });
    }
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

  Future<void> _onSubmit(double variablePixelHeight, double variablePixelWidth,
      double textMultiplier, double pixelMultiplier) async {
    FocusScope.of(context).requestFocus(FocusNode());
    enteredAmount = amountController.text;
      BaseMPartnerRemoteDataSource mPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
    logger.d('[UPI_RA] starting for TDS calc....');
      final response = await mPartnerRemoteDataSource
          .getUpiTdsGstCalculations(enteredAmount);
    logger.d('[UPI_RA] TDS calc complete....');
      setState(() {
        isloading = false;
        _showContinue = false;
        _enableArrow = false;
      });
      response.fold((l) {
        logger.e(l);
        setState(() {
          somethingWentWrong=true;
        });
      }, (r) {
        if (r.status == '200') {
          setState(() {
            _enableArrow = true;
            _showContinue = true;
          });
          logger.d(r.status);
          UPITdsGstCalculations = r;
        } else {
          showVerificationFailedAlert(r.message, context, variablePixelHeight, variablePixelWidth, textMultiplier, pixelMultiplier);
        }
      });
  }

  Future<void> _createOtpUPI() async {
    BaseMPartnerRemoteDataSource mPartnerRemoteDataSource =
        sl<BaseMPartnerRemoteDataSource>();
    final response = await mPartnerRemoteDataSource.createOtpUPI();
    response.fold((l) {
      logger.e(l);
      setState(() {
        otpsent = false;
        showLoader = false;
      });
      FailureRedirection(
          context, enteredAmount, formatDate(DateTime.now()), '', 'UPI');
    }, (r) {
      if (r.status == '200') {
    //    verifyOtpController.updateTimerLimit(r.resendTime);
        setState(() {
          otpsent = true;
          isloading=false;
          showLoader = false;
        });
      } else {
        setState(() {
          otpsent = false;
          showLoader = false;
        });
        showVerificationFailedAlert(
          otpheading: true,
            r.message,
            context,
            DisplayMethods(context: context).getVariablePixelHeight(),
            DisplayMethods(context: context).getVariablePixelWidth(),
            DisplayMethods(context: context).getTextFontMultiplier(),
            DisplayMethods(context: context).getPixelMultiplier());    
      }
    });
  }

  Future<void> _authenticateOtpUPI(String otp) async {

    setState(() {
        verifyOtpController.updateShowButtonLoader(true);
      });
      BaseMPartnerRemoteDataSource mPartnerRemoteDataSource =
        sl<BaseMPartnerRemoteDataSource>();
    final response = await mPartnerRemoteDataSource.authenticateOtpUpi(otp);

    logger.d('response of authenticate otp is $response');
    response.fold((l) {
      retryCount++;
      print(retryCount);
      logger.e(l);
      if(retryCount<=2){
        Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
        setState(() {
          verifyOtpController.updateShowButtonLoader(false);
        });
      }
      else {
        FailureRedirection(
          context, enteredAmount, formatDate(DateTime.now()), '', 'UPI');
      }
    }, (r) async{
      logger.e(r);
      logger.d(r.status);
      if (r.status == '200') {
        logger.d('[UPI_RA] Entered OTP: $otp');
        verifyOtpController.updateOtpValid(true);
        setState(() {
          isOtpCorrect = true;
        });
        logger.d('[UPI_RA] _transaction');
        await _transaction(enteredAmount, widget.beneficiaryDetails.ifsc,
            widget.beneficiaryDetails.vpa);
      } else {
        verifyOtpController.updateOtpValid(false);
        
        setState(() {
          isOtpCorrect = false;
          verifyOtpController.updateShowButtonLoader(false);
        });
      }
    });    
  }

  Future<void> _transaction(String amount, String ifsc, String vpaAvailable) async {
    BaseMPartnerRemoteDataSource mPartnerRemoteDataSource = sl<BaseMPartnerRemoteDataSource>();
    logger.d('----- starting TXN -------');
    final response = await mPartnerRemoteDataSource.upiTransaction(
        enteredAmount, ifsc, vpaAvailable, widget.beneficiaryDetails);
    logger.d('----- UPI TXN : RES $response -------');
    response.fold((l) {
      logger.e(l);
      FailureRedirection(
          context, enteredAmount, formatDate(DateTime.now()), '', 'UPI');
    }, (r) {
      logger.d('----- Updating TXN AMT-------');
      updateCashAmt();
      showUPISuccessScreen(r);
    });
  }

  void showUPISuccessScreen(UPITransactionModel upiTransactionResponse) {
    String state = 'Pending';
    if (upiTransactionResponse.data.transactionStatus == 'S') {
      //tentatively S, P and F
      state = 'Successful';
    } else if (upiTransactionResponse.data.transactionStatus == 'F') {
      state = 'Failure';
    } else if (upiTransactionResponse.data.transactionStatus == 'P') {
      state = 'Pending';
    }
    logger.d('----- Navigating ------- $state');

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => TransactionStatusDetail(
            status: state,
            amount: upiTransactionResponse.data.amount,
            redeemStatus:
                (upiTransactionResponse.data.transactionStatus == 'S')
                    ? 'Cash Redeemed'
                    : '',
            message: upiTransactionResponse.data.txnMessage,
            transactionDate:
                formatResponseDate(upiTransactionResponse.data.txnDate),
            transactionId: upiTransactionResponse.data.txnId,
            transactionMode: 'UPI',
            onClickClose: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const IsmartHomepage()),
                ModalRoute.withName(AppRoutes.ismartHomepage),
              );
            },
          ),
        ),
    );
  }

  @override
  void initState() {
    verifyOtpController.clearVerifyOtpData();
    super.initState();
  }

  @override
  Widget baseBody(BuildContext context) {
    UserDataController userDataController = Get.find();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
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
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                  HeaderWidgetWithCashInfo(
                    heading: translation(context).upi, icon: Icon(
                    Icons.arrow_back_outlined,
                    color: AppColors.iconColor,
                    size: 24 * pixelMultiplier,
                  ),
                  ),
                  (somethingWentWrong)
                  ? const SomethingWentWrongWidget()
                  : Column(
                    children: [
                      UserProfileWidget(top: 8*variablePixelHeight),
                      TransferringTo_2(
                          beneficiaryDetails: widget.beneficiaryDetails),
                      const VerticalSpace(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: (!_showContinue)?0:24 * variablePixelWidth),
                              child: EnterAmountTextField(
                                controller: amountController,
                                textfieldFocusNode: amountFocusNode,
                                keyboardType: TextInputType.number,
                                labelText:
                                    translation(context).transferAmount,
                                hintText:
                                    translation(context).enterTransferAmount,
                                validationInfo: amountValidationMessage,
                                onChanged: (value) {
                                  validateAmount(amountController.text);
                                },
                                errorText: amountValidationMessage.isNotEmpty
                                    ? amountValidationMessage
                                    : null,
                                readOnly: false,
                              ),
                            ),
                          ),
                          if(!_showContinue) HorizontalSpace(width: 16 * variablePixelWidth),
                          if(!_showContinue)
                          GestureDetector(
                            onTap: () async {
                              if (_enableArrow) {
                                setState(() {
                                  isloading = true;
                                });
                                await _onSubmit(
                                    variablePixelHeight,
                                    variablePixelWidth,
                                    textMultiplier,
                                    pixelMultiplier);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 19 * variablePixelHeight,
                                  right: 24 * variablePixelWidth),
                              child: Visibility(
                                visible: !isloading,
                                replacement: const CircularProgressIndicator(),
                                child: Container(
                                  height: 50 * variablePixelHeight,
                                  width: 50 * variablePixelWidth,
                                  decoration: ShapeDecoration(
                                    color: _enableArrow
                                        ? AppColors.lumiBluePrimary
                                        : AppColors.arrowButtonGrey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          4 * pixelMultiplier),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15.15 * variablePixelHeight,
                                        horizontal:
                                            14.67 * variablePixelWidth),
                                    child: SvgPicture.asset(
                                      'assets/mpartner/arrow_forward.svg',
                                      color: _enableArrow
                                          ? AppColors.white
                                          : AppColors.greyZeta,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    (_showContinue)
                      ? (isloading)
                        ? const Center(child: CircularProgressIndicator())
                        : (UPITdsGstCalculations.gstStatus == '1')
                        ? TransferAmountCardWithoutGST(
                            transferAmount:double.tryParse(enteredAmount) ?? 0,
                            tdsDeduction: double.tryParse(UPITdsGstCalculations.tdsValue) ?? 0,
                            tdsDeductionPercentage: double.tryParse(UPITdsGstCalculations.tdsDeductionPercentage) ?? 0,
                            netTransferAmount: double.tryParse(UPITdsGstCalculations.netAmount) ?? 0,
                          )
                        : TransferAmountCardGST(
                            transferAmount: double.tryParse(enteredAmount) ?? 0,
                            gstDeductionAmount: double.tryParse(UPITdsGstCalculations.gstDeductionAmount) ?? 0,
                            gstDeductionPercentage: double.tryParse(UPITdsGstCalculations.gstDeductionPercentage) ?? 0,
                            grossAmountAfterGstDeduction: double.tryParse(UPITdsGstCalculations.grossAmountAfterGstDeduction) ??0,
                            tdsDeduction: double.tryParse(UPITdsGstCalculations.tdsValue) ?? 0,
                            tdsDeductionPercentage: double.tryParse(UPITdsGstCalculations.tdsDeductionPercentage) ?? 0,
                            netTransferAmount: double.tryParse(UPITdsGstCalculations.netAmount) ?? 0,
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
            if (!somethingWentWrong)
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        1 * variablePixelWidth, 0, 1 * variablePixelWidth, 0),
                    alignment: Alignment.center,
                    child: Visibility(
                      visible: _showContinue,
                      child: CommonButton(
                      onPressed: () async {
                        setState(() {
                          showLoader=true;
                        });
                        
                        await _createOtpUPI();
                        if (otpsent) {
                          showModalBottomSheet<void>(
                            context: context,
                              isScrollControlled: true,
                              isDismissible: false,
                              enableDrag: false,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top:
                                      Radius.circular(25.0 * pixelMultiplier),
                                ),
                              ),
                              builder: (BuildContext context1) {
                                return Padding(
                                padding: EdgeInsets.only(
                                    bottom: 10 * variablePixelHeight),
                                child: VerifyOtpPresentation(
                                  mobileNumber:
                                      userDataController.phoneNumber,
                                  mandatoryButton: VerifyOTPButton(
                                      buttonText:
                                          translation(context1).verify,
                                      onClick: () async {
                                        await _authenticateOtpUPI(enteredOTP);
                                      }),
                                  optionalButton: null,
                                  header: translation(context1).verifyOTP,
                                  instructions: translation(context1)
                                      .enterTheOTPSentTo,
                                  updateOtp: (otp) {
                                    logger.d('entered otp is $otp');
                                    enteredOTP = otp;
                                  },
                                  timerLimit: "",
                                  showLoader: null,
                                  showMaximumAttempsMessage: null,
                                  maxAttempMessage: null,
                                  resendOtpMethod: () async {
                                    setState(() {
                                      verifyOtpController.updateIsResendOtpResponsePending(true);
                                      verifyOtpController.updateOtpValid(true);
                                    });
                                    
                                    await _createOtpUPI().then((_) => setState(() {
                                      verifyOtpController.updateIsResendOtpResponsePending(false);
                                    }));
                                    
                                    logger.d("Called resend otp");
                                  },
                                  isOtpValid: isOtpCorrect,
                                ));
                              }).whenComplete(() {
                            setState(() {
                              isOtpCorrect = true;
                              verifyOtpController
                                  .updateShowButtonLoader(false);
                              verifyOtpController.clearVerifyOtpData();
                            });
                          });
                        }
                      },
                                  isEnabled: !showLoader,
                                  showLoader: showLoader,
                                  containerBackgroundColor: AppColors.white,
                                  buttonText: translation(context).continueButtonText),
                    ),
              ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateCashAmt() async {
    await cashSummaryController.fetchCashSummary();
    logger.d('----- updateCashAmt DONE-------');
  }
}
