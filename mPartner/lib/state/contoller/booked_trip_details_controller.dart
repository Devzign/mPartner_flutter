import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/booked_trip_details_model.dart';
import '../../data/models/trip_model.dart';
import 'coin_redemption_options_controller.dart';
import 'coins_summary_controller.dart';

class BookedTripDetailsController extends GetxController {
  var isLoading = false.obs;
  var isdelete = false.obs;
  var DeleteSuccess = false.obs;
  var error = ''.obs;

  var bookedTravellers = <TravellerDetail>[].obs;
  var bookedTripDetailsData = BookedTripDetailsModel(
      tripId: 0,
      tripName: "",
      totalSeat: 0,
      availableSeats: 0,
      waitingSeat: 0,
      requiredCoinsPerSeat: 0,
      duration: "",
      durationDate: "",
      ribbonRemarks1: "",
      ribbonRemarks2: "",
      bookEligibility: false,
      tripDetail: "",
      tripUrl: "",
      termAndConditions: "",
      createdOn: "",
      earnMoreCoinsToConfirm: "",
      availableCoin: 0,
      currentAvailableCoinVal: 0,
      maxSeatLimit: 0,
      downloadUrl: "",
      minimumCoinRequired: 0,
      minimumCoinRequiredMsg: "",
      travellerDetails: []).obs;

  var tripModel = TripModel(
          tripID: 0,
          tripName: "",
          requiredCoinsPerSeat: 0,
          availableCoins: 0,
          maxSeatLimit: 0,
          duration: "",
          totalSeat: 0,
          waitingSeat: 0,
          availableSeats: 0,
          tripDetail: "",
          durationDate: "",
          ribbonRemarks1: "",
          ribbonRemarks2: "",
          bookEligibility: false,
          tripUrl: "",
          tripFlag: "",
          termAndConditions: "",
          downloadUrl: "",
          bookingDate: "",
          minimumCoinRequiredMsg: "",
          minimumCoinRequired: 0,
          bookingFirstTime: false,
          currentAvailableCoinVal: 0)
      .obs;

  void bookedTripModelToTripModel(BookedTripDetailsModel response) {
    tripModel(TripModel(
        tripID: response.tripId,
        tripName: response.tripName,
        requiredCoinsPerSeat: response.requiredCoinsPerSeat,
        availableCoins: response.availableCoin,
        maxSeatLimit: response.maxSeatLimit,
        duration: response.duration,
        totalSeat: response.totalSeat,
        waitingSeat: response.waitingSeat,
        availableSeats: response.availableSeats,
        tripDetail: response.tripDetail,
        durationDate: response.durationDate,
        ribbonRemarks1: response.ribbonRemarks1,
        ribbonRemarks2: response.ribbonRemarks2,
        bookEligibility: response.bookEligibility,
        tripUrl: response.tripUrl,
        tripFlag: "BOOKED",
        termAndConditions: response.termAndConditions,
        downloadUrl: response.downloadUrl,
        bookingDate: "",
        minimumCoinRequiredMsg: response.minimumCoinRequiredMsg,
        minimumCoinRequired: response.minimumCoinRequired,
        bookingFirstTime: false,
        currentAvailableCoinVal: response.currentAvailableCoinVal));
  }

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchBookedTripDetails(String tripId) async {
    try {
      bookedTravellers.clear();
      isLoading(true);
      final result =
          await mPartnerRemoteDataSource.postFetchBookedTripDetails(tripId);
      // print("RESULT IN CONTROLLER -> ${result}");
      result.fold((failure) {
        // Handle failure (Left)
        error('Failed to fetch booked trip details: $failure');
      }, (bookedTripDetails) async {
        if (bookedTripDetails.props.every((value) => value == 'NA')) {
          error('No data for this booked Trip');
        } else {
          error('');
        }
        bookedTripDetailsData(bookedTripDetails);
        bookedTripModelToTripModel(bookedTripDetails);
        bookedTravellers.assignAll(bookedTripDetails.travellerDetails);
      });
    } finally {
      isLoading(false);
    }
  }

  bool isUserAlreadyBooked(String name, String relation) {
    for (TravellerDetail t in bookedTravellers) {
      if (t.relation.toLowerCase() == relation.toLowerCase() &&
          t.travellerName.toLowerCase() == name.toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  @override
  void onInit() async {
    super.onInit();
    update();
  }

  clearBookedTripDetails() {
    bookedTravellers.clear();
    isLoading = false.obs;
    isdelete = false.obs;
    DeleteSuccess = false.obs;
    error = ''.obs;
  }
  Future<dynamic> delete(int tripId,String deletedId, BuildContext context) async {
    isdelete(true);
    final result =await mPartnerRemoteDataSource.postDeleteTraveller(tripId,deletedId);
    result.fold((failure) {
      error('Failed to fetch booked trip details: $failure');
    }, (response) async {
      if(response["status"]=="200"){
        CoinsSummaryController coinRedemptionOptionsController = Get.find();
        coinRedemptionOptionsController.fetchCoinsSummary();
        DeleteSuccess(true);
      }
  });
    isdelete(false);
}


}
