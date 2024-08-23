import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/trip_model.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/CommonCoins/coin_widget.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import 'trip_card_heading.dart';
import 'trip_duration.dart';

class CardWithCoinsAvailed extends StatelessWidget {
  CardWithCoinsAvailed({
    super.key,
    required this.tripModel,
    required this.Coins,
  });

  final TripModel tripModel;
  int Coins;
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      // padding: EdgeInsets.fromLTRB(0, 12 * h, 0, 12 * h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TripCardHeading(
                text: tripModel.tripName,
                fontSize: 20,
              ),
              CoinWidget(
                coins: Coins,
                postString: translation(context).coinsAvailed,
              )
            ],
          ),
          VerticalSpace(height: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TripDuration(
                duration:
                    "${translation(context).duration} : ${tripModel.duration}",
isSolo: tripModel.ribbonRemarks2.split(" ")[0].toLowerCase() ==
                    "solo",
              ),
              VerticalSpace(height: 4),
              Text(
                '${translation(context).date} : ${tripModel.durationDate}',
                style: GoogleFonts.poppins(
                  color: AppColors.darkGrey,
                  fontSize: 14 * f,
                  height: 20 / 14,
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
