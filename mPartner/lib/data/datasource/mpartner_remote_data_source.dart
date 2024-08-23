import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

import '../../../data/models/user_profile_model.dart';
import '../../../network/api_constants.dart';
import '../../error/failure.dart';
import '../../presentation/screens/ismart/registersales/secondarysales/components/serial_number_existance_model.dart';
import '../../presentation/screens/ismart/registersales/uimodels/customer_info.dart';
import '../../presentation/screens/network_management/dealer_electrician/components/common_network_utils.dart';
import '../../presentation/screens/product_history_tnc/model/purchase_product_history_request_model.dart';
import '../../presentation/screens/product_history_tnc/model/purchase_product_history_response_model.dart';
import '../../state/contoller/auth_contoller.dart';
import '../../state/contoller/cash_summary_controller.dart';
import '../../state/contoller/language_controller.dart';
import '../../state/contoller/tertiary_sales_combo_controller.dart';
import '../../state/contoller/user_data_controller.dart';
import '../../utils/app_constants.dart';
import '../../utils/localdata/language_constants.dart';
import '../../utils/requests.dart';
import '../models/battery_management_address_model.dart';
import '../models/battery_management_city_list.dart';
import '../models/battery_management_state_list_model.dart';
import '../models/booked_trip_details_model.dart';
import '../models/booking_response_model.dart';
import '../models/cash_coin_excel_model.dart';
import '../models/cash_history_model.dart';
import '../models/cash_redemption_options_model.dart';
import '../models/cash_summary_model.dart';
import '../models/catalogue_model.dart';
import '../models/coin_balance_pan_check.dart';
import '../models/coin_history_model.dart';
import '../models/coin_redemption_options_model.dart';
import '../models/coin_to_cashback_conversion_model.dart';
import '../models/coin_to_cashback_conversion_submit.dart';
import '../models/coins_summary_model.dart';
import '../models/company_info_model.dart';
import '../models/consumer_emi_log_model.dart';
import '../models/consumer_emi_send_otp.dart';
import '../models/consumer_emi_sm_ro_details.dart';
import '../models/consumer_emi_verify_otp.dart';
import '../models/create_otp_response.dart';
import '../models/credit_debit_note_model.dart';
import '../models/distributor_ledger_model.dart';
import '../models/feedback_answer_model.dart';
import '../models/fse_acknowledge_model.dart';
import '../models/fse_agreement_create_otp_model.dart';
import '../models/fse_agreement_model.dart';
import '../models/fse_agreement_verify_otp_model.dart';
import '../models/get_alert_notification_model.dart';
import '../models/get_customer_list_model.dart';
import '../models/get_dealer_list_model.dart';
import '../models/get_electrician_list_model.dart';
import '../models/get_sale_details_list_model.dart';
import '../models/get_sale_type_repsonse.dart';
import '../models/get_tertiary_bulk_details_list_model.dart';
import '../models/help_support_send_suggestion_model.dart';
import '../models/hkva_item_model.dart';
import '../models/homepage_banners_model.dart';
import '../models/ismart_offers_model.dart';
import '../models/language_model.dart';
import '../models/loginflow_banner_model.dart';
import '../models/luminous_videos_model.dart';
import '../models/network_management_model/dealer_electrician_details_model.dart';
import '../models/network_management_model/dealer_electrician_status_data_model.dart';
import '../models/network_management_model/state_city_district_info.dart';
import '../models/new_warranty_model.dart';
import '../models/notification/fcm_token_data_model.dart';
import '../models/notification/notification_details_model.dart';
import '../models/notification/notification_list_model.dart';
import '../models/notification/read_notification_detail_on_id_model.dart';
import '../models/notification/txn_details_model.dart';
import '../models/otp_model.dart';
import '../models/pinelab_get_balance_point_model.dart';
import '../models/pinelab_send_otp_model.dart';
import '../models/pinelab_verify_mobile_no_gst_model.dart';
import '../models/pinelab_verify_mobile_otp_gst.dart';
import '../models/pinelab_verify_otp_model.dart';
import '../models/pricelist_model.dart';
import '../models/primary_billing_model.dart';
import '../models/primary_report type_model.dart';
import '../models/product_wise_detail_model.dart';
import '../models/read_check_alert_notification_model.dart';
import '../models/relationship_model.dart';
import '../models/report_download_dealer_model.dart';
import '../models/report_type_model.dart';
import '../models/save_terms_condition_model.dart';
import '../models/scheme_homepage_model.dart';
import '../models/scheme_model.dart';
import '../models/secondary_report_distributor_model.dart';
import '../models/send_otp.dart';
import '../models/serial_no_existance_model.dart';
import '../models/splash_model.dart';
import '../models/survey_answer_model.dart';
import '../models/survey_question_model.dart';
import '../models/tertiary_customer_wise_detail_model.dart';
import '../models/tertiary_report_model.dart';
import '../models/tertiary_sales_userinfo_model.dart';
import '../models/traveller_model.dart';
import '../models/trip_model.dart';
import '../models/update_appversion_model.dart';
import '../models/update_userid_model.dart';
import '../models/upi_beneficiary_model.dart';
import '../models/upi_client_handshake_model.dart';
import '../models/upi_create_otp_model.dart';
import '../models/upi_tds_gst_model.dart';
import '../models/upi_transaction_model.dart';
import '../models/user_data_model.dart';
import '../models/user_gst_upload_model.dart';
import '../models/user_pan_upload_model.dart';
import '../models/user_passport_upload_model.dart';
import '../models/user_upload_profile_photo.dart';
import '../models/verify_otp_model.dart';
import '../models/verify_otp_tertiary_sales_model.dart';

abstract class BaseMPartnerRemoteDataSource {
  Future<Either<Failure, LoginFlowBanner>> getLoginFlowBanners();

  Future<Either<Failure, Splash>> getSplashScreenImage(String screenName);

  Future<Either<Failure, List<Language>>> getLanguageData();

  Future<Either<Failure, CashHistory>> getCashHistory(
      int pageNumber, int pageSize,
      {String? dealerCode});

  Future<Either<Failure, CoinHistory>> getCoinHistory(
      int pageNumber, int pageSize,
      {String? dealerCode});

  Future<Either<Failure, List<LuminousVideoModel>>> getLuminousVideos();

  Future<Either<Failure, List<LuminousVideoModel>>> getLuminousVideosViewCount(
      String videoId);

  Future<Either<Failure, List<LuminousChannelIconModel>>>
      getLuminousYoutubeChannelIcon();

  Future<Either<Failure, CashHistory>> getCashHistoryFilterData(
      String selectedSaleType,
      String selectedTransType,
      String selectCreditTransType,
      String selectDebitTransType,
      String fromDateVal,
      String toDateVal,
      String categoryType,
      String redemptionModeVal,
      int pageNumber,
      int pageSize,
      String searchKey,
      {String? dealerCode});

  Future<Either<Failure, CoinHistory>> getCoinHistoryFilterData(
      String selectedSaleType,
      String selectedTransType,
      String selectCreditType,
      String selectCreditTransType,
      String selectDebitTransType,
      String fromDateVal,
      String toDateVal,
      String categoryType,
      String redemptionModeVal,
      int pageNumber,
      int pageSize,
      String searchKey,
      {String? dealerCode});

  // Future<OTPResponseModel> createOTP(String url);
  Future<Either<Failure, List<UserData>>> getUserData(
      String phoneNumber, String userId, String token);

  Future<Either<Failure, SendOTP>> createOTP(String getPhoneNumber);

  Future<Either<Failure, SendOTP>> activeOTP(String getPhoneNumber);

  Future<Either<Failure, PurchaseProductHistoryResponseModel>> getPreviouslyPurchasedProduct(PurchaseProductHistoryRequestModel requestModel);


  Future<Either<Failure, VerifyOTP>> verifyOTP(String getId, String getOtp);

  Future<Either<Failure, List<Catalog>>> postCatalog(String customertype);

  Future<Either<Failure, List<Pricelist>>> postPricelist(String customerType, bool isHomeApiCall);

  Future<Either<Failure, List<Scheme>>> postScheme(String customertype);

  Future<Either<Failure, List<UserProfile>>> getUserProfile();

  Future<Either<Failure, FcmTokenResponse>> updateFcmToken(String fcmToken);

  Future<Either<Failure, NotificationListResponse>> fetchNotificationsList(
      String notificationType);

  Future<Either<Failure, NotificationDetailResponse>> fetchNotificationsDetails(
      String notificationId);

  Future<Either<Failure, TransactionDetailsResponse>>
      fetchingTransactionDetails(String txnId, String txnType);

  Future<Either<Failure, ReadNotificationDetailOnIdResponse>>
      postReadNotificationDetailOnId(String notificationId);

  Future<Either<Failure, List<SchemeHomepage>>> postSchemeHomepage(
      String customerType);

  Future<Either<Failure, List<SaleType>>> getSaleType();

  Future<Either<Failure, List<Dealer>>> getDealerList();

  Future<Either<Failure, List<Electrician>>> getElectricianList();

  Future<Either<Failure, List<SaleData>>>
      getIntermediaryProductDetailsBySerialNo(
          String electricianCode, String serialNo, String saleDate);

  Future<Either<Failure, List<SaleData>>> getProductDetailsBySerialNo(
      String dealerCode, String serialNo, String saleDate);

  Future<Either<Failure, List<CashRedemptionOptions>>>
      postCashRedemptionOptions();

  Future<Either<Failure, CoinsSummary>> postCoinsSummary();

  Future<Either<Failure, CashSummary>> postCashSummary();

  Future<Either<Failure, CoinRedemptionOptions>> postCoinRedemptionOptions();

  //Future<Either<Failure, CoinToCashbackConversionSubmit>> postCoinToCashbackSubmit();
  Future<Either<Failure, GetHkvaResponse>> getHkvaCombo(String serialNo);

  Future<Either<Failure, SendOTP>> postCreateOTPHkva();

  Future<Either<Failure, VerifyOtpTertiarySales>> postVerifyOtpHkva(String otp);

  Future<Either<Failure, ConsumerEmiSendOTP>> consumerEmiSendOTP(
      String getPhoneNumber);

  Future<Either<Failure, ConsumerEmiVerifyOTP>> consumerEmiverifyOTP(
      String getOtp, String getPhoneNumber);

  Future<Either<Failure, List<SmRoDetails>>> consumerEmiRoSmDetails(
      String pincode);

  Future<Either<Failure, ConsumerEmiLog>> consumerEmiLog(
      String pincode, String mobileNumber, String name, String callMode);

  Future<Either<Failure, List<HomepageBanners>>> postHomepageBanners(String type);

  Future<Either<Failure, List<ReportType>>> postReportType();

  Future<Either<Failure, List<PrimaryReportTypeModel>>> postPrimaryReportType();

  Future<Either<Failure, List<SecondaryReportDistributorModel>>>
      postSecondaryReportDistributor();

  Future<Either<Failure, List<ProductWiseDetails>>> getProductWiseDetails(
      String dealerCode);

  Future<Either<Failure, String>> getSecondaryReportPdfDistributor();

  Future<Either<Failure, TertiaryReport>> postTertiaryReport(String userId,
      {String productType = "",
      String status = "",
      String fromDate = AppConstants.FROM_DATE,
      toDate = AppConstants.TO_DATE});

  Future<String> getTertiaryReportPdfFile(String userId,
      {String productType = "",
      String status = "",
      String fromDate = AppConstants.FROM_DATE,
      toDate = AppConstants.TO_DATE,
      String customerPhone = ""});

  Future<Either<Failure, TertiaryCustomerWiseDetails>>
      postTertiaryCustomerWiseDetails(String customerPhone,
          {String productType = "",
          String status = "",
          String fromDate = AppConstants.FROM_DATE,
          toDate = AppConstants.TO_DATE});

  Future<Either<Failure, CreditDebitNote>> postCreditDebitNote(
      {String fromDate = "", toDate = ""});

  Future<Either<Failure, DistributorLedger>> postDistributorLedger(
      {String fromDate = "", toDate = ""});

  Future<Either<Failure, PrimaryBilling>> postPrimaryBillingReport(
      {String fromDate = "", toDate = ""});

  Future<Either<Failure, List<Customer>>> getCustomerList();

  Future<Either<Failure, ReportDownloadDealer>>
      postSecondaryReportDownloadDealer(String dealerId,
          {String fromDate = AppConstants.FROM_DATE,
          toDate = AppConstants.TO_DATE});

  Future<Either<Failure, SurveyQuestionsResponse>> postSurveyQuestions();

  Future<Either<Failure, SurveyAnswersResponse>> postSurveyAnswers(
      List<String> responseIds,
      List<String> userAnswers,
      List<QuestionType> responseQuestionTypes);

  Future<Either<Failure, GetAlertNotificationResponse>> postAlertNotification();

  Future<Either<Failure, ReadCheckAlertNotificationResponse>>
      postReadCheckAlertNotification(String id);

  Future<Either<Failure, FseAgreementResponse>> postFseAgreement();

  Future<Either<Failure, FeedBackAnswersResponse>> postFeedBackAnswers(
      String feedback, List<Asset> selectedImages);

  Future<Either<Failure, CompanyInfoModel>> getCompanyInfoDetails();

  Future<Either<Failure, SendSuggestion>> postSuggestion(
      String msg, List<String> imagePaths, String? previousRoute);

  Future<Either<Failure, BatteryManagementStateListModel>>
      getBatteryMgmtStateList();

  Future<Either<Failure, BatteryManagementCityListModel>>
      getBatteryMgmtCityList(String state);

  Future<Either<Failure, BatteryManagementAddressModel>>
      getBatteryMgmtAddressList(String state, String city);

  Future<Either<Failure, FseAgreementCreateOtpResponse>>
      getFseAgreementCreateOtp();

  Future<Either<Failure, FseAgreementVerifyOtpResponse>>
      getFseAgreementVerifyOtp(String otp);

  Future<Either<Failure, List<TertiarySaleData>>>
      getTertiaryBulkProductDetailsBySerialNo(
          CustomerInfo customerInfo, String serialNo);

  Future<Either<Failure, bool>> postTertiaryBulkPDFUpload(
      String filePath, String fileName);

  Future<Either<Failure, CreateOTPResponse>> postCreateOTPTertiaryBulk(
      CustomerInfo customerInfo, String serialNo);

  Future<Either<Failure, VerifyOtpTertiarySales>> postVerifyOtpTertiaryBulk(
    CustomerInfo customerInfo,
    String serialNo,
    String otp,
    String transId,
  );

  Future<Either<Failure, List<TertiarySaleData>>>
      getTertiaryBulkProductSaveDetailsBySerialNo(CustomerInfo customerInfo,
          String serialNo, String otp, String transId, String eW_ViaVerified);

  Future<Either<Failure, List<TripModel>>> postFetchTrips(String status);

