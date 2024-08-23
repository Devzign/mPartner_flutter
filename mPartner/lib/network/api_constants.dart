import '../../app_config.dart';

class ApiConstants {
  static String baseUrlMpartnerApi3 = AppConfig.shared.urlMpartnerApi3;
  static String baseUrlHomeScreenApi = AppConfig.shared.urlHomeScreenApi;
  static String baseUrlISmartApi = AppConfig.shared.urlISmartApi;
  static String baseUrlBankingUpiApi = AppConfig.shared.urlBankingUpiApi;
  static String baseUrlUserEngagementApi =
      AppConfig.shared.urlUserEngagementApi;
  static String baseUrlNonSapApi = AppConfig.shared.urlNonSapApi;
  static String baseUrlCommonApi = AppConfig.shared.urlCommonApi;
  static String baseUrlManagementApi = AppConfig.shared.urlManagementApi;
  static String baseUrlReportManagementApi =
      AppConfig.shared.urlReportManagementApi;

  static String postOTPEndPoint = "$baseUrlHomeScreenApi/login/CreateOtp";
  static String postActiveOTPEndPoint = "$baseUrlHomeScreenApi/login/ActiveOtp";

  static String postOTPAuthEndPoint =
      "$baseUrlHomeScreenApi/login/OTPAuthentication";
  static String postRefreshToken = "$baseUrlHomeScreenApi/login/RefreshToken";
  static String postUserProfileEndPoint =
      "$baseUrlHomeScreenApi/User/GetProfile";
  static String postUpadteProfileEndPoint =
      "$baseUrlHomeScreenApi/User/UpdateProfile";
  static String postDeleteDeviceEndPoint =
      "$baseUrlHomeScreenApi/User/deletedevice";
  static String postSecDevCreateOTPEndPoint =
      "$baseUrlHomeScreenApi/Login/SecondaryUserCreateOtp";
  static String postSecDevOTPAuthEndPoint =
      "$baseUrlHomeScreenApi/Login/SecondaryOTPAuthentication";
  static String postLogoutEndPoint = "$baseUrlHomeScreenApi/Login/Logout";

  static String postUserDataEndPoint = "$baseUrlHomeScreenApi/User/GetUserData";

  static String updateFcmTokenEndPoint =
      "$baseUrlHomeScreenApi/Login/UpdateFcmToken";

  static String postSplashEndPoint =
      "$baseUrlHomeScreenApi/HomeScreen/Dynamic_Screen";
  static String postLanguageEndPoint =
      "$baseUrlHomeScreenApi/HomeScreen/GetLanguage";
  static String postMenuIconsEndpoint =
      "$baseUrlHomeScreenApi/HomeScreen/Menu_side_upper_botton_New";

  static String postHomepageBannersEndpoint =
      "$baseUrlHomeScreenApi/HomeScreen/Home_Page_Cards_V1";

  static String getPreviouslyPurchasedProduct =
      "$baseUrlISmartApi/TertiarySale/GetPreviouslyPurchasedProduct";

  static String postCatalogEndPoint =
      "$baseUrlHomeScreenApi/Homescreen/Catalog_MainPdf_New";
  static String postPricelistEndPoint =
      "$baseUrlHomeScreenApi/HomeScreen/PriceList_Page_Cards";
  static String postSchemeEndPoint =
      "$baseUrlHomeScreenApi/HomeScreen/Scheme_Page_Cards";

  static String postCoinsEarnedEndpoint =
      "$baseUrlHomeScreenApi/Dealer/GetDealerRewardHistory_v2";
  static String postCashEarnedEndpoint =
      "$baseUrlHomeScreenApi/Dealer/Pinelab_getPoints_new";

  static String postPricelistHomepageEndpoint =
      "$baseUrlHomeScreenApi/HomeScreen/PriceList_Page_Cards_Home";
  static String fetchAllPriceListEndpoint =
      "$baseUrlHomeScreenApi/HomeScreen/PriceList_Page_Cards";
  static String postSchemeHomepageEndpoint =
      "$baseUrlHomeScreenApi/HomeScreen/Scheme_Page_Cards_Home";

  static String postTermsConditionsEndPoint =
      "$baseUrlISmartApi/ISmart/GetTerms_Conditions";

  static String postDisclaimerEndPoint =
      "$baseUrlISmartApi/ISmart/GetDisclaimer";

