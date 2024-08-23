import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/trip_model.dart';
import '../../../../../state/contoller/coins_summary_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/CommonCoins/coin_widget.dart';
import '../components/trip_card_heading.dart';
import '../components/trip_duration.dart';
import '../trip_details.dart';
import 'booked_trip_details.dart';

class CardTrip extends StatelessWidget {
  const CardTrip({
    super.key,
    required this.status,
    required this.tripModel,
  });
  final String status;
  final TripModel tripModel;

  Widget typeOfTrip(String type) {
    if (type.split(" ")[0].toLowerCase() == "solo") {
      return const Icon(
        Icons.person_2_outlined,
        size: 16,
        color: AppColors.white,
      );
    } else {
      return const Icon(
        Icons.groups_2_outlined,
        size: 16,
        color: AppColors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget card;
    CoinsSummaryController c = Get.find();
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    switch (status.toLowerCase()) {
      case 'booked':
        card = GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookedTripDetails(
                      tripID: tripModel.tripID
                      )),
            );
          },
          child: Container(
            decoration: const ShapeDecoration(shape: RoundedRectangleBorder()),

            child: CardSkeleton(
              booking: true,
              isExpired: false,
              tripModel: tripModel,
              iconWidget: typeOfTrip(tripModel.ribbonRemarks2),
            ),
          ),
        );
        break;
      case 'upcoming':
        card = GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TripDetails(
                        tripModel: tripModel,
                        heading: tripModel.tripName,
                        tripStatus: 'default',
                      )),
            );
          },
          child: Container(
            padding: EdgeInsets.all(16 * r),
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: AppColors.lightGrey2),
              borderRadius: BorderRadius.circular(12 * r),
            )),
            child: CardSkeleton(
              booking: false,
              isExpired: false,
              tripModel: tripModel,
              iconWidget: typeOfTrip(tripModel.ribbonRemarks2),
            ),
          ),
        );
        break;
      case 'expired':
        card = GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TripDetails(
                        tripModel: tripModel,
                        heading: tripModel.tripName,
                        showProceedButton: false,
                        tripStatus: 'details_expired',
                      )),
            );
          },
          child: Container(
            padding: EdgeInsets.all(16 * r),
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: AppColors.lightGrey2),
              borderRadius: BorderRadius.circular(12 * r),
            )),
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.4,
                  child: CardSkeleton(
                    booking: false,
                    isExpired: true,
                    tripModel: tripModel,
                    iconWidget: typeOfTrip(tripModel.ribbonRemarks2),
                  ),
                ),
                Positioned(
                  top: 95 * h,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(10 * r),
                    decoration:
                        const BoxDecoration(color: AppColors.grayBorder),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            tripModel.ribbonRemarks1,
                            style: GoogleFonts.poppins(
                              color: AppColors.blackText,
                              fontSize: 12 * f,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ]),
                  ),
                )
              ],
            ),
          ),
        );
        break;
      case "details_expired":
        card = CardSkeleton(
          booking: false,
          isExpired: true,
          isExpiredDetailsType: true,
          tripModel: tripModel,
          iconWidget: typeOfTrip(tripModel.ribbonRemarks2),
        );
        break;

      default:
        card = CardSkeleton(
          booking: false,
          isExpired: false,
          tripModel: tripModel,
          iconWidget: typeOfTrip(tripModel.ribbonRemarks2),
        );
        break;
    }
    return card;
  }
}

class CardSkeleton extends StatelessWidget {
  const CardSkeleton(
      {super.key,
      required this.booking,
      this.isExpiredDetailsType = false,
      required this.isExpired,
      required this.tripModel,
      required this.iconWidget,});
  final TripModel tripModel;
  final bool booking, isExpired, isExpiredDetailsType;
  final Widget iconWidget;
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: isExpiredDetailsType,
          replacement: ImageBookedTrip(
              isExpired: isExpired,
              callForAction: tripModel.ribbonRemarks1,
              imgUrl: tripModel.tripUrl,
              iconText: tripModel.ribbonRemarks2.split(' ')[0],
              iconWidget: iconWidget,
              booking: booking),
          child: Stack(
            children: [
              Opacity(
                opacity: 0.4,
                child: ImageBookedTrip(
                    isExpired: isExpired,
                    callForAction: tripModel.ribbonRemarks1,
                    imgUrl: tripModel.tripUrl,
                    iconText: tripModel.ribbonRemarks2.split(' ')[0],
                    iconWidget: iconWidget,
                    booking: booking),
              ),
              Positioned(
                top: 95 * h,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(10 * r),
                  decoration: const BoxDecoration(color: AppColors.grayBorder),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          tripModel.ribbonRemarks1,
                          style: GoogleFonts.poppins(
                            color: AppColors.blackText,
                            fontSize: 12 * f,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.10,
                          ),
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 8 * h,
        ),
        TextBookedTrip(
          bookingDate: tripModel.durationDate,
          coinsPerSeat: tripModel.requiredCoinsPerSeat,
          tripName: tripModel.tripName,
          availableSeats: tripModel.availableSeats,
          totalSeats: tripModel.totalSeat,
          tripDurationInDN: tripModel.duration,
          booking: booking,
          bookedOn: tripModel.bookingDate,
          isSolo:
              tripModel.ribbonRemarks2.split(" ")[0].toLowerCase() == "solo",
        ),
      ],
    );
  }
}

