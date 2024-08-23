import 'dart:io';

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
import '../models/gem_auth_bid_model.dart';
import '../models/gem_auth_detail_model.dart';
import '../models/gem_auth_list.dart';
import '../models/gem_request_gst_details_model.dart';
import '../models/gem_tender_statedata_model.dart';
import '../models/gem_tender_statelist_model.dart';
import '../models/get_category_sale_type.dart';
import '../models/maf_bid_details_response_model.dart';
import '../models/maf_bid_verify_model.dart';
import '../models/maf_gem_registartion_response_model.dart';
import '../models/maf_home_page_model.dart';
import '../models/maf_listing_home_model.dart';
import '../models/maf_participation_model.dart';
import '../models/maf_registrationwise_details.dart';




 class BaseGemRemoteDataSource {
  UserDataController controller = Get.find();

  @override
  Future<Either<Failure, GemTenderStateListModel>> getTenderStateList() async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "userId": sapId,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
    };

    try {
      final response = await Requests.sendPostRequest(
          GemApiConstants.getGEMTenderStateListEndPoint, body);
      print(response);
      if (response is! DioException && response.statusCode == 200) {
        final statusCode = response.data["status"];
        if (statusCode == "200") {
          return Right(GemTenderStateListModel.fromJson(response.data));
        }else{
          return Left(ServerFailure(response.data["message"] ?? ""));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GemTenderStateDataModel>> getTenderStateWiseData(
      String state) async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "userId": sapId,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "pageIndex": '0',
      "pageSize": '50',
      "stateId": state,
      "isFirst": false,
      "isLast": false,
      "os_Type": osType,
      "channel": AppConstants.channel,
    };

    try {
      final response = await Requests.sendPostRequest(
          GemApiConstants.getGEMTenderInformationStateWiseEndPoint, body);
      print(response);
      if (response is! DioException && response.statusCode == 200) {
        final statusCode = response.data["status"];
        if (statusCode == "200") {
          return Right(GemTenderStateDataModel.fromJson(response.data));
        }else{
          return Left(ServerFailure(response.data["message"] ?? ""));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TermsConditionsResponse>> fetchTermConditionDetails(
      String dynamicpage) async {
    try {
      String sapId = controller.sapId;
      LanguageController languageController = Get.find();
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "token": controller.token.toString(),
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
        "pageName": dynamicpage,
      };
      final response = await Requests.sendPostRequest(GemApiConstants.fetchTermConditionData, body);
      if (response is! DioException && response.statusCode == 200) {
        return Right(TermsConditionsResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      print("eroororororor" + e.toString());

      return Left(ServerFailure(""));
    }
  }
  @override
  Future<Either<Failure, MafRegistrationWiseDetails>>
  fetchRegistartionDetails() async {
    try {
      String sapId = controller.sapId;
      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "appversion_code": AppConstants.appVersionName,
        "channel": AppConstants.channel,
        "os_version_code": osVersionCode,
        "device_name": deviceName,
      };
      final response = await Requests.sendPostRequest(GemApiConstants.fetchRegistrationData, body);
      if (response is! DioException && response.statusCode == 200) {
        return Right(MafRegistrationWiseDetails.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(""));
    }
  }

  @override
  Future<Either<Failure, MafParticipationModel>> getParticipationType(
      String lookUpType) async {
    try {
      String sapId = controller.sapId;
      final Map<String, dynamic> body = {
        "user_Id": sapId /*"1100113"*/,
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "channel": AppConstants.channel,
        "lookUpType": lookUpType
      };

      final response = await Requests.sendPostRequest(
          GemApiConstants.fetchlookupType, body);

      if (response is! DioException && response.statusCode == 200) {
        return Right(MafParticipationModel.fromJson(response.data));
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }

      // List<MafParticipationModel> statusList1 = [];
      // final response = await Requests.sendPostRequest(GemApiConstants.fetchlookupType, body);
      // if (response is! DioException && response.statusCode == 200) {
      //   if (response.data['data'] == null || response.data['data'] == "") {
      //     return Right(statusList1);
      //   } else {
      //     List<MafParticipationModel> statusList =
      //     List<MafParticipationModel>.from(response.data['data']
      //         .map((model) => MafParticipationModel.fromJson(model)));
      //
      //     return Right(statusList);
      //   }
      // } else {
      //   return Left(ServerFailure((response as DioException).message ?? ""));
      // }

    } catch (e) {
      return Left(ServerFailure(""));
    }
  }


  Future<Either<Failure, List<GemCustomerDetailModel>>>getcustomerdata() async {
    String sapId = controller.sapId;
    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
    };
    print(body);
    final response = await Requests.sendPostRequest(GemApiConstants.fetchRegistrationData, body);
    if (response is! DioException && response.statusCode == 200) {
      print(response.data.toString());
      return Right(List<GemCustomerDetailModel>.from(
          (response.data["data"] as List)
              .map((e) => GemCustomerDetailModel.toJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }
  Future<Either<Failure, String?>> requestAuthCode(String gst_number) async {
    String sapId = controller.sapId;
    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "gstin": gst_number,
      "auth_TnC": true,


    };
    print(body);
    final response = await Requests.sendPostRequest(GemApiConstants.SubmitAuthCodeDetails, body);
    if (response is! DioException && response.statusCode == 200) {
      print(response.data.toString());
      return Right(response.data["message"]);
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, List<GemAuthDetailModel>>> getAuthCodedetails(
      var id) async {
    String sapId = controller.sapId;
    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "authCodeId": id,
    };
    print(body);
    final response =
    await Requests.sendPostRequest(GemApiConstants.GetAuthCodeDetails, body);
    if (response is! DioException && response.statusCode == 200) {
      print(response.data.toString());
      return Right(List<GemAuthDetailModel>.from((response.data["data"] as List)
          .map((e) => GemAuthDetailModel.toJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<GemAuthList>>> getGemAuthList(
      int? page, String? status) async {
    String sapId = controller.sapId;
    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "pageIndex": page,
      "pageSize": 10,
      "isFirst": false,
      "isLast": false,
      "authCodeStatus": status,
    };
    print("requestbody" + body.toString());

    final response =
    await Requests.sendPostRequest(GemApiConstants.GetAuthCodeList, body);
    print(response.data.toString());
    if (response is! DioException && response.statusCode == 200) {
      return Right(List<GemAuthList>.from(
          (response.data["data"] as List).map((e) => GemAuthList.toJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, List<GemAuthBidModel>>> getGemBiddetails() async {
    String sapId = controller.sapId;
    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
    };
    print(body);
    final response =
    await Requests.sendPostRequest(GemApiConstants.GetAuthCodeCount, body);
    if (response is! DioException && response.statusCode == 200) {
      print(response.data.toString());
      return Right(List<GemAuthBidModel>.from((response.data["data"] as List)
          .map((e) => GemAuthBidModel.toJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }
  Future<Either<Failure, dynamic>> validate_Gst() async {
    String sapId = controller.sapId;
    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "gstin": ""
    };
    print(body);
    final response =
    await Requests.sendPostRequest(GemApiConstants.CheckIfGSTExists, body);
    if (response is! DioException && response.statusCode == 200) {
      return Right(GemRequestGstDetailsModel.fromJson(response.data));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }


  Future<Either<Failure, List<MafBidDetailsResponseModel>>>getBidNumberDetailsApi(String bidId) async {
    String sapId = controller.sapId;
    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "sBidNumber": bidId,
    };
    print(body);
    final response =
    await Requests.sendPostRequest(GemApiConstants.getBidNumberDetails, body);
    if (response is! DioException && response.statusCode == 200) {
      print(response.data.toString());
      return Right(List<MafBidDetailsResponseModel>.from(
          (response.data["data"] as List)
              .map((e) => MafBidDetailsResponseModel.toJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, MafBidVerifyModel>> updateBidStatusApi(
      String bidNumber, bidStatus) async {
    String sapId = controller.sapId;
    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "sBidNumber": bidNumber,
      "bidStatus": bidStatus,
    };
    print(body);
    final response =
    await Requests.sendPostRequest(GemApiConstants.updateBidStatus, body);
    if (response is! DioException && response.statusCode == 200) {
      final statusCode = response.data["status"];
      if (statusCode == "200") {
        return Right(MafBidVerifyModel.fromJson(response.data));
      } else {
        return Left(response.data["message"]);
      }
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  Future<Either<Failure, List<MafHomePageModel>>>getGemMafHomepageData() async {
    String sapId = controller.sapId;
    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
    };
    print(body);
    final response = await Requests.sendPostRequest(GemApiConstants.GetGemRegistrationCount, body);
    if (response is! DioException && response.statusCode == 200) {
      print(response.data.toString());
      return Right(List<MafHomePageModel>.from((response.data["data"] as List)
          .map((e) => MafHomePageModel.toJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }

  @override
  Future<Either<Failure, List<MafListingHomePageModel>>> getMafHomePageListData(
      int? page, String status, String bidstatus) async {
    String sapId = controller.sapId;
    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "channel": AppConstants.channel,
      "os_Type": osType,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "pageIndex": page,
      "pageSize": 10,
      "isFirst": false,
      "isLast": false,
      "status": status,
      "bidStatus": bidstatus,
    };
    print("requestbody" + body.toString());

    final response = await Requests.sendPostRequest(
        GemApiConstants.getMafHomePageRequestList, body);
    print(response.data.toString());
    if (response is! DioException && response.statusCode == 200) {
      return Right(List<MafListingHomePageModel>.from(
          (response.data["data"] as List)
              .map((e) => MafListingHomePageModel.toJson(e))));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }
  @override
  Future<Either<Failure, MafBidVerifyModel>> verifyBidNumber(
      String bidNumber) async {
    try {
      String sapId = controller.sapId;

      final Map<String, dynamic> body = {
        "user_Id": sapId,
        "token": "",
        "app_Version": AppConstants.appVersionName,
        "device_Id": deviceId,
        "os_Type": osType,
        "appversion_code": AppConstants.appVersionName,
        "channel": AppConstants.channel,
        "os_version_code": osVersionCode,
        "loginUserId": "",
        "device_name": deviceName,
        "sBidNumber": bidNumber,
      };
      final response = await Requests.sendPostRequest(GemApiConstants.verifyBidNumber, body);
      if (response is! DioException) {
        if (response.statusCode == 200) {

          final statusCode = response.data["status"];
          if (statusCode == "200") {
            return Right(MafBidVerifyModel.fromJson(response.data));
          }else{
            return Left(ServerFailure(response["message"]));
          }
        } else {
          return Left(ServerFailure((response as DioException).message ?? ""));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(""));
    }
  }

  @override
  Future<Either<Failure, MafGemRegistrationResponseModel>> uploadMafBidRegistrationData(
      String sParticipationType,
      String nBidNumber,
      String sGSTINNumber,
      String dBidPublishDate,
      String dBidDueDate,
      String comments,
      String docFront,
      ) async {
    String userId = controller.sapId;
    MultipartFile? multipartImageFileFront = null;
    if (docFront.isNotEmpty) {
      multipartImageFileFront = await MultipartFile.fromFile(
        docFront,
        filename: File(docFront).path.split("/").last,
      );
    } else {
      // Handle the case when docFront is an empty string
      // For example, you might want to log a message or take some other action.
      print("docFront is an empty string");
    }


    FormData formData = FormData.fromMap({
      "UserId": userId,
      "Channel": AppConstants.channel,
      "Os_Type": osType,
      "App_Version": AppConstants.appVersionName,
      "Device_Id": deviceId,
      "nMAFID": '0',
      "sParticipationType": sParticipationType,
      "sBidNumber": nBidNumber,
      "dBidPublishDate": dBidPublishDate,
      "dBidDueDate": dBidDueDate,
      "sGSTINNumber": sGSTINNumber,
      "Comment": comments,
      "MAF_Tnc": "1",
      if (multipartImageFileFront != null) "TenderDoc": multipartImageFileFront,
      "TenderDocs": '',
    });

    final response = await Requests.sendPostForm(GemApiConstants.submitMafDetails, formData, userId);
    print("data ${response.data}");

    if (response is! DioException && response.statusCode == 200) {
      final statusCode = response.data["status"];
      if (statusCode == "200") {
        return Right(MafGemRegistrationResponseModel.fromJson(response.data));
      } return Left(ServerFailure(response.data["message"] ?? ""));
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }
  @override
  Future<Either<Failure, List<CategorySaleType>>>
  getGemSupportCategoryType() async {
    String sapId = controller.sapId;

    final Map<String, dynamic> body = {
      "userId": sapId,
      "user_Id": sapId,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "pageIndex": '0',
      "pageSize": '10',
      "os_Type": osType,
      "channel": AppConstants.channel,
    };

    final response = await Requests.sendPostRequest(
        GemApiConstants.getGEMModuleDetailCategoryEndPoint, body);

    if (response is! DioException && response.statusCode == 200) {
      final statusCode = response.data["status"];
      if (statusCode == "200") {
        return Right(List<CategorySaleType>.from((response.data["data"] as List)
            .map((e) => CategorySaleType.fromJson(e))));
      } else {
        return Left(ServerFailure(response.data["message"] ?? ""));
      }
    } else {
      return Left(ServerFailure((response as DioException).message ?? ""));
    }
  }
}
