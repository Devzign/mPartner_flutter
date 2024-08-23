import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:intl/intl.dart';

import '../../../data/datasource/mpartner_remote_data_source.dart';

import '../../../data/models/user_profile_model.dart';
import '../../../solar/data/models/option.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/utils.dart';
import '../../data/datasource/gem_remote_data_source.dart';
import '../../data/models/gem_option.dart';
import '../../data/models/maf_participation_model.dart';

class MafRegistrationFormController extends GetxController {

  String gemText = "Gem Tender";
  RxBool isLoading = false.obs;
  RxString error = ''.obs;
  bool isSuccess = false;
  RxBool isActive = false.obs;
  RxBool isInActive = false.obs;
  RxBool enableProceed = false.obs;
  RxBool enableDocSubmit = false.obs;
  RxString bidNumberErrorText = "".obs;
  RxString gstNumberErrorText = "".obs;
  RxString pubDateErrorText = "".obs;
  RxString dueDateErrorText = "".obs;
  String participantType = "";
  RxBool isApiLoading = false.obs;
  RxBool isButtonEnabled = false.obs;

  //firm detail controller
  TextEditingController participantController =
      TextEditingController(text: 'Gem Tender');
  TextEditingController bidNumberController = TextEditingController();
  TextEditingController gstNumberController = TextEditingController();
  TextEditingController writeToUsController = TextEditingController();

  RxList<GemOption> participentTypeList =
      <GemOption>[].obs;

  TextEditingController _datePublishController = TextEditingController();

  TextEditingController get datePublishController => _datePublishController;

  TextEditingController _dateDueController = TextEditingController();

  TextEditingController get dateDueController => _dateDueController;

  String currentDateFormatted = DateFormat('dd/MM/yyyy').format(DateTime.now());

  BaseGemRemoteDataSource mPartnerRemoteDataSource = BaseGemRemoteDataSource();

  String docImagePath = "";
  RxBool isCheckBoxChecked = false.obs;

  RxString gstError = "".obs;

  // Rx<MafParticipationModel> selectedParticipationModel =
  //     MafParticipationModel().obs;

  RxBool isOtpPinValid = false.obs;
  RxBool isvalidBidNumber = false.obs;
  RxBool isGstExist = false.obs;
  RxString documentType = "".obs;
  String otpValidationMessage = "";

  @override
  void onInit() async {
    super.onInit();
  }

  reset() {
    isLoading = false.obs;
    error = ''.obs;
    enableProceed = false.obs;
    bidNumberErrorText = "".obs;
    gstNumberErrorText = "".obs;
    pubDateErrorText = "".obs;
    dueDateErrorText = "".obs;
    isGstExist = false.obs;
    isvalidBidNumber = false.obs;
    isButtonEnabled = true.obs;
    docImagePath = "";
    participantType = "";
    bidNumberController = TextEditingController(text: "");
    participantController = TextEditingController(text: "");
    _datePublishController = TextEditingController(text: "");
    _dateDueController = TextEditingController(text: "");

    gstNumberController = TextEditingController(text: "");
    writeToUsController = TextEditingController(text: "");
  }

  resetController() {
    //mafRegistrationData.clear();
    isLoading = false.obs;
    error = ''.obs;
    enableDocSubmit = false.obs;
    enableProceed = false.obs;
    isButtonEnabled = true.obs;
    participantType = "";
    setDefaultControllerValue();
  }

  Future<bool> getParticipantList(context) async {
    isApiLoading.value = true;
    participentTypeList.value.clear();
    try {
      final result =
          await mPartnerRemoteDataSource.getParticipationType("participation");
      isApiLoading.value = false;
      result.fold((failure) {}, (response) async {
        participentTypeList.clear();
        participentTypeList.addAll(response.data);
      });
    } catch (e) {
      isApiLoading.value = false;
      //error('$e');
    }
    return true;
  }

  void setDefaultControllerValue() {
    isLoading.value = false;
    error.value = "";
    enableProceed.value = false;
    enableDocSubmit.value = false;
    isGstExist.value = false;
    isvalidBidNumber.value = false;
    bidNumberErrorText.value = "";
    gstNumberErrorText.value = "";
    pubDateErrorText.value = "";
    isButtonEnabled.value = true;
    dueDateErrorText.value = "";
    //firm detail controller
    bidNumberController = TextEditingController(text: "");
    participantController = TextEditingController(text: "");
    gstNumberController = TextEditingController(text: "");
    writeToUsController = TextEditingController(text: "");
    _dateDueController = TextEditingController(text: currentDateFormatted);
    _datePublishController = TextEditingController(text: currentDateFormatted);

    //Document upload
    //panImagePath.value = "";
    docImagePath = "";
    participantType = "";
    //govtDocBackImagePath.value = "";
    isCheckBoxChecked.value = false;
    gstError.value = "";
    isOtpPinValid.value = false;
  }

