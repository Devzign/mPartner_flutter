import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

import '../../../data/models/terms_condition_model.dart';
import '../../../error/failure.dart';
import '../../../network/api_constants.dart';
import '../../../state/contoller/language_controller.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/requests.dart';
import '../../network/api_constants.dart';
import '../../presentation/project_execution/model/dashboard_data_model.dart';
import '../../presentation/project_execution/model/form_model.dart';
import '../../presentation/project_execution/model/project_execution_detail_model.dart';
import '../../presentation/project_execution/model/request_list_response.dart';
import '../../presentation/project_execution/model/rescheduling_request_response.dart';
import '../../presentation/project_execution/model/support_reason_model.dart';
import '../../state/controller/solar_design_request_controller.dart';
import '../models/city_model.dart';
import '../models/design_request_model.dart';
import '../models/digital_request_by_project_id_model.dart';
import '../models/digital_survey_request_list_model.dart';
import '../models/energy_consumption_types_model.dart';
import '../models/finace_dashboard_model.dart';
import '../models/finance_customer_project_details_model.dart';
import '../models/get_loan_scheme_model.dart';
import '../models/get_units_model.dart';
import '../models/preferred_bank_response.dart';
import '../models/reassign_request_model.dart';
import '../models/request_tracking_model.dart';
import '../models/save_customer_project_details_model.dart';
import '../models/solar_design_count_details_model.dart';
import '../models/solar_design_form_submit_response.dart';
import '../models/solar_finance_requests_list_model.dart';
import '../models/solution_types_model.dart';
import '../models/go_solar_count_details_model.dart';
import '../models/state_model.dart';

abstract class BaseSolarRemoteDataSource {
  Future<Either<Failure, SolutionTypeResponse>> getSolutionTypes(String lookUpType);

  Future<Either<Failure, EnergyConsumptionTypeResponse>>
      getEnergyConsumptionTypes();

  Future<Either<Failure, FinanceDashboard>> getEnquiryCounts();

  Future<Either<Failure, SolarDesignFormSubmitResponse>>
      saveDigitalSurveyCustomerDetails(
          DesignFormModel formDetails, String billImagePath);

  Future<Either<Failure, SolarDesignCountDetailsResponse>>
      postSolarDesignCountDetails(bool isDigital);

  Future<Either<Failure, PreferredBankResponse>> getPreferredBanksList();

  Future<Either<Failure, GetLoanSchemeModel>> getLoanScheme(int bankId);

  Future<Either<Failure, GetUnitsResponse>> getUnits();
  Future<Either<Failure, SolarFinanceExistingLeads>> getFinanceRequestsList(String categoryName, int pageNumber, int pageSize, {String filterStatus = "", String searchString = ""});
  Future<Either<Failure, SaveCustomerProjectDetailsResponse>> saveProjectDetails(
      String category,
      String companyName,
      String contactPerson,
      String contactPersonMobileNo,
      String contactPersonEmailId,
      String secondaryContactName,
      String secondaryContactMobileNo,
      String secondaryContactEmailId,
      String projectName,
      String pincode,
      String state,
      String city,
      String projectCapacity,
      int unit,
      String projectCost,
      int preferredBankId,
      String gstinNumber,
      String panNumber);

  Future<Either<Failure, DigitalSurveyRequestListResponse>> postDigitalSurveyRequestList
      (String categoryType, String searchString, String filterDesignStatus, String filterSolutionType, bool isDigital, int pgNumber, int pgSize);

  Future<Either<Failure, DigitalRequestByProjectIdResponse>> postDigitalRequestByProjectId
      (String projectId);

  Future<Either<Failure,TermsConditionsResponse >> getTermsAndConditionList(String pageName);
  Future<Either<Failure,SolarFinanceCustomerProjectDetails >> postFinanceCustomerProjectDetails(String projectId);

  Future<Either<Failure, ReassignRequestResponse>> postReassignRequest(
      String projectId, String remark);

  Future<Either<Failure, ProjectExecutionSupportReasonResponse>> getSupportReasonData(String moduleType,String category, String executionTitle);

  Future<Either<Failure, SolarDesignFormSubmitResponse>>
  saveProjectExecutionProjectDetails(
      FormModel formDetails);

