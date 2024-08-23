import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final class AppConstants {

  static final VALIDATE_REGEX = RegExp(r'^(\+91)?[0-9]{10}$');
  static final VLIDATE_PLACE_REGEX = RegExp("[a-zA-Z0-9.,/ \\\\-]");
  static final VALIDATE_NAME_REGEX = RegExp("[a-zA-Z .]");
  static final VALIDATE_ALPHABETS_REGEX = RegExp("[a-zA-Z]");
  static final VALIDATE_COMPANY_REGEX = RegExp(r"[a-zA-Z0-9.\s]");
  static const FONT_FAMILY = "Poppins";
  static const FONT_SIZE_SMALL = 12;
  static const FONT_SIZE_EXTRA_SMALL = 14;
  static const FONT_SIZE_MEDIUM = 18;
  static const FONT_SIZE_LARGE = 22;
  static const FROM_DATE = "";
  static const TO_DATE = "";
  static bool toCheckResults = true;
  static bool isSerialNumberValid = false;

  // TODO: Update for Every Major/Minor App Version Changes
  static const String appVersionName = "12.2";
  // TODO: Update only when @appVersionName is Updated OR Every 5 Releases. No regular Update required
  static const String appVersionCode = "185";

  static const String channel = "App";
  static const String wifiMac =
      "02:00:00:00:00:00"; //This value has been taken from older App where it was hard coded
  static const String bluetoothMac =
      "44.556"; //This value has been taken from older App where it was hard coded
  static const String deviceType = "mob"; //Only for UPI
  static const String upiFlag = "UPI";
  static const String salesStaticToken =
      "pass@1234"; //This is required by Backend for tertiary sales
  static const String pageName =
      "Ewarranty"; //This is required by Backend for ismart terms condition
  static const String splashScreenName = "splash"; //This is required by Backend
  static const String welcomeScreenName = "welcome"; //This is required by Backend
  static const String createOTPMode = "mobile"; //This is required by Backend
  static const String electricianCode = "-"; //This is required by Backend
  static const String pinelabTransactionMode =
      "online"; //This is required by Backend
  static const String pinelabCurrency = "356"; //This is required by Backend
  static const String appTypeNamePSB =
      "PSB"; //This is required by Backend for create otp tertiary sales
  static const String productDetailsTransactionType =
      "Credit"; //This is required by Backend for tertiary bulk and secondary sales
  static const String appName = "MPartner";
  static const String capability = "5755757555"; //for UPI
  static const String tertiarySingleSaleType =
      "TertiarySingle"; // will be hardcoded for API(salesType) whether s.no already exist or not -TertiarySale/mSerWRSrNoExistanceUpdateV4
  static const String tertiaryBulkSaleType =
      "TertiaryBulk"; // will be hardcoded for API(salesType) whether s.no already exist or not -TertiarySale/mSerWRSrNoExistanceUpdateV4
  static const String tertiaryComboSaleType =
      "TertiaryCombo"; // will be hardcoded for API(salesType) whether s.no already exist or not -TertiarySale/mSerWRSrNoExistanceUpdateV4
  static const String singleProduct =
      "Single product"; // will be hardcoded for API(salesType) whether s.no already exist or not -TertiarySale/mSerWRSrNoExistanceUpdateV4
  static const String countryCode = "+91 - ";
  static const String luminousUpiId = "luminousm2p@hdfcbank";
  static const String pinlabToken = "8B607F1775CF4401BE84";
  static const String corporateBulkSale =
      "Corporate/ Bulk sale"; // used for navigation to tertiary sales types
  static const String inverterBatteryCombo =
      "Inverter & Battery combo"; // used for navigation to tertiary sales types

  static const int nameInputMaxLength = 50;
  static const int addressInputMaxLength = 256;
  static const int searchInputMaxLength = 50;
  static const int transferCashInputMaxLength = 9;
  static const int mobileNumberInputMaxLength = 10;
  static const int pinCodeInputMaxLength = 6;
  static const int coinsAmountInputMaxLength = 9;
  static const int passportNumberInputMaxLength = 12;
  static const int emailInputMaxLength = 50;
  static const int cityOrStateInputMaxLength = 50;
  static const int relationInputMaxLength = 50;
  static const int feedbackInputMaxLength = 500;
  static const int referralCodeInputMaxLength = 25;
  static const int gstNumberInputMaxLength = 15;
  static const int panInputMaxLength = 10;
  static const int aadharInputMaxLength = 12;

  static const int maxImagesCount = 10; // to be upload in help and support
  static const int imageCompressPercentage = 50; // image compress percentage
  static const double? imageMaxHeight = 1080;
  static const double? imageMaxWidth = 1920;

  static const int advertisementTextMaxLength = 224;

  static const int bufferCount = 4; // images pre-download for pop up's

  static const int maxUploadFileSize = 5;

  static const String singleSelectionCalenderType =
      "SingleSelectionCalenderType";
  static const String rangeSelectionCalenderType = "rangeSelectionCalenderType";

  static const String appDateFormatWithTime = 'MMM dd, yyyy, hh:mm a';
  static const String cashCoinDateFormatWithTime = 'dd MMM yyyy, hh:mm a';
  static const String appDateFormat = 'MMM dd, yyyy';

  static const String createDelerDocumentPanCard =
      'PAN of Proprietor/Firm/Company';

  static const clearAll=1;
  static const clearRead=2;
  static const clearUnread=3;

  static const solarRequestRaisingDate="SOLAR_REQUEST_RAISING_DATE";
  static const IsUserDeleteEnable="USER_DELETE_ENABLED";
  static const IsUserDeletemessage="USER_DELETE_MESSAGE";

  static const solarvisible="SOLAR_VISIBLE";
  static const mPartner="HomePage";
  static const solar="SolarHomePage";

}

Logger logger = Logger();
final navigatorKey = GlobalKey<NavigatorState>();

String deviceId = "";
String deviceName = "";
String osType = Platform.isAndroid ? "android" : "ios";
String osVersionName = "";
String osVersionCode = "";
String deviceModel = "";
String networkType = "";
String networkOperator = "";
String ipAddress = "";
String simCardIdentifier = "";
String geoCode = "-";
String location = "-";
