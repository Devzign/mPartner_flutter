import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mpartner/state/contoller/user_data_controller.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/network_management_model/dealer_electrician_details_model.dart';
import '../../presentation/screens/network_management/dealer_electrician/components/common_network_utils.dart';
import '../../presentation/widgets/common_bottom_sheet.dart';
import '../../utils/utils.dart';

class DealerElectricianViewDetailsController extends GetxController {
  RxBool isRedembtionBlock = false.obs;
  String userType = "Dealer";

  RxBool isActive = true.obs;
  RxBool isInActive = true.obs;
  RxBool isApiLoading = false.obs;
  RxBool isDetailAPILoading = false.obs;
  Rx<DealerElectricianDetail> dealerElectricianStatusListDetails =
      DealerElectricianDetail().obs;

  RxList<DealerElectricianDetail> dealerElectricianStatusList =
      <DealerElectricianDetail>[].obs;
  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();
  UserDataController userController = Get.find();

  @override
  void onInit() async {
    if (userController.userType == "DEALER") {
      userType = UserType.electrician;
    } else {
      userType = UserType.dealer;
    }
    await getDealerElectricanList();
    super.onInit();
  }

  Future<bool> getDealerElectricanList() async {
    isApiLoading.value = true;
    dealerElectricianStatusList.value.clear();
    try {
      String filterValue = "";

      if (isActive.value) {
        filterValue += "active ";
      }
      if (isInActive.value) {
        filterValue += "inactive ";
      }

      if (!isActive.value && !isInActive.value) {
        dealerElectricianStatusList.clear();
        isApiLoading.value = false;
        update();
      } else {
        final result = await mPartnerRemoteDataSource.getDealerElectricianList(
            userType, filterValue.toString().trim().replaceAll(" ", ","));
        isApiLoading.value = false;
        result.fold((failure) {}, (response) async {
          dealerElectricianStatusList.clear();
          dealerElectricianStatusList.addAll(response);
          update();
        });
      }
    } catch (e) {
      isApiLoading.value = false;
      //error('$e');
    }
    return true;
  }

  Future<void> getDealerElectricanListDetails(String electricianId, String userType ) async {
    isDetailAPILoading.value = true;
    final result = await mPartnerRemoteDataSource
        .getDealerElectricianListDetails(userType, electricianId);
    result.fold((failure) {
      isDetailAPILoading.value=false;
    }, (response) async {
      dealerElectricianStatusListDetails.value = response;
      isDetailAPILoading.value = false;
    });
  }

  Future<bool> setDealerElectricanBlockRedumption(
      bool isRedumptionBlock, String id,String userType) async {
    //isApiLoading.value = true;
    final result = await mPartnerRemoteDataSource
        .setDealerElectricianBlockRedumption(userType, isRedumptionBlock, id);
    return result.fold((failure) {
      return false;
    }, (response) async {
      return true;
    });
  }

  Future<String> DealerMapUnmap(
      bool isActive, String id,String userType, BuildContext context) async {
    //isApiLoading.value = true;
    final result = await mPartnerRemoteDataSource.updateDealerMapUnMap(userType, isActive, id);
    return result.fold((failure) async {
      await CommonBottomSheet.openSuccessSheet(context, "Error",failure.message.toString());
      return "";
    }, (response) async {
      return response;
    });
  }


}