  Future<Either<Failure, List<Traveller>>> getSavedTravellers(int tripID);

  // Future<Either<Failure, Traveller>> getTravellerInfo(String id);
  Future<Either<Failure, BookingResponseModel>> postBookTrip(
      List<Traveller> travellers, TripModel tripModel);

  // Future<Either<Failure, BookingResponseModel>> postFetchBookedTripDetails(
  // int tripId);
  Future<Either<Failure, String>> putTravellerMobileNumberUsingPassportNumber(
      String name, String relation, String mobileNo);

  Future<Either<Failure, String>> getWarrantyPdf(String serialNo);

  Future<Either<Failure, List<dynamic>>> fetchSellingDate(String serialNo);

  Future<Either<Failure, UpdateUserIdModel>> patchUpdateUser();

  Future<Either<Failure, PinelabSendOTP>> pinelabSendOTP();

  Future<Either<Failure, PinelabVerifyOTP>> pinelabverifyOTP(String getOtp);

  Future<Either<Failure, PinelabVerifyMobileNoGst>> pinelabVerifyMobileNoGst(
      String transferAmount);

  Future<Either<Failure, PinelabBalancePoint>> pinelabGetBalancePoint();

  Future<Either<Failure, PinelabVerifyMobileOtpGst>> pinelabVerifyMobileOtpGst(
      int transferAmount, String availableBalance);

  Future<Either<Failure, UserUploadProfilePhoto>> userUploadProfilePhoto(
      String imagePath);

  Future<Either<Failure, NewWarranty>> getWarrantyDetails(String serialNo);

  Future<Either<Failure, List<Relationship>>> postRelationships(String tripId);

  Future<List<String>> fetchImageUrls(int id);

  Future<List<Language>> getLanguages();

  Future<Either<Failure, CoinBalancePanCheck>> coinRedemptionCheck();

  Future<Either<Failure, UPIClientHandshakeModel>> UPIClientSecretHandshake();

  Future<Either<Failure, UPIBeneficiaryModel>> initialNumUpiVerification();

  Future<Either<Failure, UPITdsGstModel>> getUpiTdsGstCalculations(
      String amount);

  Future<Either<Failure, UPIOTPModel>> createOtpUPI();

  Future<Either<Failure, UPIOTPModel>> authenticateOtpUpi(String otp);

  Future<Either<Failure, UPITransactionModel>> upiTransaction(
      String enteredAmount,
      String ifsc,
      String vpaAvailable,
      UPIBeneficiaryModel beneficiaryDetails);

  Future<Either<Failure, BookedTripDetailsModel>> postFetchBookedTripDetails(
      String tripId);

  Future<Either<Failure, UserPanUploadModel>> userPanUpload(
      String imagePath, String panNumber);

  Future<Either<Failure, UserGstUploadModel>> userGstUpload(
      String imagePath, String gstNumber);

  Future<Either<Failure, UserPassportUploadModel>> userPassportUpload(
      String passportNo,
      String nationality,
      String gender,
      String firstName,
      String lastName,
      String placeOfIssue,
      String dateOfBirth,
      String birthPlace,
      String issueDate,
      String expiryDate,
      String passportFront,
      String passportBack);

  Future<ApiResponse> checkSerialNoExistence(
      String serialNo, String tertiarySalesType);

  Future<Either<Failure, CashCoinExcelModel>> getCashHistoryExcelData(
      String selectedSaleType,
      String selectedTransType,
      String selectCreditTransType,
      String selectDebitTransType,
      String fromDateVal,
      String toDateVal,
      String categoryType,
      String redemptionModeVal,
      int pageNumber,
      int pageSize,
      String searchKey,
      {String? dealerCode});

  Future<Either<Failure, CashCoinExcelModel>> getCoinHistoryExcelData(
      String selectedSaleType,
      String selectedTransType,
      String selectCreditType,
      String selectCreditTransType,
      String selectDebitTransType,
      String fromDateVal,
      String toDateVal,
      String categoryType,
      String redemptionModeVal,
      int pageNumber,
      int pageSize,
      String searchKey,
      {String? dealerCode});

  Future<Either<Failure, SaveTermsConditionResponse>> updateTermsCondition(
      String termsConditionId);

  Future<Either<Failure, bool>> clearPreTableData();

  Future<Either<Failure, UpdateAppVersionModel>> postUpdateAppVersion();
}

class MPartnerRemoteDataSource extends BaseMPartnerRemoteDataSource {
  UserDataController controller = Get.find();
  LanguageController languageController = Get.find();

