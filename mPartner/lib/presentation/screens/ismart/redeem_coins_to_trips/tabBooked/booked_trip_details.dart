import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../data/models/trip_model.dart';
import '../../../../../services/services_locator.dart';
import '../../../../../state/contoller/booked_trip_details_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../../../../../utils/utils.dart';
import '../../../../widgets/CommonCoins/available_coins_widget.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../../../../widgets/buttons/secondary_button.dart';
import '../../../../widgets/headers/back_button_header_widget.dart';
import '../../../../widgets/headers/header_widget_with_coins_info.dart';
import '../../../../widgets/something_went_wrong_screen.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../../cashredemption/widgets/verification_failed_alert.dart';
import '../../../userprofile/user_profile_widget.dart';
import '../components/alert_body_bottomsheet.dart';
import '../components/card_without_image.dart';
import '../components/delete_options/travellar_delete_sheet.dart';
import '../redeem_coins_to_trips.dart';
import '../select_travellers.dart';
import 'booked_coins_summary.dart';
import 'booked_traveller_details.dart';

class BookedTripDetails extends StatefulWidget {
  BookedTripDetails(
      {super.key,
        required this.tripID,
        this.showProceedButton = true,
        this.isNavigatingFromSystemTray = false});

  int tripID;
  bool showDetails = false;
  bool showWhatToExplore = false;
  bool showCoinSummary = true;
  bool showTravellerDetails = true;
  bool showTnC = false;
  bool showProceedButton;
  bool isSolo = false;
  bool isLoading = false;
  bool isNavigatingFromSystemTray;
  late TripModel tripModel;
  late bool bookMore;

  @override
  State<BookedTripDetails> createState() => _BookedTripDetailsState();
}

class _BookedTripDetailsState extends State<BookedTripDetails> {
  BookedTripDetailsController bookedTripDetailsController = Get.find();
  ScrollController scrollController = ScrollController();