  static String postCashHistoryEndPoint =
      "$baseUrlISmartApi/ISmart/TransactionHistory";

  static String postCoinHistoryEndPoint =
      "$baseUrlISmartApi/ISmartCoins/GetISmartSchemeDashboardTransactionData";

  static String postGetSaleTypeEndPoint =
      "$baseUrlISmartApi/saleType/GetSaleType";

  static String postGetDealerListEndPoint =
      "$baseUrlISmartApi/Dealer/GetDealerList";

  static String postGetElectricianListEndPoint =
      "$baseUrlISmartApi/Electrician/GetElectricianList";

  static String postIntermediarySaleDetailsListEndPoint =
      "$baseUrlISmartApi/Electrician/getProductDetailsBySerialNo";

  static String postSaleDetailsListEndPoint =
      "$baseUrlISmartApi/Dealer/getProductDetailsBySerialNo";

  static String postCashRedemptionOptionsEndPoint =
      "$baseUrlISmartApi/ISmart/RedemptionList";

  static String postHkvaCombination =
      "$baseUrlISmartApi/GetHKVACombination/GetHKVACombination";

  static String postHkvaCombinationEditSubmit =
      "$baseUrlISmartApi/GetHKVACombination/HKVACombinationEditSubmit";

  static String postHkvaCombinationBeforSubmit =
      "$baseUrlISmartApi/GetHKVACombination/HKVACombinationBeforeSubmit";

  static String postHkvaCreateOtp =
      "$baseUrlISmartApi/GetHKVACombination/EW_CreateOtp_V3_HKVA";
  static String postGetEwarrantyOptionsEndPoint =
      "$baseUrlISmartApi/GetEwarrantyOptions/GetEwarrantyOptions";

  static String postSrNoExistanceUpdateEndPoint =
      "$baseUrlISmartApi/TertiarySale/mSerWRSrNoExistanceUpdateV4";

  static String postSecondarySrNoExistanceUpdateEndPoint =
      "$baseUrlISmartApi/TertiarySale/SecondarySerialNoExistence";

  static String postEwarrantyCreateOtpEndPoint =
      "$baseUrlISmartApi/TertiarySale/EW_CreateOtp_V3";

  static String postEwarrantyVerifyOtpEndPoint =
      "$baseUrlISmartApi/TertiarySale/EW_VarifyOtpV3";

  static String postCoinToCashbackConversionEndPoint =
      "$baseUrlISmartApi/ISmartCoins/FinalCoinConversation";
  static String postCoinToCashbackConversionSubmitEndPoint =
      "$baseUrlISmartApi/ISmartCoins/FinalCoinConversationSubmit";
  static String postCoinsSummaryEndpoint =
      "$baseUrlISmartApi/ISmartCoins/GetISmartSchemeDashboardPoints";
  static String postCashSummaryEndpoint =
      "$baseUrlISmartApi/ISmart/GetAllocatePointByMode";
  static String postCoinRedemptionOptionsEndpoint =
      "$baseUrlISmartApi/ISmartCoins/GetSmartRedeemType";
  static String postEwarrantySaveWithOTPPoint =
      "$baseUrlISmartApi/TertiarySale/WebService_EW_SaveWithOTP_WarrantyV3_Trip";

  static String postGetSerWRSPrimarySecTerDetailEndPoint =
      "$baseUrlISmartApi/ISmart/Get_SerWRS_Primary_Sec_Ter_Detail_V2";

  static String postConsumerEmiCreateOtp =
      "$baseUrlISmartApi/ConsumerEmi/CreateOtp_ConsumerEmi";

  static String postConsumerEmiVerifyOtp =
      "$baseUrlISmartApi/ConsumerEmi/OTPAuthentication_ConsumerEmi";

  static String postConsumerEmiGetRoSmDetails =
      "$baseUrlISmartApi/ConsumerEmi/ConsumerEMI_Get_Ro_Sm_Details";

  static String postConsumerEmiLog =
      "$baseUrlISmartApi/ConsumerEmi/ConsumerEMI_Log";

  static String postHkvaVerifyOtpEndPoint =
      "$baseUrlISmartApi/TertiarySale/EW_VarifyOtpV3";

  static String postPaytmNumberExists =
      "$baseUrlBankingUpiApi/PaytmAccountExists";

