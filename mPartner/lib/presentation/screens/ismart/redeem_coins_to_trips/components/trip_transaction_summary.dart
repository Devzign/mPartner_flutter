import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/booking_response_model.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/coin_with_image_widget.dart';
import '../../../../widgets/dot_horizontal_divider.dart';
import '../../../../widgets/headers/header_widget_with_coins_info.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../../userprofile/user_profile_widget.dart';
import 'alert_trip_booking_bottomsheet.dart';

class TripTransactionSummary extends StatelessWidget {
  TripTransactionSummary(
      {super.key, required this.onTap, required this.bookingResponseModel});
  final Function() onTap;
  BookingResponseModel bookingResponseModel;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24 * w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidgetWithCoinInfo(
              heading: translation(context).bookingStatus, onPressed: () { Navigator.pop(context); }, icon: const Icon(
              Icons.close,
              color: AppColors.iconColor,
              size: 24,
            ),),
            UserProfileWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.lightWhite1,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: AppColors
                                .lightGrey1, // Adjust the color as needed
                            width: 1.0, // Adjust the width as needed
                          ),
                        ),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const VerticalSpace(height: 44),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20 * w),
                                child: TransactionSummaryTripInfoCard(
                                  w: w,
                                  h: h,
                                  bookingCoinsReserved: bookingResponseModel
                                      .data.totalRedeemedCoins
                                      .toString(),
                                  bookingMessage: bookingResponseModel.message,
                                  bookingDate: bookingResponseModel
                                          .data.tripData.transactionDate ??
                                      "",
                                ),
                              ),
                              const VerticalSpace(height: 46),
                              const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: DotHorizontalDivider(
                                      color: Colors.grey)),
                              const VerticalSpace(height: 36),
                              Text(
                                "Travellers Summary",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: AppColors.darkText2,
                                  fontSize: 16 * w,
                                  height: 24 / 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const VerticalSpace(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: bookingResponseModel
                                      .data.travellerData.length,
                                  itemBuilder: (context, index) {
                                    return TravellerSummaryCard(
                                      traveller: bookingResponseModel
                                          .data.travellerData[index],
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          SizedBox(
                                    height: 20 * h,
                                  ),
                                ),
                              ),
                              const VerticalSpace(height: 32),
                            ])),
                    const VerticalSpace(height: 18),
                    Visibility(
                      visible: bookingResponseModel
                          .data.tripData.downloadUrl.isNotEmpty,
                      // visible: true,
                      child: Column(
                        children: [
                          TripDownloadButton(
                              url: bookingResponseModel
                                  .data.tripData.downloadUrl),
                          const VerticalSpace(height: 22),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class TransactionSummaryTripInfoCard extends StatelessWidget {
  const TransactionSummaryTripInfoCard({
    super.key,
    required this.w,
    required this.h,
    required this.bookingMessage,
    required this.bookingDate,
    required this.bookingCoinsReserved,
  });
  final String bookingMessage, bookingDate, bookingCoinsReserved;
  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          bookingMessage,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: AppColors.darkText2,
            fontSize: 14 * w,
            height: 21 / 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.10,
          ),
        ),
        const VerticalSpace(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.goldCoinLight,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CoinWithImageWidget(
                        coin: double.tryParse(bookingCoinsReserved) ?? 0,
                        color: AppColors.pendingYellow,
                        size: 20,
                        weight: FontWeight.w500,
                        width: 280),
                  ],
                ),
                SizedBox(height: 4 * h),
                Text(
                  "Total Coins Reserved",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: AppColors.pendingYellow,
                    fontSize: 12 * w,
                    height: 18 / 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.10,
                  ),
                ),
              ],
            ),
          ),
        ),
        const VerticalSpace(height: 20),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Booking date: ',
                style: GoogleFonts.poppins(
                  color: AppColors.darkText2,
                  fontSize: 12 * w,
                  height: 20 / 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.10,
                ),
              ),
              TextSpan(
                text: bookingDate,
                style: GoogleFonts.poppins(
                  color: AppColors.darkText2,
                  fontSize: 12 * w,
                  height: 20 / 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String formattedStatusMessage(
    String message, BuildContext context, int waitlist) {
  if (message.contains("success"))
    return "Booked";
  else if (message.contains("pending")) {
    return "Waiting list #${waitlist}";
  } else
    return message;
}

Color seatStatusMessageColor(String message) {
  if (message.contains("success"))
    return AppColors.successGreen;
  else if (message.contains("pending"))
    return AppColors.goldCoin;
  else
    return AppColors.errorRed;
}

class TravellerSummaryCard extends StatelessWidget {
  const TravellerSummaryCard({
    super.key,
    required this.traveller,
  });
  final TravellerData traveller;
  @override
  Widget build(BuildContext context) {
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    return Card(
      elevation: 0,
      shadowColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: traveller.travellerName.isNotEmpty,
            child: Text(
              traveller.travellerName,
              style: GoogleFonts.poppins(
                fontSize: 14 * textMultiplier,
                height: 21 / 14,
                color: AppColors.darkGreyText,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
            ),
          ),
          Visibility(
              visible: traveller.travellerName.isNotEmpty,
              child: const VerticalSpace(height: 8)),
          Visibility(
              visible: traveller.relation.isNotEmpty,
              child:
                  RowInCard(text1: 'Relationship', text2: traveller.relation)),
          Visibility(
              visible: traveller.relation.isNotEmpty,
              child: const VerticalSpace(height: 4)),
          Visibility(
            visible: traveller.transactionId.isNotEmpty,
            child: RowInCard(
              text1: 'Transaction ID',
              text2: traveller.transactionId,
            ),
          ),
          Visibility(
              visible: traveller.transactionId.isNotEmpty,
              child: const VerticalSpace(height: 4)),
          Visibility(
            visible: traveller.seatStatus.isNotEmpty,
            child: RowInCard(
              text1: 'Booking Status',
              text2: formattedStatusMessage(traveller.seatStatus.toLowerCase(),
                  context, traveller.waitList),
              statusColor:
                  seatStatusMessageColor(traveller.seatStatus.toLowerCase()),
            ),
          ),
        ],
      ),
    );
  }
}

class RowInCard extends StatelessWidget {
  String text1, text2;
  Color? statusColor;
  RowInCard(
      {super.key, required this.text1, required this.text2, this.statusColor});
  Widget build(BuildContext context) {
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          style: GoogleFonts.poppins(
            fontSize: 12 * textMultiplier,
            height: 18 / 12,
            color: AppColors.grayText,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            text2,
            textAlign: TextAlign.end,
            style: GoogleFonts.poppins(
              fontSize: 12 * textMultiplier,
              height: 18 / 12,
              color: statusColor ?? AppColors.darkGreyText,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }
}
