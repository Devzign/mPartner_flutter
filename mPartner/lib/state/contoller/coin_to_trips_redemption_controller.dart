import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/traveller_model.dart';
import '../../data/models/trip_model.dart';
import '../../utils/app_constants.dart';
import '../../utils/utils.dart';

class CoinsToTripController extends GetxController {
  var travellers = <Traveller>[].obs;
  var isApiSuccess = true.obs;
  var defaultTraveller =
      Traveller(name: "", mobileNo: "", relation: "", passport: "", email: "");
  var savedTravellers = <Traveller>[].obs;
  var trips = <TripModel>[].obs;
  var indexOfEdit = -1.obs;
  var toastMessage = "".obs;
  var currNumberOfTravellers = 0.obs;
  var selectedNumberOfTravellers = 1.obs;
  var isFormCompleted = false.obs;
  var isTermsAndConditonsAccepted = false.obs;
  var isEmailValid = true.obs;
  var isLoading = false.obs;
  var isTripsLoading = false.obs;
  var isBookedTripLoading = false.obs;
  var defaultUserMessage = "".obs;
  var isSavedTravellerBeingEdited = false.obs;

  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController passportController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String relationshipController = "";

  @override
  void onInit() {
    super.onInit();
  }

  void addTextListeners() {
    nameController.addListener(checkForm);
    mobileNoController.addListener(checkForm);
    emailController.addListener(checkForm);
    mobileNoController.addListener(_checkPhoneNumber);
  }

  void cleanSelection() {
    currNumberOfTravellers.value = 0;
    selectedNumberOfTravellers.value = 1;
    travellers.clear();
    savedTravellers.clear();
    update();
  }

  void cleanSlateForSelectTravelllers(bool addDefualtTraveller) {
    travellers.clear();
    currNumberOfTravellers.value = 0;
    selectedNumberOfTravellers.value = 1;
    if (addDefualtTraveller == true) {
      addDefaultUser();
    }
  }

  void onChangeOfSelectedNumberOfTravellers(int uiSelection) {
    selectedNumberOfTravellers.value = uiSelection;
    if (currNumberOfTravellers.value > selectedNumberOfTravellers.value) {
      currNumberOfTravellers.value = selectedNumberOfTravellers.value;
      travellers.length = currNumberOfTravellers.value;
    }
    update();
  }

  //API CALLS
  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  void fetchTrips(String status) async {
    try {
      isTripsLoading(true);

      final result = await mPartnerRemoteDataSource.postFetchTrips(status);

      result.fold(
        (failure) {
          isApiSuccess(false);
        },
        (r) {
          isApiSuccess(true);
          for (int i = 0; i < r.length; i++) {
            r[i].tripName = r[i].tripName.split("2N")[0];
          }
          trips.value = r;
        },
      );
    } finally {
      isTripsLoading(false);
      update();
    }
  }

  void getSavedTravellers(int tripID) async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.getSavedTravellers(tripID);

