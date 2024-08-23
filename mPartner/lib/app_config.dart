enum Flavor { prod, staging, dev, pre_prod }

class AppConfig {
  String appName = "";
  String urlMpartnerApi3 = "";
  String urlHomeScreenApi = "";
  String urlISmartApi = "";
  String urlBankingUpiApi = "";
  String urlUserEngagementApi = "";
  String urlNonSapApi = "";
  String urlCommonApi = "";
  String urlManagementApi = "";
  String urlReportManagementApi = "";
  String urlSolar = "";
  Flavor flavor = Flavor.dev;
  String urlGem="";
  String gemImageUrl="";

  static AppConfig shared = AppConfig.create();

  factory AppConfig.create({
    String appName = "",
    String urlMpartnerApi3 = "",
    String urlHomeScreenApi = "",
    String urlISmartApi = "",
    String urlBankingUpiApi = "",
    String urlUserEngagementApi = "",
    String urlNonSapApi = "",
    String urlCommonApi = "",
    String urlManagementApi = "",
    String urlReportManagementApi = "",
    String urlSolar = "",
    String urlGem = "",
    String gemImageUrl = "",

    Flavor flavor = Flavor.dev,
  }) {
    return shared = AppConfig(
        appName,
        urlMpartnerApi3,
        urlHomeScreenApi,
        urlISmartApi,
        urlBankingUpiApi,
        urlUserEngagementApi,
        urlNonSapApi,
        urlCommonApi,
        urlManagementApi,
        urlReportManagementApi,
        urlSolar,
        urlGem,
        gemImageUrl,
        flavor);
  }

  AppConfig(
      this.appName,
      this.urlMpartnerApi3,
      this.urlHomeScreenApi,
      this.urlISmartApi,
      this.urlBankingUpiApi,
      this.urlUserEngagementApi,
      this.urlNonSapApi,
      this.urlCommonApi,
      this.urlManagementApi,
      this.urlReportManagementApi,
      this.urlSolar,
      this.urlGem,
      this.gemImageUrl,
      this.flavor);
}
