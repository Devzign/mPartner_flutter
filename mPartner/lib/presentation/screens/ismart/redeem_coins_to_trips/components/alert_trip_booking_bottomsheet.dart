import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../state/contoller/coin_redemption_options_controller.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../data/models/booking_response_model.dart';
import '../../../../../data/models/trip_model.dart';
import '../../../../../state/contoller/coin_to_trips_redemption_controller.dart';
import '../../../../../state/contoller/coins_summary_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../../../../../utils/utils.dart';
import '../../../../widgets/RedeemDetailedHistory/redeem_detailed_history.dart';
import '../../../../widgets/something_went_wrong_screen.dart';
import '../../../our_products/components/title_bottom_modal.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../../../../widgets/buttons/secondary_button.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../redeem_coins_to_trips.dart';
import 'trip_transaction_summary.dart';

void navigateToCoinsToTrips(context, initalIndex) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute<void>(
        builder: (BuildContext context) => RedeemCoinsToTrip(
              initialIndex: initalIndex,
            )),
    ModalRoute.withName(AppRoutes.redeemCoins),
  );
}

class AlertTripBookingBottomsheet extends StatefulWidget {
  AlertTripBookingBottomsheet({
    super.key,
    required this.tripModel,
  });
  bool isLoading = false;
  TripModel tripModel;

  @override
  State<AlertTripBookingBottomsheet> createState() =>
      _AlertTripBookingBottomsheetState();
}

class _AlertTripBookingBottomsheetState
    extends State<AlertTripBookingBottomsheet> {
  int retryCounter = 0;

  @override
  Widget build(BuildContext context) {
    String errorResponse = "";
    bool checkBookingResponse(BookingResponseModel c) {
      for (TravellerData t in c.data.travellerData) {
        if (t.coinRedeem == 0) {
          errorResponse = t.seatStatus;
          return false;
        }
      }
      return true;
    }

    CoinsToTripController c = Get.find();
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Padding(
      padding: EdgeInsets.fromLTRB(24 * w, 0, 24 * w, 32 * h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          titleBottomModal(
            onPressed: () => {Navigator.pop(context)},
            title: translation(context).alert,
          ),
          const VerticalSpace(height: 24),
          Text(
            translation(context).bookingOnceDoneCannotBeCancelled,
            style: GoogleFonts.poppins(
              color: AppColors.darkGreyText,
              fontSize: 14 * f,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              letterSpacing: 0.10,
            ),
          ),
          const VerticalSpace(height: 8),
          Text(
            translation(context).sureToContinue,
            style: GoogleFonts.poppins(
              color: AppColors.darkGreyText,
              fontSize: 16 * f,
              fontWeight: FontWeight.w500,
              height: 20 / 16,
              letterSpacing: 0.10,
            ),
          ),
          const VerticalSpace(height: 24),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SecondaryButton(
                buttonText: translation(context).no,
                onPressed: () => {
                  Navigator.pop(context),
                },
                buttonHeight: 48,
                isEnabled: true,
              ),
              const HorizontalSpace(width: 16),
              PrimaryButton(
                isLoading: widget.isLoading,
                buttonText: translation(context).yes,
                onPressed: () async {
                  setState(() {
                    widget.isLoading = true;
                  });
                  MPartnerRemoteDataSource mPartnerRemoteDataSource =
                      MPartnerRemoteDataSource();
                  final result = await mPartnerRemoteDataSource.postBookTrip(
                      c.travellers, widget.tripModel);

                  result.fold((failure) {
                    if (retryCounter < 3) {
                      Utils().showToast(
                          translation(context).somethingWentWrongPleaseRetry,
                          context);
                      ++retryCounter;
                      setState(() {
                        widget.isLoading = false;
                      });
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PopScope(
                            canPop: false,
                            onPopInvoked: (didPop) {
                              navigateToCoinsToTrips(context, 0);
                            },
                              child: SomethingWentWrongScreen(
                                  onPressed: () => {
                                        navigateToCoinsToTrips(context, 0),
                                      })
                          ),
                        ),
                      );
                    }
                  }, (response) {
                    CoinsSummaryController coinsSummaryController =
                          Get.find();
                    CoinRedemptionOptionsController
                        coinRedemptionOptionsController = Get.find();
                    coinsSummaryController.fetchCoinsSummary();
                    coinRedemptionOptionsController
                        .fetchCoinRedemptionOptions();
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PopScope(
                                canPop: false,
                                onPopInvoked: (didPop) {
                                  navigateToCoinsToTrips(context, 1);
                                },
                                child: TripTransactionSummary(
                                    onTap: () => {
                                          navigateToCoinsToTrips(context, 1),
                                        },
                                    bookingResponseModel: response),
                              )),
                    );
                    c.cleanSelection();
                    setState(() {
                      widget.isLoading = false;
                    });
                  });
                },
                buttonHeight: 48,
                isEnabled: !widget.isLoading,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TripDownloadButton extends StatelessWidget {
  const TripDownloadButton({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return GestureDetector(
      onTap: () async {
        if (url != "") {
          if (await canLaunchUrlString(url)) {
            var response = await launchUrlString(url);
            if (response) {
              navigateToCoinsToTrips(context, 1);
            }
          } else {
            Utils().showToast(translation(context).noDataFound, context);
          }
        } else {
          null;
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16 * w, 10 * h, 12 * h, 10 * h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/mpartner/download.svg',
                colorFilter: ColorFilter.mode(
                    url != "" ? AppColors.lumiBluePrimary : AppColors.grayText,
                    BlendMode.srcIn),
                width: 18 * r,
                height: 18 * r),
            HorizontalSpace(width: 8),
            Text(
              translation(context).downloadTripDetails,
              style: GoogleFonts.poppins(
                color:
                    url != "" ? AppColors.lumiBluePrimary : AppColors.grayText,
                fontSize: 14 * f,
                fontWeight: FontWeight.w500,
                height: 20 / 14,
                letterSpacing: 0.10,
              ),
            )
          ],
        ),
      ),
    );
  }
}
