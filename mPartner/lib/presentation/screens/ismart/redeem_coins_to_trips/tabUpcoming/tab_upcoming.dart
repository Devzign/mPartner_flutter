import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/trip_model.dart';
import '../../../../../state/contoller/coin_to_trips_redemption_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../tabBooked/card_trip.dart';

class TabUpcoming extends StatelessWidget {
  const TabUpcoming({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutUpcomingTrip();
  }
}

class LayoutUpcomingTrip extends StatelessWidget {
  LayoutUpcomingTrip({
    super.key,
  });
  CoinsToTripController c = Get.find();
  List<TripModel> populateTrips() {
    List<TripModel> result = [];
    for (TripModel i in c.trips) {
      if (i.tripFlag.toLowerCase() == "upcoming") {
        result.add(i);
      }
    }
    return result;
  }

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
          return CardTrip(
              status: trips[index].tripFlag, tripModel: trips[index]);

        },
        separatorBuilder: (BuildContext context, int index) => SizedBox(
          height:
               24 * h,
        ),
      ),
    );
  }
}
