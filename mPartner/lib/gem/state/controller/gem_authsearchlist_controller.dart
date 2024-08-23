import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/state_manager.dart';

import '../../../data/datasource/mpartner_remote_data_source.dart';

import '../../data/datasource/gem_remote_data_source.dart';
import '../../data/models/auth_filter_model.dart';
import '../../data/models/gem_auth_list.dart';
import '../../presentation/gem_support_auth/get_auth_search/gem_auth_filter/gem_auth_filter.dart';

class GemAuthSearchListController extends GetxController{
  RxInt page=1.obs;
  Rx<AuthFilterModel>filterModel=AuthFilterModel().obs;
  RxString status="".obs;
  BaseMPartnerRemoteDataSource? baseMPartnerRemoteDataSource;



  RxBool loading = false.obs;
  RxBool loadingmore = false.obs;
  RxBool search = false.obs;
  RxList<GemAuthList> authenticationlist=<GemAuthList>[].obs;
  RxList<GemAuthList> all_list=<GemAuthList>[].obs;

  BaseGemRemoteDataSource mPartnerRemoteDataSource =BaseGemRemoteDataSource();
  getList() async {
    page=1.obs;
    authenticationlist=<GemAuthList>[].obs;
    all_list=<GemAuthList>[].obs;
    loading.value = true;
    final result = await mPartnerRemoteDataSource.getGemAuthList(page.value,status.value);
    result.fold((failure) {
      loading.value = false;
    }, (response) async {
      loading.value = false;
      authenticationlist.value=response;
      all_list.value=response;
    });

  }
  void search_item(String searchValue) {

    if(searchValue.length==0){
      search.value=false;
      authenticationlist.value=[];
      authenticationlist.value=all_list.value;
    }else{
      search.value=true;
      authenticationlist.value=[];
      all_list.value.forEach((element) {
        if(element.authorizationCode.toString().toLowerCase().contains(searchValue.toLowerCase())){
          authenticationlist.value.add(element);
        }
        if(element.mobile_Number!.contains(searchValue)){
          authenticationlist.value.add(element);
        }
        else if(element.email!.contains(searchValue)){
          authenticationlist.value.add(element);
        }
        else if(element.status!.contains(searchValue)){
          authenticationlist.value.add(element);
        }
      });

    }



  }

  moveToFilter(BuildContext context) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => GemAuthFilter(filterModel,))).then((value){
      if(value!=null){
        filterModel.value =value;
        String concatStatus="";
        if(filterModel.value.inprogress==true){
          concatStatus="P";
        }
        if(filterModel.value.received==true){
          concatStatus=concatStatus+"A";
        }
        if(filterModel.value.rejected==true){
          concatStatus=concatStatus+"R";
        }
        status.value=concatStatus;
        getList();
      }


    });



  }

  Future<void> loadMore() async {
    page.value=page.value+1;
    loadingmore.value = true;
    final result = await mPartnerRemoteDataSource.getGemAuthList(page.value,status.value);
    result.fold((failure) {
    }, (response) async {
      loadingmore.value = false;
      authenticationlist.addAll(response);
      authenticationlist.addAll(response);
      update();
    });

  }


}