  bool validateFirmField(BuildContext context) {
    if (!validTextData(bidNumberController.text.trim(), context)) {
      bidNumberErrorText.value = translation(context).enterbidNumber;
      return false;
    } else if (!validateGST(gstNumberController.text.trim(), context)) {
      gstNumberErrorText.value = translation(context).invalidGstin;
      return false;
    } else if (!validTextData(_datePublishController.text, context)) {
      Utils().showToast(translation(context).selectDateValue, context);
      return false;
    } else if (!validTextData(_dateDueController.text, context)) {
      Utils().showToast(translation(context).selectDateValue, context);
      //dueDateErrorText.value = translation(context).selectDateValue;
      return false;
    }
    // If all fields pass validation
    return true;
  }

  bool validateBidNumber(String value, BuildContext context) {
    if ((value.length < 7) || (value.length > 30)) {
      bidNumberErrorText.value = translation(context).bidValidationText;
    }else{
      bidNumberErrorText.value = "";
    }
    return true;
  }

  bool validateBidNumberInputField(String bidNumber) {
    // Check if bidNumber is not null or empty
    if (bidNumber.isEmpty) {
      return false;
    }
    // Check length (assuming bid numbers should be 8 characters long)
    if ((bidNumber.length < 7) || (bidNumber.length > 30)) {
      return false;
    }
    // Check if bidNumber contains only letters and numbers
    // if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(bidNumber)) {
    //   return false;
    // }
    // If all checks pass, return true
    return true;
  }

  String? validateTextFirmField(BuildContext context) {
    if (!validTextData(bidNumberController.text.trim(), context)) {
      return translation(context).enterbidNumber;
    } else if (!validateGST(gstNumberController.text.trim(), context)) {
      return translation(context).invalidGstin;
    } else if (!validTextData(_datePublishController.text, context)) {
      return translation(context).selectDateValue;
    } else if (!validTextData(_dateDueController.text, context)) {
      return translation(context).selectDateValue;
    }

    // If all fields pass validation
    return null; // No error message, validation succeeded
  }

