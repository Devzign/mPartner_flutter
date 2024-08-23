import 'dart:ffi';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/network_management_model/dealer_electrician_status_data_model.dart';

class NewDealerElectricianStatusController extends GetxController {

  RxBool isActive= true.obs;
  RxBool isPending= true.obs;
  RxBool isRejected= true.obs;
  String userType="";
  RxBool isApiLoading=false.obs;
  RxList<StatusData> dealerElectricianStatusList=<StatusData>[].obs;
  RxList<StatusData> originalDealerElectricianStatusList=<StatusData>[].obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource = MPartnerRemoteDataSource();

  @override
  void onInit()async {
  //  await getStatusList();
    dealerElectricianStatusList.value=[];
    originalDealerElectricianStatusList.value=[];
    super.onInit();
  }


  Future<bool> getStatusList() async{
    isApiLoading.value=true;
    dealerElectricianStatusList.value.clear();
    originalDealerElectricianStatusList.value.clear();
    try{
      String filterValue="";

        if(isActive.value){
          filterValue+="Accepted ";
        }
        if(isPending.value){
          filterValue+="Pending ";
        }
        if(isRejected.value){
          filterValue+="Rejected ";
        }

        if(!isActive.value&&!isPending.value&&!isRejected.value){
          dealerElectricianStatusList.clear();
          originalDealerElectricianStatusList.clear();
          isApiLoading.value=false;
          update();
        }
        else {
          final result = await mPartnerRemoteDataSource
              .getDealerElectricianStatusList(
              userType, filterValue.toString().trim().replaceAll(" ", ","));
          isApiLoading.value = false;
          result.fold((failure) {
            // Handle failure (Left)
            // error('Failed to fetch states list  information: $failure');
          }, (response) async {
            dealerElectricianStatusList.clear();
            dealerElectricianStatusList.addAll(response);
            originalDealerElectricianStatusList.clear();
            originalDealerElectricianStatusList.addAll(response);
            update();
            //  update();
          });
        }
    } catch (e) {
      isApiLoading.value=false;
      //error('$e');
    }
    return true;
  }



Future<void> getStatusListLocal() async{
    isApiLoading.value=true;
    dealerElectricianStatusList.value.clear();
      if(!isActive.value&&!isPending.value&&!isRejected.value){
        dealerElectricianStatusList.addAll(originalDealerElectricianStatusList);
      }
      else {
        originalDealerElectricianStatusList.value.forEach((element) {
            if(isActive.value&&element.status.toString().toLowerCase()=="accepted"){
              dealerElectricianStatusList.add(element);
            }
            if(isPending.value&& element.status.toString().toLowerCase()=="pending"){
              dealerElectricianStatusList.add(element);

            }
            if(isPending.value&& element.status.toString().toLowerCase()=="rejected"){
              dealerElectricianStatusList.add(element);
            }
      });
      }
    dealerElectricianStatusList.value=dealerElectricianStatusList.value;
      isApiLoading.value=false;
      update();

  }
}
