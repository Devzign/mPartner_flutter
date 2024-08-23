import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../data/models/trip_model.dart';
import '../../../../services/services_locator.dart';
import '../../../../state/contoller/coin_to_trips_redemption_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/CommonCoins/available_coins_widget.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/headers/back_button_header_widget.dart';
import '../../../widgets/headers/header_widget_with_coins_info.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../cashredemption/widgets/verification_failed_alert.dart';
import '../../userprofile/user_profile_widget.dart';
import 'components/alert_body_bottomsheet.dart';
import 'select_travellers.dart';
import 'tabBooked/card_trip.dart';

class TripDetails extends StatefulWidget {
  TripDetails(
      {super.key,
      required this.heading,
      required this.tripModel,
      this.showProceedButton = true,
      required this.tripStatus});

  final String heading;
  bool showDetails = true;
  bool showTermsConditions = false;
  final TripModel tripModel;
  bool showProceedButton;
  String tripStatus;
  bool isLoading = false;

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  void scrollToPosition() {
    double pos = 0;
    if (scrollController.position.pixels >
        scrollController.position.maxScrollExtent - 50) {
      pos = scrollController.position.pixels + 200;
    } else {
      pos = scrollController.position.pixels;
    }
    scrollController.animateTo(
      pos,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    CoinsToTripController c = Get.find();
    toShowProceedButton();
    c.getSavedTravellers(widget.tripModel.tripID);
  }

  void toShowProceedButton() {
    widget.showProceedButton = widget.showProceedButton &&
        widget.tripModel.bookEligibility &&
        (widget.tripModel.maxSeatLimit > 0);

    
  }

  void showAlert(String message, {Function()? onTap}) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultipler =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    showVerificationFailedAlert(message, context, variablePixelHeight,
        variablePixelWidth, textMultiplier, pixelMultipler,
        onTap: onTap);
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
          children: [
            HeaderWidgetWithCoinInfo(heading: translation(context).trips, onPressed: (){Navigator.pop(context);}, icon: const Icon(
              Icons.arrow_back_outlined,
              color: AppColors.iconColor,
              size: 24,
            ),),
            UserProfileWidget(),
            const VerticalSpace(height: 24),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24 * w),
                child: ListView(
                  controller: scrollController,
                  shrinkWrap: true,
                  children: [
                    CardTrip(
                      status: widget.tripStatus,
                      tripModel: widget.tripModel,
                    ),
                    SizedBox(
                      height: 20 * h,
                    ),
                    const Divider(),
                    SizedBox(
                      height: 20 * h,
                    ),
                    InkWell(
                        onTap: () => {
                              setState(() {
                                widget.showDetails = !widget.showDetails;
                              }),
                            },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              translation(context).tripDetails,
                              style: GoogleFonts.poppins(
                                color: AppColors.blackText,
                                fontSize: 16 * f,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.10,
                              ),
                            ),
                            widget.showDetails
                                ? const Icon(Icons.keyboard_arrow_up)
                                : const Icon(Icons.keyboard_arrow_down),
                          ],
                        )),
                    Visibility(
                      visible: widget.showDetails,
                      child: HtmlWidget(
                        widget.tripModel.tripDetail,
                        renderMode: RenderMode.column,
                        textStyle: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 12 * f,
                          fontWeight: FontWeight.w400,
                          height: 20 / 12,
                          letterSpacing: 0.10,
                        ),
                      ),
                    ),
                    VerticalSpace(height: 16),
                    InkWell(
                        onTap: () => {
                              setState(() {
                                widget.showTermsConditions =
                                    !widget.showTermsConditions;
                        
                                scrollToPosition();
                              }),
                            },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              translation(context).termsAndConditions,
                              style: GoogleFonts.poppins(
                                color: AppColors.blackText,
                                fontSize: 16 * f,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.10,
                              ),
                            ),
                            widget.showTermsConditions
                                ? const Icon(Icons.keyboard_arrow_up)
                                : const Icon(Icons.keyboard_arrow_down),
                          ],
                        )),
                    Visibility(
                      visible: widget.showTermsConditions,
                      child: HtmlWidget(
                        widget.tripModel.termAndConditions,
                        renderMode: RenderMode.column,
                        textStyle: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 12 * f,
                          fontWeight: FontWeight.w400,
                          height: 20 / 12,
                          letterSpacing: 0.10,
                        ),
                      ),
                    ),
                    VerticalSpace(height: 16),
                  ],
                ),
              ),
            ),
            if (widget.showProceedButton) const VerticalSpace(height: 22),
            if (widget.showProceedButton)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24 * w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PrimaryButton(
                        buttonText: translation(context).proceed,
                        buttonHeight: 48,
                        isLoading: widget.isLoading,
                        onPressed: () async {
                          try {
                            setState(() {
                              widget.isLoading = true;
                            });
                            BaseMPartnerRemoteDataSource
                                baseMPartnerRemoteDataSource =
                                sl<BaseMPartnerRemoteDataSource>();
                            final result = await baseMPartnerRemoteDataSource
                                .coinRedemptionCheck();
                            result.fold((l) {
                              showAlert(
                                translation(context).error,
                                onTap: () => {
                                  Navigator.pop(context),
                                },
                              );
                            }, (result) {
                              if (result.status != "200") {
                                showAlert(
                                  result.message,
                                  onTap: () => {
                                    Navigator.pop(context),
                                  },
                                );
                              } else {
                                navigationAndCoinsCheck(r, context);
                              }
                            });
                          } finally {
                            setState(() {
                              widget.isLoading = false;
                            });
                          }
                        },
                        isEnabled: true),
                  ],
                ),
              ),
            if (widget.showProceedButton) const VerticalSpace(height: 32),
          ],
        ),
      ),
    );
  }

  void navigationAndCoinsCheck(double r, BuildContext context) {
    if (widget.tripModel.availableCoins <
        widget.tripModel.minimumCoinRequired) {
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
          builder: (BuildContext context) {
            return AlertBodyBottomsheet(
              message: widget.tripModel.minimumCoinRequiredMsg,
            );
          });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectTraveller(
                  tripModel: widget.tripModel,
                  isSolo: widget.tripModel.ribbonRemarks2
                      .toLowerCase()
                      .contains("solo"),
                )),
      );
    }
  }
}

class Divider extends StatelessWidget {
  const Divider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: AppColors.lightGrey2,
          ),
        ),
      ),
    );
  }
}
