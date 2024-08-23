import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/trip_model.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../widgets/CommonCoins/coin_widget.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import 'trip_card_heading.dart';
import 'trip_duration.dart';

class CardWithoutImage extends StatelessWidget {
  CardWithoutImage({
    super.key,
    required this.tripModel,
    this.totalSelectedTravellers = 1,
  });

  final TripModel tripModel;
  final int totalSelectedTravellers;
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      padding: EdgeInsets.fromLTRB(16 * w, 12 * h, 16 * w, 12 * h),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1 * w, color: AppColors.lightGrey2),
          borderRadius: BorderRadius.circular(12 * r),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: TripCardHeading(
                  text: tripModel.tripName,
                ),
              ),
              CoinWidget(
                coins: tripModel.requiredCoinsPerSeat * totalSelectedTravellers,
              )
            ],
          ),
          VerticalSpace(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TripDuration(
                duration: tripModel.duration,
isSolo: tripModel.ribbonRemarks2.split(" ")[0].toLowerCase() ==
                    "solo",
              ),
              Text(
                tripModel.durationDate,
                style: GoogleFonts.poppins(
                  color: AppColors.darkGrey,
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
