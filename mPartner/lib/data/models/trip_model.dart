import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class TripModel extends Equatable {
  final int tripID;
  String tripName;
  int requiredCoinsPerSeat;
  final int availableCoins;
  int maxSeatLimit;
  final String duration;
  final int totalSeat;
  final int waitingSeat;
  final int availableSeats;
  final String tripDetail;
  final String durationDate;
  final String ribbonRemarks1;
  final String ribbonRemarks2;
  final bool bookEligibility;
  final String tripUrl;
  final String tripFlag;
  final String termAndConditions;
  final String downloadUrl;
  final String bookingDate;
  final String minimumCoinRequiredMsg;
  final int minimumCoinRequired;
  final bool bookingFirstTime;
  final int currentAvailableCoinVal;


  TripModel({
    required this.tripID,
    required this.tripName,
    required this.requiredCoinsPerSeat,
    required this.availableCoins,
    required this.maxSeatLimit,
    required this.duration,
    required this.totalSeat,
    required this.waitingSeat,
    required this.availableSeats,
    required this.tripDetail,
    required this.durationDate,
  
    required this.ribbonRemarks1,
    required this.ribbonRemarks2,
    required this.bookEligibility,
    required this.tripUrl,
    required this.tripFlag,
    required this.termAndConditions,
    required this.downloadUrl,
    required this.bookingDate,
    required this.minimumCoinRequiredMsg,
    required this.minimumCoinRequired,
    required this.bookingFirstTime,
    required this.currentAvailableCoinVal,
  });

  @override
  List<Object?> get props => [
        tripID,
        tripName,
        requiredCoinsPerSeat,
        availableCoins,
        maxSeatLimit,
        duration,
        totalSeat,
        waitingSeat,
        availableSeats,
        tripDetail,
        durationDate,
        ribbonRemarks1,
        ribbonRemarks2,
        bookEligibility,
        tripUrl,
        tripFlag,
        termAndConditions,
        downloadUrl,
        bookingDate,
        minimumCoinRequiredMsg,
        minimumCoinRequired,
        bookingFirstTime,
        currentAvailableCoinVal,
      ];

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      tripID: json['trip_ID'] ?? 0,
      tripName: json['trip_Name'] ?? "",
      requiredCoinsPerSeat: json['required_Coins_PerSeat'] ?? 0,
      availableCoins: json['available_Coin'] ?? 0,
      maxSeatLimit: json['max_seat_limit'] ?? 0,
      duration: json['duration'] ?? "",
      totalSeat: json['total_Seat'] ?? 0,
      waitingSeat: json['waiting_Seat'] ?? 0,
      availableSeats: json['available_Seats'] ?? 0,
      tripDetail: json['trip_Detail'] ?? "",
      durationDate:
          "${DateFormat('dd MMM yy').format(DateTime.parse(json['durationStartDate'] ?? ""))} - ${DateFormat('dd MMM yy').format(DateTime.parse(json['durationEndDate'] ?? ""))}",
      ribbonRemarks1: json['ribbonRemarks1'] ?? "",
      ribbonRemarks2: json['ribbonRemarks2'] ?? "",
      bookEligibility: json['book_Eligibility'] ?? "",
      tripUrl: json['trip_Url'] ?? "",
      tripFlag: json['trip_Flag'] ?? false,
      termAndConditions: json['termAndConditions'],
      downloadUrl: json['downloadUrl'] ?? "",
      bookingDate: json['bookingDate'] ?? "",
      minimumCoinRequiredMsg: json['minimumCoinRequiredMsg'] ?? "",
      minimumCoinRequired: json['minimumCoinRequired'] ?? 0,
      bookingFirstTime: json['bookingFirstTime'] ?? false,
      currentAvailableCoinVal: json['currentAvailableCoinVal'] ?? 0,
    );
  }
}
