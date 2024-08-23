import 'package:get/get.dart';

import '../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../services/services_locator.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/enums.dart';
import '../../data/datasource/solar_remote_data_source.dart';
import '../../data/models/city_model.dart';
import '../../data/models/option.dart';
import '../../data/models/state_model.dart';

class SolarDesignRequestController extends GetxController {
  var selectedState = ''.obs;
  var isLoading = true.obs;
  var stateList = <SolarStateData>[].obs;
  var cityList = <SolarCityData>[].obs;
  var solutionTypeListDesign = <Option>[].obs;
  var solutionTypeListFinance = <Option>[].obs;
  var selectedSolutionTypeId = ''.obs;

  BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
      sl<BaseMPartnerRemoteDataSource>();
  BaseSolarRemoteDataSource solarRemoteDataSource =
      s2<BaseSolarRemoteDataSource>();

  getSolutionTypes(String lookUpType) async {
    try {
      final solutionTypesResponse =
          await solarRemoteDataSource.getSolutionTypes(lookUpType);
      solutionTypesResponse.fold((l) => logger.e(l), (r) {
        if (lookUpType == SolutionTypes.SolarDesignSolutionType.name) {
          solutionTypeListDesign.addAll(r.data);
        } else {
          solutionTypeListFinance.addAll(r.data);
        }
      });
    } catch (e) {
      logger.e('Error $e');
    }
  }

  updateSelectedSolutionTypeId(String id) {
    selectedSolutionTypeId(id);
  }

  getStates() async {
    isLoading(true);
    try {
      final result = await solarRemoteDataSource.getSapStateList();
      result.fold(
        (l) => logger.e(l),
        (r) {
          stateList.addAll(r.data.map((stateData) => stateData).toList());
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
            .postGetCityListDistrictId(int.parse(selectedState.value));
        result.fold(
          (l) => logger.e(l),
          (r) {
            cityList.addAll(r.data.map((cityData) => cityData).toList());
          },
        );
      }
    } catch (e) {
      logger.e('Error $e');
    } finally {
      isLoading(false);
    }
  }

  updateSelectedState(SolarStateData value) {
    selectedState(value.stateId);
  }

  clearState() {
    selectedState = ''.obs;
    isLoading = true.obs;
    stateList = <SolarStateData>[].obs;
    cityList = <SolarCityData>[].obs;
    selectedSolutionTypeId = ''.obs;
    update();
  }
}