  static String postVerifyPaytmMobileNoGst =
      "$baseUrlBankingUpiApi/VerifyPaytmMobileNo_Gst";

  static String postVerifyPaytmMobileNo =
      "$baseUrlBankingUpiApi/VerifyPaytmMobileNo";

  static String postCreateOtpPaytm =
      "$baseUrlHomeScreenApi/Login/CreateOtp_Paytm";

  static String postAuthenticateOtpPaytm =
      "$baseUrlHomeScreenApi/Login/OTPAuthentication_Paytm";

  static String postVerifyPaytmMobileOtp =
      "$baseUrlBankingUpiApi/VerifyPaytmMobileOTP";

  static String postVerifyPaytmMobileOtpGst =
      "$baseUrlBankingUpiApi/VerifyPaytmMobileOTP_Gst";

  static String postGetReportType = "$baseUrlReportManagementApi/GetReportType";

  static String postGetPrimaryReportType =
      "$baseUrlReportManagementApi/GetPrimaryReportType";

  static String postSecondarySalesReportDistributor =
      "$baseUrlReportManagementApi/GetSecondarySalesReportSummary";

  static String postProductWiseDetails =
      "$baseUrlReportManagementApi/GetProductWiseDetails";

  static String postSecondaryReportPDFDownload =
      "$baseUrlReportManagementApi/SecondarySalesReport";

  static String postTertiaryReport =
      "$baseUrlReportManagementApi/GetTertiarySalesReport";

  static String postTertiaryReportPdfDownload =
      "$baseUrlReportManagementApi/TertiaryReportExcelFileDownload";

  static String postTertiaryProductWiseDetails =
      "$baseUrlReportManagementApi/Get_Wrs_Filter_Report";

  static String postPrimaryBillingReport =
      "$baseUrlReportManagementApi/Distributor_Primary_Billing_Report";

  static String postCustomerLedgerReport =
      "$baseUrlReportManagementApi/Distributor_Ledger_Report";

  static String postCreditDebitNoteReport =
      "$baseUrlReportManagementApi/Distributor_Credit_Debit_Report";

  static String postGetCustomerListEndPoint =
      "$baseUrlReportManagementApi/GetCustomerDetails";

  static String postReportDownloadForDealer =
      "$baseUrlReportManagementApi/ProductWiseDetailReport";
  static String postPaytmTransactionDetails =
      "$baseUrlBankingUpiApi/Paytm_TransactionDetails";

  static String getBatteryManagementStateList =
      "$baseUrlNonSapApi/Webservice_Bmhr_State";

  static String getBatteryManagementCityList =
      "$baseUrlNonSapApi/Webservice_Bmhr_City";

  static String getBatteryManagementAddressList =
      "$baseUrlNonSapApi/Webservice_Bmhr_Address";

  static String postSurveyQuestionsEndPoint =
      "$baseUrlUserEngagementApi/PopupsAndSurvey/SurveyQuestions";

  static String postSurveyAnswersEndPoint =
      "$baseUrlUserEngagementApi/PopupsAndSurvey/SurveyAnswers";

  static String postAlertNotificationEndPoint =
      "$baseUrlUserEngagementApi/PopupsAndSurvey/GetAlertNotification";

  static String postReadCheckAlertNotificationEndPoint =
      "$baseUrlUserEngagementApi/PopupsAndSurvey/IsReadCheck_AlertNotification";

  static String postTertiarySaleBulkDetailsListEndPoint =
      "$baseUrlISmartApi/TertiarySale/GetTertiaryBulkProductInfo";

  static String postTertiarySaleBulkPDFUploadEndPoint =
      "$baseUrlISmartApi/TertiarySale/TertiaryBulkPDFUpload";

  static String postTertiaryBulkProductSaveEndPoint =
      "$baseUrlISmartApi/TertiarySale/TertiaryBulkProductSave";

  static String postFseAgreementEndPoint =
      "$baseUrlUserEngagementApi/PopupsAndSurvey/FSE_Agreement";

  static String postFeedBackAnswersEndPoint =
      "$baseUrlUserEngagementApi/PopupsAndSurvey/FeedBackAnswers";

  static String postUpdateTermsConditionEndPoint =
      "$baseUrlUserEngagementApi/PopupsAndSurvey/Save_TermsCondition_Data";