      result.fold(
        (failure) {
          print('Failed to fetch  information: $failure');
        },
        (r) {
          savedTravellers.value = r;
        },
      );
    } finally {
      isLoading(false);
      update();
    }
  }

  void UpdateMobileNumber(Traveller savedTraveller, int? indexOfCurrent,
      int? indexOfSaved, int tripID, context) async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource
          .putTravellerMobileNumberUsingPassportNumber(
        savedTraveller.name,
        savedTraveller.relation,
        savedTraveller.mobileNo,
      );

      result.fold(
        (failure) {
          print('Failed to fetch  information: $failure');
        },
        (r) {
          getSavedTravellers(tripID);
          updateTraveller(savedTraveller, indexOfCurrent, indexOfSaved);
          toastMessage.value = r;
          Utils().showToast(r, context);
        },
      );
    } finally {
      isLoading(false);
    }
  }


  bool intializeEditingController(Traveller traveller) {
    isEmailValid.value = true;
    mobileNoController.text = traveller.mobileNo;
    emailController.text = traveller.email;
    nameController.text = traveller.name;
    relationshipController = traveller.relation;

    for (Traveller i in savedTravellers) {
      if (traveller.passport == i.passport) {
        return false;
      }
    }
    return true;
  }

  void addDefaultUser() {
    travellers.clear();
    currNumberOfTravellers = 0.obs;
    for (Traveller i in savedTravellers) {
      if (i.relation.toLowerCase() == "self") {
        addTraveller(i);
        update();
        break;
      }
    }
  }

  void _checkPhoneNumber() async {
    final String mobileNumberPrefix = AppConstants.countryCode;
    final text = mobileNoController.text;

    if (text.length > mobileNumberPrefix.length &&
        (!text[text.length - 1].isNumericOnly ||
            text[mobileNumberPrefix.length] == "0" ||
            text[mobileNumberPrefix.length] == "1" ||
            text[mobileNumberPrefix.length] == "2" ||
            text[mobileNumberPrefix.length] == "3" ||
            text[mobileNumberPrefix.length] == "4" ||
            text[mobileNumberPrefix.length] == "5")) {
      mobileNoController.text =
          mobileNoController.text.substring(0, mobileNoController.length - 1);
    }

    if (text.length < mobileNumberPrefix.length) {
      mobileNoController.text = mobileNumberPrefix;
    }
    if (text.length == 10 &&
        text.isNumericOnly &&
        !text.startsWith(mobileNumberPrefix)) {
      mobileNoController.text = mobileNumberPrefix + text;
    }

    if (text.length > mobileNumberPrefix.length + 10) {
      mobileNoController.text =
          mobileNoController.text.substring(0, mobileNumberPrefix.length + 10);
    }
  }

  bool checkNo() {
    final String mobileNumberPrefix = AppConstants.countryCode;
    final text = mobileNoController.text;
    if (text.length == mobileNumberPrefix.length + 10) {
      return true;
    }
    return false;
  }

  bool checkEmail() {
    return emailController.text.isEmpty ||
        (emailController.text.isNotEmpty && emailController.text.isEmail);
  }

  bool checkName() {
    return nameController.text.isNotEmpty;
  }

  bool checkRelation() {
    return relationshipController.isNotEmpty;
  }

  int? indexOfCurrentTraveller(String name, String relation) {
    for (int i = 0; i < travellers.length; i++) {
      if (travellers[i].relation.toLowerCase() == relation.toLowerCase() &&
          travellers[i].name.toLowerCase() == name.toLowerCase()) {
        return i;
      }
    }
    return null;
  }

  int? indexOfSavedTraveller(String name, String relation) {
    for (int i = 0; i < savedTravellers.length; i++) {
      if (savedTravellers[i].relation.toLowerCase() == relation.toLowerCase() &&
          savedTravellers[i].name.toLowerCase() == name.toLowerCase()) {
        return i;
      }
    }
    return null;
  }

  bool isNameAndRelationshipUniqueness(int? indexOfCurrent, int? indexOfSaved) {
    int? indexFoundOfCurrentTraveller =
        indexOfCurrentTraveller(nameController.text, relationshipController);
    int? indexFoundOfSavedTraveller =
        indexOfSavedTraveller(nameController.text, relationshipController);

    if ((indexFoundOfCurrentTraveller == null ||
            indexFoundOfCurrentTraveller == indexOfCurrent) &&
        (indexFoundOfSavedTraveller == null ||
            indexFoundOfSavedTraveller == indexOfSaved)) {
      return true;
    }
    return false;
  }

  void checkForm() {
    if (isSavedTravellerBeingEdited.value) {
      if (checkNo()) {
        isFormCompleted.value = true;
      } else {
        isFormCompleted.value = false;
      }
    } else {
      if (checkName() &&
          checkRelation() &&
          checkEmail() &&
          checkNo()) {
        isFormCompleted.value = true;
      } else {
        isFormCompleted.value = false;
      }
    }
  }


  void updateTraveller(
      Traveller traveller, int? indexOfCurrent, int? indexOfSaved) {
    if (indexOfCurrent != null &&
        indexOfCurrent >= 0 &&
        indexOfCurrent < travellers.length) {
      travellers[indexOfCurrent] = traveller;
    }
    update();
  }

  void addTraveller(Traveller traveller) {
    for (final t in travellers) {
      if (t.relation == traveller.relation && t.name == traveller.name) {
        return;
      }
    }

    travellers.add(traveller);
    currNumberOfTravellers.value += 1;
    update();
  }

  void removeTraveller(Traveller traveller) {
    travellers.remove(traveller);
    currNumberOfTravellers.value -= 1;
    update();
  }

  @override
  void onClose() {
    super.onClose();
    travellers.clear();
    trips.clear();
    mobileNoController.dispose();
    nameController.dispose();
    emailController.dispose();
  }
}
