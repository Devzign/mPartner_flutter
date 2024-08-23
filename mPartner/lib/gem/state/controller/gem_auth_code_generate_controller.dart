import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/state_manager.dart';
import '../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../presentation/widgets/common_bottom_sheet.dart';
import '../../data/datasource/gem_remote_data_source.dart';
import '../../data/models/gem_auth_detail_model.dart';
import 'gem_bid_controller.dart';

class GemAuthCodeGenerateController extends GetxController {
  RxInt page = 1.obs;
  BaseMPartnerRemoteDataSource? baseMPartnerRemoteDataSource;
  RxBool loading = false.obs;
  RxBool termsConditionsChecked = false.obs;
  RxBool submitrequest = false.obs;
  String gstNumber = "";
  RxBool isTermsRead = false.obs;
  RxList<GemCustomerDetailModel> datalist = <GemCustomerDetailModel>[].obs;
  BaseGemRemoteDataSource mPartnerRemoteDataSource =BaseGemRemoteDataSource();
  Future<void> getdata(BuildContext context, String gst) async {
    gstNumber = gst;
    loading.value = true;
    final result = await mPartnerRemoteDataSource.getcustomerdata();
    result.fold((failure) {
      loading.value = false;
    }, (response) async {
      datalist.value = response;
      loading.value = false;
    });
  }

  Future<void> OpenTermsAndConditions(BuildContext context) async {
    await CommonBottomSheet.OpenTermsAndConditions(context, "GEMAC").then((value){
      if(value==true){
        isTermsRead.value=true;
      }
    });
  }

  submit(BuildContext context) async {
    submitrequest.value = true;
    final result = await mPartnerRemoteDataSource.requestAuthCode(gstNumber != "" ? gstNumber : datalist[0].gstNumber.toString());
    result.fold((failure) {
      submitrequest.value = false;
    }, (response) async {
      submitrequest.value = false;
      GemBidController controller = Get.find();
      controller.getdata(context);
      await CommonBottomSheet.openSuccessSheet(context, "Submit successfully.",response.toString());
      Navigator.pop(context, true);
    });
  }
}
