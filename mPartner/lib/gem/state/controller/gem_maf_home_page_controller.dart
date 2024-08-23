

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/state_manager.dart';
import '../../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/datasource/gem_remote_data_source.dart';
import '../../data/models/gem_request_gst_details_model.dart';
import '../../data/models/maf_home_page_model.dart';
import '../../presentation/gem_maf/maf_registration.dart';

class GemHomePageController extends GetxController{

  BaseMPartnerRemoteDataSource? baseMPartnerRemoteDataSource;
  RxBool loading = false.obs;
  RxBool checkgst = false.obs;


  RxList<MafHomePageModel> datalist=<MafHomePageModel>[].obs;
  BaseGemRemoteDataSource mPartnerRemoteDataSource =BaseGemRemoteDataSource();
  Future<void> getdata(BuildContext context) async {
    loading.value = true;
    final result = await mPartnerRemoteDataSource.getGemMafHomepageData();
    result.fold((failure) {
      loading.value = false;
    }, (response) async {
      datalist.value=response;
      loading.value = false;
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
        var res = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MafRegistration(gstNumber: gst,)),
        );
        if (res != null && isback == true) {
          Navigator.pop(context);
        }
      } else {
        var res = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MafRegistration(gstNumber: '',
              )),
        );
        if (res != null && isback == true) {
          Navigator.pop(context);
        }
      }
    });
  }


  // Future<dynamic> checkGstExist(BuildContext context) async {
  //   checkgst.value = true;
  //   final result = await mPartnerRemoteDataSource.validate_Gst();
  //   result.fold((failure) {
  //     checkgst.value = false;
  //   }, (response) async {
  //     checkgst.value = false;
  //     GemRequestGstDetailsModel model=response;
  //     if(model.token=="No"){
  //       return await Navigator.push(context,MaterialPageRoute(builder: (context) => GemSupportRequestCode()),);
  //     }else{
  //       return await Navigator.push(context,MaterialPageRoute(builder: (context) => Gem_AuthCodeGenerate(gstNumber: "",)),);
  //     }
  //   });
  //
  // }
}