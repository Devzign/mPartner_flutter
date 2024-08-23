import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../state/contoller/booked_trip_details_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/coin_with_image_widget.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';

class BookedCoinsSummary extends StatelessWidget {
  const BookedCoinsSummary({super.key});

  @override
  Widget build(BuildContext context) {
    int bookedCount = 0;
    int pendingCount = 0;
    int reservedCount = 0;
    BookedTripDetailsController bookedTripDetailsController = Get.find();
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    
    int countReservedSeats() {
       for (var traveller in bookedTripDetailsController.bookedTravellers) {
        if (traveller.seatStatus.toLowerCase() == "confirmed" || traveller.seatStatus.toLowerCase().contains('waitlist')) {
          reservedCount++;
        }
      }
      return reservedCount;
    }
    int countBookedSeats() {
      for (var traveller in bookedTripDetailsController.bookedTravellers) {
        if (traveller.seatStatus.toLowerCase() == "confirmed") {
          bookedCount++;
        }
      }
      return bookedCount;
    }

    int countPendingSeats() {
      for (var traveller in bookedTripDetailsController.bookedTravellers) {
        if (traveller.seatStatus.toLowerCase().contains('waitlist')) {
          pendingCount++;
        }
      }
      return pendingCount;
    }

    return Container(
      padding: EdgeInsets.only(top: 12 * h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8 * h),
            decoration: ShapeDecoration(
              color: AppColors.goldCoinLight,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8 * r)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CoinWithImageWidget(
                    coin: double.parse(
                        "${countReservedSeats() * bookedTripDetailsController.bookedTripDetailsData.value.requiredCoinsPerSeat}"),
                    color: AppColors.goldCoin,
                    size: 16,
                    weight: FontWeight.w600,
                    width: 160),
                Text(
                  translation(context).totalCoinsReserved,
                  style: GoogleFonts.poppins(
                    color: AppColors.goldCoin,
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          VerticalSpace(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8 * h),
                  decoration: ShapeDecoration(
                    color: AppColors.lumiLight5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8 * r)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CoinWithImageWidget(
                          coin: double.parse(
                              "${countBookedSeats() * bookedTripDetailsController.bookedTripDetailsData.value.requiredCoinsPerSeat}"),
                          color: AppColors.successGreen,
                          size: 16,
                          weight: FontWeight.w600,
                          width: 160),
                      Text(
                        translation(context).coinsRedeem,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkGreyText,
                          fontSize: 12 * f,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              HorizontalSpace(width: 12),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8 * h),
                  decoration: ShapeDecoration(
                    color: AppColors.lumiLight5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8 * r)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       CoinWithImageWidget(
                          coin: double.parse(
                              "${countPendingSeats() * bookedTripDetailsController.bookedTripDetailsData.value.requiredCoinsPerSeat}"),
                          color: AppColors.goldCoin,
                          size: 16,
                          weight: FontWeight.w600,
                          width: 160),
                      Text(
                        translation(context).coinPending,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkGreyText,
                          fontSize: 12 * f,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
