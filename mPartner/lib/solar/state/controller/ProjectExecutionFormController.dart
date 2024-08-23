import 'package:get/get.dart';

import '../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../services/services_locator.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/enums.dart';
import '../../data/datasource/solar_remote_data_source.dart';
import '../../data/models/city_model.dart';
import '../../data/models/option.dart';
import '../../data/models/state_model.dart';
import '../../network/api_constants.dart';
import '../../presentation/project_execution/common/common_raise_request_form/common_raise_request_form.dart';
import '../../presentation/project_execution/model/support_reason_model.dart';
import '../../utils/solar_app_constants.dart';
// Import your Failure class

class ProjectExecutionFormController extends GetxController {
  var selectedState = ''.obs;
  var selectedStateId = ''.obs;
  var selectedCity = ''.obs;
  var selectedSupportReason = ''.obs;
  var isLoading = true.obs;
  var stateList = <SolarStateData>[].obs;
  var cityList = <SolarCityData>[].obs;
  var solutionTypeList = <Option>[].obs;
  var supportReasonList = <SupportReason>[].obs;
  var selectedSolutionTypeId = ''.obs;
  var typeName="".obs;
  var typeValue="".obs;

  BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
      sl<BaseMPartnerRemoteDataSource>();
  BaseSolarRemoteDataSource solarRemoteDataSource =
      s2<BaseSolarRemoteDataSource>();

  getSolutionTypes() async {
    try {
      solutionTypeList.clear();
      final solutionTypesResponse =
          await solarRemoteDataSource.getSolutionTypes(SolutionTypes.ProjectExecutionSolutionType.name);
      solutionTypesResponse.fold(
          (l) => logger.e(l), (r) => solutionTypeList.addAll(r.data));
    } catch (e) {
      logger.e('Error $e');
    }
  }

  getReasonForSupport(String typeValue, Category category) async {
    try {
      var moduleType=getTitle(typeValue);
      var category= "";
      if (category==Category.commercial) {
        category= "Commercial";
      } else {
        category="Residential";
      }
      var executionTitle="Project Execution";
      supportReasonList.clear();
      final suportReasonResponse =
      await solarRemoteDataSource.getSupportReasonData(moduleType,category,executionTitle);
      suportReasonResponse.fold(
              (l) => logger.e(l), (r) => supportReasonList.addAll(r.data));
    } catch (e) {
      logger.e('Error $e');
    }
  }

  getTitle(String typeValue) {
    if (typeValue == SolarAppConstants.online) {
      return "Online";
    } else if (typeValue == SolarAppConstants.onsite) {
      return "Onsite";
    } else {
      return "End-to-end";
    }
  }

  getStates() async {
    isLoading(true);
    try {
      stateList.clear();
      final result =
          await solarRemoteDataSource.getSapStateList();
      result.fold(
        (l) => logger.e(l),
        (r) {
          stateList
              .addAll(r.data.map((stateData) => stateData).toList());
        },
      );
    } catch (e) {
      logger.e('Error $e');
    } finally {
      isLoading(false);
    }
  }

  getCities() async {
    cityList.clear();
    isLoading(true);
    try {
      if (selectedState.value != '') {
        final result = await solarRemoteDataSource
            .postGetCityListDistrictId(int.parse(selectedStateId.value));
        result.fold(
          (l) => logger.e(l),
          (r) {
            cityList
                .addAll(r.data.map((cityData) => cityData).toList());
          },
        );
      }
    } catch (e) {
      logger.e('Error $e');
    } finally {
      isLoading(false);
    }
  }

  updateSelectedState(String value) {
    selectedState(value);
  }

  updateSelectedStateId(String id) {
    selectedStateId(id);
  }

  updateSelectedCity(String value) {
    selectedCity(value);
  }

  updateSupportReason(String value) {
    selectedSupportReason(value);
  }


  clearState() {
    selectedState = ''.obs;
    selectedStateId = ''.obs;
    isLoading = true.obs;
    cityList = <SolarCityData>[].obs;
    selectedSolutionTypeId = ''.obs;
    update();
  }
}
