import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/network_management_model/state_city_district_info.dart';
import '../../data/models/user_profile_model.dart';
import '../../presentation/screens/network_management/dealer_electrician/components/common_network_utils.dart';
import '../../presentation/screens/network_management/network_home_page.dart';
import '../../utils/app_constants.dart';
import '../../utils/localdata/language_constants.dart';
import 'language_controller.dart';
import 'user_data_controller.dart';

class CreateDealerElectricianController extends GetxController {
  RxBool isLoading = false.obs;
  FocusNode panFocusNode = FocusNode();
  RxString error = ''.obs;
  bool isSuccess = false;
  String errorMessage = "";
  RxBool enableSubmit = false.obs;
  RxBool enableDocSubmit = false.obs;
  RxBool enableAddressSubmit = false.obs;
  RxString companyErrorText = "".obs;
  RxString dealerErrorText = "".obs;
  RxString mobileErrorText = "".obs;
  RxString emailErrorText = "".obs;
  RxString ownerErrorText = "".obs;
  String currentDistributorStateId = "";
  RxBool isButtonClicked = false.obs;

  //firm detail comtroller
  TextEditingController companyNameController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController delearController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobTextEditController = TextEditingController();
  String userType = "Dealer";

  //AddressDetails
  RxString address1ErrorText = "".obs;
  RxString address2ErrorText = "".obs;
  RxString postalCodeErrorText = "".obs;
  RxString cityErrorText = "".obs;
  RxString districtErrorText = "".obs;
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  List<StateInfo> stateList = [];
  List<DistrictInfo> districtList = [];
  List<CityInfo> cityList = [];

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();
  UserDataController userController = Get.find();
  List<UserProfile> userProfileData = [];
  DistrictInfo? selectedDistrict;
  CityInfo? selectedCity;

  //Document upload

  RxString panImagePath = "".obs;
  RxString govtDocFrontImagePath = "".obs;
  RxString govtDocBackImagePath = "".obs;

  TextEditingController panNumberController = TextEditingController();
  TextEditingController govtIdNumberController = TextEditingController();
  TextEditingController govtIdTypeController = TextEditingController();
  RxBool isCheckBoxChecked = false.obs;
  RxString panNumberErrorText = "".obs;
  RxString govtIdNumberErrorText = "".obs;
  List<GovtIdTypeInfo> govtIdTypeList = [];

  RxBool isOtpPinValid = false.obs;
  RxBool isvalidOtp = true.obs;
  RxString documentType = "".obs;
  String otpValidationMessage = "";

  @override
  void onInit() async {
    super.onInit();
    update();
    userProfileData = userController.userProfile;
    stateController.text = userProfileData[0].state;
    getStateList();
    getGovtIdTypeList();
  }

  @override
  void dispose() {
    isLoading = false.obs;
    error = ''.obs;
    enableSubmit = false.obs;
    companyErrorText = "".obs;
    dealerErrorText = "".obs;
    mobileErrorText = "".obs;
    emailErrorText = "".obs;
    ownerErrorText = "".obs;
    companyNameController = TextEditingController(text: "");
    ownerController = TextEditingController(text: "");
    delearController = TextEditingController(text: "");
    mobileNumberController = TextEditingController(text: "");
    emailController = TextEditingController(text: "");

    super.dispose();
  }

  void setDefaultControllerValue() {
    isLoading.value = false;
    error.value = "";
    enableSubmit.value = false;
    enableDocSubmit.value = false;
    enableAddressSubmit.value = false;
    companyErrorText.value = "";
    dealerErrorText.value = "";
    mobileErrorText.value = "";
    emailErrorText.value = "";
    ownerErrorText.value = "";
    currentDistributorStateId = "";

    //firm detail comtroller
    companyNameController = TextEditingController(text: "");
    ownerController = TextEditingController(text: "");
    delearController = TextEditingController(text: "");
    mobileNumberController = TextEditingController(text: "");
    emailController = TextEditingController(text: "");
    dobTextEditController = TextEditingController(text: "");

    //AddressDetails
    address1ErrorText.value = "";
    address2ErrorText.value = "";
    postalCodeErrorText.value = "";
    cityErrorText.value = "";
    districtErrorText.value = "";
    address1Controller = TextEditingController(text: "");
    address2Controller = TextEditingController(text: "");
    postalCodeController = TextEditingController(text: "");
    districtController = TextEditingController(text: "");
    cityController = TextEditingController(text: "");

    selectedDistrict = null;
    selectedCity = null;

    //Document upload

    panImagePath.value = "";
    govtDocFrontImagePath.value = "";
    govtDocBackImagePath.value = "";

    panNumberController = TextEditingController(text: "");
    govtIdNumberController = TextEditingController(text: "");
    govtIdTypeController = TextEditingController(text: "");
    isCheckBoxChecked.value = false;
    panNumberErrorText.value = "";
    govtIdNumberErrorText.value = "";

    isOtpPinValid.value = false;
    govtIdTypeController.text = govtIdTypeList[0].name!;
  }

