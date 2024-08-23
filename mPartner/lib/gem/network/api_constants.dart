import '../../app_config.dart';

class GemApiConstants{
  static String baseUrlSolarApi = AppConfig.shared.urlGem;

  static String fetchRegistrationData =
      "$baseUrlSolarApi/SolarModule/CustomerData";
  static String fetchlookupType =
      "$baseUrlSolarApi/SolarModule/LookUpType";

  static String fetchTermConditionData =
      "$baseUrlSolarApi/SolarModule/GetTerms_Conditions";

  static String getGEMModuleDetailCategoryEndPoint =
      "$baseUrlSolarApi/SolarModule/GetGEMModuleDetail";

  static String getGEMTenderInformationStateWiseEndPoint =
      "$baseUrlSolarApi/SolarModule/GetTenderInformation";

  static String SubmitAuthCodeDetails =
      "$baseUrlSolarApi/AuthorizationCode/SubmitAuthCodeDetails";

  static String getGEMTenderStateListEndPoint =
      "$baseUrlSolarApi/SolarModule/GetStatesList";

  static String submitMafDetails =
      "$baseUrlSolarApi/SolarModule/SubmitMAFDetails";
  static String GetAuthCodeDetails =
      "$baseUrlSolarApi/AuthorizationCode/GetAuthCodeDetails";

  static String GetAuthCodeList =
      "$baseUrlSolarApi/AuthorizationCode/GetAuthCodeList";

  static String GetAuthCodeCount =
      "$baseUrlSolarApi/AuthorizationCode/GetAuthCodeCount";


  static String CheckIfGSTExists =
      "$baseUrlSolarApi/AuthorizationCode/CheckIfGSTExists";

  static String getBidNumberDetails =
      "$baseUrlSolarApi/SolarModule/GetBidNumberDetail";

  static String updateBidStatus =
      "$baseUrlSolarApi/SolarModule/UpdateBidStatus";

  static String GetGemRegistrationCount =
      "$baseUrlSolarApi/SolarModule/GetBidRequestsCount";

  static String getMafHomePageRequestList =
      "$baseUrlSolarApi/SolarModule/GetMAFRequestsList";

  static String verifyBidNumber =
      "$baseUrlSolarApi/SolarModule/VerifyBidNumber";

  static String imageBaseUrl = AppConfig.shared.gemImageUrl;
}