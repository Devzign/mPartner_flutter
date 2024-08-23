

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/datasource/gem_remote_data_source.dart';
import '../../data/models/maf_registrationwise_details.dart';

class MafRegistrationDetailsController extends GetxController {
  RxBool isDataRender = false.obs;
 // var registrationWiseDetails = <Map<String, dynamic>>[].obs;
  var mafRegistrationData = <MafRegistrationWiseDetails>[].obs;
  var isLoading = false.obs;
  RxBool isApiLoading = false.obs;
  RxBool isReadTerms = false.obs;
  var error = ''.obs;

  BaseGemRemoteDataSource mPartnerRemoteDataSource =BaseGemRemoteDataSource();

  @override
  void onInit() async {
    super.onInit();
    update();
  }

  Future<String?> getRegistrationDetails() async {
    try {
      isApiLoading.value = true;
      final result = await mPartnerRemoteDataSource.fetchRegistartionDetails();
      isApiLoading.value = false;
      return result.fold(
            (failure) {
          error('Failed to verify Otp: $failure');
          if (failure.message.contains("Already Registered")) {
            return failure.message;
          } else {
            //isvalidBidNumber.value = false;
            return "";
          }
        },
            (res) {
          mafRegistrationData.add(res);
          isDataRender.value = true;
          return null;
        },
      );
    } catch (e) {
      isApiLoading.value = false;
      error('$e');
      return "";
    }
  }


  Future<String?> postMafBidRegData(
      String sParticipationType,
      String nBidNumber,
      String sGSTINNumber,
      String dBidPublishDate,
      String dBidDueDate,
      String comments,
      String sTendorDoc,
      ) async {
    try {
      isApiLoading.value = true;
      final result = await mPartnerRemoteDataSource.uploadMafBidRegistrationData(
          sParticipationType, nBidNumber, sGSTINNumber, dBidPublishDate, dBidDueDate, comments, sTendorDoc);
      isApiLoading.value = false;

      // Handling the result using fold
      return result.fold((failure) {
        error('Failed to : $failure');
        isApiLoading.value = false;
        return failure.message; // Return an empty string for failure
      }, (res) {
        print(res);

        // Checking the message for success
        if (res.token == "1") {
          return 'success'; //
          // Return 'success' for success
        } else {
          return res.message; // Return an empty string for other cases
        }
      });
    } catch (e) {
      isApiLoading.value = false;
      error('$e');
      return e.toString(); // Return an empty string in case of exception
    }
  }


  reset(){
    isLoading = false.obs;
    error = ''.obs;
    isDataRender = false.obs;
  }

  void setDefaultControllerValue() {
    isLoading.value = false;
    error.value = "";
    isDataRender.value = false;
    mafRegistrationData.value = <MafRegistrationWiseDetails>[];
  }


  clearRegistrationWiseDetailsState() {
    mafRegistrationData.clear();
    isLoading = false.obs;
    error = ''.obs;
    isReadTerms=false.obs;
  }
}
