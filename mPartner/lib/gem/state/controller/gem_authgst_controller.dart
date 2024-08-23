
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/datasource/mpartner_remote_data_source.dart';


class GemAuthGstController extends GetxController{
  RxBool isApiLoading = false.obs;
  MPartnerRemoteDataSource mPartnerRemoteDataSource = MPartnerRemoteDataSource();
  Future<String?> GstApiCall(String gstnumber, BuildContext context) async {

  }


}