  bool validateFirmField(BuildContext context) {
    if (validateMobileNumber(mobileNumberController.text.trim(), context) &&
        validateEmail(emailController.text.trim(), context)) {
      return true;
    } else {
      return false;
    }
  }

  bool validateEmail(String email, BuildContext context) {
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(email)) {
      emailErrorText.value = translation(context).validEmailError;
      return false;
    } else {
      emailErrorText.value = "";
      return true;
    }
  }

  bool validateMobileNumber(String mobileNumber, BuildContext context) {
    mobileNumber = mobileNumber.replaceAll("+91 - ", "");
    RegExp regex = RegExp(r'^[0-9]{10}$');
    if (!regex.hasMatch(mobileNumber)) {
      mobileErrorText.value = translation(context).validNumberError;
      return false;
    } else {
      mobileErrorText.value = "";
      return true;
    }
  }

  bool validateAddressField(BuildContext context) {
    if (isValidPostalCode(context)) {
      return true;
    } else {
      return false;
    }
  }

  bool isValidPostalCode(BuildContext context) {
    if (postalCodeController.text.trim().length != 6) {
      postalCodeErrorText.value = translation(context).validPostalCodeError;
      return false;
    } else {
      mobileErrorText.value = "";
      return true;
    }
  }

  bool validateGovtIdField(BuildContext context) {
    if (validatePancard(panNumberController.text.trim(), context)) {
      if (govtIdTypeController.text
          .trim()
          .toString()
          .toLowerCase()
          .contains("aadhar")) {
        if (validateAadharcard(govtIdNumberController.text.trim(), context)) {
          return true;
        } else {
          return false;
        }
      } else if (govtIdTypeController.text
          .trim()
          .toString()
          .toLowerCase()
          .contains("driving")) {
        if (validateDrivingLicense(
            govtIdNumberController.text.trim(), context)) {
          return true;
        } else {
          return false;
        }
      } else if (govtIdTypeController.text
          .trim()
          .toString()
          .toLowerCase()
          .contains("pan")) {
        if (validatePancardGovt(govtIdNumberController.text.trim(), context)) {
          return true;
        } else {
          return false;
        }
      } else if (govtIdTypeController.text
          .trim()
          .toString()
          .toLowerCase()
          .contains("gst")) {
        if (validateGST(govtIdNumberController.text.trim(), context)) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool validateAadharcard(String value, BuildContext context) {
    if (value.length != 12) {
      govtIdNumberErrorText.value = translation(context).validAadharError;
      return false;
    }
    govtIdNumberErrorText.value = "";
    return true;
  }

  bool validateGST(String value, BuildContext context) {
    String pattern =
        r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      govtIdNumberErrorText.value = translation(context).gstValidation;
      return false;
    }
    govtIdNumberErrorText.value = "";
    return true;
  }

  bool validatePancardGovt(String value, BuildContext context) {
    String pattern = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      govtIdNumberErrorText.value = translation(context).panValidation;
      return false;
    }
    govtIdNumberErrorText.value = "";
    return true;
  }

  bool validatePancard(String value, BuildContext context) {
    String pattern = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      panFocusNode.requestFocus();
      panNumberErrorText.value = translation(context).panValidation;
      return false;
    }
    panNumberErrorText.value = "";
    return true;
  }

  bool validateDrivingLicense(String value, BuildContext context) {
    String pattern =
        r'^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      govtIdNumberErrorText.value =
          translation(context).validDrivingLicenceError;
      return false;
    }
    govtIdNumberErrorText.value = "";
    return true;
  }

  bool isPanValid() {
    if (postalCodeController.text.trim().length != 6) {
      return false;
    } else {
      mobileErrorText.value = "";
      return true;
    }
  }

  void getGovtIdTypeList() async {
    try {
      final result = await mPartnerRemoteDataSource.getGovtIdTypeList();
      result.fold((failure) {
        // Handle failure (Left)
        error('Failed to fetch states list  information: $failure');
      }, (stateListResponse) async {
        govtIdTypeList.clear();
        govtIdTypeList.addAll(stateListResponse);
        govtIdTypeController.text = govtIdTypeList[0].name!;
        documentType.value = govtIdTypeList[0].name!;
      });
    } catch (e) {
      error('$e');
    }
  }

  void getStateList() async {
    try {
      final result = await mPartnerRemoteDataSource.getStateList();
      result.fold((failure) {
        // Handle failure (Left)
        error('Failed to fetch states list  information: $failure');
      }, (stateListResponse) async {
        stateList.clear();
        stateList.addAll(stateListResponse);
        userProfileData = userController.userProfile;
        stateController.text = userProfileData[0].state;
        getCurrentDistributorStateId();
      });
    } catch (e) {
      error('$e');
    }
  }

  void getDistrictList(selectedStateValue) async {
    try {
      final result =
          await mPartnerRemoteDataSource.getDistrictList(selectedStateValue);
      result.fold((failure) {
        // Handle failure (Left)
        error('Failed to fetch states list  information: $failure');
      }, (listResponse) async {
        districtList.clear();
        districtList.addAll(listResponse);
      });
    } catch (e) {
      error('$e');
    }
  }

  Future<void> getCityList(selectedStateValue) async {
    selectedDistrict = selectedStateValue;
    districtController.text = selectedDistrict!.name!;
    try {
      final result =
          await mPartnerRemoteDataSource.getCityList(selectedDistrict!.id!);
      result.fold((failure) {
        // Handle failure (Left)
        error('Failed to fetch states list  information: $failure');
      }, (stateListResponse) async {
        cityList.clear();
        cityList.addAll(stateListResponse);
        isLoading.value = false;
      });
    } catch (e) {
      error('$e');
      isLoading.value = false;
    }
  }

  Future<String?> createOtp(BuildContext context, String userType) async {
    try {
      final result = await mPartnerRemoteDataSource.createOtp(
          mobileNumberController.text.trim().replaceAll("+91 - ", ""),
          userType);
      result.fold((failure) {
        // Handle failure (Left)
        otpValidationMessage = failure.message;
        return failure.message;
        // error('Failed to send Otp : $failure');
      }, (res) async {
        otpValidationMessage = res;
        return res;
        /*  ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.toString())),
        );*/
      });
    } catch (e) {
      error('$e');
      otpValidationMessage = translation(context).somethingWentWrong;
      return translation(context).somethingWentWrong;
    }
  }

  Future<String?> verifyOtp(String otp, BuildContext context) async {
    try {
      final result = await mPartnerRemoteDataSource.verifyNewUserOtp(
          otp, mobileNumberController.text.trim().replaceAll("+91 - ", ""));
      result.fold((failure) {
        error('Failed to verify Otp: $failure');
        if (failure.message.contains("Already Registered")) {
          return failure.message;
        } else {
          isvalidOtp.value = false;
          return "";
        }
      }, (res) async {
        if (res.toLowerCase().contains("successfully")) {
          isvalidOtp.value = true;
          return "";
        } else {
          isvalidOtp.value = false;
          return res;
        }
      });
    } catch (e) {
      return "";
      error('$e');
    }
  }

  LanguageController languageController = Get.find();

  Future<void> createDealerElectrician(BuildContext context) async {
    logger.d(
        "LN_TAG State Id: ${currentDistributorStateId.toString()}, State Name: ${stateController.text}");
    logger.d(
        "LN_TAG City: ${cityController.text}, City Id: ${selectedCity!.id.toString()}");
    logger.d("LN_TAG district: ${districtController.text}");
    final body = (userType == UserType.dealer)
        ? FormData.fromMap({
            "id": 0,
            "request_no": "-",
            "request_type": "new",
            "dis_code": userController.sapId,
            "dealer_firm_name": companyNameController.text.trim(),
            "dealer_name": delearController.text.trim(),
            "owner_name": ownerController.text.trim(),
            "mobile_no": "+91 - " + mobileNumberController.text.trim(),
            "email_id": emailController.text.trim(),
            "address1": address1Controller.text.trim(),
            "address2": address2Controller.text.trim(),
            "city": cityController.text.trim(),
            "district": districtController.text.trim(),
            "state": stateController.text.trim(),
            "city_code": selectedCity!.id.toString(),
            "state_code": currentDistributorStateId,
            "country": "India",
            "postal_code": postalCodeController.text.trim(),
            "document_PanCard": AppConstants.createDelerDocumentPanCard,
            "PanCard_No": panNumberController.text.trim(),
            "document_AadharCard": govtIdTypeController.text.trim(),
            "AadharCard_No": govtIdNumberController.text.trim(),
            "PanCard_Front": await MultipartFile.fromFile(panImagePath.value,
                filename: File(panImagePath.value).path.split("/").last),
            "PanCard_Back": await MultipartFile.fromFile(panImagePath.value,
                filename: File(panImagePath.value).path.split("/").last),
            "AadharCard_Front": await MultipartFile.fromFile(
                govtDocFrontImagePath.value,
                filename:
                    File(govtDocFrontImagePath.value).path.split("/").last),
            "AadharCard_Back": await MultipartFile.fromFile(
                govtDocBackImagePath.value,
                filename:
                    File(govtDocBackImagePath.value).path.split("/").last),
            "user_Id": userController.sapId,
            "token": "",
            "app_Version": AppConstants.appVersionName,
            "os_Type": osType,
            "channel": AppConstants.channel,
            "device_name": deviceId,
            "os_version_name": osVersionName,
            "os_version_code": osVersionCode,
            "ip_address": "",
            "language": languageController.language.toString(),
            "screen_name": "",
            "network_type": networkType,
            "network_operator": networkOperator,
            "time_captured": DateTime.now().microsecondsSinceEpoch.toString(),
            "month": "",
            "year": ""
          })
        : FormData.fromMap({
            "id": "${userController.sapId}",
            "user_Id": "${userController.sapId}",
            "app_Version": AppConstants.appVersionName,
            "os_Type": Platform.isAndroid ? "android" : "ios",
            "channel": AppConstants.channel,
            "electrician_code": AppConstants.electricianCode,
            "electrician_name": companyNameController.text.trim(),
            "date_of_birth": dobTextEditController.text.trim(),
            "mobile_no": "+91 - " + mobileNumberController.text.trim(),
            "email_id": emailController.text.trim(),
            "address1": address1Controller.text.trim(),
            "address2": address2Controller.text.trim(),
            "city": cityController.text.trim(),
            "district": districtController.text.trim(),
            "state": stateController.text.trim(),
            "city_code": selectedCity!.id.toString(),
            "state_code": currentDistributorStateId,
            "country": "India",
            "postal_code": postalCodeController.text.trim(),
            "house": address1Controller.text.trim(),
            "apartment": address2Controller.text.trim(),
            "PanCard": AppConstants.createDelerDocumentPanCard,
            "Pan_Number": panNumberController.text.trim(),
            "AdharCard": govtIdTypeController.text.trim(),
            "Adhar_Number": govtIdNumberController.text.trim(),
            "PanCard_front": await MultipartFile.fromFile(panImagePath.value,
                filename: File(panImagePath.value).path.split("/").last),
            "PanCard_back": await MultipartFile.fromFile(panImagePath.value,
                filename: File(panImagePath.value).path.split("/").last),
            "Adhar_front": await MultipartFile.fromFile(
                govtDocFrontImagePath.value,
                filename:
                    File(govtDocFrontImagePath.value).path.split("/").last),
            "Adhar_back": await MultipartFile.fromFile(
                govtDocBackImagePath.value,
                filename:
                    File(govtDocBackImagePath.value).path.split("/").last),
            "electrician_status": "Pending"
          });
    try {
      logger.d("LN_TAG ${body.obs.toString()}");
      final result = await mPartnerRemoteDataSource.createDealerElectrician(
          userType, body);
      result.fold((failure) {
        // Handle failure (Left)
        error('Failed to submit the data: $failure');
        isSuccess = false;
        errorMessage = failure.message;
      }, (successResponse) async {
        isSuccess = true;
      });
    } catch (e) {
      error('$e');
      isSuccess = false;
    }
  }

  void getCurrentDistributorStateId() {
    List<StateInfo> stateInfo = stateList
        .where((element) => element.name == userProfileData[0].state)
        .toList();
    if (stateInfo.length != 0) {
      currentDistributorStateId = stateInfo[0].id!;
      getDistrictList(currentDistributorStateId);
    }
  }

  Future<bool> pickImage(ImageSource source, ImageTypeData type) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile =
        await imagePicker.pickImage(source: source, imageQuality: 80);
    File imageFile = File(pickedFile!.path);
    print(imageFile);
    try {
      if (type == ImageTypeData.pan) {
        panImagePath.value = imageFile.path;
      } else if (type == ImageTypeData.govt_doc_front) {
        govtDocFrontImagePath.value = imageFile.path;
      } else if (type == ImageTypeData.govt_doc_back) {
        govtDocBackImagePath.value = imageFile.path;
      }
      return true;
    } catch (e) {
      return false;
    }
    }

  Future captureImage(ImageSource source, ImageTypeData type) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(
        source: source, imageQuality: 80, maxWidth: 100, maxHeight: 100);
    File cameraPhotoFile = File(pickedFile!.path);
    final String path = (await getApplicationDocumentsDirectory()).path;
    final File newImage =
        await cameraPhotoFile.copy('$path/${pickedFile.name}');
    try {
      if (type == ImageTypeData.pan) {
        panImagePath.value = newImage.path;
      } else if (type == ImageTypeData.govt_doc_front) {
        govtDocFrontImagePath.value = newImage.path;
      } else if (type == ImageTypeData.govt_doc_back) {
        govtDocBackImagePath.value = newImage.path;
      }
    } catch (e) {}
    }
}
