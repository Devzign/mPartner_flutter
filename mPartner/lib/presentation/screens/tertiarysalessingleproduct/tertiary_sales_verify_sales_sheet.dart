import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../data/models/ewarranty_create_otp_model.dart';
import '../../../data/models/ewarranty_save_with_otp_model.dart';
import '../../../data/models/ewarranty_verify_otp_model.dart';
import '../../../data/models/serial_no_existance_model.dart';
import '../../../network/api_constants.dart';
import '../../../state/contoller/language_controller.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../state/contoller/verify_otp_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/requests.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/utils.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_qr1.dart';
import '../../widgets/verifySaleOTP/common_verify_otp.dart';
import '../base_screen.dart';
import '../network_management/dealer_electrician/components/custom_calender.dart';
import '../tertiary_sales/tertiary_sales_hkva_combo/components/q_r_screen_back_button.dart';
import 'components/confirmation_alert_without_otp.dart';
import 'components/tertiary_sales_single_product_registration.dart';

class TertiarySalesVerifySalesSheet extends StatefulWidget {
  final String name;
  final String address;
  final String mobileNumber;
  final String date;
  final String referralCode;
  final String? tertiarySaleType;
  // Function resumeCamera;

  TertiarySalesVerifySalesSheet({
    required this.name,
    required this.address,
    required this.mobileNumber,
    required this.date,
    required this.referralCode,
    required this.tertiarySaleType,
    // required this.resumeCamera,
  });

  @override
  State<TertiarySalesVerifySalesSheet> createState() =>
      _TertiarySalesVerifySalesSheetState();
}

