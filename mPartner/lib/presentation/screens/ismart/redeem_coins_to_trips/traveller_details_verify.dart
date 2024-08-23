import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/models/trip_model.dart';
import '../../../../state/contoller/coin_to_trips_redemption_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/headers/back_button_header_widget.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../userprofile/user_profile_widget.dart';
import 'components/alert_trip_booking_bottomsheet.dart';
import 'components/bottom_bar_coins_to_trip.dart';
import 'components/card_without_image.dart';

class TravellerDetailsVerify extends StatelessWidget {
  const TravellerDetailsVerify({super.key, required this.tripModel, required this.selectedTravellers});
  final TripModel tripModel;
  final int selectedTravellers;
  @override
  Widget build(BuildContext context) {
    CoinsToTripController c = Get.find();
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              HeaderWidgetWithBackButton(
                  heading: translation(context).verifyTripDetails,
                  onPressed: () => {Navigator.pop(context)}),
              UserProfileWidget(),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24 * w),
              child: ListView(
                children: [
                  CardWithoutImage(
                    tripModel: tripModel,
                    totalSelectedTravellers: selectedTravellers,
                  ),
                  VerticalSpace(height: 20),
                  Text(
                    translation(context).travellerDetails,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGrey,
                      fontSize: 16 * f,
                      fontWeight: FontWeight.w600,
                      height: 24 / 16,
                    ),
                  ),
                  VerticalSpace(height: 16),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${translation(context).traveller} ${index + 1}',
                              style: GoogleFonts.poppins(
                                color: AppColors.darkGreyText,
                                fontSize: 16 * f,
                                fontWeight: FontWeight.w600,
                                height: 24 / 16,
                              ),
                            ),
                            VerticalSpace(height: 4),
                            Text(
                              '${c.travellers[index].name}',
                              style: GoogleFonts.poppins(
                                color: AppColors.darkGreyText,
                                fontSize: 14 * f,
                                fontWeight: FontWeight.w500,
                                height: 20 / 14,
                                letterSpacing: 0.10 * w,
                              ),
                            ),
                            VerticalSpace(height: 4),
                            Text(
                              '${c.travellers[index].relation} | ${c.travellers[index].mobileNo}',
                              style: GoogleFonts.poppins(
                                color: AppColors.grayText,
                                fontSize: 12 * f,
                                fontWeight: FontWeight.w500,
                                height: 16 / 12,
                                letterSpacing: 0.50 * w,
                              ),
                            ),
                            VerticalSpace(height: 4),
                            Visibility(
                              visible: c.travellers[index].passport.isNotEmpty,
                              child: Text(
                                '${translation(context).passport}: ${c.travellers[index].passport} ',
                                style: GoogleFonts.poppins(
                                  color: AppColors.grayText,
                                  fontSize: 12 * f,
                                  fontWeight: FontWeight.w500,
                                  height: 16 / 12,
                                  letterSpacing: 0.50 * w,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return VerticalSpace(height: 16);
                      },
                      itemCount: c.travellers.length),
                ],
              ),
            ),
          ),
          BottomBarCoinsToTrip(
              showCoinsCost: false,
              onButtonPressed: () => {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        useSafeArea: true,
                        isDismissible: false,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(28 * r),
                                topRight: Radius.circular(28 * r))),
                        showDragHandle: true,
                        backgroundColor: AppColors.white,
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertTripBookingBottomsheet(
                              tripModel: tripModel);
                        }),
                  },
              buttonText: translation(context).bookNow),
            
        ],
      )),
    );
  }
}
