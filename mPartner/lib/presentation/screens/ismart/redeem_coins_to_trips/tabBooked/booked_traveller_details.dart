import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/utils/app_colors.dart';

import '../../../../../state/contoller/booked_trip_details_controller.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';

class bookedTravellersDetails extends StatelessWidget {
  const bookedTravellersDetails({super.key});

  String formattedStatusMessage(String message, BuildContext context) {
    if (message.contains("confirmed"))
      return 'Booked';
    else if (message.contains("waitlist")) {
      
      return message.toUpperFirstCase();
    } else
      return translation(context).bookingFailed;
  }

  Color seatStatusMessageColor(String message) {
    if (message.contains("confirmed"))
      return AppColors.successGreen;
    else if (message.contains("waitlist"))
      return AppColors.goldCoin;
    else
      return AppColors.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    BookedTripDetailsController bookedTripDetailsController = Get.find();
    return Container(
        child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    bookedTripDetailsController
                        .bookedTravellers[index].travellerName,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGreyText,
                      fontSize: 14 * f,
                      fontWeight: FontWeight.w600,
                      height: 24 / 16,
                    ),
                  ),
                  VerticalSpace(height: 4),
                  Visibility(
                    visible: bookedTripDetailsController
                        .bookedTravellers[index].relation.isNotEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalSpace(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Text(
                            translation(context).relationship,
                            style: GoogleFonts.poppins(
                              color: AppColors.grayText,
                              fontSize: 12 * f,
                              fontWeight: FontWeight.w500,
                              height: 16 / 12,
                              letterSpacing: 0.50,
                            ),
                          ),
                            Text(
                                bookedTripDetailsController
                                    .bookedTravellers[index].relation,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 12 * f,
                              fontWeight: FontWeight.w500,
                              height: 16 / 12,
                              letterSpacing: 0.50,
                            ),
                          ),
                          ] 
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: bookedTripDetailsController
                        .bookedTravellers[index].mobileNo.isNotEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalSpace(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Text(
                                translation(context).mobileNumber,
                            style: GoogleFonts.poppins(
                              color: AppColors.grayText,
                              fontSize: 12 * f,
                              fontWeight: FontWeight.w500,
                              height: 16 / 12,
                              letterSpacing: 0.50,
                            ),
                          ),
                            Text(
                                bookedTripDetailsController
                                    .bookedTravellers[index].mobileNo,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 12 * f,
                              fontWeight: FontWeight.w500,
                              height: 16 / 12,
                              letterSpacing: 0.50,
                            ),
                          ),
                          ] 
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: bookedTripDetailsController
                        .bookedTravellers[index].bookingDate.isNotEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalSpace(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Text(
                                translation(context).bookingDate,
                            style: GoogleFonts.poppins(
                              color: AppColors.grayText,
                              fontSize: 12 * f,
                              fontWeight: FontWeight.w500,
                              height: 16 / 12,
                              letterSpacing: 0.50,
                            ),
                          ),
                            Text(
                                bookedTripDetailsController
                                    .bookedTravellers[index].bookingDate,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 12 * f,
                              fontWeight: FontWeight.w500,
                              height: 16 / 12,
                              letterSpacing: 0.50,
                            ),
                          ),
                          ] 
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: bookedTripDetailsController
                        .bookedTravellers[index].transactionId.isNotEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalSpace(height: 4),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translation(context).transactionId,
                                style: GoogleFonts.poppins(
                                  color: AppColors.grayText,
                                  fontSize: 12 * f,
                                  fontWeight: FontWeight.w500,
                                  height: 16 / 12,
                                  letterSpacing: 0.50,
                                ),
                              ),
                              Text(
                                bookedTripDetailsController
                                    .bookedTravellers[index].transactionId,
                                style: GoogleFonts.poppins(
                                  color: AppColors.darkGreyText,
                                  fontSize: 12 * f,
                                  fontWeight: FontWeight.w500,
                                  height: 16 / 12,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: bookedTripDetailsController
                        .bookedTravellers[index].seatStatus.isNotEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalSpace(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Text(
                            translation(context).bookingStatus,
                            style: GoogleFonts.poppins(
                              color: AppColors.grayText,
                              fontSize: 12 * f,
                              fontWeight: FontWeight.w500,
                              height: 16 / 12,
                              letterSpacing: 0.50,
                            ),
                          ),
                            Text(
                            formattedStatusMessage(bookedTripDetailsController
                                  .bookedTravellers[index].seatStatus
                                  .toLowerCase(),
                              context),
                            style: GoogleFonts.poppins(
                              color:seatStatusMessageColor(
                                bookedTripDetailsController
                                    .bookedTravellers[index].seatStatus
                                    .toLowerCase()),
                              fontSize: 12 * f,
                              fontWeight: FontWeight.w500,
                              height: 16 / 12,
                              letterSpacing: 0.50,
                            ),
                          ),
                          ] 
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return VerticalSpace(height: 16);
            },
            itemCount: bookedTripDetailsController.bookedTravellers.length));
  }
}
