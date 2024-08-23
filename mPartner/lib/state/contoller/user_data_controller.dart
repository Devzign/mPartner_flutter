import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/user_profile_model.dart';
import '../../services/services_locator.dart';
import '../../utils/localdata/shared_preferences_util.dart';

class UserDataController extends GetxController {
  var isLoading = true.obs;
  var error = ''.obs;
  String token = "";
  String fcmToken = "";
  String phoneNumber = "";
  String sapId = "";
  String userType = "";
  String getSecondaryDeviceInfo = "";
  RxString profileImg = "".obs;
  bool isPrimaryNumberLogin = false;
  bool isFseAgreementAppeared = false;
  List<UserProfile> userProfile = [];
  bool isSurveyFormAppeared = false;
  bool isPopUpAppeared = false;
  bool isFromHomePageRoute=false;
  bool isSecondaryDevice1 = false;
  bool isSecondaryDevice2 = false;
  int incorrectOtpLimit = 0;
  Map<String,String> sapIdImageMap = {};
  bool isTermsConditionAccepted = false;
  bool isUpdateSheetAlreadyViewed=false;
  var getUserProfileOutput = <UserProfile>[].obs;

  @override
  void onInit() async {
    super.onInit();
    token = await SharedPreferencesUtil.getAccessToken() ?? "";
    phoneNumber = await SharedPreferencesUtil.getPhoneNumber() ?? "";
    sapId = await SharedPreferencesUtil.getSapId() ?? "";
    userType = await SharedPreferencesUtil.getUserType() ?? "";
    userProfile = await SharedPreferencesUtil.getUserProfile();
    getSecondaryDeviceInfo = await SharedPreferencesUtil.getSecondaryDeviceInfo() ?? "";
    bool? tempIsPrimaryNumberLogin =
        await SharedPreferencesUtil.getIsPrimaryNumberLogin();
    if (tempIsPrimaryNumberLogin == null) {
      isPrimaryNumberLogin = false;
    } else {
      isPrimaryNumberLogin = tempIsPrimaryNumberLogin;
    }
    isFseAgreementAppeared = await SharedPreferencesUtil.getIsFseAgreementAppeared() ?? false;
    isSurveyFormAppeared = false;
    isPopUpAppeared = false;
    incorrectOtpLimit = await SharedPreferencesUtil.getIncorrectOtpLimit() ?? 0;
    fcmToken = await SharedPreferencesUtil.getFcmDeviceToken() ?? "";
    update();
  }

  updateToken(String val) async {
    await SharedPreferencesUtil.saveAccessToken(val);
    token = val;
    update();
  }

  updatePhoneNumber(String val) async {
    await SharedPreferencesUtil.savePhoneNumber(val);
    phoneNumber = val;
    update();
  }

  updateSapId(String val) {
    SharedPreferencesUtil.saveSapId(val);
    sapId = val;
    update();
  }

  updateUserType(String val) {
    SharedPreferencesUtil.saveUserType(val);
    userType = val;
    update();
  }

  updateSecondaryDeviceInfo(String val) {
    SharedPreferencesUtil.saveSecondaryDeviceInfo(val);
    getSecondaryDeviceInfo = val;
    update();
  }

  updateUserProfile(String val) {
    SharedPreferencesUtil.saveUserProfile(val);
    final List<dynamic> userProfileList = jsonDecode(val);
    final List<UserProfile> userProfileDta =
        userProfileList.map((e) => UserProfile.fromJson(e)).toList();
    userProfile = userProfileDta;

    if (userProfile.isNotEmpty && userProfile[0].tC_Accepted == 1) {
      isTermsConditionAccepted = true;
      SharedPreferencesUtil.setShowISmartDisclaimerAlert(isTermsConditionAccepted);
    } else if (userProfile.isNotEmpty && userProfile[0].tC_Accepted == 0) {
      isTermsConditionAccepted = false;
      SharedPreferencesUtil.setShowISmartDisclaimerAlert(isTermsConditionAccepted);
    }
    update();
  }

  updateIsPrimaryNumberLogin(bool val) {
    SharedPreferencesUtil.saveIsPrimaryNumberLogin(val);
    isPrimaryNumberLogin = val;
    update();
  }

  updateIsFseAgreementAppeared(bool val) {
    SharedPreferencesUtil.saveIsFseAgreementAppeared(val);
    isFseAgreementAppeared = val;
    update();
  }

  updateIsFseAgreementAppearedOnlyController(bool val) {
    isFseAgreementAppeared = val;
    update();
  }

  updateIsSurveyFormAppeared(bool val) {
    isSurveyFormAppeared = val;
    update();
  }
  updateIsPopUpAppeared(bool val) {
    isPopUpAppeared = val;
    update();
  }

  updateSapIdImageMap(Map<String, String> val) {
    sapIdImageMap = val;
    update();
  }

  clearUserData() async {
    token = "";
    phoneNumber = "";
    sapId = "";
    userType = "";
    userProfile = [];
    isPrimaryNumberLogin = false;
    isFseAgreementAppeared = false;
    isSurveyFormAppeared = false;
    isPopUpAppeared = false;
    profileImg.value = "";
    sapIdImageMap = {};
    isLoading = true.obs;
    error = ''.obs;
    getUserProfileOutput = <UserProfile>[].obs;
    update();
  }

  updateIncorrectOtpLimit(int val) {
    SharedPreferencesUtil.setIncorrectOtpLimit(val);
    incorrectOtpLimit = val;
    update();
  }

  fetchUserProfile() async {
    try {
      isLoading(true);
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource = sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.getUserProfile();

      result.fold(
            (l) => debugPrint("Error: $l"),
            (r) async {
              getUserProfileOutput = <UserProfile>[].obs;
              getUserProfileOutput.addAll(r);
        },
      );
    } catch (e) {
      error("Error: $e");
    } finally {
      isLoading(false);
    }
  }
}