  void initialize() {
    widget.tripModel = bookedTripDetailsController.tripModel.value;
    widget.isSolo =
        widget.tripModel.ribbonRemarks2.toLowerCase().contains("solo");
    widget.bookMore = checkBookMore();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bookedTripDetailsController
          .fetchBookedTripDetails(widget.tripID.toString());
    });
  }

  bool checkBookMore() {
    if (widget.isSolo ||
        !bookedTripDetailsController
            .bookedTripDetailsData.value.bookEligibility) {
      return false;
    } else if (widget.tripModel.maxSeatLimit > 0) {
      return true;
    } else {
      return false;
    }
  }

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
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
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
    return WillPopScope(
      onWillPop: () async {
        if (widget.isNavigatingFromSystemTray) {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.ismartHomepage,
                  (Route<dynamic> route) => false);
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     HeaderWidgetWithBackButton(
              //       heading: translation(context).trips,
              //       onPressed: () => {
              //         if (widget.isNavigatingFromSystemTray)
              //           {
              //             Navigator.pushNamedAndRemoveUntil(
              //                 context,
              //                 AppRoutes.ismartHomepage,
              //                     (Route<dynamic> route) => false),
              //           }
              //         else
              //           {
              //             Navigator.pop(context),
              //           }
              //       },
              //       leftPadding: 0,
              //       topPadding: 0,
              //     ),
              //     const AvailableCoinsWidget(
              //       fontSize: 12,
              //       fontColor: AppColors.goldCoin,
              //     ),
              //   ],
              // ),
              HeaderWidgetWithCoinInfo(heading: translation(context).trips,
               onPressed: (){
                if (widget.isNavigatingFromSystemTray)
                        {
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.ismartHomepage,
                                  (Route<dynamic> route) => false);
                        }
                      else
                        {
                          Navigator.pop(context);
                        }
              }, icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: AppColors.iconColor,
                  size: 24,
                ),),
              UserProfileWidget(),
              const VerticalSpace(height: 24),
              Obx(() {
                if (bookedTripDetailsController.isLoading.value) {
                  return const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    ),
                  );
                } else {
                  if (bookedTripDetailsController.error.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SomethingWentWrongScreen(
                              onPressed: () {
                                Navigator.popAndPushNamed(
                                    context, AppRoutes.ismartHomepage);
                              },
                            )));
                    return Container();
                  } else {
                    initialize();
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24 * w),
                        child: ListView(
                          controller: scrollController,
                          shrinkWrap: true,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12 * r),
                              child: Container(
                                height: 216 * h,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12 * r),
                                  ),
                                ),
                                child: Image.network(
                                  widget.tripModel.tripUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                            .expectedTotalBytes !=
                                            null
                                            ? loadingProgress
                                            .cumulativeBytesLoaded /
                                            loadingProgress
                                                .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder:
                                      (context, exception, stackTrace) {
                                    return Image.asset(
                                      'assets/mpartner/ic_trips_small.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const VerticalSpace(height: 20),
                            CardWithoutImage(
                              tripModel: widget.tripModel,
                            ),
                            const VerticalSpace(height: 24),
                            Visibility(
                              visible: bookedTripDetailsController
                                  .bookedTravellers.isNotEmpty,
                              child: Column(
                                children: [
                                  InkWell(
                                      onTap: () => {
                                        setState(() {
                                          widget.showCoinSummary =
                                          !widget.showCoinSummary;
                                        }),
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            translation(context).coinsSummary,
                                            style: GoogleFonts.poppins(
                                              color: AppColors.blackText,
                                              fontSize: 16 * f,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.10,
                                            ),
                                          ),
                                          widget.showCoinSummary
                                              ? const Icon(
                                              Icons.keyboard_arrow_up)
                                              : const Icon(
                                              Icons.keyboard_arrow_down),
                                        ],
                                      )),
                                  Visibility(
                                      visible: widget.showCoinSummary,
                                      child: Column(
                                        children: [
                                          const BookedCoinsSummary(),
                                          Visibility(
                                              visible:
                                              bookedTripDetailsController
                                                  .bookedTripDetailsData
                                                  .value
                                                  .earnMoreCoinsToConfirm
                                                  .isNotEmpty,
                                              child: const VerticalSpace(
                                                  height: 12)),
                                          Visibility(
                                            visible: bookedTripDetailsController
                                                .bookedTripDetailsData
                                                .value
                                                .earnMoreCoinsToConfirm
                                                .isNotEmpty,
                                            child: Text(
                                              bookedTripDetailsController
                                                  .bookedTripDetailsData
                                                  .value
                                                  .earnMoreCoinsToConfirm,
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.poppins(
                                                color: AppColors.grayText,
                                                fontSize: 14 * f,
                                                fontWeight: FontWeight.w500,
                                                height: 21 / 14,
                                                letterSpacing: 0.50,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: 20 * h),
                            Visibility(
                              visible: bookedTripDetailsController
                                  .bookedTravellers.isNotEmpty,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        widget.showTravellerDetails =
                                        !widget.showTravellerDetails;
                                        scrollToPosition();
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          translation(context)
                                              .travellersSummary,
                                          style: GoogleFonts.poppins(
                                            color: AppColors.darkGrey,
                                            fontSize: 16 * f,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        widget.showTravellerDetails
                                            ? const Icon(
                                            Icons.keyboard_arrow_up)
                                            : const Icon(
                                            Icons.keyboard_arrow_down),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                      visible: widget.showTravellerDetails,
                                      child: const VerticalSpace(height: 16)),
                                  Visibility(
                                      visible: widget.showTravellerDetails &&
                                          bookedTripDetailsController
                                              .bookedTravellers.value !=
                                              null &&
                                          bookedTripDetailsController
                                              .bookedTravellers
                                              .where((model) =>
                                          model.isDelete_Show == "1")
                                              .toList()
                                              .isNotEmpty,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            child: const Icon(
                                              Icons.delete,
                                              color: AppColors.red,
                                            ),
                                            onTap: () async {
                                              await TravellarDeleteSheet
                                                  .ShowTravellerDelete(
                                                  context,
                                                  bookedTripDetailsController
                                                      .bookedTravellers,
                                                  widget.tripID)
                                                  .then((message) {
                                                if (bookedTripDetailsController
                                                    .DeleteSuccess.value ==
                                                    true) {
                                                  navigateToCoinsToTrips(
                                                      context, 1);
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      )),
                                  Visibility(
                                      visible: widget.showTravellerDetails,
                                      child: const bookedTravellersDetails()),
                                  if (widget.showTravellerDetails)
                                    Visibility(
                                      visible: widget
                                          .tripModel.downloadUrl.isNotEmpty,
                                      child: Column(
                                        children: [
                                          const VerticalSpace(height: 16),
                                          Row(
                                            children: [
                                              SecondaryButton(
                                                  buttonText:
                                                  translation(context)
                                                      .downloadTripDetails,
                                                  buttonHeight: 48,
                                                  onPressed: () async {
                                                    if (await canLaunchUrlString(
                                                        widget.tripModel
                                                            .downloadUrl)) {
                                                      await launchUrlString(
                                                          widget.tripModel
                                                              .downloadUrl);
                                                    } else {
                                                      Utils().showToast(
                                                          translation(context)
                                                              .noDataFound,
                                                          context);
                                                    }
                                                  },
                                                  isEnabled: true)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const VerticalSpace(height: 20),
                            InkWell(
                                onTap: () => {
                                  setState(() {
                                    widget.showDetails =
                                    !widget.showDetails;
                                    scrollToPosition();
                                  }),
                                },
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
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
                                  color: AppColors.black,
                                  fontSize: 12 * f,
                                  fontWeight: FontWeight.w400,
                                  height: 20 / 12,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ),
                            const VerticalSpace(height: 20),
                            InkWell(
                                onTap: () => {
                                  setState(() {
                                    widget.showTnC = !widget.showTnC;
                                    scrollToPosition();
                                  }),
                                },
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
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
                                    widget.showTnC
                                        ? const Icon(Icons.keyboard_arrow_up)
                                        : const Icon(Icons.keyboard_arrow_down),
                                  ],
                                )),
                            Visibility(
                              visible: widget.showTnC,
                              child: HtmlWidget(
                                bookedTripDetailsController
                                    .bookedTripDetailsData
                                    .value
                                    .termAndConditions,
                                renderMode: RenderMode.column,
                                textStyle: GoogleFonts.poppins(
                                  color: AppColors.black,
                                  fontSize: 12 * f,
                                  fontWeight: FontWeight.w400,
                                  height: 20 / 12,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ),
                            const VerticalSpace(height: 16),
                          ],
                        ),
                      ),
                    );
                  }
                }
              }),
              Obx(() {
                if (bookedTripDetailsController.isLoading.value) {
                  return Container();
                } else if (bookedTripDetailsController.error.isNotEmpty) {
                  return Center(child: Container());
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24 * w),
                    child: Column(
                      children: [
                        Visibility(
                            visible: widget.bookMore,
                            replacement: const VerticalSpace(height: 16),
                            child: const VerticalSpace(height: 22)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Visibility(
                              visible: widget.bookMore,
                              replacement: Text(
                                translation(context).noMoreBookingMessage,
                                style: GoogleFonts.poppins(
                                  color: AppColors.grayText,
                                  fontSize: 12 * f,
                                  fontWeight: FontWeight.w500,
                                  height: 18 / 12,
                                  letterSpacing: 0.50,
                                ),
                              ),
                              child: PrimaryButton(
                                  isLoading: widget.isLoading,
                                  buttonText: translation(context).bookMore,
                                  buttonHeight: 48,
                                  onPressed: () async {
                                    try {
                                      setState(() {
                                        widget.isLoading = true;
                                      });
                                      BaseMPartnerRemoteDataSource
                                      baseMPartnerRemoteDataSource =
                                      sl<BaseMPartnerRemoteDataSource>();
                                      final result =
                                      await baseMPartnerRemoteDataSource
                                          .coinRedemptionCheck();
                                      result.fold((l) {
                                        showAlert(
                                          translation(context).noDataFound,
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
                            ),
                          ],
                        ),
                        const VerticalSpace(height: 16),
                      ],
                    ),
                  );
                }
              }),
            ],
          ),
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
                message: widget.tripModel.minimumCoinRequiredMsg);
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
              addDefaultTraveller: false,
            )),
      );
    }
  }

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
}
