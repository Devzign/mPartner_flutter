import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../../network/api_constants.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/requests.dart';
import '../secondary_device.dart';
import '../../../../state/contoller/user_data_controller.dart';

class VerifyOtpRes {
  final String msg;
  final String status;
  final String error;

  VerifyOtpRes({required this.msg, required this.status, required this.error});
}

Future<OtpResponse> SecondaryUserCreateOtp(String secPhoneNo) async {
  UserDataController controller = Get.find();

  String token = controller.token;
  String sapId = controller.sapId;
  final Map<String, dynamic> body = {
    "user_Id": sapId,
    "channel": AppConstants.channel,
    "os_Type": osType,
    "token": token,
    "app_Version": AppConstants.appVersionName,
    "os_version_code": osVersionCode,
    "device_name": deviceName,
    "phone_number": secPhoneNo,
  };
  try {
    final response = await Requests.sendPostRequest(
      ApiConstants.postSecDevCreateOTPEndPoint,
      body
    );

    //Map<String, dynamic> responseDataSecCreateOTP;
    if (response is! DioException && response.statusCode == 200) {
      return OtpResponse(
          data1: response.data['data1'] ?? '',
          msg: response.data['message'] ?? '',
          error: "");
    } else {
      return OtpResponse(
          data1: response.data['data1'] ?? '',
          msg: response.data['message'] ?? '',
          error: "");
    }
  } catch (error) {
    return OtpResponse(
        data1: "", msg: "", error: ErrorStrings.SOMETHING_WENT_WRONG);
  }
}

Future<VerifyOtpRes> SecondaryUserOtpAuth(String otp, String phone) async {
  UserDataController controller = Get.find();
  String token = controller.token;
  String sapId = controller.sapId;
  final Map<String, dynamic> body = {
    "user_Id": sapId,
    "token": token,
    "channel": AppConstants.channel,
    "app_Version": AppConstants.appVersionName,
    "device_Id": deviceId,
    "os_Type": osType,
    "otp": otp,
    "os_version_code": osVersionCode,
    "device_name": deviceName,
    "phone_number": phone,
  };
  try {
    final response = await Requests.sendPostRequest(
      ApiConstants.postSecDevOTPAuthEndPoint,
      body
    );
    //Map<String, dynamic> responseDataSecOTPAuth;
    if (response is! DioException && response.statusCode == 200) {
      return VerifyOtpRes(
          status: response.data['status'] ?? '',
          msg: response.data['message'] ?? '',
          error: "");
    } else {
      return VerifyOtpRes(
          status: response.data['status'] ?? '',
          msg: response.data['message'] ?? '',
          error: "");
    }
  } catch (error) {
    return VerifyOtpRes(
        status: "", msg: "", error: ErrorStrings.SOMETHING_WENT_WRONG);
  }
}
