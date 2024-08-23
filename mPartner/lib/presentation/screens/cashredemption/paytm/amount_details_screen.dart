import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/paytm_amt_calculation_api_response.dart';
import '../../../../network/api_constants.dart';
import '../../../../state/contoller/language_controller.dart';
import '../../../../state/contoller/verify_otp_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../data/models/paytm_transaction_response_model.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/requests.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/common_confirmation_alert.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../widgets/continue_button.dart';
import '../../userprofile/user_profile_widget.dart';
import '../../../widgets/verifySaleOTP/common_verify_otp.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../../../state/contoller/cash_summary_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../widgets/headers/header_widget_with_cash_info.dart';
import '../widgets/registered_num_widget.dart';
import '../widgets/transaction_status_screen.dart';
import '../widgets/transfer_amount_card.dart';
import '../widgets/transfer_amount_textfield.dart';
import 'api_error_redirection.dart';

class AmountDetailsScreen extends StatefulWidget {
  const AmountDetailsScreen(
      {required this.number,
      required this.amount,
      required this.gstNumber,
      required this.isVerified,
      super.key});

  final String number;
  final String amount;
  final String gstNumber;
  final bool isVerified;

  @override
  State<AmountDetailsScreen> createState() {
    return _AmountDetailsScreen();
  }
}

class _AmountDetailsScreen extends State<AmountDetailsScreen> {
  TextEditingController amountController = TextEditingController();
  CashSummaryController cashSummaryController = Get.find();
  VerifyOtpController verifyOtpController= Get.find();

  bool _isloading = false;
  String paytmInitId = '';
  String enteredOTP = '';
  bool isOtpCorrect = true;
  ApiResponseWithoutGST apiResponseWithoutGST = ApiResponseWithoutGST.empty();
  ApiResponseWithGST apiResponseWithGST = ApiResponseWithGST.empty();

  String formatDate(DateTime dateTime) {
    String month = DateFormat('MMM').format(dateTime);
    String day = DateFormat('dd').format(dateTime);
    String year = DateFormat('yyyy').format(dateTime);
    String hour = DateFormat('hh').format(dateTime);
    String minute = DateFormat('mm').format(dateTime);
    String period = DateFormat('a').format(dateTime);

    return '$day $month $year, $hour:$minute $period';
  }

  Future<ApiResponseWithGST> _displayWithGST() async {
    UserDataController userController = Get.find();
    final String sapId = userController.sapId;
    final String token = userController.token;

    LanguageController languageController = Get.find();

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "device_Name": deviceName,
      "os_Version_Name":osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "language": languageController.language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "mobileNumber": widget.number,
      "transactionMode": "",
      "transferAmount": widget.amount,
    };
    try {
      final response = await Requests.sendPostRequest(
        ApiConstants.postVerifyPaytmMobileNoGst,
        body
      );

      if (response is! DioException && response.statusCode == 200) {
        final apiResponse = ApiResponseWithGST.fromJson(response.data);

        if (response is! DioException && apiResponse.Status == '200') {
          return apiResponse;
        } else {
          FailureRedirection(context, widget.amount, formatDate(DateTime.now()), apiResponse.Paytm_init_id, 'Paytm');
        }
      }
    } catch (e) {
      print('Error: $e');
      FailureRedirection(context, widget.amount, formatDate(DateTime.now()), '', 'Paytm');
    }