  static String postGetAdvertisementLanguage =
      "$baseUrlUserEngagementApi/AdvertisementManagement/GetLanguage";

  static String postGetAdvertisementImageUrls =
      "$baseUrlUserEngagementApi/AdvertisementManagement/Custom_Image";

  static String postContactUsDetails =
      "$baseUrlUserEngagementApi/HelpandSupport/ContactUs_Details";

  static String postSuggestion =
      "$baseUrlUserEngagementApi/v1/HelpandSupport/Save_Contactus_Suggestion";
  static String postLuminousVideos =
      "$baseUrlHomeScreenApi/HomeScreen/PlaylistItems";
  static String postLuminousChannelIcon =
      "$baseUrlHomeScreenApi/HomeScreen/PlaylistItemsChannelIcon";
  static String postLuminousVideosViewsCount =
      "$baseUrlHomeScreenApi/HomeScreen/PlaylistItemssViewsCount";

  static String getStateList = "$baseUrlNonSapApi/SapStateList";

  static String getDistrictListInfo = "$baseUrlCommonApi/GetDistrictListByStateId";

  static String getCityListInfo = "$baseUrlCommonApi/GetCityListDistrictId";

  static String getGovtIdListListInfo =
      "$baseUrlManagementApi/DelearManagement/GetDocList";

  static String createOtp =
      "$baseUrlManagementApi/DelearManagement/CreateOtp_Dealer";

  static String verifyOtp =
      "$baseUrlManagementApi/DelearManagement/OtpVerification_Dealer";

  static String createDealer =
      "$baseUrlManagementApi/DelearManagement/CreateDealer";

  static String createElectrician =
      "$baseUrlManagementApi/ElectricianManagement/CreateElectrician";

  static String getDealerStatusList =
      "$baseUrlManagementApi/DelearManagement/GetCheckDealerStatusList";

  static String getElectricainStatusList =
      "$baseUrlManagementApi/ElectricianManagement/GetElectricianStatus";

  static String getDealerDetails =
      "$baseUrlManagementApi/DelearManagement/GetDealerDetails";

  static String getDealerList =
      "$baseUrlManagementApi/DelearManagement/GetDealersList";
  static String GetDealersList_V1 =
      "$baseUrlManagementApi/DelearManagement/GetDealersList_V1";


  static String getElectricainList =
      "$baseUrlManagementApi/ElectricianManagement/GetElectricianStatusList";

  static String getElectricainListItemDetails =
      "$baseUrlManagementApi/ElectricianManagement/GetElectricianDetails";

  static String getDealerListItemDetails =
      "$baseUrlManagementApi/DelearManagement/GetDealerDetails_V1";


  // static String setDealerBlockRedumption =
  //     "$baseUrlManagementApi/DelearManagement/Block_PinelabPartner";
  static String SetUpdateDistributorInActive =
      "$baseUrlManagementApi/DelearManagement/UpdateDistributorInActive";

  static String Block_UnblockDealer_V1 =
      "$baseUrlManagementApi/DelearManagement/Block_UnblockDealer_V1";


  static String setElectricianBlockRedumption =
      "$baseUrlManagementApi/ElectricianManagement/BlockUnblock_Electrician";

  static String getFseAgreementCreateOtpEndPoint =
      "$baseUrlNonSapApi/SSCMDisCreateOtp";

  static String getFseAgreementVerifyOtpEndPoint =
      "$baseUrlNonSapApi/SSCMDisVarifyOtp";

  static String updateFSEAcknowledgementEndPoint =
      "$baseUrlUserEngagementApi/PopupsAndSurvey/Save_FSE_Agreement";

  static String postFetchTrips =
      "$baseUrlISmartApi/Trip/GetChannelSchemeTripList";
  static String getSavedTravellers =
      "$baseUrlISmartApi/Trip/GetSavedTravellers";
  static String postBookTrip =
      "$baseUrlISmartApi/Trip/SubChannelSchemeTripForm";
  static String getTravellerInfo = "$baseUrlISmartApi/Trip/GetTravellerById";
  // static String postFetchBookedTripDetails =
  //     "$baseUrlISmartApi/Trip/GetBookedTripDetail";

  static String GetBookedTripDetail_v1 =
      "$baseUrlISmartApi/Trip/GetBookedTripDetail_v1";
  static String postIsmart_DeleteTravelID =
      "$baseUrlISmartApi/Trip/Ismart_DeleteTravelID";


