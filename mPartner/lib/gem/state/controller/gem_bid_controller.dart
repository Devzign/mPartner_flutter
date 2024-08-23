import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/state_manager.dart';
import '../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../error/failure.dart';
import '../../../presentation/widgets/common_bottom_sheet.dart';
import '../../../utils/utils.dart';
import '../../data/datasource/gem_remote_data_source.dart';
import '../../data/models/gem_auth_bid_model.dart';
import '../../data/models/gem_request_gst_details_model.dart';
import '../../presentation/gem_support_auth/gem_auth_generate/gem_auth_code_generate.dart';
import '../../presentation/gem_support_auth/gem_support_autcode/gem_support_request_code.dart';

class GemBidController extends GetxController {
  BaseMPartnerRemoteDataSource? baseMPartnerRemoteDataSource;
  RxBool loading = false.obs;
  RxBool checkgst = false.obs;

  RxList<GemAuthBidModel> datalist = <GemAuthBidModel>[].obs;
  BaseGemRemoteDataSource mPartnerRemoteDataSource = BaseGemRemoteDataSource();
  Future<void> getdata(BuildContext context) async {
    loading.value = true;
    final result = await mPartnerRemoteDataSource.getGemBiddetails();
    result.fold((failure) {
      loading.value = false;
    }, (response) async {
      datalist.value = response;
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

      if (model.isValidityExpired.toString() == "Yes" || model.isValidityExpired.toString() == "") {
        if (model.token == "No") {
          var res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GemSupportRequestCode()),
          );
          if (res != null && isback == true) {
            Navigator.pop(context);
          }
        } else {
          var res = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Gem_AuthCodeGenerate(
                      gstNumber: "",
                    )),
          );
          if (res != null && isback == true) {
            Navigator.pop(context);
          }
        }
      } else if (model.isValidityExpired.toString() == "In Progress") {
        await CommonBottomSheet.openSuccessSheet(context, "Error!",
            "Dear Partner, your request is already in process.. ");
      } else if (model.isValidityExpired.toString() == "No") {
        String authorizationCode = model.authorizationCode.toString();
        String validity = model.validity.toString();

        String text = 'Dear Partner, use Authorization Code $authorizationCode as it\'s already valid until ${Utils().getFormattedDateMonth(validity)}, so there\'s no need to reapply.';

        await CommonBottomSheet.openSuccessSheet(context, "Error!", text);
      } else {
        await CommonBottomSheet.openSuccessSheet(
            context, "Error!", model.message.toString());
      }
    });
  }
}