    return ApiResponseWithGST.empty();
  }

  Future<ApiResponseWithoutGST> _displayWithoutGST() async {
    UserDataController userController = Get.find();
    final String sapId = userController.sapId;
    final String token = userController.token;

    LanguageController languageController = Get.find();

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel":AppConstants.channel,
      "device_Name": deviceName,
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "language": languageController.language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "mobileNumber": widget.number,
      "transactionMode": "",
      "transferAmount": widget.amount
    };
    try {
      final response = await Requests.sendPostRequest(
        ApiConstants.postVerifyPaytmMobileNo,
        body
      );

      if (response is! DioException && response.statusCode == 200) {
        final apiResponse = ApiResponseWithoutGST.fromJson(response.data);

        if (response is! DioException && apiResponse.Status == '200') {
          return apiResponse;
        } else {
          FailureRedirection(context, widget.amount, formatDate(DateTime.now()), apiResponse.Paytm_init_id, 'Paytm');
        }
      }
    } catch (e) {
      print('Error: $e');
      FailureRedirection(context, widget.amount, formatDate(DateTime.now()), '', "Paytm");
    }

    return ApiResponseWithoutGST.empty();
  }

  Future<bool> _createOtpPaytm() async {
    UserDataController userController = Get.find();
    final String sapId = userController.sapId;
    final String token = userController.token;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "appVersion_Code": AppConstants.appVersionCode,
      "otp": "",
      "os_Version_Code": osVersionCode,
      "loginUserId": sapId,
      "device_Name": deviceName,
      "phone_Number": userController.phoneNumber,
      "type": "",
      "mode": "",
      "transactionId": paytmInitId,
      "electrician_Mapping_Flag": ""
    };
    try {
      final response = await Requests.sendPostRequest(
        ApiConstants.postCreateOtpPaytm,
        body
      );

      if (response is! DioException && response.statusCode == 200) {
        print(response.data['status']);
        if (response.data['status'] == 'SUCCESS') {
        //  verifyOtpController.updateTimerLimit(response.data['data1']);
          return true;
        } else {
          FailureRedirection(context, widget.amount, formatDate(DateTime.now()), paytmInitId, 'Paytm');
        }
      }
    } catch (e) {
      print('Error: $e');
      FailureRedirection(context, widget.amount, formatDate(DateTime.now()), paytmInitId, 'Paytm');
    }
    return false;
  }

  Future<void> _authenticateOtpPaytm(String otp) async {
    UserDataController userController = Get.find();
    final String sapId = userController.sapId;
    final String token = userController.token;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "appVersion_Code": AppConstants.appVersionCode,
      "otp": otp,
      "os_Version_Code": osVersionCode,
      "loginUserId": sapId,
      "device_Name": deviceName,
      "phone_Number": widget.number,
      "type": "",
      "mode": "",
      "transactionId": paytmInitId,
      "electrician_Mapping_Flag": ""
    };
    try {
      final response = await Requests.sendPostRequest(
        ApiConstants.postAuthenticateOtpPaytm,
        body
      );

      if (response is! DioException && response.statusCode == 200) {
        print(response.data['status']);
        if (response.data['status'] == 'SUCCESS') {
          verifyOtpController.updateOtpValid(true);
          verifyOtpController.clearVerifyOtpData();
          if (widget.gstNumber == '') {
            _transaction(ApiConstants.postVerifyPaytmMobileOtp);
          } else {
            _transaction(ApiConstants.postVerifyPaytmMobileOtpGst);
          }
        } else {
          verifyOtpController.updateOtpValid(false);
          setState(() {
            isOtpCorrect=false;
          });
        }
      }
    } catch (e) {
      print('Error: $e');
      FailureRedirection(context, widget.amount, formatDate(DateTime.now()), paytmInitId, 'Paytm');
    }
  }

  void _transaction(String endpoint) async {
    setState(() {
      _isloading = true;
    });
    UserDataController userController = Get.find();
    final String sapId = userController.sapId;
    final String token = userController.token;

    LanguageController languageController = Get.find();

    int availableCash = int.tryParse(cashSummaryController.availableCash) ?? 0;

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
      "mobileNumber": widget.number,
      "transactionMode": "",
      "availableAmount": "$availableCash",
      "payTmInitid": paytmInitId,
      "transferAmount": widget.amount,
      "otp": enteredOTP,
    };

    try {
      final response = await Requests.sendPostRequest(
        endpoint,
        body
      );

      print(response.statusCode);

      if (response is! DioException && response.statusCode == 200) {
        cashSummaryController.fetchCashSummary();
        PaytmResponseModel apiResponse =
            PaytmResponseModel.fromJson(response.data);
        print('Message: ${apiResponse.message}');
        print('Status: ${apiResponse.status}');
        print('Token: ${apiResponse.token}');
        print('Order ID: ${apiResponse.data.orderId}');
        print('Paytm Order ID: ${apiResponse.data.paytmOrderId}');
        setState(() {
          _isloading = false;
        });
        showPaytmSuccessScreen(apiResponse);
      } else {
        FailureRedirection(context, widget.amount, formatDate(DateTime.now()), paytmInitId, 'Paytm');
      }
    } catch (e) {
      print('Error: $e');
      FailureRedirection(context, widget.amount, formatDate(DateTime.now()), paytmInitId, 'Paytm');
    }
  }

  void showPaytmSuccessScreen(PaytmResponseModel apiResponse) {
    String state = 'Pending';
    if (apiResponse.data.redeemStatus == 'SUCCESS') {
      state = 'Successful';
    } else if (apiResponse.data.redeemStatus == 'FAILURE') {
      state = 'Failure';
    } else if (apiResponse.data.redeemStatus == 'PENDING') {
      state = 'Pending';
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TransactionStatusDetail(
          status: state,
          transactionMode: 'Paytm',
          amount: apiResponse.data.amount,
          redeemStatus: (apiResponse.data.redeemStatus == 'SUCCESS')
              ? 'Cash Redeemed'
              : '',
          message: apiResponse.message,
          transactionDate: apiResponse.data.createdOn,
          transactionId: apiResponse.data.orderId,
          onClickClose: () {
            Navigator.of(context).pushNamed(AppRoutes.redeemCashHome);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    UserDataController userController = Get.find();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (userController.userProfile[0].gstNumber == '') {
        final data = await _displayWithoutGST();
        setState(() {
          apiResponseWithoutGST = data;
          paytmInitId = apiResponseWithoutGST.Paytm_init_id;
        });
      } else {
        final data = await _displayWithGST();
        setState(() {
          apiResponseWithGST = data;
          paytmInitId = apiResponseWithGST.Paytm_init_id;
        });
      }
    });
    verifyOtpController.clearVerifyOtpData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserDataController userController = Get.find();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    return WillPopScope(
      onWillPop: () async{
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context1) {
            return CommonConfirmationAlert(
              confirmationText1: translation(context).goingBackWillRestartProcess,
              confirmationText2: translation(context).areYouSureYouWantToLeave,
              onPressedYes: () {
                Navigator.of(context).popUntil(
                              ModalRoute.withName(AppRoutes.ismartHomepage));
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
                    children: [
                      EnterAmountTextField(
                        controller: TextEditingController(text: widget.amount),
                        keyboardType: TextInputType.number,
                        labelText: translation(context).transferAmount,
                        hintText: translation(context).enterTransferAmount,
                        validationInfo: '',
                        readOnly: false,
                      ),
                      HorizontalSpace(width: 16 * variablePixelWidth),
                      Padding(
                        padding: EdgeInsets.only(top: 6 * variablePixelHeight,right: 24 * variablePixelWidth),
                        child: Container(
                          height: 52 * variablePixelHeight, 
                          width: 52 * variablePixelWidth,
                          decoration: ShapeDecoration(
                            color: AppColors.arrowButtonGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4 * pixelMultiplier),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.15 * variablePixelHeight, horizontal: 14.67 * variablePixelWidth),
                            child: SvgPicture.asset(
                              'assets/mpartner/arrow_forward.svg',
                              color: AppColors.greyZeta,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  (paytmInitId == '')
                      ? const CircularProgressIndicator()
                      : (widget.gstNumber == '')
                          ? TransferAmountCardWithoutGST(
                              transferAmount: double.tryParse(widget.amount) ?? 0,
                              tdsDeduction: double.tryParse(
                                      apiResponseWithoutGST.tdsDeduction) ??
                                  0,
                              tdsDeductionPercentage: double.tryParse(
                                      apiResponseWithoutGST
                                          .tdsDeductionPercentage) ??
                                  0,
                              netTransferAmount: double.tryParse(
                                      apiResponseWithoutGST.netAmount) ??
                                  0,
                            )
                          : TransferAmountCardGST(
                              transferAmount: double.tryParse(widget.amount) ?? 0,
                              gstDeductionAmount: double.tryParse(
                                      apiResponseWithGST.gstDeductionAmount) ??
                                  0,
                              gstDeductionPercentage: double.tryParse(
                                      apiResponseWithGST.gstDeductionPercentage) ??
                                  0,
                              grossAmountAfterGstDeduction: double.tryParse(
                                      apiResponseWithGST
                                          .grossAmountAfterGstDeduction) ??
                                  0,
                              tdsDeduction: double.tryParse(
                                      apiResponseWithGST.tdsDeduction) ??
                                  0,
                              tdsDeductionPercentage: double.tryParse(
                                      apiResponseWithGST.tdsDeductionPercentage) ??
                                  0,
                              netTransferAmount:
                                  double.tryParse(apiResponseWithGST.netAmount) ??
                                      0,
                            ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: (_isloading == true)
                    ? const CircularProgressIndicator()
                    : Container(
                        padding: EdgeInsets.fromLTRB(
                            1 * variablePixelWidth, 0, 1 * variablePixelWidth, 0),
                        alignment: Alignment.center,
                        child: ContinueButton(
                            onPressed: () {
                              _createOtpPaytm().then((bool otpSent) {
                                if (otpSent) {
                                  VerifyOtpPresentation(
                                    mobileNumber: userController.phoneNumber,
                                    mandatoryButton: VerifyOTPButton(
                                        buttonText: translation(context).verify,
                                        onClick: () async {
                                          await _authenticateOtpPaytm(enteredOTP);
                                        }),
                                    optionalButton: null,
                                    header: translation(context).verifyOTP,
                                    instructions: translation(context).enterTheOTPSentTo, 
                                    updateOtp: (otp) {
                                      enteredOTP = otp;
                                    },
                                    timerLimit: "",
                                    showLoader: null,
                                    resendOtpMethod: () async {
                                      await _createOtpPaytm();
                                      print("Called resend otp");
                                    },
                                    isOtpValid: isOtpCorrect,
                                  );
                                }
                              });
                            },
                            isEnabled: true,
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
