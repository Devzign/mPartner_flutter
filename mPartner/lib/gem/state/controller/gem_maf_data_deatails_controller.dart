import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/state_manager.dart';

import '../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../utils/utils.dart';
import '../../data/datasource/gem_remote_data_source.dart';
import '../../data/models/maf_bid_details_response_model.dart';

class GemMafDataDetailsController extends GetxController {
  BaseMPartnerRemoteDataSource? baseMPartnerRemoteDataSource;
  RxBool loading = false.obs;
  RxBool bidStatusButtonEnable = false.obs;
  RxBool isBidStatusBarShow = false.obs;
  RxList<MafBidDetailsResponseModel> datalist = <MafBidDetailsResponseModel>[].obs;
  BaseGemRemoteDataSource mPartnerRemoteDataSource = BaseGemRemoteDataSource();
  Future<void> getdata(BuildContext context, String bidNumber) async {
    loading.value = true;
    final result =await mPartnerRemoteDataSource.getBidNumberDetailsApi(bidNumber);
    result.fold((failure) {
      loading.value = false;
    }, (response) async {
      datalist.value = response;
      loading.value = false;
      if(datalist.value[0].status == "Approved"  && datalist.value[0].bidStatus == "Pending"){
        isBidStatusBarShow.value = true;
      }else{
        isBidStatusBarShow.value = false;
      }
    });
  }

  Future<void> submitBidStatus(BuildContext context, String bidNumber, String bidStatus) async {
    loading.value = true;
    final result =
     await mPartnerRemoteDataSource.updateBidStatusApi(bidNumber, bidStatus);
    result.fold((failure) {
      loading.value = false;
      Utils().showToast(failure.message, context);
    }, (response) async {
      //datalist.value = response;
      isBidStatusBarShow.value = false;
      loading.value = false;
      Utils().showToast("Bid status is updated successfully", context);
      getdata(context, bidNumber);
    });
  }


}
