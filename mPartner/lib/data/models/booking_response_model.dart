import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../utils/app_constants.dart';

class BookingResponseModel extends Equatable {
  final String message;
  final String status;
  final String token;
  final BookingResponseModelData data;

  BookingResponseModel({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
  });

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingResponseModel(
      message: json['message'] ?? "",
      status: json['status'] ?? "",
      token: json['token'] ?? "",
      data: BookingResponseModelData.fromJson(json['data']),
    );
  }

  @override
  List<Object?> get props => [message, status, token, data];
}

class BookingResponseModelData extends Equatable {
  final List<TravellerData> travellerData;
  final BookedTripModel tripData;
  final String congratulationMsg;
  final int totalRedeemedCoins;

  BookingResponseModelData({
    required this.travellerData,
    required this.tripData,
    required this.congratulationMsg,
    required this.totalRedeemedCoins,
  });

  factory BookingResponseModelData.fromJson(Map<String, dynamic> json) {
    return BookingResponseModelData(
      travellerData: json['travellerData'] != null
          ? List<TravellerData>.from(
              json['travellerData'].map((x) => TravellerData.fromJson(x)))
          : [],
      tripData: json['tripData'] != null
          ? BookedTripModel.fromJson(json['tripData'][0])
          : BookedTripModel(
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
              maxSeatLimit: 0,
              termAndConditions: "",
              tripFlag: "",
              transactionDate: "",
              transactionId: "",
              downloadUrl: ""),
      congratulationMsg: json['congratulation_msg'] ?? "",
      totalRedeemedCoins: json['totalRedeemedCoins'] ?? "",
    );
  }

  @override
  List<Object?> get props =>
      [travellerData, tripData, congratulationMsg, totalRedeemedCoins];
}

class TravellerData extends Equatable {
  final String travellerName;
  final String relation;
  final int coinRedeem;
  final String seatStatus;
  final int waitList;
  final String transactionId;

  TravellerData({
    required this.travellerName,
    required this.relation,
    required this.coinRedeem,
    required this.seatStatus,
    required this.waitList,
    required this.transactionId,
  });

  factory TravellerData.fromJson(Map<String, dynamic> json) {
    return TravellerData(
      travellerName: json['traveller_Name'] ?? "",
      relation: json['relation'] ?? "",
      coinRedeem: json['coinRedeem'] ?? 0,
      seatStatus: json['seatStatus'] ?? "",
      waitList: json['waitList'] ?? 0,
      transactionId: json['transactionId'] ?? "",
    );
  }

  @override
  List<Object?> get props =>
      [travellerName, relation, coinRedeem, seatStatus, waitList];
}

// Additional class for illustration purposes
class BookedTripModel extends Equatable {
  final int tripId;
  final String tripName;
  final int totalSeat;
  final int availableSeats;
  final int waitingSeat;
  final int requiredCoinsPerSeat;
  final String duration;
  final String durationDate;
  final String ribbonRemarks1;
  final String ribbonRemarks2;
  final bool bookEligibility;
  final String tripDetail;
  final String tripUrl;
  final int maxSeatLimit;
  final String termAndConditions;
  final String tripFlag;
  String transactionDate;
  final String transactionId;
  final String downloadUrl;

  BookedTripModel({
    required this.tripId,
    required this.tripName,
    required this.totalSeat,
    required this.availableSeats,
    required this.waitingSeat,
    required this.requiredCoinsPerSeat,
    required this.duration,
    required this.durationDate,
    required this.ribbonRemarks1,
    required this.ribbonRemarks2,
    required this.bookEligibility,
    required this.tripDetail,
    required this.tripUrl,
    required this.maxSeatLimit,
    required this.termAndConditions,
    required this.tripFlag,
    required this.transactionDate,
    required this.transactionId,
    required this.downloadUrl,
  });
  factory BookedTripModel.fromJson(Map<String, dynamic> json) {
    return BookedTripModel(
      tripId: json['trip_ID'] ?? 0,
      tripName: json['trip_Name'] ?? "",
      totalSeat: json['total_Seat'] ?? 0,
      availableSeats: json['available_Seats'] ?? 0,
      waitingSeat: json['waiting_Seat'] ?? 0,
      requiredCoinsPerSeat: json['required_Coins_PerSeat'] ?? 0,
      duration: json['duration'] ?? "",
      durationDate: json['durationDate'] ?? "",
      ribbonRemarks1: json['ribbonRemarks1'] ?? "",
      ribbonRemarks2: json['ribbonRemarks2'] ?? "",
      bookEligibility: json['book_Eligibility'] ?? false,
      tripDetail: json['trip_Detail'] ?? "",
      tripUrl: json['trip_Url'] ?? "",
      maxSeatLimit: json['max_Seat_Limit'] ?? 0,
      termAndConditions: json['termAndConditions'] ?? "",
      tripFlag: json['trip_Flag'] ?? "",
      transactionDate: DateFormat(AppConstants.cashCoinDateFormatWithTime)
          .format(DateTime.parse(
            json['transactionDate'] ?? "",
          ))
          .toString(),
      transactionId: json['transactionId'] ?? "",
      downloadUrl: json['downloadUrl'] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        tripId,
        tripName,
        totalSeat,
        availableSeats,
        waitingSeat,
        requiredCoinsPerSeat,
        duration,
        durationDate,
        ribbonRemarks1,
        ribbonRemarks2,
        bookEligibility,
        tripDetail,
        tripUrl,
        maxSeatLimit,
        termAndConditions,
        tripFlag,
        transactionDate,
        transactionId,
        downloadUrl,
      ];
}