class ImageBookedTrip extends StatelessWidget {
  ImageBookedTrip({
    super.key,
    required this.isExpired,
    required this.callForAction,
    required this.imgUrl,
    required this.iconText,
    required this.iconWidget,
    required this.booking,
  });
  final String callForAction;
  final String imgUrl;
  final String iconText;
  final Widget iconWidget;
  final bool booking;
  final bool isExpired;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Stack(
        fit: StackFit.loose,
        alignment: Alignment.bottomLeft,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12 * r),  
            child: Container(
              height: 216 * h,
              width: double.maxFinite,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12 * r),
                ),
              ),
              child: Image.network(
                imgUrl,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, exception, stackTrace) {
                  return Image.asset(
                    'assets/mpartner/ic_trips_small.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
),

          booking || isExpired
              ? Container()
              : Positioned(
                  child: Container(
                    padding: EdgeInsets.all(10 * r),
                    decoration: ShapeDecoration(
                      color: AppColors.grayBorder,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12 * r),
                          bottomRight: Radius.circular(12 * r),
                        ),
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            callForAction,
                            style: GoogleFonts.poppins(
                              color: AppColors.blackText,
                              fontSize: 12 * f,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ]),
                  ),
                ),
          Positioned(
              top: 8 * h,
              right: 8 * w,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12 * r, vertical: 4 * r),
                decoration: ShapeDecoration(
                  color: AppColors.darkIcon2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100 * r),
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      iconWidget,
                      SizedBox(
                        width: 4 * w,
                      ),
                      Text(
                        iconText,
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 12 * f,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.10,
                        ),
                      )
                    ]),
              ))
        ]);
  }
}

class TextBookedTrip extends StatelessWidget {
  TextBookedTrip(
      {super.key,
      required this.booking,
      required this.tripName,
      required this.tripDurationInDN,
      required this.bookingDate,
      required this.coinsPerSeat,
      required this.totalSeats,
      required this.availableSeats,
    required this.bookedOn,
    required this.isSolo,
  });
  final bool booking, isSolo;
  final String tripName, tripDurationInDN, bookingDate, bookedOn;
  final int coinsPerSeat, totalSeats, availableSeats;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(child: TripCardHeading(text: tripName)),
            booking
                ? Container()
                : CoinWidget(
                    coins: coinsPerSeat,
                  ),
          ],
        ),
        SizedBox(
          height: 12 * h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SeatAvailability(
              seats: availableSeats,
              totalSeats: totalSeats,
            ),
            TripDuration(
              duration: tripDurationInDN,
              isSolo: isSolo,
            ),
          ],
        ),
        SizedBox(
          height: 6 * h,
        ),
        Text(
          '${translation(context).date}: $bookingDate',
          style: GoogleFonts.poppins(
            color: AppColors.darkGreyText,
            fontSize: 14 * f,
            fontWeight: FontWeight.w500,
          ),
        ),
        booking
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BookingDate(
                      text: "${translation(context).bookedOn} ${bookedOn}"),
                  const BookingLogo(),
                ],
              )
            : Container(),
      ],
    );
  }
}

class SeatAvailability extends StatelessWidget {
  SeatAvailability({super.key, required this.seats, required this.totalSeats});
  final int seats;
  final int totalSeats;
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${translation(context).seatsAvailable} : ',
            style: GoogleFonts.poppins(
              color: AppColors.darkGrey,
              fontSize: 14 * f,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: '$seats',
            style: GoogleFonts.poppins(
              color: AppColors.successGreen,
              fontSize: 14 * f,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: '/$totalSeats',
            style: GoogleFonts.poppins(
              color: AppColors.grayText,
              fontSize: 14 * f,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.right,
    );
  }
}

class BookingLogo extends StatelessWidget {
  const BookingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * r, vertical: 4 * r),
      decoration: ShapeDecoration(
        color: AppColors.green10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Center(
        child: Text(
          translation(context).booked,
          style: GoogleFonts.poppins(
            color: AppColors.successGreen,
            fontSize: 12 * f,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class BookingDate extends StatelessWidget {
  BookingDate({super.key, required this.text});
  final String text;
  @override
// = 'Booked on 20 Dec 2023'
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Text(
      text,
      style: GoogleFonts.poppins(
        color: AppColors.grayText,
        fontSize: 14 * f,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