  Future<Either<Failure, GoSolarCountDetailsResponse>> postGoSolarCountDetails();

  Future<Either<Failure, SolarStateDataResponse>> getSapStateList();

  Future<Either<Failure, SolarCityDataResponse>> postGetCityListDistrictId(int stateId);

  Future<Either<Failure, SolarRequestTracking>> postRequestTracking(String projectId);
}

class SolarRemoteDataSource extends BaseSolarRemoteDataSource {
  UserDataController userDataController = Get.find();
  LanguageController languageController = Get.find();

  @override
  Future<Either<Failure, SolutionTypeResponse>> getSolutionTypes(String lookUpType) async {
    final Map<String, dynamic> body = {
      "user_Id": userDataController.sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "lookUpType": lookUpType,
    };

    final response = await Requests.sendPostRequest(
        SolarApiConstants.postGetSolutionTypes, body);

    if (response is! DioException && response.statusCode == 200) {
      return Right(SolutionTypeResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, EnergyConsumptionTypeResponse>>
      getEnergyConsumptionTypes() async {
    final Map<String, dynamic> body = {
      "user_Id": userDataController.sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId
    };

    final response = await Requests.sendPostRequest(
        SolarApiConstants.postGetAverageEnergyConsumptionTypes, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(EnergyConsumptionTypeResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, FinanceDashboard>> getEnquiryCounts() async {
    final Map<String, dynamic> body = {
      "user_Id": userDataController.sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
    };

    final response = await Requests.sendPostRequest(
        SolarApiConstants.postFinanceRequests, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(FinanceDashboard.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, SolarDesignCountDetailsResponse>>
      postSolarDesignCountDetails(bool isDigital) async {
    String sapId = userDataController.sapId;

    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "channel": AppConstants.channel,
        "os_Type": osType,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "SolarModuleType": isDigital ? "Digital" : "Physical",
      };
      logger.i("Solar Design Count Details Body: $body");
      logger.d("Solar Design Count Details API - " +
          SolarApiConstants.postSolarDesignCountDetails);
      final response = await Requests.sendPostRequest(
          SolarApiConstants.postSolarDesignCountDetails, body);

      if (response is! DioException && response.statusCode == 200) {
        logger.i("Solar Design Count Details Response: ${response.data}");
        return Right(SolarDesignCountDetailsResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(
          ServerFailure("Failed to fetch Solar Design Count Details: $error"));
    }
  }

  @override
  Future<Either<Failure, SolarDesignFormSubmitResponse>>
      saveDigitalSurveyCustomerDetails(
          DesignFormModel formDetails, String billImagePath) async {
    String userId = userDataController.sapId;
    MultipartFile multipartImageFile =
        await MultipartFile.fromFile(billImagePath);
    SolarDesignRequestController solarDesignRequestController = Get.find();

    FormData formData = FormData.fromMap({
      "Category": formDetails.category,
      "CompanyName": formDetails.companyName,
      "ContactPerson": formDetails.contactPersonName,
      "ContactPersonMobileNo": formDetails.contactPersonNumber,
      "ContactPersonEmailId": formDetails.contactPersonEmailId,
      "SecondaryContactName": formDetails.secondaryName,
      "SecondaryContactMobileNo": (formDetails.secondaryNumber.isNotEmpty)
          ? formDetails.secondaryNumber
          : "",
      "SecondaryContactEmailId": formDetails.secondaryEmail,
      "ProjectName": formDetails.projectName,
      "ProjectAddress": formDetails.projectAddress,
      "ProjectLandmark": formDetails.projectLandmark,
      "ProjectCurrentLocation": formDetails.projectLocation,
      "Pincode": formDetails.projectPincode,
      "SolutionTypeId": solarDesignRequestController.selectedSolutionTypeId,
      "AvgEnergyConsumption": formDetails.averageEnergy.replaceAll(",", ""),
      "AvgMonthlyBill": formDetails.monthlyBill
          .replaceAll(",", ""), // removing the rupee symbol and the commas
      "Remark": "",
      "User_Id": userDataController.sapId,
      "Channel": AppConstants.channel,
      "Os_Type": osType,
      "App_Version": AppConstants.appVersionName,
      "Device_Id": deviceId,
      "ElectrycityBill": multipartImageFile,
      "PreferredDate":formDetails.preferredDateOfVisit,
      "SolarModuleType":formDetails.solarModuleType,
      "State":formDetails.state,
      "City":formDetails.city,
    });
    logger.d({
      "Category": formDetails.category,
      "CompanyName": formDetails.companyName,
      "ContactPerson": formDetails.contactPersonName,
      "ContactPersonMobileNo": formDetails.contactPersonNumber,
      "ContactPersonEmailId": formDetails.contactPersonEmailId,
      "SecondaryContactName": formDetails.secondaryName,
      "SecondaryContactMobileNo": (formDetails.secondaryNumber.isNotEmpty)
          ? formDetails.secondaryNumber
          : "",
      "SecondaryContactEmailId": formDetails.secondaryEmail,
      "ProjectName": formDetails.projectName,
      "ProjectAddress": formDetails.projectAddress,
      "ProjectLandmark": formDetails.projectLandmark,
      "ProjectCurrentLocation": formDetails.projectLocation,
      "Pincode": formDetails.projectPincode,
      "SolutionTypeId": solarDesignRequestController.selectedSolutionTypeId,
      "AvgEnergyConsumption": formDetails.averageEnergy.replaceAll(",", ""),
      "AvgMonthlyBill": formDetails.monthlyBill
          .replaceAll(",", ""), // removing the rupee symbol and the commas
      "Remark": "",
      "User_Id": userDataController.sapId,
      "Channel": AppConstants.channel,
      "Os_Type": osType,
      "App_Version": AppConstants.appVersionName,
      "Device_Id": deviceId,
      "ElectrycityBill": multipartImageFile,
      "PreferredDate":formDetails.preferredDateOfVisit,
      "SolarModuleType":formDetails.solarModuleType,
      "State":formDetails.state,
      "City":formDetails.city,
    });
    // Dio dio = new Dio();
    // dio.options.headers['Content-Type'] = 'multipart/form-data';
    final response = await Requests.sendPostForm(
        SolarApiConstants.postSaveDigitalSurveyCustomerDetails, formData, userId);
    if (response is! DioException && response.statusCode == 200) {
      return Right(SolarDesignFormSubmitResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, PreferredBankResponse>> getPreferredBanksList() async {
    final Map<String, dynamic> body = {
      "user_Id": userDataController.sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId
    };
    final response = await Requests.sendPostRequest(
        SolarApiConstants.postGetPreferredBanksList, body);

    if (response is! DioException && response.statusCode == 200) {
      return Right(PreferredBankResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, GetLoanSchemeModel>> getLoanScheme(int bankId) async {
    final Map<String, dynamic> body = {
      "user_Id": userDataController.sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "partner_bank": bankId,
    };
    final response = await Requests.sendPostRequest(
        SolarApiConstants.postGetLoanScheme, body);

    if (response is! DioException && response.statusCode == 200) {
      return Right(GetLoanSchemeModel.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, GetUnitsResponse>> getUnits() async {
    final Map<String, dynamic> body = {
      "user_Id": userDataController.sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId
    };
    final response =
        await Requests.sendPostRequest(SolarApiConstants.postGetUnits, body);

    if (response is! DioException && response.statusCode == 200) {
      return Right(GetUnitsResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override

  Future<Either<Failure, DigitalSurveyRequestListResponse>> postDigitalSurveyRequestList
      (String categoryType, String searchString, String filterDesignStatus, String filterSolutionType, bool isDigital, int pgNumber, int pgSize) async {
    String sapId = userDataController.sapId;

    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "channel": AppConstants.channel,
        "os_Type": osType,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "category": categoryType,
        "SearchString": searchString,
        "FilterDesignStatus": filterDesignStatus,
        "FilterSolutionType": filterSolutionType,
        "SolarModuleType": isDigital ? "Digital" : "Physical",
        "PageNumber": pgNumber,
        "PageSize":  pgSize,
      };
      logger.i("Digital Survey Request List Body: $body");
      logger.d("Digital Survey Request List API - " +
          SolarApiConstants.postDigitalSurveyRequestList);
      final response = await Requests.sendPostRequest(
          SolarApiConstants.postDigitalSurveyRequestList, body);

      if (response is! DioException && response.statusCode == 200) {
        logger.i("Digital Survey Request List Response: ${response.data}");
        return Right(DigitalSurveyRequestListResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(
          ServerFailure("Failed to fetch Digital Survey Request List: $error"));
    }
  }

  @override
   Future<Either<Failure, SolarFinanceExistingLeads>> getFinanceRequestsList(String categoryName, int pageNumber, int pageSize, {String filterStatus = "", String searchString = ""}) async{
    final Map<String, dynamic> body = {
      "user_Id": userDataController.sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "category": categoryName,
      "FilterStatus": filterStatus,
      "SearchString": searchString,
      "PageNumber": pageNumber,
      "PageSize": pageSize
    };

    final response = await Requests.sendPostRequest(
        SolarApiConstants.postFinanceRequestsList, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(SolarFinanceExistingLeads.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, SaveCustomerProjectDetailsResponse>>
      saveProjectDetails(
          String category,
          String companyName,
          String contactPerson,
          String contactPersonMobileNo,
          String contactPersonEmailId,
          String secondaryContactName,
          String secondaryContactMobileNo,
          String secondaryContactEmailId,
          String projectName,
          String pincode,
          String state,
          String city,
          String projectCapacity,
          int unit,
          String projectCost,
          int preferredBankId,
          String gstinNumber,
          String panNumber) async {
    SolarDesignRequestController solarDesignRequestController = Get.find();

    FormData formData = FormData.fromMap({
      "User_Id": userDataController.sapId,
      "Channel": AppConstants.channel,
      "Os_Type": osType,
      "App_Version": AppConstants.appVersionName,
      "Device_Id": deviceId,
      "Category": category,
      "CompanyName": companyName,
      "ContactPerson": contactPerson,
      "ContactPersonMobileNo": contactPersonMobileNo,
      "ContactPersonEmailId": contactPersonEmailId,
      "SecondaryContactName": secondaryContactName,
      "SecondaryContactMobileNo": secondaryContactMobileNo,
      "SecondaryContactEmailId": secondaryContactEmailId,
      "ProjectName": projectName,
      "Pincode": pincode,
      "State": state,
      "City": city,
      "SolutionTypeId": solarDesignRequestController.selectedSolutionTypeId,
      "ProjectCapacity": projectCapacity,
      "UnitId": unit,
      "ProjectCost": projectCost,
      "PreferedBankId": preferredBankId,
      "GSTINNumber": gstinNumber,
      "PANNumber": panNumber
    });

    final response = await Requests.sendPostForm(
        SolarApiConstants.saveCustomerProjectDetailsUrl,
        formData,
        userDataController.sapId);

    if (response is! DioException && response.statusCode == 200) {
      return Right(SaveCustomerProjectDetailsResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override

  Future<Either<Failure, DigitalRequestByProjectIdResponse>> postDigitalRequestByProjectId(String projectId) async {
    String sapId = userDataController.sapId;
    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "channel": AppConstants.channel,
        "os_Type": osType,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "ProjectId": projectId,
      };
      print("Digital Request By Project Id Body: $body");
      print("Digital Request By Project Id API - " +
          SolarApiConstants.postDigitalRequestByProjectId);
      final response = await Requests.sendPostRequest(
          SolarApiConstants.postDigitalRequestByProjectId, body);
      if (response is! DioException && response.statusCode == 200) {
        print("Digital Request By Project Id Response: ${response.data}");
        return Right(DigitalRequestByProjectIdResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure(
          "Failed to fetch Digital Request By Project Id: $error"));
    }
  }

  @override
  Future<Either<Failure, TermsConditionsResponse>> getTermsAndConditionList(
      String pageName) async {
    final Map<String, dynamic> body = {
      "user_Id": userDataController.sapId,
      "token": userDataController.token,
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
      "browser": "",
      "browser_Version": "",
      "pageName": pageName
    };

    final response = await Requests.sendPostRequest(
        ApiConstants.postTermsConditionsEndPoint, body);

    if (response is! DioException && response.statusCode == 200) {
      return Right(TermsConditionsResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure,SolarFinanceCustomerProjectDetails >> postFinanceCustomerProjectDetails(String projectId) async {
      final Map<String, dynamic> body = {
      "user_Id": userDataController.sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "projectId": projectId,
    };

    final response = await Requests.sendPostRequest(
        SolarApiConstants.financeCustomerProjectDetails, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(SolarFinanceCustomerProjectDetails.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, ProjectExecutionDashboardResponse>>
      getProjectExecutionDashboardData(String typeValue) async {
    final Map<String, dynamic> body = {
      "user_Id": userDataController.sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "PhoneNo": userDataController.phoneNumber,
      "device_Id": deviceId,
      "projectExecutionType": typeValue
    };

    final response = await Requests.sendPostRequest(
        SolarApiConstants.getProjectExecutionDashboardData, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(ProjectExecutionDashboardResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, ProjectExecutionSupportReasonResponse>>
      getSupportReasonData(String moduleType,String category, String executionTitle) async {
    final Map<String, dynamic> body = {
      "user_Id": userDataController.sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "PhoneNo": userDataController.phoneNumber,
      "SolarModuleType": moduleType,
      "Category" :category,
      "SourceType": executionTitle,
      "device_Id": deviceId,
    };

    final response = await Requests.sendPostRequest(
        SolarApiConstants.getSupportReason, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(ProjectExecutionSupportReasonResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, SolarDesignFormSubmitResponse>>
  saveProjectExecutionProjectDetails(
      FormModel formDetails) async {
    String userId = userDataController.sapId;
    MultipartFile? multipartImageFile=null;
    if(formDetails.imagePath.isNotEmpty) {
      multipartImageFile =
      await MultipartFile.fromFile(formDetails.imagePath);
    }

    FormData formData = FormData.fromMap({
      "ProjectExecutionType": formDetails.projectType,
      "Project_Type": formDetails.category,
      "CompanyName": formDetails.companyName,
      "ContactPersonName": formDetails.contactPersonName,
      "ContactPersonMobileNo": formDetails.contactPersonNumber,
      "ContactPersonEmailId": formDetails.contactPersonEmailId,
      "SecondaryContactName": formDetails.secondaryName,
      "SecondaryContactMobileNo": (formDetails.secondaryNumber?.isNotEmpty==true)
          ? formDetails.secondaryNumber
          : "",
      "SecondaryContactEmailId": formDetails.secondaryEmail,
      "ProjectName": formDetails.projectName,
      "ProjectAddress": formDetails.projectAddress,
      "ProjectLandmark": formDetails.projectLandmark,
      "ProjectCurrentLocation": formDetails.projectLocation,
      "Pincode": formDetails.projectPincode,
      "State": formDetails.state,
      "City": formDetails.city,
      "SolutionType": formDetails.solutionTypeId.toString(),
      "SupportReasonId": formDetails.supportReasonId.toString(),
      "SubCategoryId": formDetails.subCategoryId.toString(), // removing the rupee symbol and the commas
      "PreferredDate": formDetails.preferredDate,
      "DocumentFilePath":multipartImageFile??"",
      "User_Id": userDataController.sapId,
      "Channel": AppConstants.channel,
      "Os_Type": osType,
      "App_Version": AppConstants.appVersionName,
      "Device_Id": deviceId,
    }); // Dio dio = new Dio();
    formData.fields.toString();
    // dio.options.headers['Content-Type'] = 'multipart/form-data';
    final response = await Requests.sendPostForm(
        SolarApiConstants.saveProjectExecutionProjectData,
        formData,
        userId);
    print("DigitalSurveyCustomerDetails form response data ${response.data}");
    if (response is! DioException && response.statusCode == 200) {
      return Right(SolarDesignFormSubmitResponse.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, RequestListResponse>>
  postPERequestList(
      String projectType, String searchString, String filterSupportStatus, String supportReason, String projectExecutionType,int pageNumber,int pageSize) async {
    String sapId = userDataController.sapId;

    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "channel": AppConstants.channel,
        "os_Type": osType,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "projectExecutionType": projectExecutionType,
        "projectType": projectType,
        "searchString": searchString,
        "filterSupportStatus": filterSupportStatus,
        "supportReason": supportReason,
        "pageNumber": pageNumber,
        "pageSize": pageSize
      };
      logger.i("PE Request List Body: $body");
      logger.d("PE Request List API - " +
          SolarApiConstants.getPERequestList);
      final response = await Requests.sendPostRequest(
          SolarApiConstants.getPERequestList, body);

      if (response is! DioException && response.statusCode == 200) {
        logger.i("PE Request List Response: ${response.data}");
        return Right(RequestListResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(
          ServerFailure("Failed to fetch PE Request List: $error"));
    }
  }


  Future<Either<Failure, ReassignRequestResponse>> postReassignRequest(
      String projectId, String remark) async {
    String sapId = userDataController.sapId;
    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "channel": AppConstants.channel,
        "os_Type": osType,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "projectId": projectId,
        "remark": remark,
      };
      print("Reassign Request Body: $body");
      final response = await Requests.sendPostRequest(
          SolarApiConstants.postReassignRequest, body);
      if (response is! DioException && response.statusCode == 200) {
        print("Reassign Request Response: ${response.data}");
        return Right(ReassignRequestResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure("Failed to fetch Reassign Request: $error"));
    }
  }


  @override
  Future<Either<Failure, ProjectExecutionRequestDetailResponse>> postPEByProjectId(String projectId) async {
    String sapId = userDataController.sapId;
    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "channel": AppConstants.channel,
        "os_Type": osType,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "ProjectId": projectId,
      };
      print("PE By Project Id Body: $body");
      print("PE By Project Id API - " +
          SolarApiConstants.getPERequestDetailById);
      final response = await Requests.sendPostRequest(
          SolarApiConstants.getPERequestDetailById, body);
      if (response is! DioException && response.statusCode == 200) {
        print("PE By Project Id Response: ${response.data}");
        return Right(ProjectExecutionRequestDetailResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure(
          "Failed to fetch PE By Project Id: $error"));
    }
  }


  Future<Either<Failure, ReScheduleRequestResponse>> postRescheduleRequest(
      String projectId,String reason, String date) async {
    String sapId = userDataController.sapId;
    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "channel": AppConstants.channel,
        "os_Type": osType,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "projectId": projectId,
        "reason": reason,
        "rescheduleDate": date,
      };
      print("Reschedule Request Body: $body");
      final response = await Requests.sendPostRequest(
          SolarApiConstants.postReScheduleRequest, body);
      if (response is! DioException && response.statusCode == 200) {
        print("Reschedule Request Response: ${response.data}");
        return Right(ReScheduleRequestResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure("Failed to fetch Reschedule Request: $error"));
    }
  }



  @override
  Future<Either<Failure, GoSolarCountDetailsResponse>> postGoSolarCountDetails() async {
    String sapId = userDataController.sapId;

    try {
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "channel": AppConstants.channel,
        "os_Type": osType,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
      };
      logger.i("Go Solar Count Details Body: $body");
      final response = await Requests.sendPostRequest(
          SolarApiConstants.postGoSolarCountDetails, body);

      if (response is! DioException && response.statusCode == 200) {
        logger.i("Go Solar Count Details Response: ${response.data}");
        return Right(GoSolarCountDetailsResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure("Failed to fetch Go Solar Count Details Body: $error"));
    }
  }
 @override
  Future<Either<Failure, SolarStateDataResponse>> getSapStateList() async {

    try {
      final response = await Requests.sendGetRequest(
          SolarApiConstants.getSapStates,{});

      if (response is! DioException && response.statusCode == 200) {
        return Right(SolarStateDataResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure("Failed to fetch states: $error"));
    }
  }

  @override
  Future<Either<Failure, SolarCityDataResponse>> postGetCityListDistrictId(int stateId) async {
    String sapId = userDataController.sapId;
    final Map<String, dynamic> body = {
        "user_Id": sapId,
        "channel": AppConstants.channel,
        "os_Type": osType,
        "stateId": stateId,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
      };
    try {
      final response = await Requests.sendPostRequest(
          SolarApiConstants.postGetCityList,body);

      if (response is! DioException && response.statusCode == 200) {
        return Right(SolarCityDataResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (error) {
      return Left(ServerFailure("Failed to fetch cities: $error"));
    }
  }

  Future<Either<Failure, SolarRequestTracking>> postRequestTracking(String projectId) async {
    final Map<String, dynamic> body = {
      "user_Id": userDataController.sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "projectId": projectId,
    };

    final response = await Requests.sendPostRequest(
        SolarApiConstants.postGetStatusHistory, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(SolarRequestTracking.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }
}
