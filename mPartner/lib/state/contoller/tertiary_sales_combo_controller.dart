import 'dart:convert';

import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/hkva_item_model.dart';
import '../../data/models/send_otp.dart';
import '../../data/models/tertiary_sales_userinfo_model.dart';
import '../../data/models/verify_otp_tertiary_sales_model.dart';
import 'verify_otp_controller.dart';

class TertiarySalesHKVAcombo extends GetxController {
  VerifyOtpController _controller = Get.find();
  var hkvaItemModels = <HkvaItemModel>[].obs;
  var messageToDisplay = "No error".obs;
  var isScanSuccessful = true.obs;
  var userInfo = TertiarySalesUserInfo(
          name: "",
          address: "",
          mobileNumber: "",
          date: "",
          saleTime: "",
          referralCode: "",
          otp: "",
          tertiarySaleType: "",
          transId: "")
      .obs;
  var otpResponse = SendOTP(
    message: "",
    status: "",
    token: "",
    data: "",
    data1: "",
  ).obs;
  var verifyOtpResponse = VerifyOtpTertiarySales(
      message: "",
      status: "",
      token: "",
      data: VerifyOtpHkvaData(code: "", des: ""),
      data1: "");
  var isOtpCorrect = false.obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var isComplete = false.obs;

  void updateUserInfo(TertiarySalesUserInfo userInformation) {
    userInfo.value.name = userInformation.name;
    userInfo.value.mobileNumber = userInformation.mobileNumber;
    userInfo.value.date = userInformation.date;
    userInfo.value.saleTime= userInformation.saleTime;
    userInfo.value.address = userInformation.address;
    userInfo.value.referralCode = userInformation.referralCode;
    userInfo.value.tertiarySaleType = userInformation.tertiarySaleType;
    userInfo.value.otp = userInformation.otp;
    userInfo.value.transId = userInformation.transId;
  }

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();


  void intialize(String text) {
    hkvaItemModels.value = jsonDecode(text)
        .map<HkvaItemModel>((json) => HkvaItemModel.fromJson(json))
        .toList();
  }

  bool isVerifiable() {
    if (hkvaItemModels.value.isEmpty) {
      return false;
    }
    for (HkvaItemModel item in hkvaItemModels) {
      if (item.id == 0) {
        return false;
      }
    }
    return true;
  }

  void postCreateOtp() async {
    try {
      isLoading(true);
      final result = await mPartnerRemoteDataSource.postCreateOTPHkva();

      result.fold(
        (failure) {
          error('Failed Create Otp Hkva: $failure');
        },
        (r) {
          messageToDisplay(r.status);
          otpResponse(r);
          userInfo.value.transId = r.token;
        },
      );
    } finally {
      isVerifiable();
      isLoading(false);
    }
  }

  void postVerifyOtp(String otp) async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postVerifyOtpHkva(otp);

      result.fold(
        (failure) {
          error('Failed Create Otp Hkva: $failure');
        },
        (r) {
          if(r.status=='200'){
            if (r.data.code.toLowerCase() == "success") {
            print("------->my otp is correct");
            isOtpCorrect(true);
            _controller.updateOtpValid(true);
          } else {
            print("------->my otp is incorrect");
            isOtpCorrect(false);
            _controller.updateOtpValid(false);
          }
          }
        },
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    // onCreation

    super.onInit();
  }

  @override
  void onReady() {
    // OnRender
    super.onReady();
  }

  @override
  void onClose() {
    //toRemoveFromMemory
    super.onClose();
  }
}
