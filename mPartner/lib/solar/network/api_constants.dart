import '../../app_config.dart';

class SolarApiConstants{
  static String baseUrlSolar = AppConfig.shared.urlSolar;
  static String baseUrlNonSapApi = AppConfig.shared.urlNonSapApi;
  static String baseUrlCommonApi = AppConfig.shared.urlCommonApi;
  static String postGetSolutionTypes="$baseUrlSolar/LookUpType";
  static String postGetAverageEnergyConsumptionTypes="$baseUrlSolar/Get_AvgEnergyConsumption";
  static String postFinanceRequests = "$baseUrlSolar/Get_FinanceRequest_Count_Details";
  static String postSolarDesignCountDetails = "$baseUrlSolar/Get_SolarDesign_Count_Details";
  static String postSaveDigitalSurveyCustomerDetails = "$baseUrlSolar/Save_DigitalSurvey_CustomerDetails";
  static String postGetPreferredBanksList="$baseUrlSolar/Get_PreferedBankDetails";
  static String postGetLoanScheme="$baseUrlSolar/Get_Loan_Scheme_Banner";
  static String postGetUnits="$baseUrlSolar/Get_UnitDetails";
  static String postDigitalSurveyRequestList="$baseUrlSolar/get_DigitalSurvey_RequestList";
  static String postFinanceRequestsList = "$baseUrlSolar/get_financial_RequestList";
  static String saveCustomerProjectDetailsUrl="$baseUrlSolar/Save_CustomerProjectDetails";
  static String postDigitalRequestByProjectId = "$baseUrlSolar/Get_DigitalSurvey_RequestListBy_ProjectId";
  static String financeCustomerProjectDetails = "$baseUrlSolar/get_financial_RequestListBy_ProjectId";
  static String postReassignRequest = "$baseUrlSolar/ReassignByProjectId";
  static String getProjectExecutionDashboardData = "$baseUrlSolar/get_ProjectExecution_Count_Details";
  static String getSupportReason = "$baseUrlSolar/Get_Supported_Reason";
  static String saveProjectExecutionProjectData = "$baseUrlSolar/Save_ProjectExecution_CustomerDetails";
  static String getPERequestList="$baseUrlSolar/get_ProjectExecution_RequestList";
  static String postGoSolarCountDetails = "$baseUrlSolar/Get_Finance_Design_Execution_Requests";
  static String getPERequestDetailById = "$baseUrlSolar/get_ProjectExecution_RequestListBy_ProjectId";
  static String postReScheduleRequest = "$baseUrlSolar/RescheduleByProjectId";
  static String getSapStates = "$baseUrlNonSapApi/SapStateList";
  static String postGetCityList = "$baseUrlCommonApi/GetDistrictListByStateId";
  static String postGetStatusHistory = "$baseUrlSolar/Get_Status_History";
}