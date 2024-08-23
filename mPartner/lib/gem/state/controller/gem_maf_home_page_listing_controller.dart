import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/state_manager.dart';

import '../../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/datasource/gem_remote_data_source.dart';
import '../../data/models/gem_request_gst_details_model.dart';
import '../../data/models/maf_filter_model.dart';
import '../../data/models/maf_listing_home_model.dart';
import '../../presentation/gem_maf/maf_filter_page.dart';
import '../../presentation/gem_maf/maf_registration.dart';

class GemMafHomePageListingController extends GetxController {
  RxInt page = 1.obs;
  Rx<MafFilterModel> filterModel = MafFilterModel().obs;
  RxString status = "".obs;
  RxString bidstatus = "".obs;
  RxBool checkgst = false.obs;


  RxBool loading = false.obs;
  RxBool loadingmore = false.obs;
  RxBool search = false.obs;
  RxList<MafListingHomePageModel> authenticationlist =
      <MafListingHomePageModel>[].obs;
  RxList<MafListingHomePageModel> all_list = <MafListingHomePageModel>[].obs;

  BaseGemRemoteDataSource mPartnerRemoteDataSource =BaseGemRemoteDataSource();
  getList() async {
    page = 1.obs;
    authenticationlist = <MafListingHomePageModel>[].obs;
    all_list = <MafListingHomePageModel>[].obs;
    loading.value = true;
    final result = await mPartnerRemoteDataSource.getMafHomePageListData(
        page.value, status.value, bidstatus.value);
    result.fold((failure) {
      loading.value = false;
    }, (response) async {
      loading.value = false;
      authenticationlist.value = response;
      all_list.value = response;
    });
  }

  Future<dynamic> checkGstExist(BuildContext context, bool isback) async {
    checkgst.value = true;
    final result = await mPartnerRemoteDataSource.validate_Gst();
    result.fold((failure) {
      checkgst.value = false;
    }, (response) async {
      checkgst.value = false;
      GemRequestGstDetailsModel model = response;
      if (model.gstStatus!.isNotEmpty) {
        String gst = model.gstStatus.toString();
         await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MafRegistration(gstNumber: gst,)),
        ).then((value){});

      } else {
         await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MafRegistration(gstNumber: '',
              )),
        );

      }
    });
  }

  void search_item(String searchValue) {
    if (searchValue.length == 0) {
      search.value = false;
      authenticationlist.value = [];
      authenticationlist.value = all_list.value;
    } else {
      search.value = true;
      authenticationlist.value = [];
      all_list.value.forEach((element) {
        if (element.sBidNumber.toString().toLowerCase()!.contains(searchValue.toString().toLowerCase())) {
          authenticationlist.value.add(element);
        }
        // else if(element.sBidNumber!.(searchValue)){
        //   authenticationlist.value.add(element);
        // }
        // else if(element.status!.contains(searchValue)){
        //   authenticationlist.value.add(element);
        // }
      });
    }
  }

  moveToFilter(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MafFilterPage(
                  filterModel,
                ))).then((value) {
      if (value != null) {

        filterModel.value = value;

        String concatStatus = "";
        String _bidstatus = "";

        // if (filterModel.value.inprogress) {
        //   concatStatus = "In Progress";
        // } else if (filterModel.value.received) {
        //   concatStatus = "Approved";
        // } else if (filterModel.value.rejected) {
        //   concatStatus = "Rejected";
        // }

        if (filterModel.value.inprogress == true) {
          concatStatus = "In Progress";
        }
        if (filterModel.value.received == true) {
          concatStatus = "${concatStatus}${concatStatus.isEmpty ? '' : ','}Approved";
        }
        if (filterModel.value.rejected == true) {
          concatStatus = "${concatStatus}${concatStatus.isEmpty ? '' : ','}Rejected";
        }

        _bidstatus = filterModel.value.win
            ? "Won"
            : (filterModel.value.lost ? "Lost" : "");

        if(_bidstatus.isNotEmpty){
          status.value = "Approved";
        }else{
          status.value = concatStatus;
        }

        bidstatus.value = _bidstatus;
        getList();
      }
    });
  }

  Future<void> loadMore() async {
    page.value = page.value + 1;
    loadingmore.value = true;
    final result = await mPartnerRemoteDataSource.getMafHomePageListData(
        page.value, status.value, bidstatus.value);
    result.fold((failure) {}, (response) async {
      loadingmore.value = false;
      authenticationlist.addAll(response);
      //authenticationlist.addAll(response);
      update();
    });
  }
}
