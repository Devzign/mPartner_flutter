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
import '../tabBooked/tab_booked.dart';

class tabAll extends StatefulWidget {
  tabAll({super.key});

  @override
  State<tabAll> createState() => _tabAllState();
}

class _tabAllState extends State<tabAll> {
  CoinsToTripController c = Get.find();
  List<TripModel> upcomingTrips = [];
  List<TripModel> bookedTrips = [];
  List<TripModel> expiredTrips = [];

  void populateTrips() {
    for (TripModel i in c.trips) {
      if (i.tripFlag.toLowerCase() == "upcoming") {
        upcomingTrips.add(i);
      } else if (i.tripFlag.toLowerCase() == "booked") {
        bookedTrips.add(i);
      } else {
        expiredTrips.add(i);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    populateTrips();
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();

    return Visibility(
      visible: c.trips.isNotEmpty,
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: upcomingTrips.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24 * w),
                    child: Text(
                      translation(context).upcoming,
                      style: GoogleFonts.poppins(
                        fontSize: 16 * f,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText2,
                        height: 22 / 16,
                      ),
                    ),
                  ),
                  VerticalSpace(height: 12),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.fromLTRB(24 * w, 0, 24 * w, 22 * h),
                    itemCount: upcomingTrips.length,
                    itemBuilder: (context, index) {
                      return CardTrip(
                        status: upcomingTrips[index].tripFlag,
                        tripModel: upcomingTrips[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: 24 * h,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: bookedTrips.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24 * w),
                    child: Text(
                      translation(context).booked,
                      style: GoogleFonts.poppins(
                        fontSize: 16 * f,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText2,
                        height: 22 / 16,
                      ),
                    ),
                  ),
                  VerticalSpace(height: 12),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.fromLTRB(24 * w, 0, 24 * w, 22 * h),
                    itemCount: bookedTrips.length,
                    itemBuilder: (context, index) {
                      return bookedTripCompleteCard(trip: bookedTrips[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: 24 * h,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: expiredTrips.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24 * w),
                    child: Text(
                      translation(context).expired,
                      style: GoogleFonts.poppins(
                        fontSize: 16 * f,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText2,
                        height: 22 / 16,
                      ),
                    ),
                  ),
                  VerticalSpace(height: 12),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.fromLTRB(24 * w, 0, 24 * w, 22 * h),
                    itemCount: expiredTrips.length,
                    itemBuilder: (context, index) {
                      return CardTrip(
                        status: expiredTrips[index].tripFlag,
                        tripModel: expiredTrips[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: 24 * h,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
