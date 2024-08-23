import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../network/api_constants.dart';
import '../presentation/widgets/common_button.dart';
import '../presentation/widgets/common_divider.dart';
import '../presentation/widgets/verticalspace/vertical_space.dart';
import '../state/clear_states.dart';
import '../state/contoller/auth_contoller.dart';
import '../state/contoller/user_data_controller.dart';
import 'app_colors.dart';
import 'app_constants.dart';
import 'app_string.dart';
import 'displaymethods/display_methods.dart';
import 'localdata/language_constants.dart';

void updateAccessToken(token) {
  AuthController controller = getx.Get.find();
  controller.updateAccessToken(token);
}

void updateRefreshToken(token) {
  AuthController controller = getx.Get.find();
  controller.updateRefreshToken(token);
}

class Requests {
  static void showUpdateAlertDialog() {
    final currentState = navigatorKey.currentState;
    if (currentState == null) {
      Logger().e("widget tree might not be built or has been disposed of",
          error: 'CurrentState is NULL');
      return;
    }
    String storeVal = Platform.isAndroid
        ? translation(currentState.context).playStoreString
        : translation(currentState.context).appStoreString;
    double variablePixelHeight =
        DisplayMethods(context: currentState.context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: currentState.context).getVariablePixelWidth();
    double variablePixelText =
        DisplayMethods(context: currentState.context).getTextFontMultiplier();

    showModalBottomSheet<void>(
      context: currentState.context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: SafeArea(
              child: Wrap(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(
                    24 * variablePixelWidth,
                    36 * variablePixelHeight,
                    24 * variablePixelWidth,
                    32 * variablePixelHeight),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translation(currentState.context)
                                .updateNewVersionVal,
                            style: GoogleFonts.poppins(
                              color: AppColors.bottomSheetHeaderTextColor,
                              fontSize: 20 * variablePixelText,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8 * variablePixelHeight),
                    Container(
                      height: 1,
                      color: AppColors.bottomSheetSeparatorColor,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    SizedBox(height: 8 * variablePixelHeight),
                    Text(
                      storeVal,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 14 * variablePixelText,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.10,
                      ),
                    ),
                    SizedBox(height: 16 * variablePixelHeight),
                    CommonButton(
                      onPressed: () async {
                        if (Platform.isAndroid) {
                          await launchUrl(
                              Uri.parse(AppUpdateStrings.playStoreLink));
                        } else if (Platform.isIOS) {
                          await launchUrl(
                              Uri.parse(AppUpdateStrings.appStoreLink));
                        }
                      },
                      isEnabled: true,
                      buttonText: translation(currentState.context).updateVal,
                      containerBackgroundColor: Colors.transparent,
                      horizontalPadding: 0,
                    ),
                  ],
                ),
              )
            ],
          )),
        );
      },
      isDismissible: false,
      enableDrag: false,
      // routeSettings: backRoute(),
    );
  }

  static void showLogoutBottomSheet() {
    AuthController controller = getx.Get.find();
    BuildContext? buildContext = controller.buildContext;

    if (buildContext != null &&
        controller.isSessionExpiredBottomSheetActive != true) {
      double variablePixelHeight =
          DisplayMethods(context: buildContext).getVariablePixelHeight();
      double variablePixelWidth =
          DisplayMethods(context: buildContext).getVariablePixelWidth();
      double pixelMultiplier =
          DisplayMethods(context: buildContext).getPixelMultiplier();
      double textFontMultiplier =
          DisplayMethods(context: buildContext).getTextFontMultiplier();

      controller.updateIsSessionExpiredBottomSheetActive(true);

      showModalBottomSheet(
          context: buildContext,
          isDismissible: false,
          enableDrag: false,
          builder: (BuildContext bc) {
            return PopScope(
              canPop: false,
              child: Container(
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
                          Center(
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
                          IconButton(
                            onPressed: () {
                              Navigator.of(bc).pop();
                              logoutUser();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.black,
                            ),
                          ),
                          const VerticalSpace(height: 20),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 16 * variablePixelWidth),
                            child: Text(
                              "Alert!",
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
                            padding:
                                EdgeInsets.only(left: 16 * pixelMultiplier),
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
                                //  translation(context).transferAmountValidation,
                                "Your session is expired. Please login again.",
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
                          Padding(
                            padding: EdgeInsets.only(
                                right: 16 * variablePixelWidth,
                                left: 16 * variablePixelWidth,
                                bottom: 24 * variablePixelWidth),
                            child: CommonButton(
                                onPressed: () {
                                  Navigator.of(bc).pop();
                                  logoutUser();
                                },
                                isEnabled: true,
                                //buttonText: translation(context).enterAgain,
                                buttonText: "Login",
                                withContainer: false
                                //containerBackgroundColor: AppColors.white,
                                ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  static void showLoginFailedBottomSheet() {
    AuthController controller = getx.Get.find();
    BuildContext? buildContext = controller.buildContext;

    if (buildContext != null &&
        controller.isSessionExpiredBottomSheetActive != true) {
      double variablePixelHeight =
          DisplayMethods(context: buildContext).getVariablePixelHeight();
      double variablePixelWidth =
          DisplayMethods(context: buildContext).getVariablePixelWidth();
      double pixelMultiplier =
          DisplayMethods(context: buildContext).getPixelMultiplier();
      double textFontMultiplier =
          DisplayMethods(context: buildContext).getTextFontMultiplier();

      controller.updateIsSessionExpiredBottomSheetActive(true);

      showModalBottomSheet(
          context: buildContext,
          isDismissible: false,
          enableDrag: false,
          builder: (BuildContext bc) {
            return PopScope(
              canPop: false,
              child: Container(
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
                          Center(
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
                          IconButton(
                            onPressed: () {
                              controller
                                  .updateIsSessionExpiredBottomSheetActive(
                                      false);
                              Navigator.of(bc).pop();
                              logoutUser();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.black,
                            ),
                          ),
                          const VerticalSpace(height: 20),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 16 * variablePixelWidth),
                            child: Text(
                              "Alert!",
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
                            padding:
                                EdgeInsets.only(left: 16 * pixelMultiplier),
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
                                //  translation(context).transferAmountValidation,
                                "Your login has failed. Please try again later.",
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
                          Padding(
                            padding: EdgeInsets.only(
                                right: 16 * variablePixelWidth,
                                left: 16 * variablePixelWidth,
                                bottom: 24 * variablePixelWidth),
                            child: CommonButton(
                                onPressed: () {
                                  controller
                                      .updateIsSessionExpiredBottomSheetActive(
                                          false);
                                  Navigator.of(bc).pop();
                                  logoutUser();
                                },
                                isEnabled: true,
                                //buttonText: translation(context).enterAgain,
                                buttonText: "Login",
                                withContainer: false
                                //containerBackgroundColor: AppColors.white,
                                ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  static void show429ErrorBottomSheet(String errorMessage) {
    BuildContext? buildContext = navigatorKey.currentState?.context;

    if (buildContext != null) {
      double variablePixelHeight =
      DisplayMethods(context: buildContext).getVariablePixelHeight();
      double variablePixelWidth =
      DisplayMethods(context: buildContext).getVariablePixelWidth();
      double pixelMultiplier =
      DisplayMethods(context: buildContext).getPixelMultiplier();
      double textFontMultiplier =
      DisplayMethods(context: buildContext).getTextFontMultiplier();

      showModalBottomSheet(
          context: buildContext,
          isDismissible: true,
          enableDrag: true,
          builder: (BuildContext bc) {
            return PopScope(
              canPop: false,
              child: Container(
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
                          Center(
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
                          IconButton(
                            onPressed: () {
                              Navigator.of(bc).pop();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.black,
                            ),
                          ),
                          const VerticalSpace(height: 20),
                          Padding(
                            padding:
                            EdgeInsets.only(left: 16 * variablePixelWidth),
                            child: Text(
                              "Alert!",
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
                            child: const CustomDivider(
                                color: AppColors.dividerColor),
                          ),
                          const VerticalSpace(height: 16),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 24 * variablePixelWidth,
                                left: 16 * variablePixelWidth),
                            child: SizedBox(
                              width: 345 * variablePixelWidth,
                              height: 40 * variablePixelHeight,
                              child: Text(
                                errorMessage,
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
                          Padding(
                            padding: EdgeInsets.only(
                                right: 16 * variablePixelWidth,
                                left: 16 * variablePixelWidth,
                                bottom: 24 * variablePixelWidth),
                            child: CommonButton(
                                onPressed: () {
                                  Navigator.of(bc).pop();
                                },
                                isEnabled: true,
                                buttonText: translation(buildContext).okIUnderstand,
                                withContainer: false
                              //containerBackgroundColor: AppColors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  static void logoutUser() {
    clearStates();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.login, (Route<dynamic> route) => false);
  }

  // This function is called to get the access token from the refresh token
  /*static Future<Map<String, String>> getAccessTokenFromRefreshToken(
      String accessToken, String refreshToken, String userId) async {
    AuthController controller = getx.Get.find();
    try {
      Dio dio = Dio();
      final Map<String, dynamic> body = {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "user_Id": userId,
        "os_Type": osType,
        "channel": AppConstants.channel
      };
      logger.d(
          "getAccessTokenFromRefreshToken \n API: ${ApiConstants.postRefreshToken} \n BODY: ${jsonEncode(body)}");
      final response = await dio.post(ApiConstants.postRefreshToken,
          data: body,
          options: Options(
            headers: {
              "Authorization": controller.accessToken.isNotEmpty
                  ? "Bearer ${controller.accessToken}"
                  : "",
            },
          ));
      logger.d(
          "getAccessTokenFromRefreshToken \n API: ${ApiConstants.postRefreshToken} \n RESPONSE: ${response.toString()}");
      if (response.statusCode == 200 &&
          response.data['accessToken'] != null &&
          response.data["refreshToken"] != null) {
        Map<String, String> obj = {
          "accessToken": response.data['accessToken'] ?? "",
          "refreshToken": response.data["refreshToken"] ?? ""
        };
        return (obj);
      } else {
        print('Hitting the logout');
        showLogoutBottomSheet();
        // Failure to get the refresh token will cause the user to logout

        return {};
      }
    } catch (e) {
      showLogoutBottomSheet();
      // Failure to get the refresh token will cause the user to logout
      return {};
    }
  }*/

  static Future<dynamic> sendPostRequest(String url, Map<String, dynamic>? body,
      {int? isUpi, String? userID}) async {
    AuthController controller = getx.Get.find();
    UserDataController userDataController = getx.Get.find();
    if (body != null) {
      if (isUpi == null) {
        body["device_Id"] = deviceId;
      }
      body["app_Version"] = AppConstants.appVersionName;
      body["os_Type"] = osType;
      body["channel"] = AppConstants.channel;

      if (userID == null) {
        body["User_Id"] = userDataController.sapId;
      } else {
        body["User_Id"] = userID;
      }

      body["PhoneNo"] = userDataController.phoneNumber;
    }

    Dio dio = Dio();
    logger.d(
        "sendPostRequest \n API: $url \n BODY: ${jsonEncode(body)} \n ACCESS Token: ${controller.accessToken} \n UniqueCode: ${controller.uniqueCode}");

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          return handler.next(options);
        },
        onResponse:
            (Response<dynamic> response, ResponseInterceptorHandler handler) {
          logger.d(
              "sendPostRequest \n API: $url \n RESPONSE: ${response.toString()}");
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          logger.e("Error received for the API url: $url");
          logger.e("Error received for the API statusCode: ${error.response!.statusCode}");
          /* if (error.response!.statusCode == 401) {
            if (errorCount < maxErrorCount) {
              errorCount += 1;
              Map<String, String> obj = await getAccessTokenFromRefreshToken(
                  controller.accessToken,
                  controller.refreshToken,
                  (body == null) ? "" : body["user_Id"]);
              if (obj.isEmpty) {
                return handler.reject(error);
              }
              updateAccessToken(obj["accessToken"] ?? "");
              updateRefreshToken(obj["refreshToken"] ?? "");

              error.requestOptions.headers['Authorization'] =
                  obj["accessToken"] != ""
                      ? 'Bearer ${obj["accessToken"]}'
                      : '';

              return handler.resolve(await dio.fetch(error.requestOptions));
            } else {
              showLogoutBottomSheet();
              // Failure to get the refresh token will cause the user to logout
              return handler.reject(error);
            }
          } else */
          if (error.response!.statusCode == 402) {
            UserDataController userDataController = Get.find();
            if (!userDataController.isUpdateSheetAlreadyViewed) {
              userDataController.isUpdateSheetAlreadyViewed = true;
              showUpdateAlertDialog();
            }
            return handler.reject(error);
          } else if (error.response!.statusCode == 406 || error.response!.statusCode == 401) {
            showLogoutBottomSheet();
            return handler.reject(error);
          } else if (error.response!.statusCode == 429) {
            logger.d(
                "RA_429 (tooManyOtpAttempt) : ${error.response!.statusCode}");
            logger.d(
                "RA_429 (tooManyOtpAttempt) : ${error.response!.data['Message']}");
            if(error.response!.data['Message']==null || error.response!.data['Message']==""){
              show429ErrorBottomSheet(translation(navigatorKey.currentState!.context).tooManyOtpAttempt);
            }
            else {
              show429ErrorBottomSheet(error.response!.data['Message']);
            }
            return handler.reject(error);
          }
          debugPrint("Request Dart Error: ${error.toString()}");
          return handler.next(error);
        },
      ),
    );

    try {
      final response = await dio.post(url,
          data: body,
          options: Options(
            headers: {
              "Authorization": controller.accessToken.isNotEmpty
                  ? "Bearer ${controller.accessToken}"
                  : "",
              "UniqueCode":
                  controller.uniqueCode.isNotEmpty ? controller.uniqueCode : "",
            },
          ));

      logger.d(
          "sendPostRequest \n API: $url \n RESPONSE: ${response.toString()}");
      return response;
    } catch (e) {
      logger.e('API: $url \n ERROR: $e');

      return e;
    }
  }

  static Future<dynamic> sendGetRequest(
      String url, Map<String, dynamic>? query) async {
    AuthController controller = getx.Get.find();
    Dio dio = Dio();
    logger.d(
        "sendGetRequest \n API: $url \n QUERY: $query \n ACCESS Token: ${controller.accessToken} \n UniqueCode: ${controller.uniqueCode}");

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          return handler.next(options);
        },
        onResponse:
            (Response<dynamic> response, ResponseInterceptorHandler handler) {
          logger.d(
              "sendGetRequest \n API: $url \n RESPONSE: ${response.toString()}");
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          logger.e("Error received for the API url: $url");
          // Handle errors here
          /* if (error.response!.statusCode == 401) {
            if (errorCount < maxErrorCount) {
              errorCount += 1;
              Map<String, String> obj = await getAccessTokenFromRefreshToken(
                  controller.accessToken,
                  controller.refreshToken,
                  (query == null) ? "" : query["user_Id"]);
              if (obj.isEmpty) {
                return handler.reject(error);
              }
              updateAccessToken(obj["accessToken"] ?? "");
              updateRefreshToken(obj["refreshToken"] ?? "");

              error.requestOptions.headers['Authorization'] =
                  obj["accessToken"] != ""
                      ? 'Bearer ${obj["accessToken"]}'
                      : '';

              return handler.resolve(await dio.fetch(error.requestOptions));
            } else {
              showLogoutBottomSheet();
              // Failure to get the refresh token will cause the user to logout
              return handler.reject(error);
            }
          } else */ if (error.response!.statusCode == 402) {
            showUpdateAlertDialog();
            return handler.reject(error);
          } else if (error.response!.statusCode == 406 || error.response!.statusCode == 401) {
            showLogoutBottomSheet();
            return handler.reject(error);
          }
          return handler.reject(error);
        },
      ),
    );
    final response = await dio.get(url,
        queryParameters: query,
        options: Options(
          headers: {
            "Authorization": controller.accessToken.isNotEmpty
                ? "Bearer ${controller.accessToken}"
                : "",
            "UniqueCode":
                controller.uniqueCode.isNotEmpty ? controller.uniqueCode : "",
          },
        ));
    logger.d("sendGetRequest \n API: $url \n RESPONSE: ${response.toString()}");
    return response;
  }

  static Future<dynamic> sendPostForm(
      String url, FormData formData, String user_Id) async {
    AuthController controller = getx.Get.find();
    UserDataController userDataController = getx.Get.find();
    Dio dio = Dio();

    formData.fields.add(MapEntry("User_Id", userDataController.sapId));
    formData.fields.add(MapEntry("PhoneNo", userDataController.phoneNumber));

    logger.d(
        "sendPostForm \n URL: $url \n FormData: ${formData.fields} \n ACCESS Token: ${controller.accessToken} \n UniqueCode: ${controller.uniqueCode}");

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          return handler.next(options);
        },
        onResponse:
            (Response<dynamic> response, ResponseInterceptorHandler handler) {
          logger.d(
              "sendPostForm \n API: $url \n RESPONSE: ${response.toString()}");
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          logger.e("Error received for the API url: $url");
          // Handle errors here
          /* if (error.response!.statusCode == 401) {
            if (errorCount < maxErrorCount) {
              errorCount += 1;
              Map<String, String> obj = await getAccessTokenFromRefreshToken(
                  controller.accessToken, controller.refreshToken, user_Id);
              if (obj.isEmpty) {
                return handler.reject(error);
              }
              updateAccessToken(obj["accessToken"] ?? "");
              updateRefreshToken(obj["refreshToken"] ?? "");

              error.requestOptions.headers['Authorization'] =
                  obj["accessToken"] != ""
                      ? 'Bearer ${obj["accessToken"]}'
                      : '';

              return handler.resolve(await dio.fetch(error.requestOptions));
            } else {
              showLogoutBottomSheet();
              // Failure to get the refresh token will cause the user to logout
              return handler.reject(error);
            }
          } else */ if (error.response!.statusCode == 402) {
            showUpdateAlertDialog();
            return handler.reject(error);
          } else if (error.response!.statusCode == 406 || error.response!.statusCode == 401) {
            showLogoutBottomSheet();
            return handler.reject(error);
          }
          return handler.reject(error);
        },
      ),
    );

    final response = await Dio().post(url,
        data: formData,
        options: Options(
          headers: {
            "Authorization": controller.accessToken.isNotEmpty
                ? "Bearer ${controller.accessToken}"
                : "",
            "UniqueCode":
                controller.uniqueCode.isNotEmpty ? controller.uniqueCode : "",
          },
          contentType: "application/form-data",
        ));
    logger.d("sendPostForm \n API: $url \n RESPONSE: ${response.toString()}");
    return response;
  }

  static Future<dynamic> sendPutRequest(
      String url, Map<String, dynamic> body) async {
    AuthController controller = getx.Get.find();
    UserDataController userDataController = getx.Get.find();
    Dio dio = Dio();

    body["User_Id"] = userDataController.sapId;
    body["PhoneNo"] = userDataController.phoneNumber;

    logger.d(
        "sendPutRequest \n URL: $url \n BODY: ${jsonEncode(body)} \n ACCESS Token: ${controller.accessToken} \n UniqueCode: ${controller.uniqueCode}");

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          return handler.next(options);
        },
        onResponse:
            (Response<dynamic> response, ResponseInterceptorHandler handler) {
          logger.d(
              "sendPutRequest \n API: $url \n RESPONSE: ${response.toString()}");
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          logger.e("Error received for the API url: $url");
          if (error.response!.statusCode == 402) {
            showUpdateAlertDialog();
            return handler.reject(error);
          } else if (error.response!.statusCode == 406 || error.response!.statusCode == 401) {
            showLogoutBottomSheet();
            return handler.reject(error);
          }
          return handler.reject(error);
        },
      ),
    );

    final response = await dio.put(
      url,
      data: body,
      options: Options(
        headers: {
          "Authorization": controller.accessToken.isNotEmpty
              ? "Bearer ${controller.accessToken}"
              : "",
          "UniqueCode":
              controller.uniqueCode.isNotEmpty ? controller.uniqueCode : "",
        },
      ),
    );
    logger.d("sendPutRequest \n API: $url \n RESPONSE: ${response.toString()}");
    return response;
  }

  static void sendLogoutPostRequest() async {
    UserDataController controller = Get.find();
    AuthController authController = Get.find();

    final Map<String, dynamic> body = {
      "user_Id": controller.sapId,
      "token": authController.accessToken,
      "otp": "",
      "os_version_code": osVersionCode,
      "loginUserId": "",
      "device_name": deviceName,
      "phone_number": controller.phoneNumber,
      "type": "",
      "mode": "",
      "transactionId": "",
      "electrician_Mapping_Flag": "",
      "device_Id": deviceId,
      "app_Version": AppConstants.appVersionName,
      "os_Type": osType,
      "channel": AppConstants.channel
    };

    Dio dio = Dio();
    logger.d(
        "sendLogoutPostRequest \n API: $ApiConstants.postLogoutEndPoint \n BODY: ${jsonEncode(body)} \n ACCESS Token: ${authController.accessToken}");

    try {
      final response = await dio.post(ApiConstants.postLogoutEndPoint,
        data: body,
        options: Options(
          headers: {
            "Authorization":  authController.accessToken.isNotEmpty ? "Bearer ${authController.accessToken}":"",
          },
        )
      );

      logger.d(
          "sendPostRequest \n API: $ApiConstants.postLogoutEndPoint \n RESPONSE: ${response.toString()}");
    } catch (e) {
      logger.e('API: $ApiConstants.postLogoutEndPoint \n ERROR: $e');
    }
  }
}