  static String checkTravellerPassportNumber =
      "$baseUrlISmartApi/Trip/GetTravellerByPassportNo";
  static String putTravellerMobileNumberUsingPassportNumber =
      "$baseUrlISmartApi/Trip/EditTravellerdetails";
  static String getWarrantyPdf =
      '$baseUrlISmartApi/GetEwarrantyOptions/DownloadWarrantyCard';
  static String postIsmartOffers =
      "$baseUrlISmartApi/ISmart/Ewarranty_Page_Cards";
  static String patchUpdateUserEndPoint =
      "$baseUrlHomeScreenApi/Login/UpdateUserId";
  static String postPinelabCreateOtp =
      "$baseUrlBankingUpiApi/CreateOtp_Pinelab";
  static String postPinelabVerifyOtp =
      "$baseUrlBankingUpiApi/OTPAuthentication_Pinelab";
  static String postPinelabVerifyMobileNoGst =
      "$baseUrlBankingUpiApi/VerifyPinelabMobileNo_Gst";
  static String postPinelabGetBalancePoint =
      "$baseUrlBankingUpiApi/getpinelab_balancepoint";
  static String postPinelabVerifyMobileOtpGst =
      "$baseUrlBankingUpiApi/VerifyPinelabMobileOTP_Gst";
  static String getSalesDateBySrNo = '$baseUrlCommonApi/GetSaleDatesBySerialNo';
  static String postUserUploadProfilePhoto =
      "$baseUrlHomeScreenApi/User/UploadProfilePhoto";

  static String postUPIClientSecretHandshake =
      "$baseUrlBankingUpiApi/UPI_ClientSecret_HandShake";

  static String postUPICheckVPA = "$baseUrlBankingUpiApi/UPI_CheckVPA";

  static String postUPIGetTdsGst = "$baseUrlBankingUpiApi/UPI_get_tds_gst";

  static String postUPITransferAmount =
      "$baseUrlBankingUpiApi/UPI_Transfermount";

  /* Notification Apis [START] */
  static String postNotificationListEndPoint =
      "$baseUrlUserEngagementApi/Notification/GetNotificationDetailsOnType";

  static String postNotificationDetailEndPoint =
      "$baseUrlUserEngagementApi/Notification/GetNotificationDetailsOnNotificationId";

  static String postTransactionDetailsEndPoint =
      "$baseUrlUserEngagementApi/Notification/GetTransactionDetailOnBehalfOfTypeAndId";

  static String postReadNotificationDetailOnIdEndPoint =
      "$baseUrlUserEngagementApi/Notification/ReadNotificationDetailOnId";

  static String postClearNotificationsEndPoint =
      "$baseUrlUserEngagementApi/Notification/DeleteNotificationOnUserId";

  /* Notification Apis [START] */

  static String getWarrantyDetails =
      "$baseUrlISmartApi/ISmart/GetSaleDetailsBySerialNo";

  static String postRelationships =
      "$baseUrlISmartApi/Trip/getChannelSchemeRelationList";

  static String postPancardNullBalanceCheck =
      "$baseUrlISmartApi/ISmartCoins/PanCardNullBalanceCheck";

  static String postUserPanUpload = "$baseUrlHomeScreenApi/User/UploadPan";

  static String postUserGstUpload = "$baseUrlHomeScreenApi/User/UploadGST";

  static String postUserPassportUpload =
      "$baseUrlHomeScreenApi/User/UploadPassport";

  static String postLoginPageCardsEndPoint =
      "$baseUrlHomeScreenApi/HomeScreen/Login_Page_Cards";

  static String postCashHistoryExcelEndPoint =
      "$baseUrlISmartApi/ISmart/DownloadCashHistoryReport";
  static String postCoinHistoryExcelEndPoint =
      "$baseUrlISmartApi/ISmartCoins/DownloadCoinHistoryReport";

  static String postHKVABackButtonCleanUpEndPoint =
      "$baseUrlISmartApi/GetHKVACombination/HKVABackButtonCleanUp";

  static String fetchAppSettingValue =
      "$baseUrlHomeScreenApi/Helper/GetAppSettingsValue";

  static String postUpdateAppVersion =
      "$baseUrlHomeScreenApi/Login/UpdateAppVersion";
}
