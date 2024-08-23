import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_constants.dart';
import '../../data/datasource/solar_remote_data_source.dart';
import '../../data/models/request_tracking_model.dart';
import '../../presentation/project_execution/model/project_execution_detail_model.dart';
import '../../presentation/project_execution/model/request_list_response.dart';
import '../../utils/solar_app_constants.dart';

class ProjectExecutionRequestListController extends GetxController {
  var isLoadingResidential = false.obs;
  var isLoadingCommercial = false.obs;
  var isDetailLoading = false.obs;
  var error = ''.obs;
  var requestResListData = <RequestlistData>[].obs;
  var requestComListData = <RequestlistData>[].obs;
  var solarRequestTrackingList = <RequestTrackingDetails>[].obs;
  RxMap<String, List<RequestTrackingDetails>> requestTrackingMap = <String, List<RequestTrackingDetails>>{}.obs;
  var isFilterButtonEnabled = false.obs;
  var searchString = ''.obs;
  var finalSupportReasonString = ''.obs;
  var finalPEStatusString = ''.obs;
  var responseMessage = '';
  var peRequestDataList = <ProjectExecutionRequestDetail>[].obs;
  var pageNumber = 0;
  var pageSize = SolarAppConstants.pageSize;
  var totalListCount = 0;
  var selectedProjectTypeTab = SolarAppConstants.residentialCategory;

  final SolarRemoteDataSource solarRemoteDataSource = SolarRemoteDataSource();

  Future<void> fetchProjectRequestList(
      String projectType,
      String searchString,
      String filterSupportStatus,
      String supportReason,
      String projectExecutionType) async {
    try {
      var projectExecutionTypeValue =
          (projectExecutionType == SolarAppConstants.online)
              ? "Online"
              : (projectExecutionType == SolarAppConstants.onsite)
                  ? "Onsite"
                  : "End-to-end";
      if (projectType.contains("Res")) {
        isLoadingResidential(true);
      } else {
        isLoadingCommercial(true);
      }
      pageNumber += 1;
      final result = await solarRemoteDataSource.postPERequestList(
          projectType,
          searchString,
          filterSupportStatus,
          supportReason,
          projectExecutionTypeValue,
          pageNumber,
          pageSize);
      result.fold(
        (failure) {
          error('Failed to fetch PE requests: $failure');
        },
        (response) {
          if (projectType.contains("Res")) {
            isLoadingResidential(false);
          } else {
            isLoadingCommercial(false);
          }
          if (projectType.contains("Res")) {
            requestResListData.addAll(response.data.dataList);
            if (response.data.dataList.isNotEmpty) {
              totalListCount = response.data.totalListCount;
            }
          } else {
            requestComListData.addAll(response.data.dataList);
            if (response.data.dataList.isNotEmpty) {
              totalListCount = response.data.totalListCount;
            }
          }
        },
      );
    } catch (e) {
      if (projectType.contains("Res")) {
        isLoadingResidential(false);
      } else {
        isLoadingCommercial(false);
      }
      error('Failed to fetch PE requests');
    } finally {
      if (projectType.contains("Res")) {
        isLoadingResidential(false);
      } else {
        isLoadingCommercial(false);
      }
    }
  }

  Future<void> fetchPERequestDetailByProjectId(String projectId) async {
    try {
      isDetailLoading(true);
      final result = await solarRemoteDataSource.postPEByProjectId(projectId);
      result.fold(
        (failure) {
          error('Failed to fetch PE Request By Project Id: $failure');
        },
        (response) {
          peRequestDataList.assignAll(response.data);
        },
      );
    } catch (e) {
      isDetailLoading(false);
      error('Failed to fetch PE Request By Project Id');
    } finally {
      isDetailLoading(false);
    }
  }

  Future<void> postPERescheduling(
      String projectId, String reason, String date) async {
    try {
      //isDetailLoading(true);
      final result = await solarRemoteDataSource.postRescheduleRequest(
          projectId, reason, date);
      result.fold(
        (failure) {
          error('Failed to fetch PE Request By Project Id: $failure');
        },
        (response) {
          responseMessage = response.message;
        },
      );
    } catch (e) {
      // isDetailLoading(false);
      error('Failed to fetch PE Request By Project Id');
    } finally {
      // isDetailLoading(false);
    }
  }



  Future<void> fetchRequestTrackingList(String projectId) async {
    try {
      isDetailLoading(true);
      final result = await solarRemoteDataSource.postRequestTracking(projectId);
      result.fold(
        (failure) {
          isDetailLoading(false);
          error('Failed to fetch request tracking details: $failure');
        },
        (response) {
          isDetailLoading(false);
          solarRequestTrackingList.clear();
          if(response.data.isEmpty){
            solarRequestTrackingList.assignAll([]);
            requestTrackingMap.value=<String, List<RequestTrackingDetails>>{};
          }
          else {
          performListToGroupList(response.data);
            solarRequestTrackingList.assignAll(response.data);
          }
        },
      );
    } finally {
      isDetailLoading(false);
    }
  }

  Map<String,List<RequestTrackingDetails>> performListToGroupList (List<RequestTrackingDetails> detaildata){
    //Map<String, List<RequestTrackingDetails>> requestTrackingMap = Map();
    for (var detail in detaildata) {
      String createdOn = detail.createdOn;
      DateTime parsedDate = DateTime.parse(createdOn);
      String monthAndYear = DateFormat('MMMM yyyy').format(parsedDate);
     // createdOn = DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);

      if (!requestTrackingMap.containsKey(monthAndYear)) {
        requestTrackingMap[monthAndYear] = [];
      }
      RequestTrackingDetails data=RequestTrackingDetails(status:detail.status,reason:detail.reason,createdOn: createdOn);
      requestTrackingMap[monthAndYear]!.add(data);
    }

    return requestTrackingMap;
  }


  clearPaginationListData() {
    pageNumber = 0;
    pageSize = 6;
    totalListCount = 0;
    requestResListData = <RequestlistData>[].obs;
    requestComListData = <RequestlistData>[].obs;
  }

  clearPERequests() {
    isLoadingResidential(false);
    isLoadingCommercial(false);
    isDetailLoading(false);
    error = ''.obs;
    requestComListData.clear();
    requestResListData.clear();
    isFilterButtonEnabled.value = false;
    searchString = ''.obs;
    finalSupportReasonString = ''.obs;
    finalPEStatusString = ''.obs;
    peRequestDataList.clear();
    update();
  }
}
