import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/user_profile_model.dart';

class SharedPreferencesUtil {
  static const String _accessTokenKey = 'token';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _sapIdKey = 'sapId';
  static const String _userType = 'userType';
  static const String _secondaryDeviceInfo = 'secondaryDeviceInfo';
  static const String _phoneNumber = 'phoneNumber';
  static const String _userProfileListKey = 'userProfileList';
  static const String _setBottomSheetShown = 'setBottomSheetShown';
  static const String _showISmartDisclaimerAlert = 'showISmartDisclaimerAlert';
  static const String _homepageBannerUrls = "homepageBannerUrls";

  static const String _isPrimaryNumberLogin = "isPrimaryNumberLogin";
  static const String _isFseAgreementAppeared = "isFseAgreementAppeared";
  static const String _fcmDeviceTokenKey = 'fcmDeviceToken';
  static const String _incorrectOtpLimitCount = 'incorrectOtpMaxLimit';
  static const String _loginUniqueCode = 'uniquecode';
  static const String _language = 'language';
  static const String _languageCode = 'languageCode';
  static const String _upiHandshakeFlag = 'upiHandshakeFlag';
  static const String isAccountDeleted = 'isAccountDeleted';

  // Add more keys for other data as needed

  static Future<void> saveAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_accessTokenKey, token);
  }


  static Future<void> saveRefreshToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_refreshTokenKey, token);
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<void> setBottomSheetShown(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_setBottomSheetShown, val);
  }

  static Future<bool?> getBottomSheetShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_setBottomSheetShown);
  }

  static Future<void> saveSapId(String sapId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_sapIdKey, sapId);
  }

  static Future<String?> getSapId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sapIdKey);
  }

  static Future<void> saveUserType(String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_userType, userType);
  }

  static Future<String?> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userType);
  }

  static Future<void> saveSecondaryDeviceInfo(String getSecondaryDeviceInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_secondaryDeviceInfo, getSecondaryDeviceInfo);
  }

  static Future<String?> getSecondaryDeviceInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_secondaryDeviceInfo);
  }

  static Future<String?> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneNumber);
  }

  static Future<void> savePhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_phoneNumber, phoneNumber);
  }

  static Future<void> saveUserProfile(String userProfileJson) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_userProfileListKey, userProfileJson);
  }

  static Future<List<UserProfile>> getUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userProfileJson = prefs.getString(_userProfileListKey);
    if (userProfileJson != null) {
      final List<dynamic> userProfileList = jsonDecode(userProfileJson);
      final List<UserProfile> userProfileDta =
      userProfileList.map((e) => UserProfile.fromJson(e)).toList();
      return userProfileDta;
    } else {
      return [];
    }
  }

  static Future<void> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<void> setShowISmartDisclaimerAlert(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_showISmartDisclaimerAlert, val);
  }

  static Future<bool?> getShowISmartDisclaimerAlert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showISmartDisclaimerAlert);
  }

  static Future<String?> getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageCode);
  }

  static Future<void> saveLang(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_languageCode, val);
  }

  static Future<String?> getLangText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_language);
  }

  static Future<void> saveLangText(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_language, val);
  }

  static Future<void> saveHomepageBanners(List<String> bannerURLs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_homepageBannerUrls, bannerURLs);
  }

  static Future<void> saveIsPrimaryNumberLogin(
      bool isPrimaryNumberLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isPrimaryNumberLogin, isPrimaryNumberLogin);
  }

  static Future<bool?> getIsPrimaryNumberLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isPrimaryNumberLogin);
  }

  static Future<void> saveIsFseAgreementAppeared(
      bool isFseAgreementAppeared) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isFseAgreementAppeared, isFseAgreementAppeared);
  }

  static Future<bool?> getIsFseAgreementAppeared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFseAgreementAppeared);
  }

  static Future<void> saveFcmDeviceToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_fcmDeviceTokenKey, token);
  }

  static Future<String?> getFcmDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fcmDeviceTokenKey);
  }

  static Future<void> setIncorrectOtpLimit(int val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_incorrectOtpLimitCount, val);
  }

  static Future<int?> getIncorrectOtpLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_incorrectOtpLimitCount);
  }

  static Future<void> saveUniqueCode(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_loginUniqueCode, token);
  }

  static Future<String?> getUniqueCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loginUniqueCode);
  }

  static Future<void> setUpiHandShakeFlag(int handShakeFlag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_upiHandshakeFlag, handShakeFlag);
  }

  static Future<int?> getUpiHandShakeFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_upiHandshakeFlag);
  }

  static Future<void> setAccountDeleted(String isDeleted) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(isAccountDeleted, isDeleted);
  }
  static Future<String?> getIsAccountDeleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(isAccountDeleted);
  }

}
