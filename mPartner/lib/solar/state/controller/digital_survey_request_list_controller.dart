import 'package:get/get.dart';

import '../../../utils/app_constants.dart';
import '../../data/datasource/solar_remote_data_source.dart';
import '../../data/models/digital_survey_request_list_model.dart';
import '../../utils/solar_app_constants.dart';

class DigitalSurveyRequestListController extends GetxController {
  var isLoadingResidential = false.obs;
  var isLoadingCommercial = false.obs;
  var resDigitalSurveyRequests = <DigitalSurveyRequest>[].obs;
  var commDigitalSurveyRequests = <DigitalSurveyRequest>[].obs;
  var totalRequestCountRes = 0.obs;
  var totalRequestCountComm = 0.obs;
  //var isLoading = false.obs;
  var error = ''.obs;
  //var digitalSurveyRequests = <DigitalSurveyRequest>[].obs;
  var designSharedSelected = false.obs;
  var designPendingSelected = false.obs;
  var designReassignedSelected = false.obs;
  var solutionTypeFilterList = [].obs;
  var designStatusList = [].obs;
  var isFilterButtonEnabled = false.obs;
  var searchString = ''.obs;
  var finalSolutionTypeString = ''.obs;
  var finalDesignStatusString = ''.obs;
  var insideResiOrComm = true.obs;
  // var totalRequestCount = 0.obs;
  var pgNumber = 1.obs;
  var pgSize = SolarAppConstants.pageSize.obs;
  var hasMoreData = false.obs;

  final SolarRemoteDataSource solarRemoteDataSource = SolarRemoteDataSource();

  Future<void> fetchDigitalSurveyRequestList(String categoryType, String searchString, String filterDesignStatus, String filterSolutionType, bool isDigital) async {
    error.value = "";
    try {
      if (categoryType == SolarAppConstants.residentialCategory) {
        isLoadingResidential(true);
      } else {
        isLoadingCommercial(true);
      }
      //isLoading(true);
      final result = await solarRemoteDataSource.postDigitalSurveyRequestList(categoryType, searchString, filterDesignStatus, filterSolutionType, isDigital, pgNumber.value, pgSize.value);
      result.fold(
            (failure) {
          error('Failed to fetch digital survey requests: $failure');
        },
            (response) {
              if (categoryType == SolarAppConstants.residentialCategory) {
                isLoadingResidential(false);
                totalRequestCountRes.value = response.totalRequestCount;
              } else {
                isLoadingCommercial(false);
                totalRequestCountComm.value = response.totalRequestCount;
              }
              //totalRequestCount.value = response.totalRequestCount;
              if (response.data.isEmpty) {
                hasMoreData.value = false;
                //digitalSurveyRequests.clear();
                if (categoryType == SolarAppConstants.residentialCategory) {
                  resDigitalSurveyRequests.clear();
                } else {
                  commDigitalSurveyRequests.clear();
                }
              } else {
                if (hasMoreData.value) {
                  if (categoryType == SolarAppConstants.residentialCategory) {
                    resDigitalSurveyRequests.addAll(response.data);
                  } else {
                    commDigitalSurveyRequests.addAll(response.data);
                  }
                 // digitalSurveyRequests.addAll(response.data);
                } else {
                  if (categoryType == SolarAppConstants.residentialCategory) {
                    resDigitalSurveyRequests(response.data);
                  } else {
                    commDigitalSurveyRequests(response.data);
                  }
                  //digitalSurveyRequests(response.data);
                }
              }
              if (categoryType == SolarAppConstants.residentialCategory) {
                logger.i(resDigitalSurveyRequests);
              } else {
                logger.i(commDigitalSurveyRequests);
              }
              logger.i(
                //'Total Request Count: $totalRequestCount\n'
                'Filter Design Status: ${finalDesignStatusString}\n'
                'Filter Solution Type: ${finalSolutionTypeString}\n'
                'Search String: ${searchString}\n'
                'Is Digital: $isDigital\n'
                'Category Type: $categoryType'
              );
        },
      );
    } catch (e) {
      //isLoading(false);
      if (categoryType == SolarAppConstants.residentialCategory) {
        isLoadingResidential(false);
      } else {
        isLoadingCommercial(false);
      }
      error('Failed to fetch digital survey requests');
    } finally {
      if (categoryType == SolarAppConstants.residentialCategory) {
        isLoadingResidential(false);
      } else {
        isLoadingCommercial(false);
      }
      //isLoading(false);
    }
  }

  Future<void> addAndRemoveValuesToList() async {
    if (designSharedSelected.value == true && !designStatusList.contains('Design Shared')) {
      designStatusList.add('Design Shared');
    } else if (designSharedSelected.value == false && designStatusList.contains('Design Shared')) {
      designStatusList.remove('Design Shared');
    }

    if (designPendingSelected.value == true && !designStatusList.contains('Design Pending')) {
      designStatusList.add('Design Pending');
    } else if (designPendingSelected.value == false && designStatusList.contains('Design Pending')) {
      designStatusList.remove('Design Pending');
    }

    if (designReassignedSelected.value == true && !designStatusList.contains('Design Reassigned')) {
      designStatusList.add('Design Reassigned');
    } else if (designReassignedSelected.value == false && designStatusList.contains('Design Reassigned')) {
      designStatusList.remove('Design Reassigned');
    }

    if (solutionTypeFilterList.isNotEmpty)
      finalSolutionTypeString.value = solutionTypeFilterList.join(',');
    else
      finalSolutionTypeString.value = "";

    if (designStatusList.isNotEmpty)
      finalDesignStatusString.value = designStatusList.join(',');
    else
      finalDesignStatusString.value = "";
  }

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10 && !phoneNumber.startsWith('+91')) {
      return '+91 - $phoneNumber';
    } else if (phoneNumber.startsWith('+91') && phoneNumber.length > 10)  {
      String last10Digits = phoneNumber.substring(phoneNumber.length - 10);
      return '+91 - $last10Digits';
    } else {
      return phoneNumber;
    }
  }

  void resetPagination() {
    pgNumber.value = 1;
    hasMoreData.value = false;
  }

  clearDigitalSurveyRequests() {
    isLoadingResidential(true);
    isLoadingCommercial(true);
    resDigitalSurveyRequests.clear();
    commDigitalSurveyRequests.clear();
    totalRequestCountRes.value = 0;
    totalRequestCountComm.value = 0;
    //isLoading(true);
    error = ''.obs;
    //digitalSurveyRequests.clear();
    designSharedSelected.value = false;
    designPendingSelected.value = false;
    designReassignedSelected.value = false;
    isFilterButtonEnabled.value = false;
    searchString = ''.obs;
    solutionTypeFilterList.clear();
    designStatusList.clear();
    finalSolutionTypeString = ''.obs;
    finalDesignStatusString = ''.obs;
    insideResiOrComm.value = true;
    //totalRequestCount.value = 0;
    pgNumber.value = 1;
    pgSize.value = SolarAppConstants.pageSize;
    hasMoreData.value = false;
    update();
  }
}
