import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/localdata/shared_preferences_util.dart';

class AuthController extends GetxController {
  String accessToken = "";
  String refreshToken = "";
  BuildContext? buildContext;
  bool isCalendarAtFirst=true;
  bool isSessionExpiredBottomSheetActive = false;
  String uniqueCode = "";


  @override
  void onInit() async {
    super.onInit();
    String accessToken = await SharedPreferencesUtil.getAccessToken() ?? "";
    String refreshToken = await SharedPreferencesUtil.getRefreshToken() ?? "";
    String uniqueCode = await SharedPreferencesUtil.getUniqueCode() ?? "";
    updateAccessToken(accessToken);
    updateRefreshToken(refreshToken);
    updateUniqueCode(uniqueCode);
  }

  void updateBuildContext(BuildContext val) {
    buildContext = val;
    update();
  }

  void updateIsSessionExpiredBottomSheetActive(bool val) {
    isSessionExpiredBottomSheetActive = val;
    update();
  }

  void updateAccessToken (String token) {
    accessToken = token;
    SharedPreferencesUtil.saveAccessToken(token);
    update();
  }

  void updateRefreshToken (String token) {
    refreshToken = token;
    SharedPreferencesUtil.saveRefreshToken(token);
    update();
  }

  void clearAuthData() {
    accessToken = "";
    refreshToken = "";
    uniqueCode = "";
    update();
  }

  void updateUniqueCode(String uniqueCodeVal) {
    uniqueCode = uniqueCodeVal;
    SharedPreferencesUtil.saveUniqueCode(uniqueCode);
    update();
  }

}