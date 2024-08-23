import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../data/models/trip_model.dart';
import '../../../../../state/contoller/coin_to_trips_redemption_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/utils.dart';
import '../../../../widgets/buttons/secondary_button.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import 'card_trip.dart';

class TabBooked extends StatelessWidget {
  const TabBooked({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBookedTrip();
  }
}

class LayoutBookedTrip extends StatelessWidget {
  LayoutBookedTrip({
    super.key,
    this.headingforCard = false,
  });
  CoinsToTripController c = Get.find();
  List<TripModel> populateTrips() {
    List<TripModel> result = [];
    for (TripModel i in c.trips) {
      if (i.tripFlag.toLowerCase() == "booked") {
        result.add(i);
      }
    }
    return result;
  }
  bool headingforCard;

  @override
  Widget build(BuildContext context) {
    List<TripModel> trips = populateTrips();

    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    
    return Visibility(
      visible: trips.isNotEmpty,
      replacement: Column(
        children: [
          VerticalSpace(height: 250 * h),
          Text(
            translation(context).currentlyNoTripsInThisSection,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.blackText,
              fontSize: 18 * f,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(24 * w, 0, 24 * w, 47 * h),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          return bookedTripCompleteCard(trip: trips[index]);
        },
        separatorBuilder: (BuildContext context, int index) => SizedBox(
          height: 24 * h,
        ),
      ),
    );
  }
}

class bookedTripCompleteCard extends StatelessWidget {
  bookedTripCompleteCard({
    super.key,
    required this.trip,
  });

  TripModel trip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardTrip(
          status: "booked",
          tripModel: trip,
        ),
        Visibility(
          visible: trip.downloadUrl.isNotEmpty,
          child: Column(
            children: [
              VerticalSpace(height: 20),
              Row(
          children: [
            SecondaryButton(
                buttonText: translation(context).downloadTripDetails,
                buttonHeight: 48,
                onPressed: () async {
                  if (await canLaunchUrlString(
                      trip.downloadUrl)) {
                    await launchUrlString(trip.downloadUrl);
                  } else {
                    Utils()
                        .showToast(translation(context).noDataFound, context);
                  }
                },
                      isEnabled: true)
          ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
