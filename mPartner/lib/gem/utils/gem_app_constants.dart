class GemAppConstants {

  static final VALIDATE_GSTIN_REGEX = RegExp(r'^\d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}[Z]{1}[A-Z\d]{1}$');

  static const String commercialCategory = "Commercial";
  static const String residentialCategory = "Residential";
  static const int residentialCategoryId = 1;
  static const int commercialCategoryId = 2;
  static const online="online";
  static const onsite="onsite";
  static const endToEnd="end_to_end";
  static final PROJECT_NAME_REGEX = RegExp(r"[a-zA-Z0-9\s]");
  static final PROJECT_ADDRESS_REGEX = RegExp(r"[a-zA-Z0-9,\-\s]");
  static final PROJECT_LANDMARK_REGEX = RegExp(r"[a-zA-Z\s]");
  static final NAME_REGEX_1 = RegExp(r"^.{5,50}$");
  static final NAME_REGEX_2 = RegExp(r"^.{5,250}$");
  static final LATITUDE_REGEX = RegExp(r'^[-+]?([0-9]|[1-8][0-9]|90)\.{1}\d{6}$');
  static final LONGITUDE_REGEX = RegExp(r'^[-+]?([0-9]|[1-9][0-9]|1[0-7][0-9]|180)\.{1}\d{6}$');
  static final PINCODE_REGEX = RegExp(r'^(?!0+$)\d{6}$');
  static final EMAIL_REGEX = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  static final MOBILE_NUMBER_REGEX = RegExp(r'^[0-9]{10}$');
  static final DIGITS_REGEX = RegExp(r'[0-9]');
  static final NON_ZERO_FIRST_DIGIT_REGEX = RegExp(r'^(?!0)[0-9]*$');
  static final MOBILE_NUMBER_FILTER_ALLOW_REGEX = RegExp(r'^\+91 - [0-9]*$');
  static final MOBILE_NUMBER_FILTER_DENY_REGEX = RegExp(r'^\+91 - [0-5]$');
  static final GEOCODE_ALLOW_REGEX = RegExp(r'^[0-9.,\-+]*$');
  static final SPACE_REGEX = RegExp(r'\s');
  static final DIGITS_CHARS_REGEX = RegExp("[0-9a-zA-Z]");
  static final PAN_REGEX = RegExp('[A-Z]{5}[0-9]{4}[A-Z]{1}');
  static final GST_REGEX = RegExp(r"^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$");
  static final PROJECT_CAPACITY_REGEX_KWH = RegExp(r"^[1-9]\d{0,2}$|1000$");
  static final PROJECT_CAPACITY_REGEX_MW =  RegExp(r"^[1-9]$|10$");
  static final dateTimeFormatCalender = "dd/MM/yyyy";
  static const int remarkInputMaxLength = 500;
  static const int maxLength10 = 10;
  static const int maxLength15 = 15;
  static const int projectCapacityMaxLength = 5;
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
  static const int bidNumberInputMaxLength = 50;
  static const int panInputMaxLength = 10;
  static const int aadharInputMaxLength = 12;

  static const int maxImagesCount = 10; // to be upload in help and support
  static const int imageCompressPercentage = 50; // image compress percentage
  static const double? imageMaxHeight = 1080;
  static const double? imageMaxWidth = 1920;

  static const String singleSelectionCalenderType =
      "SingleSelectionCalenderType";
  static const String rangeSelectionCalenderType = "rangeSelectionCalenderType";

  static const String appDateFormatWithTime = 'MMM dd, yyyy, hh:mm a';
  static const String cashCoinDateFormatWithTime = 'dd MMM yyyy, hh:mm a';
  static const String appDateFormat = 'MMM dd, yyyy';

  static const int pincodeMaxLength = 6;
  static const String mobileNoPrefix = '+91 - ';
  static const String fromPushNotification="fromPushNotification";
  static const String fromNotificationActiveTab="fromNotificationActiveTab";
  static const String fromDashboard="fromDashboard";
  static const int pageSize = 50;
  static const int solarProjectAddressInputMaxLength = 250;
  static const int solarProjectNameInputMaxLength = 50;
  static const String approved = "approved";
  static const String inProgress = "in progress";
  static const String rejected = "rejected";
  static const String gemSupportTrmCnd = 'Gem Support';
  static const String tenderTrmCnd = 'Tender'; // for help and support api payload
// for help and support api payload
}