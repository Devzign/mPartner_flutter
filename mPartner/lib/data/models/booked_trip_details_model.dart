
class BookedTripDetailsModel {
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
  final String termAndConditions;
  final String createdOn;
  final String earnMoreCoinsToConfirm;
  final int availableCoin;
  final int currentAvailableCoinVal;
  final int maxSeatLimit;
  final String downloadUrl;
  final String minimumCoinRequiredMsg;
  final int minimumCoinRequired;
  final List<TravellerDetail> travellerDetails;


  BookedTripDetailsModel({
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
    required this.termAndConditions,
    required this.createdOn,
    required this.earnMoreCoinsToConfirm,
    required this.availableCoin,
    required this.currentAvailableCoinVal,
    required this.maxSeatLimit,
    required this.downloadUrl,
    required this.minimumCoinRequiredMsg,
    required this.minimumCoinRequired,
    required this.travellerDetails,
  });

  @override
  List<Object> get props => [
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
        termAndConditions,
        createdOn,
        earnMoreCoinsToConfirm,
        availableCoin,
        currentAvailableCoinVal,
        maxSeatLimit,
        downloadUrl,
        minimumCoinRequiredMsg,
        minimumCoinRequired,
        travellerDetails,
      ];

  factory BookedTripDetailsModel.fromJson(Map<String, dynamic> json){

    return  BookedTripDetailsModel(
      tripId: json['trip_Id'] ?? 0,
      tripName: json['trip_Name'] ?? '',
      totalSeat: json['total_Seat'] ?? 0,
      availableSeats: json['available_Seats'] ?? 0,
      waitingSeat: json['waiting_Seat'] ?? 0,
      requiredCoinsPerSeat: json['required_Coins_PerSeat'] ?? 0,
      duration: json['duration'] ?? '',
      durationDate: json['durationDate'] ?? '',
      ribbonRemarks1: json['ribbonRemarks1'] ?? '',
      ribbonRemarks2: json['ribbonRemarks2'] ?? '',
      bookEligibility: json['book_Eligibility'] ?? false,
      tripDetail: json['trip_Detail'] ?? '',
      tripUrl: json['trip_Url'] ?? '',
      termAndConditions: json['termAndConditions'] ?? '',
      createdOn: json['createdOn'] ?? '',
      earnMoreCoinsToConfirm: json['earnMoreCoinsToConfirm'] ?? '',
      availableCoin: json['available_Coin'] ?? 0,
      currentAvailableCoinVal: json['currentAvailableCoinVal'] ?? 0,
      maxSeatLimit: json['max_seat_limit'] ?? 0,
      downloadUrl: json['downloadUrl'] ?? '',
      minimumCoinRequiredMsg: json['minimumCoinRequiredMsg'] ?? '',
      minimumCoinRequired: json['minimumCoinRequired'] ?? 0,
      travellerDetails: List<TravellerDetail>.from(
          json["travellerDetails"].map((x) => TravellerDetail.fromJson(x))),
    );
  }

}

class TravellerDetail {
  final String travellerName;
  final String relation;
  final int coinRedeem;
  final String mobileNo;
  final String passport;
  final String seatStatus;
  final String bookingDate;
  final String transactionId;
  final String isDelete_Show;
  bool isChecked=false;
  final String traveller_ID;


  TravellerDetail({
    required this.travellerName,
    required this.relation,
    required this.coinRedeem,
    required this.mobileNo,
    required this.passport,
    required this.seatStatus,
    required this.bookingDate,
    required this.transactionId,
    required this.isDelete_Show,
    required this.traveller_ID,

  });

  @override
  List<Object> get props => [
        travellerName,
        relation,
        coinRedeem,
        mobileNo,
        passport,
        seatStatus,
        bookingDate,
        transactionId,
        isDelete_Show,
        traveller_ID,
      ];

  factory TravellerDetail.fromJson(Map<String, dynamic> json) =>
      TravellerDetail(
        travellerName: json["traveller_Name"] ?? "",
        relation: json["relation"] ?? "",
        coinRedeem: json["coinRedeem"] ?? 0,
        mobileNo: json["mobileNo"] ?? "",
        passport: json["passport"] ?? "",
        seatStatus: json["seatStatus"] ?? "",
        bookingDate: json["bookingDate"] ?? "",
        transactionId: json['transactionId'] ?? "",
        isDelete_Show: json['isDelete_Show'].toString(),
        traveller_ID: json['traveller_ID'].toString(),

      );
}