class _TertiarySalesVerifySalesSheetState
    extends BaseScreenState<TertiarySalesVerifySalesSheet> {
  UserDataController controller = Get.find();
  VerifyOtpController _verifyOtpController = Get.find();
  LanguageController languageController = Get.find();
  String? token;
  String? user_id;
  String? userType;
  String? language;
  String serialNumber = "N/A";
  bool isInitialized = false;
  bool isCreateOTPSuccess = false;
  bool isLoading = true;
  bool isSerialNumberExist = false;
  String transID = "";
  String otpEntered = "";
  bool isOtpCorrect = true;
  bool verifiedWithOtp = false;
  String? responseSlNo = "";
  String? responseCoinsPoint = "";
  String? responseCashPoint = "";
  String? responseStatus = "";
  String? responseOtpRemark = "";
  String? responseProductType = "";
  String? responseModel = "";
  String? responseCode = "";
  String? responseRegisteredOn = "";
  String? formattedRegisteredOn = "";
  String state = "";
  String? data1Message = "";
  String? data3Message = "";
  String? data7Message = "";
  bool showWithoutOTPAlert = false;
  bool showSomethingWentWrong = false;
  bool isLoadingAfterVerify = false;
  final GlobalKey _bottomSheetKey = GlobalKey();
  double _bottomSheetHeight = 0.0;
  int retryCountVerifyOTP=0;
  int retryCountWithoutOTP=0;
  bool isWithoutOTPAPICallComplete = false;


  @override
  void initState() {
    super.initState();
    AppConstants.isSerialNumberValid = false;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      widget.tertiarySaleType;
      apiCallFunction();
    });
  }

  void _updateBottomSheetHeight() {
    final RenderBox renderBoxRed =
        _bottomSheetKey.currentContext?.findRenderObject() as RenderBox;
    if (renderBoxRed != null) {
      setState(() {
        _bottomSheetHeight =
            MediaQuery.of(context).size.height - renderBoxRed.size.height;
      });
    }
  }

  Future<void> apiCallFunction() async {
    await getTokenAndSapId();
    await fetchSrNoExistance();
    if (isSerialNumberExist) {
      await fetchCreateOtpData();
      if (isCreateOTPSuccess) {
        setState(() {
          isLoading = false;
        });
        _updateBottomSheetHeight();
      }
    }
  }

  Future<void> getTokenAndSapId() async {
    token = controller.token;
    user_id = controller.sapId;
    userType = controller.userType;
    language = languageController.language;
  }

  Future<void> fetchSrNoExistance() async {
    String sapId = controller.sapId;
    final Map<String, dynamic> body = {
      "sr_no": serialNumber,
      "app_Version": AppConstants.appVersionName,
      "user_Id": sapId,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "mobileno": widget.mobileNumber,
      "saledate": widget.date,
      "saleType": (widget.tertiarySaleType == AppConstants.singleProduct)
          ? AppConstants.tertiarySingleSaleType
          : AppConstants.tertiaryComboSaleType,
      "token": AppConstants.salesStaticToken
    };

    print("------------->${body}");

    try {
      final response = await Requests.sendPostRequest(
          ApiConstants.postSrNoExistanceUpdateEndPoint, body);

      if (response is! DioException && response.statusCode == 200) {
        //final Map<String, dynamic> data = response.data;
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data);

        String serialNumberExistanceResponse = apiResponse.data.isNotEmpty
            ? apiResponse.data[0].wrsEntryStatus
            : "";

        if (serialNumberExistanceResponse == "ok") {
          isSerialNumberExist = true;
          AppConstants.isSerialNumberValid = true;
        } else {
          Navigator.pop(context);
          AppConstants.isSerialNumberValid = false;
          showErrorMessageBottomSheet(serialNumberExistanceResponse);
        }
      } else {
        AppConstants.isSerialNumberValid = false;
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      AppConstants.isSerialNumberValid = false;
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      print("Error fetching data: $error");
    }
  }

  Future<void> fetchCreateOtpData() async {
    String sapId = controller.sapId;
    final Map<String, dynamic> body = {
      "customerCode": user_id,
      "serialNo": serialNumber,
      "mobileNo": widget.mobileNumber,
      "imeiNumber": deviceId,
      "osVersion": osVersionName,
      "deviceName": deviceName,
      "app_Version": AppConstants.appVersionName,
      "user_Id": sapId,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "appTypeName": AppConstants.appTypeNamePSB,
      "token": AppConstants.salesStaticToken
    };

    try {
      final response = await Requests.sendPostRequest(
        ApiConstants.postEwarrantyCreateOtpEndPoint,
        body,
      );

      if (response is! DioException && response.statusCode == 200) {
        final EWCreateOtp otpApiResponse = EWCreateOtp.fromJson(response.data);

        String code = otpApiResponse.data.code;
        transID = otpApiResponse.data.transID;
        if (code == "SUCCESS") {
          isCreateOTPSuccess = true;
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
          Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
        }
      } else {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      print("Error fetching data: $error");
    }
  }

  Future<void> fetchVerifyOtpData() async {
    String sapId = controller.sapId;
    final Map<String, dynamic> requestBody = {
      "customerCode": user_id,
      "serialNo": serialNumber,
      "mobileNo": widget.mobileNumber,
      "app_Version": AppConstants.appVersionName,
      "user_Id": sapId,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "imeiNumber": deviceId,
      "osVersion": osVersionName,
      "deviceName": deviceName,
      "otp": otpEntered,
      "appTypeName": AppConstants.appTypeNamePSB,
      "token": AppConstants.salesStaticToken,
      "transID": transID,
    };

    try {
      final response = await Requests.sendPostRequest(
        ApiConstants.postEwarrantyVerifyOtpEndPoint,
        requestBody,
      );

      if (response is! DioException && response.statusCode == 200) {
        final EWVerifyOtpResponse verifyOtpResponse =
            EWVerifyOtpResponse.fromJson(response.data);

        String code = verifyOtpResponse.data.code;

        if (code == "SUCCESS") {
          await fetchSaveWithOTPData();
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TertiarySalesSingleProductRegistration(
                      state: state,
                      stateMsg: responseStatus ?? "",
                      cashOrCoinHistory: '',
                      data1: data1Message ?? "",
                      data2: responseCashPoint ?? "0",
                      data3: data3Message ?? "",
                      data4: responseCode ?? "",
                      data5: responseOtpRemark ?? "",
                      transactionType: '',
                      data6: responseCoinsPoint ?? "0",
                      data7: data7Message ?? "",
                      userType: userType,
                      serialNumber: responseSlNo ?? "",
                      productType: responseProductType ?? "",
                      model: responseModel ?? "",
                      name: widget.name,
                      date: widget.date,
                      mobileNumber: widget.mobileNumber,
                      registeredOn: formattedRegisteredOn ?? "",
                      showSomethingWentWrongScreen: showSomethingWentWrong)));
          _verifyOtpController.clearVerifyOtpData();
        } else {
          setState(() {
            isOtpCorrect = false;
            isLoadingAfterVerify = false;
          });
          _verifyOtpController.updateOtpValid(false);
        }
      } else {
        retryCountVerifyOTP += 1;
        print("Error: ${response.statusCode}");

        if (retryCountVerifyOTP <= 2) {
          Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
          setState(() {
            isLoadingAfterVerify = false;
          });
        }
        if (retryCountVerifyOTP >= 3) {
          Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TertiarySalesSingleProductRegistration(
                      state: state,
                      stateMsg: "",
                      cashOrCoinHistory: '',
                      data1: "",
                      data2: "0",
                      data3: "",
                      data4: "",
                      data5: "",
                      transactionType: '',
                      data6: "0",
                      data7: "",
                      userType: userType,
                      serialNumber: "",
                      productType: "",
                      model: "",
                      name: widget.name,
                      date: widget.date,
                      mobileNumber: widget.mobileNumber,
                      registeredOn: "",
                      showSomethingWentWrongScreen: true)));
        }
      }
    } catch (error) {
      retryCountVerifyOTP += 1;
      print("Error fetching data: $error");

      if (retryCountVerifyOTP <= 2) {
        Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
        setState(() {
          isLoadingAfterVerify = false;
        });
      }
      if (retryCountVerifyOTP >= 3) {
        Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => TertiarySalesSingleProductRegistration(
                    state: state,
                    stateMsg: "",
                    cashOrCoinHistory: '',
                    data1: "",
                    data2: "0",
                    data3: "",
                    data4: "",
                    data5: "",
                    transactionType: '',
                    data6: "0",
                    data7: "",
                    userType: userType,
                    serialNumber: "",
                    productType: "",
                    model: "",
                    name: widget.name,
                    date: widget.date,
                    mobileNumber: widget.mobileNumber,
                    registeredOn: "",
                    showSomethingWentWrongScreen: true)));
      }
    }
  }

  Future<void> fetchSaveWithOTPData() async {
    String sapId = controller.sapId;
    final Map<String, dynamic> body = {
      "user_Id": user_id,
      "token": AppConstants.salesStaticToken,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "device_Name": deviceName,
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "language": language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_Version": "",
      "transferAmount": "",
      "serialNo": serialNumber,
      "disCode": "<NOT AVAILABLE>",
      "saleDate": widget.date,
      "customerPhone": widget.mobileNumber,
      "CustomerName": widget.name,
      "CustomerAddress": widget.address,
      "logDistyId": user_id,
      "eW_isVerified": verifiedWithOtp ? "1" : "0",
      "eW_ViaVerified": verifiedWithOtp ? "WITH_OTP" : "WITHOUT_OTP",
      "eW_VerifiedBy": user_id,
      "eW_OTP": otpEntered,
      "eW_IMEI": deviceId,
      "transID": transID,
      "tokenEw": AppConstants.salesStaticToken
    };

    try {
      final response = await Requests.sendPostRequest(
          ApiConstants.postEwarrantySaveWithOTPPoint, body);

      if (response is! DioException && response.statusCode == 200) {
        final EW_SaveWithOTPResponse saveWithOTPResponse =
            EW_SaveWithOTPResponse.fromJson(response.data);

        List<EW_SaveWithOTPData> dataList = saveWithOTPResponse.data;
        if (dataList.isNotEmpty) {
          EW_SaveWithOTPData otpData = dataList.first;

          setState(() {
            responseSlNo = otpData.serialNo;
            responseCoinsPoint = otpData.coin_Points;
            responseCashPoint = otpData.wrsPoint;
            responseStatus = otpData.status;
            responseOtpRemark = otpData.otpRemark;
            responseProductType = otpData.productType;
            responseModel = otpData.model;
            responseCode = otpData.code;
            responseRegisteredOn = otpData.registeredOn;
            showSomethingWentWrong = false;
            isWithoutOTPAPICallComplete = true;
          });

          if (responseStatus == "Accepted") {
            state = 'Success';
            if (verifiedWithOtp) {
              data3Message = translation(context).cashEarned;
              data7Message = translation(context).coinsEarned;
            } else {
              data3Message = "";
              data7Message = "";
            }
          } else if (responseStatus == "Rejected") {
            state = 'Failure';
            if (verifiedWithOtp) {
              data3Message = translation(context).cashRejected;
              data7Message = translation(context).coinsRejected;
            } else {
              data3Message = "";
              data7Message = "";
            }
          } else if (responseStatus == "Pending") {
            state = 'Pending';
            if (verifiedWithOtp) {
              data3Message = translation(context).cashPending;
              data7Message = translation(context).coinsPending;
            } else {
              data3Message = "";
              data7Message = "";
            }
          }

          if (verifiedWithOtp) {
            if (userType != null && userType == "DEALER") {
              if (responseStatus == "Accepted") {
                data1Message =
                    "${responseCoinsPoint} ${translation(context).coinsLowerCase} & ₹ ${responseCashPoint} ${translation(context).creditedToYourMPartnerWallet}";
              } else if (responseStatus == "Rejected") {
                data1Message =
                    "${responseCoinsPoint} ${translation(context).coinsLowerCase} & ₹ ${responseCashPoint} ${translation(context).creditRejected}";
              } else if (responseStatus == "Pending") {
                data1Message =
                    "${responseCoinsPoint} ${translation(context).coinsLowerCase} & ₹ ${responseCashPoint} ${translation(context).creditPending}";
              }
            } else {
              if (responseStatus == "Accepted") {
                data1Message =
                    "₹ ${responseCashPoint} ${translation(context).creditedToYourMPartnerWallet}";
              } else if (responseStatus == "Rejected") {
                data1Message =
                    "₹ ${responseCashPoint} ${translation(context).creditRejected}";
              } else if (responseStatus == "Pending") {
                data1Message =
                    "₹ ${responseCashPoint} ${translation(context).creditPending}";
              }
            }
          } else {
            if (userType != null && userType == "DEALER") {
              data1Message = translation(context).noCoinCashRewardEarned;
            } else {
              data1Message = translation(context).noCashRewardEarned;
            }
          }

          DateTime? originalRegisteredOn = (responseRegisteredOn != null)
              ? DateTime.parse(responseRegisteredOn!)?.toLocal()
              : null;
          formattedRegisteredOn = (originalRegisteredOn != null)
              ? DateFormat(AppConstants.appDateFormatWithTime).format(originalRegisteredOn)
              : "Default Value";
        } else {
          print("Error: Empty data list");
          setState(() {
            showSomethingWentWrong = true;
          });
        }
      } else {
        if (!verifiedWithOtp) {
          retryCountWithoutOTP += 1;
          print("Error: ${response.statusCode}");

          if (retryCountWithoutOTP <= 2) {
            Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
          }
          if (retryCountWithoutOTP >= 3) {
            Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
            setState(() {
              showSomethingWentWrong = true;
              isWithoutOTPAPICallComplete = true;
            });
          }
        } else {
          setState(() {
            showSomethingWentWrong = true;
          });
        }
      }
    } catch (error) {
      if (!verifiedWithOtp) {
        retryCountWithoutOTP += 1;
        print("Error fetching data: $error");

        if (retryCountWithoutOTP <= 2) {
          Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
        }
        if (retryCountWithoutOTP >= 3) {
          Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
          setState(() {
            showSomethingWentWrong = true;
            isWithoutOTPAPICallComplete = true;
          });
        }
      } else {
        setState(() {
          showSomethingWentWrong = true;
        });
      }
    }
  }

  @override
  Widget baseBody(BuildContext context) {
    final String serialNo =
        ModalRoute.of(context)!.settings.arguments as String;

    if (!isInitialized) {
      if (serialNo != serialNumber) {
        serialNumber = serialNo;
      }
      isInitialized = true;
    }

    if (showWithoutOTPAlert) {
      return WillPopScope(
        onWillPop: () async {
          setState(() {
            showWithoutOTPAlert = false;
          });
          return false;
        },
        child: ConfirmationAlertWithoutOTP(
          confirmationText1: translation(context).continueWithoutOTPVerification,
          confirmationText2: translation(context).sureToContinue,
          onPressedNo: () {
            setState(() {
              showWithoutOTPAlert = false;
            });
          },
          onPressedYes: () async {
            verifiedWithOtp = false;
            await fetchSaveWithOTPData();
            if (isWithoutOTPAPICallComplete) {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TertiarySalesSingleProductRegistration(
                          state: state,
                          stateMsg: responseStatus ?? "",
                          cashOrCoinHistory: '',
                          data1: data1Message ?? "",
                          data2: responseCashPoint ?? "0",
                          data3: data3Message ?? "",
                          data4: responseCode ?? "",
                          data5: responseOtpRemark ?? "",
                          transactionType: '',
                          data6: responseCoinsPoint ?? "0",
                          data7: data7Message ?? "",
                          userType: userType,
                          serialNumber: responseSlNo ?? "",
                          productType: responseProductType ?? "",
                          model: responseModel ?? "",
                          name: widget.name,
                          date: widget.date,
                          mobileNumber: widget.mobileNumber,
                          registeredOn: formattedRegisteredOn ?? "",
                          showSomethingWentWrongScreen: showSomethingWentWrong)));
            }
            print("continue without otp");
          },
        ),
      );
    } else {
      return Stack(
        children: [
          WillPopScope(
            onWillPop: () async {
              AppConstants.toCheckResults= true;
              Navigator.pop(context);
               // backToQRScanner();
              return false;

            },
            child: VerifyOtpPresentation(
              key: _bottomSheetKey,
              onCrossClicked:(){
                AppConstants.toCheckResults= true;
                Navigator.pop(context);
              },
              mobileNumber: widget.mobileNumber,
              mandatoryButton: VerifyOTPButton(
                buttonText: translation(context).verifySale,
                onClick: () async {
                  setState(() {
                    isLoadingAfterVerify = true;
                  });
                  verifiedWithOtp = true;
                  await fetchVerifyOtpData();
                  print("Clicking verify Otp");
                },
              ),
              optionalButton: VerifyOTPButton(
                buttonText: translation(context).continueWithoutVerification,
                onClick: () async {
                  setState(() {
                    showWithoutOTPAlert = true;
                  });
                },
              ),
              header: translation(context).verifySale,
              instructions:
                  translation(context).enterWarrantyVerificationCodeSentTo,
              resendOtpMethod: () async {
                setState(() {
                  isLoading = true;
                });
                _verifyOtpController.updateOtpValid(true);
                _verifyOtpController.updateIsResendOtpResponsePending(true);
                await fetchCreateOtpData();
                _verifyOtpController.updateIsResendOtpResponsePending(false);
                print("Called resend otp");
              },
              timerLimit: "30",
              showLoader: isLoading,
              showMaximumAttempsMessage: null,
              maxAttempMessage: null,
              updateOtp: (otp) {
                otpEntered = otp;
                print("Called update OTP: $otp");
              },
              isOtpValid: isOtpCorrect,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: _bottomSheetHeight,
            child: Visibility(
              visible: isLoadingAfterVerify,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.3),
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  void backToQRScanner() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarcodeAndQRScanner(
          title: "Tertiary Sales",
          subtitle: "Single product",
          onBackButtonPressed: () => {},
          useFunction: true,
          onBackButtonPressedWithController: (pauseCamera, resumeCamera) => {
            pauseCamera(),
            showModalBottomSheet(
                isScrollControlled: false,
                enableDrag: false,
                useSafeArea: true,
                isDismissible: false,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28 * variablePixelMultiplier),
                        topRight: Radius.circular(28 * variablePixelMultiplier))),
                showDragHandle: false,
                backgroundColor: AppColors.white,
                context: context,
                builder: (BuildContext context) {
                  return PopScope(
                    canPop: false,
                    child: QRScreenBackButton(
                      resumeCamera: resumeCamera,
                    ),
                  );
                }),
          },
          routeWidget: TertiarySalesVerifySalesSheet(
            name: widget.name,
            address: widget.address,
            mobileNumber: widget.mobileNumber,
            date: widget.date,
            referralCode: widget.referralCode,
            tertiarySaleType: AppConstants.singleProduct,
          ),
          showBottomModal: true,

        ),
      ),
    );
  }

  void showErrorMessageBottomSheet(String errorMessage) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    showModalBottomSheet(
    context: context,
    enableDrag: false,
    isDismissible: false,
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0 * pixelMultiplier),
      ),
    ),
    builder: (context) => WillPopScope(
      onWillPop: () async {
        AppConstants.toCheckResults= true;
        Navigator.pop(context);
        // Navigator.of(context).popUntil(
        //     ModalRoute.withName(AppRoutes.tertiarySales));
        return false;
      },
      child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Wrap(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        24 * variablePixelWidth,
                        24 * variablePixelHeight,
                        24 * variablePixelWidth,
                        0 * variablePixelHeight),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                AppConstants.toCheckResults= true;
                                Navigator.pop(context);
                                // Navigator.of(context).popUntil(
                                //     ModalRoute.withName(AppRoutes.tertiarySales));
                              },
                              child: const Icon(
                                Icons.close,
                                color: AppColors.titleColor,
                              )),
                          SizedBox(height: 6 * variablePixelHeight),
                          Text(
                            translation(context).scanFailed,
                            style: GoogleFonts.poppins(
                              color: AppColors.titleColor,
                              fontSize: 20 * textFontMultiplier,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        24 * variablePixelWidth,
                        16 * variablePixelHeight,
                        24 * variablePixelWidth,
                        0 * variablePixelHeight),
                    child: Container(
                      height: 1 * variablePixelHeight,
                      color: AppColors.bottomSheetSeparatorColor,
                      margin:
                          EdgeInsets.symmetric(vertical: 8 * variablePixelHeight),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        24 * variablePixelWidth,
                        24 * variablePixelHeight,
                        24 * variablePixelWidth,
                        16 * variablePixelHeight),
                    child: Text(
                      errorMessage,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGrey,
                        fontSize: 14 * textFontMultiplier,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.10,
                      ),
                    ),
                  ),
                  CommonButton(
                      onPressed: () {
                        AppConstants.toCheckResults= true;
                        Navigator.pop(context);
                        // Navigator.of(context)
                        //     .popUntil(ModalRoute.withName(AppRoutes.tertiarySales));
                      },
                      isEnabled: true,
                      buttonText: translation(context).okIUnderstand,
                      containerBackgroundColor: AppColors.lightWhite1,
                      containerHeight: variablePixelHeight * 56),
                ],
              ),
            ),
    ),
        );
  }
}