  @override
  Future<Either<Failure, LoginFlowBanner>> getLoginFlowBanners() async {
    final Map<String, dynamic> body = {
      "user_Id": "",
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postLoginPageCardsEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(LoginFlowBanner.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, PurchaseProductHistoryResponseModel>> getPreviouslyPurchasedProduct(
      PurchaseProductHistoryRequestModel requestModel) async {
    final response = await Requests.sendPostRequest(
        ApiConstants.getPreviouslyPurchasedProduct, requestModel.toJson());
    if (response is! DioException && response.statusCode == 200) {
      return Right(PurchaseProductHistoryResponseModel.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, Splash>> getSplashScreenImage(String screenName) async {
    String language = languageController.language;

    final Map<String, dynamic> body = {
      "user_Id": "",
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "screen": screenName,
      "token": "",
      "device_Name": deviceName,
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "language": language,
      "screen_Name": screenName,
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_Version": ""
    };
    final response =
        await Requests.sendPostRequest(ApiConstants.postSplashEndPoint, body);

    if (response is! DioException && response.statusCode == 200) {
      return Right(Splash.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<Language>>> getLanguageData() async {
    final Map<String, dynamic> body = {
      "user_Id": controller.sapId.isNotEmpty ? controller.sapId : "",
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "device_Name": deviceName,
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_Version": ""
    };

    final response =
        await Requests.sendPostRequest(ApiConstants.postLanguageEndPoint, body);

    if (response is! DioException && response.statusCode == 200) {
      return Right(List<Language>.from((response.data["data"] as List).map(
        (e) => Language.fromJson(e),
      )));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, CashHistory>> getCashHistory(
      int pageNumber, int pageSize,
      {String? dealerCode}) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "userId": sapId,
      "user_Id": sapId,
      "transaction_User_Id":
          (dealerCode == null) ? sapId : dealerCode /*"9900000062"*/,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "userType": "",
      "transactionType": "",
      "creditVerificationType": "",
      "debitVerificationType": "",
      "fromdate": "",
      "todate": "",
      "verificationType": "",
      "category": "",
      "redemptionmode": "",
      "pageSize": pageSize,
      "pageNumber": pageNumber,
      "SearchKey": ""
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postCashHistoryEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      var responseModel = CashHistory.fromJson(response.data);
      if (responseModel.status == 0) {
      } else {}
      return Right(CashHistory.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, CashHistory>> getCashHistoryFilterData(
      String selectedSaleType,
      String selectedTransType,
      String selectCreditTransType,
      String selectDebitTransType,
      String fromDateVal,
      String toDateVal,
      String categoryType,
      String redemptionModeVal,
      int pageNumber,
      int pageSize,
      String searchKey,
      {String? dealerCode}) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "userId": sapId,
      "user_Id": sapId,
      "transaction_User_Id":
          (dealerCode == null) ? sapId : dealerCode /*"9900000062"*/,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "userType": selectedSaleType,
      "transactionType": selectedTransType,
      "creditVerificationType": selectCreditTransType,
      "debitVerificationType": selectDebitTransType,
      "fromdate": fromDateVal,
      "todate": toDateVal,
      "category": categoryType,
      "redemptionmode": redemptionModeVal,
      "pageSize": pageSize,
      "pageNumber": pageNumber,
      "SearchKey": searchKey,
    };
    final response = await Requests.sendPostRequest(
        ApiConstants.postCashHistoryEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(CashHistory.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, CoinHistory>> getCoinHistory(
      int pageNumber, int pageSize,
      {String? dealerCode}) async {
    Locale locale = await getLocale();
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "transaction_User_Id":
          (dealerCode == null) ? sapId : dealerCode /*"9900000062"*/,
      "token": "",
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "device_Name": deviceName,
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "language": locale.languageCode,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "startDate": "",
      "endDate": "",
      "search_Key": "",
      "transactionType": "",
      "CreditType": "",
      "category": "",
      "redemptionMode": "",
      "creditStatus": "",
      "debitStatus": "",
      "SaleType": "",
      "pageSize": pageSize,
      "pageNo": pageNumber
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postCoinHistoryEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(CoinHistory.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<LuminousVideoModel>>> getLuminousVideos() async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
    };
    final response =
        await Requests.sendPostRequest(ApiConstants.postLuminousVideos, body);
    List<LuminousVideoModel> videosData = [];
    if (response is! DioException && response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.data);
      final List<dynamic> items = data['items'];

      videosData = items.map<LuminousVideoModel>((item) {
        final snippet = item['snippet'];
        final thumbnails = snippet['thumbnails'];
        final resourceId = snippet['resourceId'];
        final description = snippet['description'];
        final videoId = resourceId['videoId'];
        final thumbnailURL = thumbnails.containsKey('standard')
            ? thumbnails['standard']
            : thumbnails.containsKey('default')
                ? thumbnails['default']
                : null;
        return LuminousVideoModel(
          videoId: resourceId['videoId'],
          thumbnail: thumbnailURL['url'],
          title: snippet['title'],
          viewCount: '',
          description: snippet['description'],
        );
      }).toList();
      return Right(videosData);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<LuminousVideoModel>>> getLuminousVideosViewCount(
      String videoId) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "id": videoId,
      "token": "",
      "device_Name": "",
      "os_Version_Name": "",
      "os_Version_Code": "",
      "ip_Address": "",
      "language": "",
      "screen_Name": "",
      "network_Type": "",
      "network_Operator": "",
      "time_Captured": "",
      "browser": "",
      "browser_Version": "",
    };
    final response = await Requests.sendPostRequest(
        ApiConstants.postLuminousVideosViewsCount, body);
    List<LuminousVideoModel> videosData = [];
    if (response is! DioException && response.statusCode == 200) {
      // final List<dynamic> items = response.data['items'];
      final Map<String, dynamic> data = json.decode(response.data);
      final List<dynamic> items = data['items'];

      videosData = items.map<LuminousVideoModel>((item) {
        final statistics = item['statistics'];
        final viewCount = statistics['viewCount'];
        return LuminousVideoModel(
          videoId: '',
          thumbnail: '',
          title: '',
          viewCount: statistics['viewCount'],
          description: '',
        );
      }).toList();

      return Right(videosData);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<LuminousChannelIconModel>>>
      getLuminousYoutubeChannelIcon() async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
    };
    final response = await Requests.sendPostRequest(
        ApiConstants.postLuminousChannelIcon, body);
    List<LuminousChannelIconModel> videosData = [];
    print('YT chennel');
    if (response is! DioException && response.statusCode == 200) {
      print('YT chennel1 ${response.data}');
      // final List<dynamic> items = response.data['items'];
      final Map<String, dynamic> data = json.decode(response.data);
      final List<dynamic> items = data['items'];

      videosData = items.map<LuminousChannelIconModel>((item) {
        final snippet = item['snippet'];
        final thumbnails = snippet['thumbnails'];
        final thumbnailURL = thumbnails.containsKey('default')
            ? thumbnails['default']
            : thumbnails.containsKey('medium')
                ? thumbnails['default']
                : null;
        return LuminousChannelIconModel(
          thumbnail: thumbnailURL['url'],
        );
      }).toList();

      print('YT chennel1222 ${videosData}');
      return Right(videosData);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, CoinHistory>> getCoinHistoryFilterData(
      String selectedSaleType,
      String selectedTransType,
      String selectCreditType,
      String selectCreditTransType,
      String selectDebitTransType,
      String fromDateVal,
      String toDateVal,
      String categoryType,
      String redemptionModeVal,
      int pageNumber,
      int pageSize,
      String searchKey,
      {String? dealerCode}) async {
    String sapId = controller.sapId;
    String language = languageController.language;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "transaction_User_Id":
          (dealerCode == null) ? sapId : dealerCode /*"9900000062"*/,
      "token": "",
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
      "startDate": fromDateVal,
      "endDate": toDateVal,
      "search_Key": searchKey,
      "transactionType": selectedTransType,
      "CreditType": selectCreditType,
      "category": categoryType,
      "redemptionMode": redemptionModeVal,
      "creditStatus": selectCreditTransType,
      "debitStatus": selectDebitTransType,
      "SaleType": selectedSaleType,
      "pageSize": pageSize,
      "pageNo": pageNumber
    };
    final response = await Requests.sendPostRequest(
        ApiConstants.postCoinHistoryEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(CoinHistory.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<UserData>>> getUserData(
      String phoneNumber, String userId, String token) async {
    String language = languageController.language;

    final Map<String, dynamic> body = {
      "user_Id": userId,
      "dob": "",
      "name": "",
      "relationShip": "",
      "birthday": "",
      "anniversaryDate": "",
      "secondaryDevice1": "",
      "secondaryDevice2": "",
      "businessName": "",
      "message": "",
      "profileImg": "",
      "Phone_No": phoneNumber,
      "token": token,
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
      "browser_version": "",
      "value": ""
    };
    final response = await Requests.sendPostRequest(
        ApiConstants.postUserDataEndPoint, body,
        userID: userId);
    if (response is! DioException && response.statusCode == 200) {
      return Right(List<UserData>.from((response.data["data"] as List).map(
        (e) => UserData.fromJson(e),
      )));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, FcmTokenResponse>> updateFcmToken(
      String fcmToken) async {
    String sapId = controller.sapId;
    String token = controller.token;

    final Map<String, dynamic> requestParam = {
      "fcmToken": fcmToken,
      "token": token,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
    };
    logger.i('updateFcmToken-> $requestParam');
    final response = await Requests.sendPostRequest(
        ApiConstants.updateFcmTokenEndPoint, requestParam);
    logger.i('response-> $response');
    if (response is! DioException && response.statusCode == 200) {
      return Right(FcmTokenResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, SendOTP>> createOTP(String getPhoneNumber) async {
    final Map<String, dynamic> body = {
      "user_Id": "",
      "token": "token",
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "otp": "",
      "os_version_code": osVersionCode,
      "loginUserId": "",
      "device_name": deviceName,
      "phone_number": getPhoneNumber,
      "type": "",
      "mode": AppConstants.createOTPMode,
      "transactionid": "",
      "electrician_Mapping_Flag": ""
    };
    final response =
        await Requests.sendPostRequest(ApiConstants.postOTPEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(OTPResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, SendOTP>> activeOTP(String getPhoneNumber) async {
    final Map<String, dynamic> body = {
      "user_Id": "",
      "channel": "App",
      "os_Type": "android",
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Version_Code": osVersionCode,
      "device_Name": deviceName,
      "phone_Number": getPhoneNumber,
      "type": "",
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postActiveOTPEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(OTPResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, VerifyOTP>> verifyOTP(
      String getId, String getOtp) async {
    final Map<String, dynamic> body = {
      "user_Id": getId,
      "token": "token",
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "otp": getOtp,
      "os_version_code": osVersionCode,
      "loginUserId": "",
      "device_name": deviceName,
      "phone_number": "",
      "type": "",
      "mode": AppConstants.createOTPMode,
      "transactionid": "",
      "electrician_Mapping_Flag": ""
    };
    final response = await Requests.sendPostRequest(
        ApiConstants.postOTPAuthEndPoint, body,
        userID: getId);
    if (response is! DioException && response.statusCode == 200) {
      var obj = VerifyOTP.fromJson(response.data);
      return Right(obj);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, List<UserProfile>>> getUserProfile() async {
    String token = controller.token;
    String sapId = controller.sapId;
    String phone = controller.phoneNumber;
    String language = languageController.language;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "DOB": "",
      "anniversaryDate": "",
      "secondaryDevice1": "",
      "secondaryDevice2": "",
      "businessName": "",
      "message": "",
      "profileImg": "",
      "phoneNumber": phone,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "Device_Name": deviceName,
      "Os_Version_Name": osVersionName,
      "Os_Version_Code": osVersionCode,
      "Ip_Address": ipAddress,
      "language": language,
      "Screen_Name": "",
      "Network_Type": networkType,
      "Network_Operator": networkOperator,
      "Time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_version": "",
      "Name": "",
      "Birthday": "",
      "RelationShip": ""
    };
    final response = await Requests.sendPostRequest(
        ApiConstants.postUserProfileEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      logger.d("[RA_LOG] : getUserProfile() success $response");
      return Right(List<UserProfile>.from(
          (response.data["data"] as List).map((e) => UserProfile.fromJson(e))));
    } else {
      logger.e("[RA_LOG] : getUserProfile() err $response");
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, List<Catalog>>> postCatalog(
      String customertype) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "customertype": customertype,
      "parentid": "",
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
      "browser_Version": ""
    };
    print("RA: Catalog body: ${body}");
    print("RA: Catalog Endpoints: ${ApiConstants.postCatalogEndPoint}");
    final response =
        await Requests.sendPostRequest(ApiConstants.postCatalogEndPoint, body);
    print("RA: Catalog statusCode: ${response.statusCode}");
    print("RA: Catalog statusMessage: ${response.statusMessage}");
    print("RA: Catalog status123: ${response.data["status"]}");
    if (response is! DioException && response.statusCode == 200) {
      if (response.data["data"] != null) {
        return Right(List<Catalog>.from(
            (response.data["data"] as List).map((e) => Catalog.fromJson(e))));
      } else {
        return const Right([]);
      }
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<Pricelist>>> postPricelist(
      String customerType, bool isHomeApiCall) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "customertype": customerType,
      "parentid": "",
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
      "browser_Version": ""
    };

    final response = await Requests.sendPostRequest(
        isHomeApiCall ? ApiConstants.postPricelistHomepageEndpoint : ApiConstants.fetchAllPriceListEndpoint, body);
    if (response is! DioException && response.statusCode == 200) {
      if (response.data["data"] != null) {
        return Right(List<Pricelist>.from(
            (response.data["data"] as List).map((e) => Pricelist.fromJson(e))));
      } else {
        return const Right([]);
      }
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<Scheme>>> postScheme(String customertype) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "customertype": customertype,
      "parentid": "",
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
      "browser_Version": ""
    };
    print("body---->${body}");
    final response =
        await Requests.sendPostRequest(ApiConstants.postSchemeEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      print(response);
      if (response.data["data"] != null) {
        return Right(List<Scheme>.from(
            (response.data["data"] as List).map((e) => Scheme.fromJson(e))));
      } else {
        return const Right([]);
      }
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, List<SchemeHomepage>>> postSchemeHomepage(
      String customertype) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    final Map<String, dynamic> body = {
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
      "language": language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_Version": "",
      "customertype": customertype
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postSchemeHomepageEndpoint, body);
    if (response is! DioException && response.statusCode == 200) {
      if (response.data["data"] != null) {
        return Right(List<SchemeHomepage>.from((response.data["data"] as List)
            .map((e) => SchemeHomepage.fromJson(e))));
      } else {
        return const Right([]);
      }
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<CashRedemptionOptions>>>
      postCashRedemptionOptions() async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    final Map<String, dynamic> body = {
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
      "language": language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_Version": ""
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postCashRedemptionOptionsEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(List<CashRedemptionOptions>.from(
          (response.data["data"] as List)
              .map((e) => CashRedemptionOptions.fromJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<SaleType>>> getSaleType() async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "userId": sapId,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postGetSaleTypeEndPoint, body);

    if (response is! DioException && response.statusCode == 200) {
      print('data${response.data["data"]}');
      return Right(List<SaleType>.from((response.data["data"] as List).map(
        (e) => SaleType.fromJson(e),
      )));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<Dealer>>> getDealerList() async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "userId": sapId,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postGetDealerListEndPoint, body);
    print(response);
    if (response is! DioException && response.statusCode == 200) {
      return Right(List<Dealer>.from(
          (response.data["data"] as List).map((e) => Dealer.fromJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<Electrician>>> getElectricianList() async {
    try {
      final jsonString = await rootBundle
          .loadString('assets/mpartner/json/electrician_list.json');
      final Map<String, dynamic> response = json.decode(jsonString);

      print(response);

      if (response['status'] == "200" && response['data'] != null) {
        final List<Electrician> electricians = List<Electrician>.from(
            (response['data'] as List).map((e) => Electrician.fromJson(e)));
        return Right(electricians);
      } else {
        return Left(
            ServerFailure(response['message'] ?? 'Error fetching data'));
      }
    } catch (e) {
      print('Error occurred while reading from the JSON file: $e');
      return Left(ServerFailure('Failed to load electricians data'));
    }
  }

  @override
  Future<Either<Failure, List<SaleData>>> getProductDetailsBySerialNo(
      String dealerCode, String serialNo, String saleDate) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;
    String mobile = controller.phoneNumber;

    final Map<String, dynamic> body = {
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
      "language": language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "serialNo": serialNo,
      "saleDate": saleDate,
      "mobileNo": mobile,
      "dealer_Code": dealerCode,
      "transactionType": AppConstants.productDetailsTransactionType,
      "userType": "",
      "verificationType": "",
      "saleType": "",
      "dis_Dlr_Code": sapId,
      "scheme": "",
      "fromDate": "",
      "toDate": "",
      "start_Date": "",
      "end_Date": ""
    };

    print(body);
    final response = await Requests.sendPostRequest(
        ApiConstants.postSaleDetailsListEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      print(response);
      return Right(List<SaleData>.from(
          (response.data["data1"] as List).map((e) => SaleData.fromJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<SaleData>>>
      getIntermediaryProductDetailsBySerialNo(
          String electricianCode, String serialNo, String saleDate) async {
    try {
      final jsonString = await rootBundle.loadString(
          'assets/mpartner/json/intermediary_product_details_list.json');
      final Map<String, dynamic> response = json.decode(jsonString);

      print(response);

      if (response['status'] == "200" && response['data'] != null) {
        final List<SaleData> productList = List<SaleData>.from(
            (response['data1'] as List).map((e) => SaleData.fromJson(e)));
        return Right(productList);
      } else {
        return Left(
            ServerFailure(response['message'] ?? 'Error fetching data'));
      }
    } catch (e) {
      print('Error occurred while reading from the JSON file: $e');
      return Left(
          ServerFailure('Failed to load electricians products list data'));
    }
  }

  Future<Either<Failure, GetHkvaResponse>> getHkvaCombo(String serialNo) async {
    TertiarySalesHKVAcombo c = Get.find();
    TertiarySalesUserInfo userInfo = c.userInfo.value;
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    final Map<String, dynamic> body = {
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
      "language": language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "balance_Value": "",
      "productSerialNo": serialNo,
      "distcode": sapId,
      "saleDate": userInfo.date,
      "custPhone":userInfo.mobileNumber.split(' - ')[1],
      "eW_isVerified": true,
      "eW_ViaVerified": "",
      "eW_VerifiedBy": "",
      "eW_OTP": "",
      "eW_IMEI": deviceId,
      "transID": "",
      "id": 0,
      "catType": c.hkvaItemModels.isEmpty ? "Inverter" : "Battery",
    };
    final response =
        await Requests.sendPostRequest(ApiConstants.postHkvaCombination, body);
    if (response is! DioException && response.statusCode == 200) {
      List<HkvaItemModel> hkvaList = [];

      if (response.data["data"] is List) {
        hkvaList = (response.data["data"] as List)
            .map((item) => HkvaItemModel.fromJson(item))
            .toList();
      }

      return Right(GetHkvaResponse(
        message: response.data["message"] ?? "No response",
        status: response.data["status"] ?? "404",
        token: response.data["token"],
        data: hkvaList,
        data1: response.data["data1"],
      ));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, SendOTP>> postCreateOTPHkva() async {
    String token = controller.token;
    String sapId = controller.sapId;
    TertiarySalesHKVAcombo c = Get.find();

    TertiarySalesUserInfo userInfo = c.userInfo.value;
    List<String> serialNumbers = [];

    for (int i = 0; i < c.hkvaItemModels.length; i++) {
      if (c.hkvaItemModels[i].serial.isNotEmpty) {
        serialNumbers.add(c.hkvaItemModels[i].serial);
      }
    }

    serialNumbers.join(',');

    final Map<String, dynamic> body = {
      "customerCode": sapId,
      "user_Id": sapId,
      "serialNo": serialNumbers.join(','),
      "mobileNo": userInfo.mobileNumber.split(' - ')[1],
      "imeiNumber": deviceId,
      "osVersion": osVersionName,
      "deviceName": deviceName,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "appTypeName": AppConstants.appTypeNamePSB,
      "token": token,
    };

    final response =
        await Requests.sendPostRequest(ApiConstants.postHkvaCreateOtp, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(OTPResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, VerifyOtpTertiarySales>> postVerifyOtpHkva(
      String otp) async {
    String token = controller.token;
    String sapId = controller.sapId;
    TertiarySalesHKVAcombo c = Get.find();
    TertiarySalesUserInfo userInfo = c.userInfo.value;

    final Map<String, dynamic> body = {
      "customerCode": sapId,
      "user_Id": sapId,
      "serialNo": c.hkvaItemModels.first.serial,
      "mobileNo": userInfo.mobileNumber.split(' - ')[1],
      "imeiNumber": deviceId,
      "osVersion": osVersionName,
      "deviceName": deviceName,
      "otp": otp,
      "appTypeName": AppConstants.appTypeNamePSB,
      "token": AppConstants.salesStaticToken,
      //add requested by backend Team
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "transID": userInfo.transId
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postHkvaVerifyOtpEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(VerifyOtpTertiarySales.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, CoinToCashbackConversion>>
      postCoinsToCashbackConversion(
          String coins, String available, int redeemable) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String stringWithoutCommas = available.replaceAll(',', '');
    int availableCoin = int.parse(stringWithoutCommas);
    String language = languageController.language;

    final Map<String, dynamic> body = {
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
      "language": language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "enterCoins": coins,
      "availableCoins": availableCoin,
      "redeemableCoins": redeemable
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postCoinToCashbackConversionEndPoint, body);
    print("RESPONSE STATUS CODE CONVERSION ${response.statusCode}");
    if (response is! DioException && response.statusCode == 200) {
      return Right(CoinToCashbackConversion.fromJson(response.data["data"]));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, CoinsSummary>> postCoinsSummary(
      {String? dealerCode, String fromDate = "", String toDate = ""}) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "transaction_User_Id":
          (dealerCode == null) ? sapId : dealerCode /*"9900000062"*/,
      "token": token,
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
      "fromDate": fromDate,
      "toDate": toDate
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postCoinsSummaryEndpoint, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(CoinsSummary.fromJson(response.data["data"][0]));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, CashSummary>> postCashSummary(
      {String? dealerCode, String fromDate = "", String toDate = ""}) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "transaction_User_Id":
          (dealerCode == null) ? sapId : dealerCode /*"9900000062"*/,
      "token": token,
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
      "fromDate": fromDate,
      "toDate": toDate
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postCashSummaryEndpoint, body);
    if (response is! DioException && response.statusCode == 200) {
      logger.d('get allocate points by mode: ${response.data}');
      return Right(CashSummary.fromJson(response.data["data"][0]));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, CoinToCashbackConversionSubmit>>
      postCoinToCashbackSubmit(int coinsForCashback, int conversionRate) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    final Map<String, dynamic> body = {
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
      "language": language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "enterCoins": coinsForCashback,
      "conversionRate": conversionRate
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postCoinToCashbackConversionSubmitEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      print("COIN TO CASHBACK SUBMIT DATA ${response.data["data"]}");
      return Right(
          CoinToCashbackConversionSubmit.fromJson(response.data["data"]));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, CoinRedemptionOptions>>
      postCoinRedemptionOptions() async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;
    final Map<String, dynamic> body = {
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
      "language": language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postCoinRedemptionOptionsEndpoint, body);
    if (response is! DioException && response.statusCode == 200) {
      print("COIN OPTIONS DATA ${response.data["data"]}");
      return Right(CoinRedemptionOptions.fromJson(response.data["data"]));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, ConsumerEmiSendOTP>> consumerEmiSendOTP(
      String getPhoneNumber) async {
    String token = controller.token;
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "otp": "",
      "os_Version_Code": osVersionCode,
      "loginUserId": sapId,
      "device_Name": deviceName,
      "phone_Number": getPhoneNumber,
      "type": "",
      "mode": "",
      "transactionId": "",
      "electrician_Mapping_Flag": ""
    };
    final response = await Requests.sendPostRequest(
        ApiConstants.postConsumerEmiCreateOtp, body);
    if (response is! DioException && response.statusCode == 200) {
      print(' data${response.data}');
      return Right(ConsumerEmiOTPResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, ConsumerEmiVerifyOTP>> consumerEmiverifyOTP(
      String getOtp, String getPhoneNumber) async {
    String token = controller.token;
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "otp": getOtp,
      "os_Version_Code": osVersionCode,
      "loginUserId": sapId,
      "device_Name": deviceName,
      "phone_Number": getPhoneNumber,
      "type": "",
      "mode": "",
      "transactionId": "",
      "electrician_Mapping_Flag": ""
    };
    final response = await Requests.sendPostRequest(
        ApiConstants.postConsumerEmiVerifyOtp, body);
    print("data ${response.data}");
    if (response is! DioException && response.statusCode == 200) {
      return Right(ConsumerEmiVerifyOTP.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<SmRoDetails>>> consumerEmiRoSmDetails(
      String pincode) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    final Map<String, dynamic> body = {
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
      "language": language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "pinCode": pincode
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postConsumerEmiGetRoSmDetails, body);
    print("data ${response.data}");
    if (response is! DioException && response.statusCode == 200) {
      List<SmRoDetails> detailsList = (response.data["data"] as List)
          .map((e) => SmRoDetails.fromJson(e))
          .toList();

      detailsList.forEach((details) {
        print("SmRoDetails: $details");
      });

      return Right(detailsList);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, ConsumerEmiLog>> consumerEmiLog(
      String pincode, String mobileNumber, String name, String callMode) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    final Map<String, dynamic> body = {
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
      "language": language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "pincode": pincode,
      "mobileNumber": mobileNumber,
      "name": name,
      "call_Mode": callMode
    };

    final response =
        await Requests.sendPostRequest(ApiConstants.postConsumerEmiLog, body);
    print("data ${response.data}");
    if (response is! DioException && response.statusCode == 200) {
      return Right(ConsumerEmiLog.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<HomepageBanners>>> postHomepageBanners(String type) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    final Map<String, dynamic> body = {
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
      "language": language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_Version": "",
      "type": type
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postHomepageBannersEndpoint, body);
    if (response is! DioException && response.statusCode == 200) {
      print(
          "Homepage banners data ${response.data["data"][0]['bannercard_data']}");
      return Right(List<HomepageBanners>.from((response.data["data"][0]
              ['bannercard_data'])
          .map((e) => HomepageBanners.fromJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<ReportType>>> postReportType() async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "userId": sapId,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
    };

    final response =
        await Requests.sendPostRequest(ApiConstants.postGetReportType, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(List<ReportType>.from(
          (response.data["data"]).map((e) => ReportType.fromJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<PrimaryReportTypeModel>>>
      postPrimaryReportType() async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "userId": sapId,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postGetPrimaryReportType, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(List<PrimaryReportTypeModel>.from((response.data["data"])
          .map((e) => PrimaryReportTypeModel.fromJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, SecondaryReport>>
      postSecondarySummaryReportDistributor(
          {String dealerCode = "",
          String productType = "",
          String status = "",
          String fromDate = AppConstants.FROM_DATE,
          toDate = AppConstants.TO_DATE}) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "disId": sapId,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "dealer_code": dealerCode,
      "product_type": productType,
      "status": status,
      "fromDate": fromDate,
      "toDate": toDate
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postSecondarySalesReportDistributor, body);
    if (response is! DioException && response.statusCode == 200) {
      final secondaryReport = SecondaryReport.fromJson(response.data);
      return Right(secondaryReport);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<SecondaryReportDistributorModel>>>
      postSecondaryReportDistributor(
          {String dealerCode = "",
          String productType = "",
          String status = "",
          String fromDate = AppConstants.FROM_DATE,
          toDate = AppConstants.TO_DATE}) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "disId": sapId,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "dealer_code": dealerCode,
      "product_type": productType,
      "status": status,
      "fromDate": fromDate,
      "toDate": toDate
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postSecondarySalesReportDistributor, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(List<SecondaryReportDistributorModel>.from(
          (response.data["data"])
              .map((e) => SecondaryReportDistributorModel.fromJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, CompanyInfoModel>> getCompanyInfoDetails() async {
    String token = controller.token;
    String sapId = controller.sapId;

    Locale locale = await getLocale();

    final Map<String, dynamic> body = {
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
      "language": locale.languageCode,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_Version": ""
    };
    final response =
        await Requests.sendPostRequest(ApiConstants.postContactUsDetails, body);
    print("data ${response.data}");
    if (response is! DioException && response.statusCode == 200) {
      return Right(CompanyInfoModel.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, List<ProductWiseDetails>>> getProductWiseDetails(
      String dealerCode,
      {String distributorCode = "",
      String productType = "",
      String status = "",
      String fromDate = AppConstants.FROM_DATE,
      toDate = AppConstants.TO_DATE}) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "disCode": distributorCode,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "dealer_code": dealerCode,
      "product_Type": productType,
      "status": status,
      "fromDate": fromDate,
      "toDate": toDate
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postProductWiseDetails, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(List<ProductWiseDetails>.from(
          (response.data["data"]).map((e) => ProductWiseDetails.fromJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, SendSuggestion>> postSuggestion(
      msg, imagePaths, previousRoute) async {
    String userId = controller.sapId;

    String name = controller.userProfile[0].phone;
    String email = controller.userProfile[0].email;
    List<dynamic> multipartImageFileList = [];
    List<String> fileNames = [];

    for (int i = 1; i < imagePaths.length; i++) {
      multipartImageFileList.add(
        await MultipartFile.fromFile(imagePaths[i],
            filename: File(imagePaths[i]).path.split("/").last),
      );
      fileNames.add(File(imagePaths[i]).path.split("/").last);
    }

    FormData formData = FormData.fromMap({
      "user_Id": userId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "Name": name,
      "Email": email,
      "Message": msg,
      "FileNames": fileNames,
      'ContactusImages': multipartImageFileList,
      'PageName': previousRoute
    });

    final response = await Requests.sendPostForm(
      ApiConstants.postSuggestion,
      formData,
      userId,
    );
    logger.d(formData.fields);

    if (response is! DioException && response.statusCode == 200) {
      return Right(SendSuggestion.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, String>> getSecondaryReportPdfDistributor(
      {String dealerCode = "",
      String productType = "",
      String status = "",
      String fromDate = AppConstants.FROM_DATE,
      toDate = AppConstants.TO_DATE}) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "disId": sapId,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "dealer_code": dealerCode,
      "product_type": productType,
      "status": status,
      "fromDate": fromDate,
      "toDate": toDate
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postSecondaryReportPDFDownload, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(response.data['data']);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, TertiaryReport>> postTertiaryReport(String userId,
      {String productType = "",
      String status = "",
      String fromDate = AppConstants.FROM_DATE,
      toDate = AppConstants.TO_DATE,
      String customerPhone = "",
      String search = "",
      bool showHistoricData = false}) async {
    final Map<String, dynamic> body = {
      "userId": userId,
      "user_Id": userId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "customerPhone": customerPhone,
      "product_Type": productType,
      "status": status,
      "fromDate": fromDate,
      "toDate": toDate,
      "search": search,
      "showHistoricData": showHistoricData
    };

    final response =
        await Requests.sendPostRequest(ApiConstants.postTertiaryReport, body);
    if (response is! DioException && response.statusCode == 200) {
      final tertiaryReport = TertiaryReport.fromJson(response.data);

      return Right(tertiaryReport);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<String> getTertiaryReportPdfFile(String userId,
      {String productType = "",
      String status = "",
      String fromDate = AppConstants.FROM_DATE,
      toDate = AppConstants.TO_DATE,
      String customerPhone = "",
      String search = "",
      bool showHistoricData = false}) async {
    final Map<String, dynamic> body = {
      "userId": userId,
      "user_Id": userId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "customerPhone": customerPhone,
      "product_Type": productType,
      "status": status,
      "fromDate": fromDate,
      "toDate": toDate,
      "search": search,
      "showHistoricData": showHistoricData
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postTertiaryReportPdfDownload, body);
    if (response is! DioException && response.statusCode == 200) {
      final tertiaryReport = response.data;

      return tertiaryReport["data"] ?? "";
    } else {
      return "";
    }
  }

  @override
  Future<Either<Failure, BatteryManagementStateListModel>>
      getBatteryMgmtStateList() async {
    String token = controller.token;
    String sapId = controller.sapId;

    try {
      final String url =
          "${ApiConstants.getBatteryManagementStateList}?token=$token&user_Id=$sapId&app_Version=${AppConstants.appVersionName}&device_Id=$deviceId&os_Type=$osType&channel=${AppConstants.channel}&PhoneNo=${controller.phoneNumber}&User_Id=$sapId";
      final response = await Requests.sendGetRequest(url, null);

      print("data ${response.data}");

      if (response is! DioException && response.statusCode == 200) {
        return Right(BatteryManagementStateListModel.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<GovtIdTypeInfo>>> getGovtIdTypeList() async {
    String token = controller.token;
    String sapId = controller.sapId;

    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "channel": AppConstants.channel
      };

      final response = await Requests.sendPostRequest(
          ApiConstants.getGovtIdListListInfo, body);
      if (response is! DioException && response.statusCode == 200) {
        List<GovtIdTypeInfo> stateList = List<GovtIdTypeInfo>.from(response
            .data['data']
            .map((model) => GovtIdTypeInfo.fromJson(model)));

        return Right(stateList);
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StateInfo>>> getStateList() async {
    try {
      final response =
          await Requests.sendGetRequest(ApiConstants.getStateList, null);
      if (response is! DioException && response.statusCode == 200) {
        List<StateInfo> stateList = List<StateInfo>.from(
            response.data['data'].map((model) => StateInfo.fromJson(model)));

        return Right(stateList);
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return const Left(ServerFailure(""));
    }
  }

  @override
  Future<Either<Failure, List<StatusData>>> getDealerElectricianStatusList(
      String userType, String filterValue) async {
    try {
      String language = languageController.language;
      String url = (userType == UserType.dealer)
          ? ApiConstants.getDealerStatusList
          : ApiConstants.getElectricainStatusList;
      String sapId = controller.sapId;

      final Map<String, dynamic> body = (userType == UserType.dealer)
          ? {
              "user_Id": sapId,
              "app_Version": AppConstants.appVersionName,
              "device_Id": deviceId,
              "os_Type": osType,
              "channel": AppConstants.channel,
              "device_name": deviceName,
              "os_version_name": osVersionName,
              "os_version_code": osVersionCode,
              "ip_address": ipAddress,
              "language": language,
              "screen_name": "",
              "network_type": networkType,
              "network_operator": networkOperator,
              "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
              "browser": "",
              "browser_Version": "",
              "filter": filterValue
            }
          : {
              "user_Id": sapId,
              "device_name": deviceName,
              "app_Version": AppConstants.appVersionName,
              "device_Id": deviceId,
              "os_Type": osType,
              "channel": AppConstants.channel,
              "token": "",
              "os_version_name": osVersionName,
              "os_version_code": osVersionCode,
              "ip_address": ipAddress,
              "language": language,
              "screen_name": "",
              "network_type": networkType,
              "network_operator": networkOperator,
              "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
              "browser": "",
              "browser_Version": "",
              "filter": filterValue
            };
      List<StatusData> statusList1 = [];
      final response = await Requests.sendPostRequest(url, body);
      if (response is! DioException && response.statusCode == 200) {
        if (response.data['data'] == null) {
          return Right(statusList1);
        } else {
          List<StatusData> statusList = List<StatusData>.from(response
              .data['data']
              .map((model) => StatusData.fromJson(model, userType)));

          return Right(statusList);
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return const Left(ServerFailure(""));
    }
  }

  @override
  Future<Either<Failure, List<DealerElectricianDetail>>>
      getDealerElectricianList(String userType, String filterValue) async {
    try {
      String url = (userType == UserType.dealer)
          ? ApiConstants.GetDealersList_V1
          : ApiConstants.getElectricainList;
      String sapId = controller.sapId;
      final Map<String, dynamic> body = {
        "user_Id": sapId /*"1100113"*/,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "channel": AppConstants.channel,
        "filter": filterValue
      };

      List<DealerElectricianDetail> statusList1 = [];
      final response = await Requests.sendPostRequest(url, body);
      if (response is! DioException && response.statusCode == 200) {
        if (response.data['data'] == null || response.data['data'] == "") {
          return Right(statusList1);
        } else {
          List<DealerElectricianDetail> statusList =
              List<DealerElectricianDetail>.from(response.data['data'].map(
                  (model) =>
                      DealerElectricianDetail.fromJson(model, userType)));

          return Right(statusList);
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(""));
    }
  }

  @override
  Future<Either<Failure, DealerElectricianDetail>>
      getDealerElectricianListDetails(String userType, String id) async {
    try {
      String url = (userType == UserType.electrician)
          ? ApiConstants.getElectricainListItemDetails
          : ApiConstants.getDealerListItemDetails;
      String sapId = controller.sapId;

      final Map<String, dynamic> body = {
        (userType == UserType.dealer) ? "dealerCode" : "electricianCode": "$id",
        "user_Id": sapId,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "channel": AppConstants.channel,
      };
      DealerElectricianDetail statusList1 = DealerElectricianDetail();
      final response = await Requests.sendPostRequest(url, body);
      if (response is! DioException && response.statusCode == 200) {
        if (response.data['data'] == null || response.data['data'] == "") {
          return Right(statusList1);
        } else {
          if (userType == UserType.electrician) {
            List<DealerElectricianDetail> statusList =
                List<DealerElectricianDetail>.from(response.data['data'].map(
                    (model) =>
                        DealerElectricianDetail.fromJson(model, userType)));
            return Right(statusList[0]);
          } else {
            DealerElectricianDetail detail = DealerElectricianDetail.fromJson(
                response.data['data'], userType);
            return Right(detail);
          }
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(""));
    }
  }

  @override
  Future<Either<Failure, bool>> setDealerElectricianBlockRedumption(
      String userType, bool isRedumptionBlock, String id) async {
    try {
      String language = languageController.language;

      String url = (userType == UserType.dealer)
          ? ApiConstants.Block_UnblockDealer_V1
          : ApiConstants.setElectricianBlockRedumption;
      String sapId = controller.sapId;

      final Map<String, dynamic> body = (userType == UserType.dealer)
          ? {
              "user_Id": sapId,
              "block_flag": (isRedumptionBlock) ? "1" : "0",
              "dealer_id": id,
              "app_Version": AppConstants.appVersionName,
              "device_Id": deviceId,
              "os_Type": osType,
              "channel": AppConstants.channel,
              "device_name": deviceName,
              "os_version_name": osVersionName,
              "os_version_code": osVersionCode,
              "ip_address": ipAddress,
              "language": language,
              "screen_name": "",
              "network_type": networkType,
              "network_operator": networkOperator,
              "time_captured": DateTime.now().microsecondsSinceEpoch.toString(),
              "browser": "",
              "browser_version": ""
            }
          : {
              "electricianId": id,
              "user_Id": sapId,
              "app_Version": AppConstants.appVersionName,
              "device_Id": deviceId,
              "os_Type": osType,
              "channel": AppConstants.channel,
              "flag": (isRedumptionBlock) ? "1" : "0"
            };
      final response = await Requests.sendPostRequest(url, body);
      if (response is! DioException && response.statusCode == 200) {
        if (response.data['status'] == "200") {
          return Right(true);
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(
          translation(navigatorKey.currentState!.context).somethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, String>> updateDealerMapUnMap(
      String userType, bool isactive, String id) async {
    try {
      String language = languageController.language;
      String url =ApiConstants.SetUpdateDistributorInActive;
      String sapId = controller.sapId;

      final Map<String, dynamic> body =
         {
        "user_Id": sapId,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "channel": AppConstants.channel,
        "isActive":isactive,
        "dealerCode":id
      };
      final response = await Requests.sendPostRequest(url, body);
      if (response is! DioException && response.statusCode == 200) {
        if (response.data['status'] == "200") {
          return Right(response.data['data']["descriptionMessage"]);
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(
          translation(navigatorKey.currentState!.context).somethingWentWrong));
    }
  }




  @override
  Future<Either<Failure, String>> createDealerElectrician(
      String userType, FormData body) async {
    try {
      String url = (userType == UserType.dealer)
          ? ApiConstants.createDealer
          : ApiConstants.createElectrician;
      String sapId = controller.sapId;
      if (body != null) {
        body.fields.add(MapEntry("device_Id", deviceId));
      }
      Dio dio = new Dio();
      dio.options.headers['Content-Type'] = 'multipart/form-data';
      final response = await Requests.sendPostForm(url, body, sapId);
      if (response is! DioException && response.statusCode == 200) {
        if (response.data['status'] == "200") {
          return Right(response.data['message'] ?? "");
        } else {
          return Left(ServerFailure((response.data['message'] ?? "")));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(
          translation(navigatorKey.currentState!.context).somethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, String>> createOtp(
      String mobileNumber, String userType) async {
    try {
      String url = ApiConstants.createOtp;
      String sapId = controller.sapId;

      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "token": "",
        "app_Version": AppConstants.appVersionName,
        "appversion_code": AppConstants.appVersionCode,
        "device_Id": deviceId,
        "os_Type": osType,
        "channel": AppConstants.channel,
        "otp": "",
        "os_version_code": osVersionCode,
        "loginUserId": "$sapId",
        "device_name": deviceName,
        "phone_number": "$mobileNumber",
        "type": userType,
        "mode": "",
        "transactionid": "",
        "electrician_Mapping_Flag": ""
      };
      final response = await Requests.sendPostRequest(url, body);
      if (response is! DioException && response.statusCode == 200) {
        return Right(response.data['message']);
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(""));
    }
  }

  @override
  Future<Either<Failure, String>> verifyNewUserOtp(
      String otp, String mobileNumber) async {
    try {
      String url = ApiConstants.verifyOtp;
      String sapId = controller.sapId;

      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "token": "",
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "appversion_code": AppConstants.appVersionName,
        "channel": AppConstants.channel,
        "otp": otp,
        "os_version_code": osVersionCode,
        "loginUserId": "",
        "device_name": deviceName,
        "phone_number": mobileNumber,
        "type": "",
        "mode": "",
        "transactionid": "",
        "electrician_Mapping_Flag": ""
      };
      final response = await Requests.sendPostRequest(url, body);
      if (response is! DioException && response.statusCode == 200) {
        return Right(response.data['message']);
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(""));
    }
  }

  @override
  Future<Either<Failure, List<DistrictInfo>>> getDistrictList(
      String stateId) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "stateID": "$stateId" /*"20"*/,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
    };
    try {
      final Map<String, dynamic> body = {
        "stateID": stateId,
        "user_Id": sapId,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "channel": AppConstants.channel
      };

      final response = await Requests.sendPostRequest(
          ApiConstants.getDistrictListInfo, body);
      if (response is! DioException && response.statusCode == 200) {
        List<DistrictInfo> stateList = List<DistrictInfo>.from(
            response.data['data'].map((model) => DistrictInfo.fromJson(model)));

        return Right(stateList);
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, BatteryManagementCityListModel>>
      getBatteryMgmtCityList(String state) async {
    String token = controller.token;
    String sapId = controller.sapId;

    try {
      final String url =
          "${ApiConstants.getBatteryManagementCityList}?token=$token&state=$state&user_Id=$sapId&app_Version=${AppConstants.appVersionName}&device_Id=$deviceId&os_Type=$osType&channel=${AppConstants.channel}&PhoneNo=${controller.phoneNumber}&User_Id=$sapId";
      final response = await Requests.sendGetRequest(url, null);

      print("data ${response.data}");

      if (response is! DioException && response.statusCode == 200) {
        return Right(BatteryManagementCityListModel.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CityInfo>>> getCityList(String districtId) async {
    String sapId = controller.sapId;

    try {
      final Map<String, dynamic> body = {
        "DistrictId": districtId,
        "user_Id": sapId,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "channel": AppConstants.channel
      };

      final response =
          await Requests.sendPostRequest(ApiConstants.getCityListInfo, body);

      if (response is! DioException && response.statusCode == 200) {
        List<CityInfo> stateList = List<CityInfo>.from(
            response.data['data'].map((model) => CityInfo.fromJson(model)));

        return Right(stateList);
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, BatteryManagementAddressModel>>
      getBatteryMgmtAddressList(String state, String city) async {
    String token = controller.token;
    String sapId = controller.sapId;

    try {
      final String url =
          "${ApiConstants.getBatteryManagementAddressList}?token=$token&state=$state&city=$city&user_Id=$sapId&app_Version=${AppConstants.appVersionName}&device_Id=$deviceId&os_Type=$osType&channel=${AppConstants.channel}&PhoneNo=${controller.phoneNumber}&User_Id=$sapId";
      final response = await Requests.sendGetRequest(url, null);

      print("data ${response.data}");

      if (response is! DioException && response.statusCode == 200) {
        return Right(BatteryManagementAddressModel.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TertiarySaleData>>>
      getTertiaryBulkProductDetailsBySerialNo(
          CustomerInfo customerInfo, String serialNo) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    final Map<String, dynamic> body = {
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
      "language": language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_Version": "",
      "transferAmount": "",
      "serialNo": serialNo,
      "disCode": sapId,
      "saleDate": customerInfo.saleDate,
      "customerName": customerInfo.customerName,
      "customerAddress": customerInfo.custAddress,
      "customerPhone": customerInfo.mobileNo,
      "logDistyId": sapId
    };

    print(body);

    final response = await Requests.sendPostRequest(
        ApiConstants.postTertiarySaleBulkDetailsListEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      print(response);
      return Right(List<TertiarySaleData>.from((response.data["data"] as List)
          .map((e) => TertiarySaleData.fromJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, bool>> postTertiaryBulkPDFUpload(
      String filePath, String fileName) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
    };
    // FormData formData = FormData.fromMap({
    //   "File": await MultipartFile.fromFile(filePath, filename: fileName),
    //   "FileName": fileName,
    //   "SapCode": sapId,
    //   "FileType": "pdf"
    // });

    final response = await Requests.sendPostRequest(
        ApiConstants.postTertiarySaleBulkPDFUploadEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      print(response.data["data"]);
      return Right(true);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, CreateOTPResponse>> postCreateOTPTertiaryBulk(
      CustomerInfo customerInfo, String serialNo) async {
    String token = controller.token;
    String sapId = controller.sapId;

    print(token);

    final Map<String, dynamic> body = {
      "customerCode": sapId,
      "user_Id": sapId,
      "serialNo": serialNo,
      "mobileNo": customerInfo.mobileNo,
      "imeiNumber": deviceId,
      "osVersion": osVersionName,
      "deviceName": deviceName,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "appTypeName": AppConstants.appTypeNamePSB,
      "token": AppConstants.salesStaticToken,
      //add requested by backend Team
    };
    final response = await Requests.sendPostRequest(
        ApiConstants.postEwarrantyCreateOtpEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      print('TSBCreateOtp:body${body}');
      print('TSBCreateOtp:response${response.data}');

      return Right(CreateOTPResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, VerifyOtpTertiarySales>> postVerifyOtpTertiaryBulk(
    CustomerInfo customerInfo,
    String serialNo,
    String otp,
    String transId,
  ) async {
    String token = controller.token;
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "customerCode": sapId,
      "user_Id": sapId,
      "serialNo": serialNo,
      "mobileNo": customerInfo.mobileNo,
      "imeiNumber": deviceId,
      "osVersion": osVersionName,
      "deviceName": deviceName,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "otp": otp,
      "appTypeName": AppConstants.appTypeNamePSB,
      "token": AppConstants.salesStaticToken,
      //add requested by backend Team
      "transID": transId
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postHkvaVerifyOtpEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      print('TSBVerifyOtp:body${body}');
      print('TSBVerifyOtp:response${response.data}');
      return Right(VerifyOtpTertiarySales.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<TertiarySaleData>>>
      getTertiaryBulkProductSaveDetailsBySerialNo(
          CustomerInfo customerInfo,
          String serialNo,
          String otp,
          String transId,
          String ewViaverified) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;
    String isVerified = ewViaverified == "WITH_OTP" ? "true" : "false";

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "token": token,
      //add requested by backend Team
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
      "serialNo": serialNo,
      "disCode": sapId,
      "saleDate": customerInfo.saleDate,
      "customerPhone": customerInfo.mobileNo,
      "customerName": customerInfo.customerName,
      "customerAddress": customerInfo.custAddress,
      "logDistyId": sapId,
      "eW_isVerified": isVerified,
      "eW_ViaVerified": ewViaverified,
      "eW_VerifiedBy": sapId,
      "eW_OTP": otp,
      "eW_IMEI": deviceId,
      "tokenEw": AppConstants.salesStaticToken,
      //add requested by backend Team
      "transID": transId
    };

    print("TSBS:body ${body}");
    final response = await Requests.sendPostRequest(
        ApiConstants.postTertiaryBulkProductSaveEndPoint, body);

    print("TSBS:response ${response}");

    if (response is! DioException && response.statusCode == 200) {
      print("TSBS:response ${response}");
      return Right(List<TertiarySaleData>.from((response.data["data"] as List)
          .map((e) => TertiarySaleData.fromJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, SurveyQuestionsResponse>> postSurveyQuestions() async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    try {
      final Map<String, dynamic> body = {
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
        "language": language,
        "screen_Name": "",
        "network_Type": networkType,
        "network_Operator": networkOperator,
        "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
        "browser": "",
        "browser_Version": ""
      };

      final response = await Requests.sendPostRequest(
          ApiConstants.postSurveyQuestionsEndPoint, body);

      if (response is! DioException && response.statusCode == 200) {
        print("Survey Questions DATA ${response.data}");
        return Right(SurveyQuestionsResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure("Failed to fetch survey questions: $error"));
    }
  }

  @override
  Future<Either<Failure, SurveyAnswersResponse>> postSurveyAnswers(
      List<String> responseIds,
      List<String> userAnswers,
      List<QuestionType> responseQuestionTypes) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    String questionTypeToString(QuestionType type) {
      switch (type) {
        case QuestionType.radioButton:
          return "radioButton";
        case QuestionType.starRating:
          return "starRating";
        case QuestionType.checkbox:
          return "checkbox";
        default:
          return "null";
      }
    }

    List<Map<String, dynamic>> buildAnswersList(List<String> responseIds,
        List<String> userAnswers, List<QuestionType> responseQuestionTypes) {
      List<Map<String, dynamic>> answers = [];

      for (int i = 0; i < responseIds.length; i++) {
        answers.add({
          'id': responseIds[i],
          'selectedOption': userAnswers[i],
          'type': questionTypeToString(responseQuestionTypes[i])
        });
      }
      return answers;
    }

    try {
      final Map<String, dynamic> body = {
        "answers":
            buildAnswersList(responseIds, userAnswers, responseQuestionTypes),
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
        "language": language,
        "screen_Name": "",
        "network_Type": networkType,
        "network_Operator": networkOperator,
        "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      };
      print("Request Survey Answers Body: $body");
      final response = await Requests.sendPostRequest(
          ApiConstants.postSurveyAnswersEndPoint, body);

      if (response is! DioException && response.statusCode == 200) {
        print("Survey Answers DATA ${response.data}");
        return Right(SurveyAnswersResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure("Failed to fetch survey Answers: $error"));
    }
  }

  @override
  Future<Either<Failure, GetAlertNotificationResponse>>
      postAlertNotification() async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    try {
      final Map<String, dynamic> body = {
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
        "language": language,
        "screen_Name": "",
        "network_Type": networkType,
        "network_Operator": networkOperator,
        "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
        "browser": "",
        "browser_Version": ""
      };
      print("Alert Notification Body: $body");
      final response = await Requests.sendPostRequest(
          ApiConstants.postAlertNotificationEndPoint, body);

      if (response is! DioException && response.statusCode == 200) {
        print("Alert Notification DATA ${response.data}");
        return Right(GetAlertNotificationResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure("Failed to fetch Alert Notification: $error"));
    }
  }

  @override
  Future<Either<Failure, ReadCheckAlertNotificationResponse>>
      postReadCheckAlertNotification(String id) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    try {
      final Map<String, dynamic> body = {
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
        "language": language,
        "screen_Name": "",
        "network_Type": networkType,
        "network_Operator": networkOperator,
        "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
        "browser": "",
        "browser_Version": "",
        "notificationid": id,
        "isread": "",
        "show_flag": ""
      };
      print("Read Check Alert Notification Body: $body");
      final response = await Requests.sendPostRequest(
          ApiConstants.postReadCheckAlertNotificationEndPoint, body);

      if (response is! DioException && response.statusCode == 200) {
        print("Read Check Alert Notification DATA ${response.data}");
        return Right(
            ReadCheckAlertNotificationResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure(
          "Failed to fetch Read Check Alert Notification: $error"));
    }
  }

  @override
  Future<Either<Failure, FseAgreementResponse>> postFseAgreement() async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    try {
      final Map<String, dynamic> body = {
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
        "language": language,
        "screen_Name": "",
        "network_Type": networkType,
        "network_Operator": networkOperator,
        "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      };
      logger.i("Fse Agreement Body: $body");
      final response = await Requests.sendPostRequest(
          ApiConstants.postFseAgreementEndPoint, body);

      if (response is! DioException && response.statusCode == 200) {
        logger.i("Fse Agreement Response: ${response.data}");
        return Right(FseAgreementResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure("Failed to fetch Fse Agreement: $error"));
    }
  }

  @override
  Future<Either<Failure, FeedBackAnswersResponse>> postFeedBackAnswers(
      String feedback, List<Asset> images) async {
    String sapId = controller.sapId;

    List<MultipartFile> multipartFiles = [];

    for (Asset asset in images) {
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      String contentType = 'image/jpeg';
      if (asset.name.toLowerCase().endsWith('.png')) {
        contentType = 'image/png';
      }
      final multipartFile = MultipartFile.fromBytes(
        imageData,
        filename: asset.name,
        contentType: MediaType('image', contentType.split('/').last),
      );
      multipartFiles.add(multipartFile);
    }

    try {
      FormData formData = FormData.fromMap({
        "FeedbackMessage": feedback,
        "UserId": sapId,
        "user_Id": sapId,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "channel": AppConstants.channel,
        "Image": [
          for (var file in multipartFiles) MapEntry("Images", file),
        ],
      });
      print("FeedBack Answers Body: $formData");
      final response = await Requests.sendPostForm(
          ApiConstants.postFeedBackAnswersEndPoint, formData, sapId);

      if (response is! DioException && response.statusCode == 200) {
        print("FeedBack Answers DATA ${response.data}");
        return Right(FeedBackAnswersResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure("Failed to fetch FeedBack Answers: $error"));
    }
  }

  @override
  Future<Either<Failure, FseAgreementCreateOtpResponse>>
      getFseAgreementCreateOtp() async {
    String token = controller.token;
    String sapId = controller.sapId;

    String apiUrl =
        "${ApiConstants.getFseAgreementCreateOtpEndPoint}?DisID=$sapId&IMEINumber=$deviceId&osVersion=$osVersionName&deviceName=$deviceName&appVersion=${AppConstants.appVersionName}&PhoneNo=${controller.phoneNumber}&User_Id=$sapId";

    print(apiUrl);
    logger.e("FSE otp Sent apiUrl ----> ${apiUrl}");

    try {
      final response = await Requests.sendGetRequest(apiUrl, null);
      logger.e("FSE otp Sent response ----> ${response}");
      if (response is! DioException && response.statusCode == 200) {
        print("Fse Agreement Create Otp Response DATA ${response.data}");
        return Right(FseAgreementCreateOtpResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure(
          "Failed to fetch Fse Agreement Create Otp Response: $error"));
    }
  }

  @override
  Future<Either<Failure, FseAgreementVerifyOtpResponse>>
      getFseAgreementVerifyOtp(String otp) async {
    String token = controller.token;
    String sapId = controller.sapId;

    String apiUrl =
        "${ApiConstants.getFseAgreementVerifyOtpEndPoint}?DisID=$sapId&IMEINumber=$deviceId&osVersion=$osVersionName&deviceName=$deviceName&OTP=$otp&PhoneNo=${controller.phoneNumber}&User_Id=$sapId";
    logger.i("FSE Agreement Verify OTP URL: ${apiUrl}");

    try {
      final response = await Requests.sendGetRequest(apiUrl, null);
      logger.i("FSE Agreement Verify Otp Response: ${response.data}");
      if (response is! DioException && response.statusCode == 200) {
        print("Fse Agreement Verify Otp Response DATA ${response.data}");
        return Right(FseAgreementVerifyOtpResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure(
          "Failed to fetch Fse Agreement Verify Otp Response: $error"));
    }
  }

  @override
  Future<Either<Failure, FseAcknowledgeResponse>> updateFseAcknowledgement(
      String fseId) async {
    String token = controller.token;
    String sapId = controller.sapId;

    String apiUrl = ApiConstants.updateFSEAcknowledgementEndPoint;
    logger.i("Fse update FSE Acknowledgement URL: ${apiUrl}");
    final Map<String, dynamic> requestParam = {
      "userId": sapId,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "id": fseId
    };
    logger.d("Fse update requestParam:: ${requestParam}");
    try {
      final response = await Requests.sendPostRequest(apiUrl, requestParam);
      logger.i("Fse update FSE Acknowledgement response ${response.data}");
      logger.i("Fse update SUCCESS ${response.statusCode}");
      if (response is! DioException && response.statusCode == 200) {
        logger.i("Fse update SUCCESS");
        return Right(FseAcknowledgeResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure(
          "Failed to update FSE Agreement acknowledgement: $error"));
    }
  }

  @override
  Future<Either<Failure, List<TripModel>>> postFetchTrips(String status) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "trip_Status_Type": status.toUpperCase(),
    };

    final response =
        await Requests.sendPostRequest(ApiConstants.postFetchTrips, body);

    if (response is! DioException && response.statusCode == 200) {
      return Right(List<TripModel>.from(
          (response.data["data"]).map((e) => TripModel.fromJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<Traveller>>> getSavedTravellers(
      int tripID) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "userId": sapId,
      "user_Id": sapId,
      "trip_Id": tripID.toString(),
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel
    };

    final response =
        await Requests.sendPostRequest(ApiConstants.getSavedTravellers, body);
    print("tripApi:2:response ${response}");

    if (response is! DioException && response.statusCode == 200) {
      // logger.d("tripApi:1:successResponse ${response.data["data"]}");
      return Right(List<Traveller>.from(
          (response.data["data"]).map((e) => Traveller.fromJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  // @override
  // Future<Either<Failure, bool>> checkTravellerPassportNumber(
  //     String passportNo) async {
  //   String sapId = controller.sapId;
  //   final Map<String, dynamic> body = {
  //     "passportNo": passportNo,
  //     "user_Id": sapId,
  //     "app_Version": AppConstants.appVersionName,
  //     "device_Id": deviceId,
  //     "os_Type": osType,
  //     "channel": AppConstants.channel
  //   };
  //   final response = await Requests.sendPostRequest(
  //       ApiConstants.checkTravellerPassportNumber, body);
  //   print("tripApi:checkTravellerPassportNumber:response ${response}");
  //   if (response is! DioException && response.statusCode == 200) {
  //     print(
  //         "tripApi:checkTravellerPassportNumber:successResponse ${response.data["data"]}");
  //     if (response.data["data"][0]["userExists"] == "1") {
  //       return Right(true);
  //     } else {
  //       return Right(false);
  //     }
  //   } else {
  //     return Left(ServerFailure((response as DioException).message ?? ""));
  //   }
  // }

  @override
  Future<Either<Failure, BookingResponseModel>> postBookTrip(
      List<Traveller> travellers, TripModel tripModel) async {
    String token = controller.token;
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "trip_ID": tripModel.tripID,
      "travellerData": travellers
          .map((traveller) => {
                "trip_ID": tripModel.tripID,
                "traveller_Name": traveller.name,
                "relation": traveller.relation,
                "seatStatus": "",
                "waitList": 0,
                "emailId": traveller.email,
                "mobileNo": traveller.mobileNo,
                "passport": traveller.passport,
              })
          .toList(),
    };

    final response =
        await Requests.sendPostRequest(ApiConstants.postBookTrip, body);
    if (response is! DioException) {
      if (response.data["status"] == "200") {
        return Right(BookingResponseModel.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data["message"]));
      }
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, String>> putTravellerMobileNumberUsingPassportNumber(
      String name, String relation, String mobileNo) async {
    String sapId = controller.sapId;

    final response = await Requests.sendPutRequest(
      ApiConstants.putTravellerMobileNumberUsingPassportNumber,
      {
        'name': name,
        'relation': relation,
        'passportNo': "",
        'mobileNo': mobileNo,
        "user_Id": sapId,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "channel": AppConstants.channel,
      },
    );
    print("tripApi:UpdateMobileNumber:response ${response}");

    if (response is! DioException && response.statusCode == 200) {
      print(
          "tripApi:UpdateMobileNumber:successResponse ${response.data["data"]}");

      return Right(response.data["data"]["result"]);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, String>> getWarrantyPdf(String serialNo) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "SlNo": serialNo,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel
    };

    final response =
        await Requests.sendPostRequest(ApiConstants.getWarrantyPdf, body);

    if (response is! DioException && response.statusCode == 200) {
      return Right(response.data["data"]);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> fetchSellingDate(
      String serialNo) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "srNo": serialNo,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel
    };

    final response =
        await Requests.sendPostRequest(ApiConstants.getSalesDateBySrNo, body);

    if (response is! DioException && response.statusCode == 200) {
      return Right(response.data["data"]);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, TertiaryCustomerWiseDetails>>
      postTertiaryCustomerWiseDetails(String customerPhone,
          {String disId = "",
          String productType = "",
          String status = "",
          String fromDate = AppConstants.FROM_DATE,
          toDate = AppConstants.TO_DATE}) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "disId": disId,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "customerPhone": customerPhone,
      "product_Type": productType,
      "status": status,
      "fromDate": fromDate,
      "toDate": toDate
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postTertiaryProductWiseDetails, body);
    if (response is! DioException && response.statusCode == 200) {
      TertiaryCustomerWiseDetails tertiaryProductWiseReport =
          TertiaryCustomerWiseDetails.fromJson(response.data);

      return Right(tertiaryProductWiseReport);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, PrimaryBilling>> postPrimaryBillingReport(
      {String fromDate = "", toDate = ""}) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "token": "",
      "device_Name": deviceName,
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "language": languageController.language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_Version": "",
      "customerCode": "",
      "customerName": "",
      "address": "",
      "phoneno": "",
      "region": "",
      "email": "",
      "fromDate": fromDate,
      "toDate": toDate,
      "way": "",
      "token_M": ""
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postPrimaryBillingReport, body);
    if (response is! DioException && response.statusCode == 200) {
      final primaryBilling = PrimaryBilling.fromJson(response.data);
      return Right(primaryBilling);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<Customer>>> getCustomerList() async {
    String sapId = controller.sapId;

    // 1110718
    final Map<String, dynamic> body = {
      "userId": sapId,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postGetCustomerListEndPoint, body);
    print(response);
    if (response is! DioException && response.statusCode == 200) {
      return Right(List<Customer>.from(
          (response.data["data"] as List).map((e) => Customer.fromJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, DistributorLedger>> postDistributorLedger(
      {String fromDate = "", toDate = ""}) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "token": "",
      "device_Name": deviceName,
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "language": languageController.language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_Version": "",
      "customerCode": "",
      "customerName": "",
      "address": "",
      "phoneno": "",
      "region": "",
      "email": "",
      "fromDate": fromDate,
      "toDate": toDate,
      "way": "",
      "token_M": ""
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postCustomerLedgerReport, body);
    if (response is! DioException && response.statusCode == 200) {
      DistributorLedger distributorLedger =
          DistributorLedger.fromJson(response.data);
      return Right(distributorLedger);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, CreditDebitNote>> postCreditDebitNote(
      {String fromDate = "", toDate = ""}) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "token": "",
      "device_Name": deviceName,
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "language": languageController.language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_Version": "",
      "customerCode": "",
      "customerName": "",
      "address": "",
      "phoneno": "",
      "region": "",
      "email": "",
      "fromDate": fromDate,
      "toDate": toDate,
      "way": "",
      "token_M": ""
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postCreditDebitNoteReport, body);
    if (response is! DioException && response.statusCode == 200) {
      CreditDebitNote creditDebiNote = CreditDebitNote.fromJson(response.data);
      return Right(creditDebiNote);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, ReportDownloadDealer>>
      postSecondaryReportDownloadDealer(String dealerId,
          {String disID = "",
          String fromDate = AppConstants.FROM_DATE,
          toDate = AppConstants.TO_DATE,
          String productTypes = "",
          String status = ""}) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "disCode": disID,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "dealer_code": dealerId,
      "product_Type": productTypes,
      "status": status,
      "fromDate": fromDate,
      "toDate": toDate
    };

    logger.d("Report Body: $body");

    final response = await Requests.sendPostRequest(
        ApiConstants.postReportDownloadForDealer, body);
    if (response is! DioException && response.statusCode == 200) {
      logger.d("Report Data: ${response.data}");
      ReportDownloadDealer reportDownloadDealer =
          ReportDownloadDealer.fromJson(response.data);
      return Right(reportDownloadDealer);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<IsmartOffers>>> postIsmartOffers() async {
    String token = controller.token;
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "token": token,
      "device_Name": deviceName,
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "language": languageController.language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_Version": ""
    };

    final response =
        await Requests.sendPostRequest(ApiConstants.postIsmartOffers, body);
    if (response is! DioException && response.statusCode == 200) {
      print("ISMART Offers Data ${response.data["data"][1]['card_data']}");
      return Right(List<IsmartOffers>.from((response.data["data"][1]
              ['card_data'])
          .map((e) => IsmartOffers.fromJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, UpdateUserIdModel>> patchUpdateUser() async {
    String phoneNo = controller.phoneNumber;
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "PhoneNo": phoneNo,
      "osVersion": osVersionCode,
    };
    final response = await Requests.sendPostRequest(
      ApiConstants.patchUpdateUserEndPoint,
      body,
    );
    if (response is! DioException && response.statusCode == 200) {
      var obj = UpdateUserIdModel.fromJson(response.data);
      if (obj.token.isNotEmpty && obj.data != "null") {
        AuthController authController = Get.find();
        authController.updateAccessToken(obj.token);
        authController.updateRefreshToken(obj.data);
        return Right(obj);
      } else {
        Requests.showLoginFailedBottomSheet();
        return Left(ServerFailure(obj.message ?? ""));
      }
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, PinelabSendOTP>> pinelabSendOTP() async {
    String sapId = controller.sapId;
    String getPhoneNumber = controller.phoneNumber;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "otp": "",
      "os_Version_Code": osVersionCode,
      "loginUserId": sapId,
      "device_Name": deviceName,
      "phone_Number": getPhoneNumber,
      "type": "",
      "mode": "",
      "transactionId": "",
      "electrician_Mapping_Flag": ""
    };
    final response =
        await Requests.sendPostRequest(ApiConstants.postPinelabCreateOtp, body);
    if (response is! DioException && response.statusCode == 200) {
      print('data ${response.data}');
      return Right(PinelabOTPResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, PinelabVerifyOTP>> pinelabverifyOTP(
      String getOtp) async {
    String sapId = controller.sapId;
    String getPhoneNumber = controller.phoneNumber;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "otp": getOtp,
      "os_Version_Code": osVersionCode,
      "loginUserId": sapId,
      "device_Name": deviceName,
      "phone_Number": getPhoneNumber,
      "type": "",
      "mode": "",
      "transactionId": "",
      "electrician_Mapping_Flag": ""
    };
    final response =
        await Requests.sendPostRequest(ApiConstants.postPinelabVerifyOtp, body);
    print("data ${response.data}");
    if (response is! DioException && response.statusCode == 200) {
      return Right(PinelabVerifyOTP.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, PinelabVerifyMobileNoGst>> pinelabVerifyMobileNoGst(
      String transferAmount) async {
    String sapId = controller.sapId;
    String phoneNumber = controller.phoneNumber;
    String token = controller.token;

    final Map<String, dynamic> body = {
      "mobileNumber": phoneNumber,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "token": token,
      "transactionMode": "online",
      "transferAmount": transferAmount,
      "device_Name": deviceName,
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "language": languageController.language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString()
    };
    final response = await Requests.sendPostRequest(
        ApiConstants.postPinelabVerifyMobileNoGst, body);
    print("data ${response.data}");
    if (response is! DioException && response.statusCode == 200) {
      return Right(PinelabVerifyMobileNoGst.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, PinelabBalancePoint>> pinelabGetBalancePoint() async {
    String sapId = controller.sapId;
    String phoneNumber = controller.phoneNumber;
    String token = controller.token;

    final Map<String, dynamic> body = {
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
      "mobileNumber": phoneNumber,
      "transactionMode": "",
      "transferAmount": "",
      "firstname": "",
      "lastname": "",
      "dob": "",
      "telephone": "",
      "email": "",
      "corporate": "",
      "uid": "",
      "cid": "",
      "username": "",
      "address": {
        "id": "",
        "firstName": "",
        "lastName": "",
        "email": "",
        "line1": "",
        "line2": "",
        "city": "",
        "region": "",
        "country": "",
        "postcode": "",
        "billToThis": true
      },
      "billing": {
        "id": "",
        "line1": "",
        "line2": "",
        "city": "",
        "region": "",
        "country": "",
        "postcode": ""
      },
      "amount": 0,
      "refNo": "",
      "remarks": "",
      "currency": "",
      "cust_Id": ""
    };
    final response = await Requests.sendPostRequest(
        ApiConstants.postPinelabGetBalancePoint, body);
    print("data ${response.data}");
    if (response is! DioException && response.statusCode == 200) {
      return Right(PinelabBalancePoint.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, PinelabVerifyMobileOtpGst>> pinelabVerifyMobileOtpGst(
      int transferAmount, String availableBalance) async {
    String sapId = controller.sapId;
    String phoneNumber = controller.phoneNumber;
    String token = controller.token;

    final Map<String, dynamic> body = {
      "mobileNumber": phoneNumber,
      "user_Id": sapId,
      "token": token,
      "transactionMode": AppConstants.pinelabTransactionMode,
      "availableAmount": availableBalance,
      "payTmInitId": "",
      "transferAmount": transferAmount,
      "amount": 0,
      "currency": AppConstants.pinelabCurrency,
      "refNo": "",
      "remarks": "",
      "otp": "",
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "device_Name": "",
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "language": languageController.language,
      "screen_Name": "",
      "network_Type": "",
      "network_Operator": "",
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString()
    };
    final response = await Requests.sendPostRequest(
        ApiConstants.postPinelabVerifyMobileOtpGst, body);
    print("data ${response.data}");
    if (response is! DioException && response.statusCode == 200) {
      return Right(PinelabVerifyMobileOtpGst.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, UserUploadProfilePhoto>> userUploadProfilePhoto(
      String imagePath) async {
    String userId = controller.sapId;
    MultipartFile multipartImageFile = await MultipartFile.fromFile(imagePath);

    FormData formData = FormData.fromMap({
      "UserId": userId,
      "user_Id": userId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "ProfilePhoto": multipartImageFile
    });

    final response = await Requests.sendPostForm(
        ApiConstants.postUserUploadProfilePhoto, formData, userId);
    print("data ${response.data}");

    if (response is! DioException && response.statusCode == 200) {
      return Right(UserUploadProfilePhoto.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, NotificationListResponse>> fetchNotificationsList(
      String notificationType) async {
    String sapId = controller.sapId;

    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "channel": AppConstants.channel,
        "type": notificationType,
      };
      logger.d("RA: Notification list Body: $body");
      final response = await Requests.sendPostRequest(
          ApiConstants.postNotificationListEndPoint, body);
      logger.d("RA: Notification List: $response");

      if (response is! DioException && response.statusCode == 200) {
        logger.d("Notification Details DATA ${response.data}");
        return Right(NotificationListResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(
          ServerFailure("Failed to fetch Notification Details: $error"));
    }
  }

  @override
  Future<Either<Failure, NotificationDetailResponse>> fetchNotificationsDetails(
      String notificationId) async {
    String sapId = controller.sapId;

    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "channel": AppConstants.channel,
        "notificationId": notificationId,
      };
      logger.d("Notification list Body: $body");
      final response = await Requests.sendPostRequest(
          ApiConstants.postNotificationDetailEndPoint, body);
      logger.d("Notification List: $response");

      if (response is! DioException && response.statusCode == 200) {
        logger.d("Notification Details DATA ${response.data}");
        return Right(NotificationDetailResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(
          ServerFailure("Failed to fetch Notification Details: $error"));
    }
  }

  @override
  Future<Either<Failure, TransactionDetailsResponse>>
      fetchingTransactionDetails(String txnId, String txnType) async {
    String sapId = controller.sapId;

    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "channel": AppConstants.channel,
        "transactionId": txnId,
        "transactionType": txnType
      };
      logger.d("fetching Transaction Details Body: $body");
      final response = await Requests.sendPostRequest(
          ApiConstants.postTransactionDetailsEndPoint, body);
      logger.d("N_D TXN DATA: $response");

      if (response is! DioException && response.statusCode == 200) {
        logger.d("Notification Transaction Details DATA ${response.data}");
        return Right(TransactionDetailsResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure(
          "Failed to fetch Notification Transaction Details: $error"));
    }
  }

  @override
  Future<Either<Failure, ReadNotificationDetailOnIdResponse>>
      postReadNotificationDetailOnId(String notificationId) async {
    String sapId = controller.sapId;

    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "channel": AppConstants.channel,
        "notificationId": notificationId
      };
      logger.d("Read Notification Detail On Id Body: $body");
      final response = await Requests.sendPostRequest(
          ApiConstants.postReadNotificationDetailOnIdEndPoint, body);
      logger.d("Read Notification Detail On Id Response: $response");

      if (response is! DioException && response.statusCode == 200) {
        logger.d("Read Notification Detail On Id DATA ${response.data}");
        return Right(
            ReadNotificationDetailOnIdResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure(
          "Failed to fetch Read Notification Detail On Id: $error"));
    }
  }

  @override
  Future<Either<Failure, ReadNotificationDetailOnIdResponse>>
      deleteNotificationByType(
          int notificationDeleteType, bool isPromotional) async {
    String sapId = controller.sapId;

    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "channel": AppConstants.channel,
        "isPromotion": isPromotional,
        "notificationDeleteType": notificationDeleteType
      };
      logger.d("Read Notification Detail On Id Body: $body");
      final response = await Requests.sendPostRequest(
          ApiConstants.postClearNotificationsEndPoint, body);
      logger.d("Read Notification Detail On Id Response: $response");

      if (response is! DioException && response.statusCode == 200) {
        logger.d("Read Notification Detail On Id DATA ${response.data}");
        return Right(
            ReadNotificationDetailOnIdResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure(
          "Failed to fetch Read Notification Detail On Id: $error"));
    }
  }

  @override
  Future<Either<Failure, NewWarranty>> getWarrantyDetails(
      String serialNo) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "serialNo": serialNo,
      "userId": sapId,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
    };
    final response =
        await Requests.sendPostRequest(ApiConstants.getWarrantyDetails, body);
    print("Warranty Response${response.data["data"]}");
    if (response is! DioException && response.statusCode == 200) {
      return Right(NewWarranty.fromJson(response.data["data"]));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<Relationship>>> postRelationships(
      String tripId) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "tripId": tripId
    };

    final response =
        await Requests.sendPostRequest(ApiConstants.postRelationships, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(List<Relationship>.from(
          (response.data["data"]).map((e) => Relationship.fromJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<List<String>> fetchImageUrls(int id) async {
    final String sapId = controller.sapId;
    final String token = controller.token;

    final response = await Requests.sendPostRequest(
        ApiConstants.postGetAdvertisementImageUrls, {
      "userId": sapId,
      "languageId": "$id",
      "token": token,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "deviceId": deviceId,
      "deviceName": deviceName,
      "osType": osType,
      "osVersionName": osVersionName,
      "osVersionCode": osVersionCode,
      "ipAddress": ipAddress,
      "language": languageController.language,
      "screenName": "",
      "networkType": networkType,
      "networkOperator": networkOperator,
      "timeCaptured": DateTime.now().microsecondsSinceEpoch.toString(),
    });

    if (response is! DioException && response.statusCode == 200) {
      List<dynamic> items = response.data['data'];
      List<String> urls =
          items.map((image) => image['custom_image'].toString()).toList();
      print(urls);
      return urls;
    } else {
      return [];
    }
  }

  Future<SerialNumberExistanceModel> fetchSrNoExistance(
      String serialNumber, String number, String date, bool isTertiary) async {
    String sapId = controller.sapId;
    final Map<String, dynamic> body = {
      "sr_no": serialNumber,
      "app_Version": AppConstants.appVersionName,
      "user_Id": sapId,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "mobileno": number,
      "saledate": date,
      "token": AppConstants.salesStaticToken
    };

    if (isTertiary) {
      body['saleType'] = AppConstants.tertiaryBulkSaleType;
    }

    try {
      final response = await Requests.sendPostRequest(
          (isTertiary)
              ? ApiConstants.postSrNoExistanceUpdateEndPoint
              : ApiConstants.postSecondarySrNoExistanceUpdateEndPoint,
          body);

      if (response is! DioException && response.statusCode == 200) {
        //final Map<String, dynamic> data = response.data;
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data);
        String serialNumberExistanceResponse = apiResponse.data.isNotEmpty
            ? apiResponse.data[0].wrsEntryStatus
            : "";
        String modelname = apiResponse.data.isNotEmpty
            ? apiResponse.data[0].modelName
            : "";
        if (serialNumberExistanceResponse == "ok") {
          SerialNumberExistanceModel model=SerialNumberExistanceModel(status: serialNumberExistanceResponse, modelName: modelname,message: "");
          return model;
        } else {
          SerialNumberExistanceModel model=SerialNumberExistanceModel(status: "", modelName: "",message:serialNumberExistanceResponse);
          return model;
          //Navigator.pop(context);
          // showErrorMessageBottomSheet(serialNumberExistanceResponse);
        }
      } else {
        SerialNumberExistanceModel model=SerialNumberExistanceModel(status: "", modelName: "",message:response.message);

        print("Error: ${response.statusCode}");
        return model;
      }
    } catch (error) {
      SerialNumberExistanceModel model=SerialNumberExistanceModel(status: "", modelName: "",message:error.toString());
      print("Error fetching data: $error");
      return model;
    }
  }

  @override
  Future<List<Language>> getLanguages() async {
    final String sapId = controller.sapId;
    final response = await Requests.sendPostRequest(
        ApiConstants.postGetAdvertisementLanguage, {
      "app_Version": AppConstants.appVersionName,
      "user_Id": sapId,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "device_Name": deviceName,
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_Version": ""
    });

    if (response is! DioException && response.statusCode == 200) {
      List<dynamic> items = response.data['data'];
      List<Language> languageList =
          items.map((json) => Language.fromJson(json)).toList();

      return languageList;
    } else {
      throw Exception();
    }
  }

  Future<Either<Failure, CoinBalancePanCheck>> coinRedemptionCheck() async {
    final sapId = controller.sapId;
    final token = controller.token;
    Map<String, dynamic> body = {
      "user_Id": sapId,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "device_Name": deviceName,
      "os_Type": osType,
      "os_Version_Name": osVersionCode,
      "os_Version_Code": osVersionName,
      "ip_Address": ipAddress,
      "language": languageController.language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "channel": AppConstants.channel,
      "browser": "",
      "browser_Version": ""
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postPancardNullBalanceCheck, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(CoinBalancePanCheck.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, UPIClientHandshakeModel>>
      UPIClientSecretHandshake() async {
    Map<String, dynamic> body = {
      "device_Id": deviceId,
      "simId": simCardIdentifier,
      "geoCode": geoCode,
      "location": location,
      "ip": ipAddress,
      "os": osType,
      "deviceType": AppConstants.deviceType,
      "appName": AppConstants.appName,
      "capability": AppConstants.capability,
      "androidId": deviceId,
      "bluetoothMac": AppConstants.bluetoothMac,
      "wifiMac": AppConstants.wifiMac,
      "app_Version": AppConstants.appVersionName,
      "user_Id": controller.sapId,
      "client_id": "",
      "client_secret": "",
      "token": controller.token,
      "channel": AppConstants.channel,
      "os_Type": osType,
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postUPIClientSecretHandshake, body);

    if (response is! DioException && response.statusCode == 200) {
      return Right(UPIClientHandshakeModel.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, UPIBeneficiaryModel>>
      initialNumUpiVerification() async {
    Map<String, dynamic> body = {
      // "mobileno": AppConstants.upiMobileNumber.isEmpty
      //     ? controller.phoneNumber
      //     : AppConstants.upiMobileNumber,
      //controller.phoneNumber,
      "mobileno": controller.phoneNumber,
      "device_Id": deviceId,
      "simId": simCardIdentifier,
      "geoCode": geoCode,
      "location": location,
      "ip": ipAddress,
      "os": osType,
      "deviceType": AppConstants.deviceType,
      "appName": AppConstants.appName,
      "capability": AppConstants.capability,
      "androidId": deviceId,
      "bluetoothMac": AppConstants.bluetoothMac,
      "wifiMac": AppConstants.wifiMac,
      "app_Version": AppConstants.appVersionName,
      "user_Id": controller.sapId,
      "token": controller.token,
      "access_token": controller.token,
      "os_Type": osType,
      "channel": AppConstants.channel,
    };

    logger.d('Upi body: $body');
    try {
      final response =
          await Requests.sendPostRequest(ApiConstants.postUPICheckVPA, body);
      logger.d("UPI statusCode: ${response.statusCode}");
      logger.d("UPI response: $response");
      if (response is! DioException && response.statusCode == 200) {
        // response is! DioException &&
        return Right(UPIBeneficiaryModel.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure('Error $e'));
    }
  }

  @override
  Future<Either<Failure, UPITdsGstModel>> getUpiTdsGstCalculations(
      String amount) async {
    Map<String, dynamic> body = {
      "user_Id": controller.sapId,
      "token": controller.token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "device_Name": deviceName,
      "os_Type": osType,
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "language": languageController.language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "channel": AppConstants.channel,
      "browser": "",
      "browser_Version": "",
      "transferAmount": amount,
    };

    logger.d('GST/TDS Calc Body: $body');

    try {
      final response =
          await Requests.sendPostRequest(ApiConstants.postUPIGetTdsGst, body);
      if (response is! DioException && response.statusCode == 200) {
        print(response);
        return Right(UPITdsGstModel.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure('Error $e'));
    }
  }

  @override
  Future<Either<Failure, UPIOTPModel>> createOtpUPI() async {
    final Map<String, dynamic> body = {
      "user_Id": controller.sapId,
      "token": controller.token,
      "app_Version": AppConstants.appVersionName,
      "appversion_code": AppConstants.appVersionCode,
      "otp": "",
      "os_version_code": osVersionCode,
      "loginUserId": controller.sapId,
      "device_Id": deviceId,
      "device_name": deviceName,
      "os_Type": osType,
      "phone_number": controller.phoneNumber,
      "type": "",
      "mode": "",
      "transactionid": "",
      "electrician_Mapping_Flag": "",
      "channel": AppConstants.channel,
    };

    try {
      final response =
          await Requests.sendPostRequest(ApiConstants.createOtp, body);
      if (response is! DioException && response.statusCode == 200) {
        return Right(UPIOTPModel.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure('Error $e'));
    }
  }

  @override
  Future<Either<Failure, UPIOTPModel>> authenticateOtpUpi(String otp) async {
    final Map<String, dynamic> body = {
      "user_Id": controller.sapId,
      "token": controller.token,
      "app_Version": AppConstants.appVersionName,
      "appversion_code": AppConstants.appVersionCode,
      "otp": otp,
      "os_version_code": osVersionCode,
      "loginUserId": controller.sapId,
      "device_Id": deviceId,
      "device_name": deviceName,
      "os_Type": osType,
      "phone_number": controller.phoneNumber,
      "type": "",
      "mode": "",
      "transactionid": "",
      "electrician_Mapping_Flag": "",
      "channel": AppConstants.channel,
    };

    try {
      final response =
          await Requests.sendPostRequest(ApiConstants.verifyOtp, body);

      logger.d('statusof verifyotp ${response.statusCode}');
      if (response is! DioException && response.statusCode == 200) {
        return Right(UPIOTPModel.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure('Error $e'));
    }
  }

  @override
  Future<Either<Failure, UPITransactionModel>> upiTransaction(
      String enteredAmount,
      String ifsc,
      String vpaAvailable,
      UPIBeneficiaryModel beneficiaryDetails) async {
    CashSummaryController cashSummaryController = Get.find();

    Map<String, dynamic> body = {
      "device_Id": beneficiaryDetails.deviceid,
      "mobile_Number": controller.phoneNumber, //AppConstants.upiMobileNumber,
      "sim_Id": beneficiaryDetails.deviceid,
      "os": osType,
      "app_Name": AppConstants.appName,
      "location": location,
      "ip": ipAddress,
      "geocode": geoCode,
      "type": "",
      "account_Provider_Ref_Id": "",
      "sender_Vpa": AppConstants.luminousUpiId,
      "receiver_Vpa": vpaAvailable,
      "receiver_Name": "",
      "txn_Note": "",
      "amount": enteredAmount,
      "order_Number": "",
      "payee_Account_Number": "",
      "vpa_Type": "",
      "payee_Ifsc": ifsc,
      "app_Version": AppConstants.appVersionName,
      "access_Token": controller.token,
      "device_Type": AppConstants.deviceType,
      "user_Id": controller.sapId,
      "token": controller.token,
      "available_Amount": cashSummaryController.availableCash,
      "firInfo": {
        "init_Mod": "",
        "purpose_Code": "",
        "institution_Type": "",
        "route": "",
        "orginator_Type": "",
        "orginator_Addr": "",
        "orginator_City": "",
        "orginator_Country": "",
        "pr_Account_Type": "",
        "note": "",
        "acc_name": "",
        "acc_num": "",
        "beneficiary_name": "",
        "originator_name": "",
        "originator_ref_no": "",
        "originator_geocode": ""
      },
      "os_Type": osType,
      "channel": AppConstants.channel,
    };

    try {
      final response = await Requests.sendPostRequest(
          ApiConstants.postUPITransferAmount, body,
          isUpi: 1);
      if (response is! DioException && response.statusCode == 200) {
        UPITransactionModel upiTransactionResponse =
            UPITransactionModel.fromJson(response.data);
        return Right(upiTransactionResponse);
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      logger.e('Error $e');
      return Left(ServerFailure('Error $e'));
    }
  }

  Future<Either<Failure, BookedTripDetailsModel>> postFetchBookedTripDetails(
      String tripId) async {
    String sapId = controller.sapId;
    final token = controller.token;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "tripId": tripId,
      "app_Version": AppConstants.appVersionCode,
      "channel": AppConstants.channel,
      "device_Id": deviceId,
      "device_Name": deviceName,
      "ip_Address": ipAddress,
      "language": languageController.language,
      "network_Operator": networkOperator,
      "network_Type": networkType,
      "os_Type": osType,
      "os_Version_Code": osVersionCode,
      "os_Version_Name": osVersionName,
      "screen_Name": "",
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "token": token,
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.GetBookedTripDetail_v1, body);
    print("RESPONSE -- > ${response.data['data']}");
    if (response is! DioException && response.statusCode == 200) {
      return Right(BookedTripDetailsModel.fromJson((response.data["data"][0])));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, UserPanUploadModel>> userPanUpload(
      String imagePath, String panNumber) async {
    String userId = controller.sapId;
    MultipartFile multipartImageFile = await MultipartFile.fromFile(imagePath);

    FormData formData = FormData.fromMap({
      "User_Id": userId,
      "Channel": AppConstants.channel,
      "Os_Type": osType,
      "App_Version": AppConstants.appVersionName,
      "Device_Id": deviceId,
      "PanCardNumber": panNumber,
      "PanCardImage": multipartImageFile
    });

    final response = await Requests.sendPostForm(
        ApiConstants.postUserPanUpload, formData, userId);
    print("data ${response.data}");

    if (response is! DioException && response.statusCode == 200) {
      return Right(UserPanUploadModel.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, UserGstUploadModel>> userGstUpload(
      String imagePath, String gstNumber) async {
    String userId = controller.sapId;
    MultipartFile multipartImageFile = await MultipartFile.fromFile(imagePath);

    FormData formData = FormData.fromMap({
      "User_Id": userId,
      "Channel": AppConstants.channel,
      "Os_Type": osType,
      "App_Version": AppConstants.appVersionName,
      "Device_Id": deviceId,
      "GST_Number": gstNumber,
      "GSTCertImage": multipartImageFile
    });

    final response = await Requests.sendPostForm(
        ApiConstants.postUserGstUpload, formData, userId);
    print("data ${response.data}");

    if (response is! DioException && response.statusCode == 200) {
      return Right(UserGstUploadModel.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, UserPassportUploadModel>> userPassportUpload(
      String passportNo,
      String nationality,
      String gender,
      String firstName,
      String lastName,
      String placeOfIssue,
      String dateOfBirth,
      String birthPlace,
      String issueDate,
      String expiryDate,
      String passportFront,
      String passportBack) async {
    String userId = controller.sapId;
    MultipartFile multipartImageFileFront =
        await MultipartFile.fromFile(passportFront);
    MultipartFile multipartImageFileBack =
        await MultipartFile.fromFile(passportBack);

    FormData formData = FormData.fromMap({
      "User_Id": userId,
      "Channel": AppConstants.channel,
      "Os_Type": osType,
      "App_Version": AppConstants.appVersionName,
      "Device_Id": deviceId,
      "PassportNo": passportNo,
      "Nationality": nationality,
      "Gender": gender,
      "FirstName": firstName,
      "LastName": lastName,
      "PlaceOfIssue": placeOfIssue,
      "DateOfBirth": dateOfBirth,
      "BirthPlace": birthPlace,
      "IssueDate": issueDate,
      "ExpiryDate": expiryDate,
      "PassportFront": multipartImageFileFront,
      "PassportBack": multipartImageFileBack,
    });

    final response = await Requests.sendPostForm(
        ApiConstants.postUserPassportUpload, formData, userId);
    print("data ${response.data}");

    if (response is! DioException && response.statusCode == 200) {
      return Right(UserPassportUploadModel.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<ApiResponse> checkSerialNoExistence(
      String serialNo, String tertiarySaleType) async {
    TertiarySalesHKVAcombo comboController = Get.find();
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "sr_no": serialNo,
      "app_Version": AppConstants.appVersionName,
      "user_Id": sapId,
      "device_Id": deviceId,
      "os_Type": Platform.isAndroid ? "android" : "ios",
      "channel": AppConstants.channel,
      "mobileno": comboController.userInfo.value.mobileNumber
          .substring(comboController.userInfo.value.mobileNumber.length - 10),
      "saledate": comboController.userInfo.value.date,
      "saleType": (tertiarySaleType == AppConstants.singleProduct)
          ? AppConstants.tertiarySingleSaleType
          : AppConstants.tertiaryComboSaleType,
      "token": AppConstants.salesStaticToken
    };
    print("SRS body${body}");
    // try {
    final response = await Requests.sendPostRequest(
        ApiConstants.postSrNoExistanceUpdateEndPoint, body);

    if (response is! DioException &&
        response.statusCode == 200 &&
        response.data["status"] == "200") {
      final ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      // String serialNumberExistanceResponse =
      //     apiResponse.data.isNotEmpty ? apiResponse.data[0].wrsEntryStatus : "";

      return apiResponse;
    } else {
      return ApiResponse(
          message: "Api Failed", status: "", token: "", data: [], data1: "");
    }
  }

  @override
  Future<Either<Failure, CashCoinExcelModel>> getCashHistoryExcelData(
      String selectedSaleType,
      String selectedTransType,
      String selectCreditTransType,
      String selectDebitTransType,
      String fromDateVal,
      String toDateVal,
      String categoryType,
      String redemptionModeVal,
      int pageNumber,
      int pageSize,
      String searchKey,
      {String? dealerCode}) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "transaction_User_Id":
          (dealerCode == null) ? sapId : dealerCode /*"9900000062"*/,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "userType": selectedSaleType,
      "transactionType": selectedTransType,
      "creditVerificationType": selectCreditTransType,
      "debitVerificationType": selectDebitTransType,
      "fromdate": fromDateVal,
      "todate": toDateVal,
      "category": categoryType,
      "redemptionmode": redemptionModeVal,
      "pageSize": pageSize,
      "pageNumber": pageNumber,
      "SearchKey": searchKey
    };
    final response = await Requests.sendPostRequest(
        ApiConstants.postCashHistoryExcelEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(CashCoinExcelModel.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, CashCoinExcelModel>> getCoinHistoryExcelData(
      String selectedSaleType,
      String selectedTransType,
      String selectCreditType,
      String selectCreditTransType,
      String selectDebitTransType,
      String fromDateVal,
      String toDateVal,
      String categoryType,
      String redemptionModeVal,
      int pageNumber,
      int pageSize,
      String searchKey,
      {String? dealerCode}) async {
    String sapId = controller.sapId;
    String language = languageController.language;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "transaction_User_Id":
          (dealerCode == null) ? sapId : dealerCode /*"9900000062"*/,
      "token": "",
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
      "startDate": fromDateVal,
      "endDate": toDateVal,
      "search_Key": searchKey,
      "transactionType": selectedTransType,
      "CreditType": selectCreditType,
      "category": categoryType,
      "redemptionMode": redemptionModeVal,
      "creditStatus": selectCreditTransType,
      "debitStatus": selectDebitTransType,
      "SaleType": selectedSaleType,
      "pageSize": pageSize,
      "pageNo": pageNumber,
    };
    final response = await Requests.sendPostRequest(
        ApiConstants.postCoinHistoryExcelEndPoint, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(CashCoinExcelModel.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, SaveTermsConditionResponse>> updateTermsCondition(
      String termsConditionId) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "token": token,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "device_Name": deviceName,
        "os_Type": osType,
        "os_Version_Name": osVersionName,
        "os_Version_Code": osVersionCode,
        "ip_Address": ipAddress,
        "language": language,
        "screen_Name": "",
        "network_Type": networkType,
        "network_Operator": networkOperator,
        "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
        "channel": AppConstants.channel,
        "id": termsConditionId
      };
      print("Save Terms Condition Body: $body");
      final response = await Requests.sendPostRequest(
          ApiConstants.postUpdateTermsConditionEndPoint, body);

      if (response is! DioException && response.statusCode == 200) {
        print("Save Terms Condition DATA ${response.data}");
        return Right(SaveTermsConditionResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(
          ServerFailure("Failed to fetch Save Terms Condition: $error"));
    }
  }

  @override
  Future<Either<Failure, bool>> clearPreTableData() async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;

    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "token": token,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "device_Name": deviceName,
        "os_Type": osType,
        "os_Version_Name": osVersionName,
        "os_Version_Code": osVersionCode,
        "ip_Address": ipAddress,
        "language": language,
        "screen_Name": "",
        "network_Type": networkType,
        "network_Operator": networkOperator,
        "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
        "channel": AppConstants.channel,
      };

      final response = await Requests.sendPostRequest(
          ApiConstants.postHKVABackButtonCleanUpEndPoint, body);

      if (response is! DioException && response.statusCode == 200) {
        return Right(true);
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure("Failed to call clean up: $error"));
    }
  }

  @override
  Future<Either<Failure, String>> fetchAppSettingValues(String transaction_id) async {
    String token = controller.token;
    String sapId = controller.sapId;
    String language = languageController.language;
    UserDataController userDataController = Get.find();

    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "LoginUserId": sapId,
        "token": token,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "device_Name": deviceName,
        "otp": "",
        "os_Type": osType,
        "os_Version_Name": osVersionName,
        "os_Version_Code": osVersionCode,
        "ip_Address": ipAddress,
        "language": language,
        "screen_Name": "",
        "network_Type": networkType,
        "network_Operator": networkOperator,
        "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
        "channel": AppConstants.channel,
        "Phone_Number": userDataController.phoneNumber,
        "type": "",
        "transactionId": transaction_id,
        "mode": "",
        "electrician_Mapping_Flag": ""
      };

      final response = await Requests.sendPostRequest(
          ApiConstants.fetchAppSettingValue, body);

      if (response is! DioException && response.statusCode == 200) {
        print("***${response.data}");
        return Right(response.data['data']);
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure("Failed to call clean up: $error"));
    }
  }

  @override
  Future<Either<Failure, UpdateAppVersionModel>> postUpdateAppVersion() async {
    String phoneNo = controller.phoneNumber;
    String sapId = controller.sapId;
    String getFcmToken = controller.fcmToken;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "PhoneNo": phoneNo,
      "FcmToken": getFcmToken
    };

    final response = await Requests.sendPostRequest(
      ApiConstants.postUpdateAppVersion,
      body,
    );
    if (response is! DioException && response.statusCode == 200) {
      var obj = UpdateAppVersionModel.fromJson(response.data);
      AuthController authController = Get.find();
      authController.updateAccessToken(obj.token);
      authController.updateRefreshToken(obj.data);
      return Right(obj);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, dynamic>> postDeleteTraveller(
      int tripId,String deletedId) async {
    String sapId = controller.sapId;
    final token = controller.token;

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "tripId": tripId,
      "app_Version": AppConstants.appVersionCode,
      "channel": AppConstants.channel,
      "device_Id": deviceId,
      "device_Name": deviceName,
      "ip_Address": ipAddress,
      "language": languageController.language,
      "network_Operator": networkOperator,
      "network_Type": networkType,
      "os_Type": osType,
      "os_Version_Code": osVersionCode,
      "os_Version_Name": osVersionName,
      "screen_Name": "",
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "token": token,
      "traveller_Id": deletedId,
      "showDeleteFlag": "1"
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postIsmart_DeleteTravelID, body);
    print("RESPONSE -- > ${response.data['data']}");
    if (response is! DioException && response.statusCode == 200) {
      return Right(response.data);
      // return Right(BookedTripDetailsModel.fromJson((response.data["data"][0])));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }
}
