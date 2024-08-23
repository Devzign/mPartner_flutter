import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'components/bottom_bar_coins_to_trip.dart';
import 'components/card_without_image.dart';
import 'components/terms_and_conditon_trip.dart';
import 'traveller_details_verify.dart';

class TravellerDetailsPostSelection extends StatefulWidget {
  TravellerDetailsPostSelection({super.key, required this.tripModel, this.totalSelectedTravellers = 1});
  final TripModel tripModel;
  final int totalSelectedTravellers;

  @override
  State<TravellerDetailsPostSelection> createState() =>
      _TravellerDetailsPostSelectionState();
}

class _TravellerDetailsPostSelectionState
    extends State<TravellerDetailsPostSelection> {
  CoinsToTripController c = Get.find();
  void initState() {
    super.initState();
    c.isTermsAndConditonsAccepted.value = false;
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                HeaderWidgetWithBackButton(
                    heading: translation(context).travellerDetails,
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
                      tripModel: widget.tripModel,
                      totalSelectedTravellers: widget.totalSelectedTravellers,
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
                                visible:
                                    c.travellers[index].passport.isNotEmpty,
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
            GestureDetector(
              onTap: () => {
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
                      return TermsAndConditonTrip(
                        htmlData: widget.tripModel.termAndConditions,
                      );
                    }),
              },
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 24 * w, vertical: 12 * h),
                color: AppColors.lumiLight5,
                child: Text(
                  translation(context).beforeClickingContinue,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    decoration: TextDecoration.underline,
                    color: AppColors.lumiBluePrimary,
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w500,
                    height: 20 / 12,
                    letterSpacing: 0.10,
                  ),
                  
                ),
              ),
            ),
            Obx(
              () => BottomBarCoinsToTrip(
                  coinCostPerPerson: widget.tripModel.requiredCoinsPerSeat,
                  numberOfTravellers: c.selectedNumberOfTravellers.value,
                  isButtonEnabled: c.isTermsAndConditonsAccepted.value,
                  onButtonPressed: () => {
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TravellerDetailsVerify(
                                      tripModel: widget.tripModel,
                                      selectedTravellers : widget.totalSelectedTravellers
                                    )))
                      },
                  buttonText: translation(context).continueButtonText),
            ),
          ],
        ),
      ),
    );
  }
}