  bool validateGST(String value, BuildContext context) {
    String pattern =
        r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      gstError.value = translation(context).gstValidation;
      return false;
    }
    gstError.value = "";
    return true;
  }

  bool validTextData(String value, BuildContext context) {
    if (value.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<String?> verifyBidNumber(
      String bidNumber, String gst, BuildContext context) async {
    isButtonEnabled.value = false;
    try {
      isApiLoading.value = true;
      final result = await mPartnerRemoteDataSource.verifyBidNumber(bidNumber);
      isApiLoading.value = false;
      result.fold(
        (failure) {
          Utils().showToast(failure.message, context);
          isvalidBidNumber.value = false;
          isButtonEnabled.value = true;
          error('Failed to bid verify: $failure');
        },
        (res) {
          if (res.token!.contains("0")) {
            isvalidBidNumber.value = false;
            isButtonEnabled.value = true;
            Utils().showToast(res.message!, context);
          } else {
            isvalidBidNumber.value = true;
            isButtonEnabled.value = false;
            if (gst.isNotEmpty) {
              isGstExist.value = true;
              TextEditingValue resText = TextEditingValue(text: gst);
              gstNumberController.value = resText;
              // enableProceed.value = false;
            } else {
              isGstExist.value = false;
              //enableProceed.value = false;
            }
          }
        },
      );
    } catch (e) {
      isApiLoading.value = false;
      isButtonEnabled.value = true;
      isvalidBidNumber.value = false;
      Utils().showToast(e.toString(), context);
      error('$e');
      return "";
    }
  }

  bool isValidField() {
    // if(validBidNumber(bidNumberController.text)){
    //
    // }
    if (bidNumberController.text.isEmpty ||
        gstNumberController.text.isEmpty ||
        datePublishController.text.isEmpty ||
        dateDueController.text.isEmpty ||
        participantType.isEmpty) {
      // At least one field is empty
      return true;
    } else {
      // All fields have some value
      return false;
    }

    return false;
  }

  // Future<String?> submitFormData(String gstNumber) async {
  //   try {
  //     isApiLoading.value = true;
  //     final result =
  //         await mPartnerRemoteDataSource.fetchRegistartionDetails(gstNumber);
  //     isApiLoading.value = false;
  //     result.fold((failure) {
  //       error('Failed to verify Otp: $failure');
  //       if (failure.message.contains("Already Registered")) {
  //         return failure.message;
  //       } else {
  //         //isvalidBidNumber.value = false;
  //         return "";
  //       }
  //     }, (res) async {
  //       if (res.toLowerCase().contains("successfully")) {
  //         // isvalidBidNumber.value = true;
  //         return "";
  //       } else {
  //         //isvalidBidNumber.value = true;
  //         return res;
  //       }
  //     });
  //   } catch (e) {
  //     isApiLoading.value = false;
  //     return "";
  //     error('$e');
  //   }
  // }

  // Future<String?> postMafBidRegData(
  //     String sParticipationType,
  //     String nBidNumber,
  //     String sGSTINNumber,
  //     String dBidPublishDate,
  //     String dBidDueDate,
  //     String sTendorDoc,
  //     ) async {
  //   try {
  //     isApiLoading.value = true;
  //     final result = await mPartnerRemoteDataSource.uploadMafBidRegistrationData(
  //         sParticipationType, nBidNumber, sGSTINNumber, dBidPublishDate, dBidDueDate, sTendorDoc);
  //     isApiLoading.value = false;
  //
  //     // Handling the result using fold
  //     return result.fold((failure) {
  //       error('Failed to : $failure');
  //       return ""; // Return an empty string for failure
  //     }, (res) {
  //       print(res);
  //
  //       // Checking the message for success
  //       if (res.msgs == "Abcd") {
  //         return 'success'; // Return 'success' for success
  //       } else {
  //         return ''; // Return an empty string for other cases
  //       }
  //     });
  //   } catch (e) {
  //     isApiLoading.value = false;
  //     error('$e');
  //     return ""; // Return an empty string in case of exception
  //   }
  // }

// Future<String?> getTermConditionData() async {
//   try {
//     isApiLoading.value = true;
//     final result = await mPartnerRemoteDataSource.fetchTermConditionDetails();
//     isApiLoading.value = false;
//     result.fold((failure) {
//       error('Failed to verify Otp: $failure');
//       if (failure.message.contains("Already Registered")) {
//         return failure.message;
//       } else {
//         isvalidBidNumber.value = false;
//         return "";
//       }
//     }, (res) async {
//
//       if (res.toLowerCase().contains("successfully")) {
//         isvalidBidNumber.value = true;
//         return "";
//       } else {
//         isvalidBidNumber.value = true;
//         return res;
//       }
//     });
//   } catch (e) {
//     isApiLoading.value = false;
//     return "";
//     error('$e');
//   }
//   return null;
// }

//   Future<bool> pickImage(ImageSource source, ImageTypeData type) async {
//     ImagePicker imagePicker = ImagePicker();
//     XFile? pickedFile =
//     await imagePicker.pickImage(source: source, imageQuality: 80);
//     File imageFile = File(pickedFile!.path);
//     print(imageFile);
//     if (imageFile != null) {
//       try {
//         if (type == ImageTypeData.pan) {
//           panImagePath.value = imageFile.path;
//         } else if (type == ImageTypeData.govt_doc_front) {
//           govtDocFrontImagePath.value = imageFile.path;
//         } else if (type == ImageTypeData.govt_doc_back) {
//           govtDocBackImagePath.value = imageFile.path;
//         }
//         return true;
//       } catch (e) {
//         return false;
//       }
//     } else {
//       return false;
//       //Get.showSnackbar(Ui.ErrorSnackBar(message: "Please select an image file".tr));
//     }
//   }
//
//   Future captureImage(ImageSource source, ImageTypeData type) async {
//     ImagePicker imagePicker = ImagePicker();
//     XFile? pickedFile = await imagePicker.pickImage(
//         source: source, imageQuality: 80, maxWidth: 100, maxHeight: 100);
//     File cameraPhotoFile = File(pickedFile!.path);
//     final String path = (await getApplicationDocumentsDirectory()).path;
//     final File newImage =
//     await cameraPhotoFile.copy('$path/${pickedFile.name}');
//     if (newImage != null) {
//       try {
//         if (type == ImageTypeData.pan) {
//           panImagePath.value = newImage.path;
//         } else if (type == ImageTypeData.govt_doc_front) {
//           govtDocFrontImagePath.value = newImage.path;
//         } else if (type == ImageTypeData.govt_doc_back) {
//           govtDocBackImagePath.value = newImage.path;
//         }
//       } catch (e) {}
//     } else {
//       //Get.showSnackbar(Ui.ErrorSnackBar(message: "Please select an image file".tr));
//     }
//   }
// }
}
