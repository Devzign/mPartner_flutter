import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/state_manager.dart';

import '../../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/datasource/gem_remote_data_source.dart';
import '../../data/models/gem_auth_detail_model.dart';

class GemAuthDetailController extends GetxController {
  BaseMPartnerRemoteDataSource? baseMPartnerRemoteDataSource;
  RxBool loading = false.obs;
  RxList<GemAuthDetailModel> datalist = <GemAuthDetailModel>[].obs;
  BaseGemRemoteDataSource mPartnerRemoteDataSource =BaseGemRemoteDataSource();
  Future<void> getdata(BuildContext context, int id) async {
    loading.value = true;
    final result = await mPartnerRemoteDataSource.getAuthCodedetails(id);
    result.fold((failure) {
      loading.value = false;
    }, (response) async {
      datalist.value = response;
      loading.value = false;
    });
  }
}
