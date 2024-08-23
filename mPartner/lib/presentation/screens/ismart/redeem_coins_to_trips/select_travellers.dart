import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/models/traveller_model.dart';
import '../../../../data/models/trip_model.dart';
import '../../../../state/contoller/booked_trip_details_controller.dart';
import '../../../../state/contoller/coin_to_trips_redemption_controller.dart';
import '../../../../state/contoller/coins_summary_controller.dart';
import '../../../../state/contoller/relationship_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/common_selection_button_widget.dart';
import '../../../widgets/headers/back_button_header_widget.dart';
import '../../../widgets/headers/header_widget_with_coins_info.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../userprofile/user_profile_widget.dart';
import 'components/add_traveller_card.dart';
import 'components/bottom_bar_coins_to_trip.dart';
import 'components/card_without_image.dart';
import 'components/select_number_of_travellers_body.dart';
import 'components/select_saved_add_new_traveller_body_bottomsheet.dart';
import 'components/traveller_info_card.dart';
import 'components/view_details_edit_traveller.dart';
import 'traveller_details_post_selection.dart';

class SelectTraveller extends StatefulWidget {
  SelectTraveller(
      {super.key,
      required this.tripModel,
      required this.isSolo,
      this.isBooked = false,
      this.addDefaultTraveller = true});
  final TripModel tripModel;
  final bool isSolo;
  final bool isBooked;
  bool showDefaultMessage = true;
  final bool addDefaultTraveller;
  @override
  State<SelectTraveller> createState() => _SelectTravellerState();
}

class _SelectTravellerState extends State<SelectTraveller> {
  CoinsToTripController c = Get.find();
  CoinsSummaryController coinsSummaryController = Get.find();
  RelationshipContoller relationshipContoller = Get.find();
  BookedTripDetailsController bookedTripDetailsController = Get.find();
  int maxNumberOfTravellers = 0;
  @override
  void initState() {
    c.getSavedTravellers(widget.tripModel.tripID);
    c.cleanSlateForSelectTravelllers(widget.addDefaultTraveller);
    relationshipContoller
        .fetchRelationships(widget.tripModel.tripID.toString());
    maxNumberOfTravellers = widget.tripModel.maxSeatLimit;
    if (widget.tripModel.tripFlag != 'BOOKED') {
      bookedTripDetailsController.clearBookedTripDetails();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  HeaderWidgetWithCoinInfo(heading: translation(context).selectTraveller, onPressed: (){Navigator.pop(context);}, icon: const Icon(
                    Icons.arrow_back_outlined,
                    color: AppColors.iconColor,
                    size: 24,
                  ),),
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
                      ),
                      Visibility(
                        visible: !widget.isSolo,
                        child: SelectNumberOfTravellersTextAndButton(
                            r: r,
                            maxNumberOfTravellers: maxNumberOfTravellers,
                            c: c,
                            f: f,
                            w: w),
                      ),
                      Visibility(
                          visible: !widget.isSolo,
                          child:
                              AddTravellerInfoTextAndPresentNumberOfTravellers(
                                  w: w, f: f, c: c)),
                      const VerticalSpace(height: 24),
                      ListOfTravellers(
                        tripID: widget.tripModel.tripID,
                      ),
                      const VerticalSpace(height: 16),
                    ],
                  ),
                ),
              ),
              Obx(
                () => BottomBarCoinsToTrip(
                    coinCostPerPerson: widget.tripModel.requiredCoinsPerSeat,
                    numberOfTravellers: c.selectedNumberOfTravellers.value,
                    isButtonEnabled: c.selectedNumberOfTravellers ==
                        c.currNumberOfTravellers,
                    onButtonPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TravellerDetailsPostSelection(
                                        tripModel: widget.tripModel,
                                        totalSelectedTravellers:
                                            c.selectedNumberOfTravellers.value,
                                      ))),
                        },
                    buttonText: translation(context).continueButtonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddTravellerInfoTextAndPresentNumberOfTravellers extends StatelessWidget {
  const AddTravellerInfoTextAndPresentNumberOfTravellers({
    super.key,
    required this.w,
    required this.f,
    required this.c,
  });

  final double w;
  final double f;
  final CoinsToTripController c;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const VerticalSpace(height: 24),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                translation(context).travellerInfo,
                style: GoogleFonts.poppins(
                  color: AppColors.darkGrey,
                  fontSize: 16 * f,
                  fontWeight: FontWeight.w600,
                  height: 24 / 16,
                ),
              ),
              Obx(() => Text(
                    '${c.currNumberOfTravellers}/${c.selectedNumberOfTravellers} ${translation(context).added}',
                    style: GoogleFonts.poppins(
                      color: c.currNumberOfTravellers ==
                              c.selectedNumberOfTravellers
                          ? AppColors.successGreen
                          : AppColors.hintColor,
                      fontSize: 12 * f,
                      fontWeight: FontWeight.w500,
                      height: 16 / 12,
                      letterSpacing: 0.50 * w,
                    ),
                  )),
            ]),
      ],
    );
  }
}

class SelectNumberOfTravellersTextAndButton extends StatelessWidget {
  const SelectNumberOfTravellersTextAndButton({
    super.key,
    required this.r,
    required this.maxNumberOfTravellers,
    required this.c,
    required this.f,
    required this.w,
  });

  final double r;
  final int maxNumberOfTravellers;
  final CoinsToTripController c;
  final double f;
  final double w;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VerticalSpace(height: 24),
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
                  return SelectNumberOfTravellers(
                    size: maxNumberOfTravellers,
                    curr: c.selectedNumberOfTravellers.value,
                  );
                }),
          },
          child: Obx(
            () => DropDownSelectionButtonWidget(
                flex: 1,
                myState: "${c.selectedNumberOfTravellers}",
                icon: Icons.keyboard_arrow_down,
                label: translation(context).selectNumberofTravellers,
                heightOfContainer: 56),
          ),
        ),
        VerticalSpace(height: 8),
        Text(
          '${translation(context).youCanSelectMaximum} ${maxNumberOfTravellers}  ${translation(context).travellers}',
          style: GoogleFonts.poppins(
            color: AppColors.errorRed,
            fontSize: 12 * f,
            fontWeight: FontWeight.w400,
            height: 16 / 12,
            letterSpacing: 0.40 * w,
          ),
        ),
      ],
    );
  }
}

class ListOfTravellers extends StatefulWidget {
  ListOfTravellers({
    super.key,
    required this.tripID,
  });
  bool showDefaultMessage = false;
  final int tripID;
  @override
  State<ListOfTravellers> createState() => _ListOfTravellersState();
}

class _ListOfTravellersState extends State<ListOfTravellers> {
  @override
  void initState() {
    widget.showDefaultMessage = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CoinsToTripController c = Get.find();
    return GetBuilder<CoinsToTripController>(
      builder: (_) => ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            double r = DisplayMethods(context: context).getPixelMultiplier();
            double h =
                DisplayMethods(context: context).getVariablePixelHeight();
            double w = DisplayMethods(context: context).getVariablePixelWidth();
            double f = DisplayMethods(context: context).getTextFontMultiplier();

            if (index >= c.travellers.length) {
              return GestureDetector(
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
                            builder: (BuildContext context) {
                              double h = DisplayMethods(context: context)
                                  .getVariablePixelHeight();

                              // c.indexOfEdit = -1;

                              return GestureDetector(
                                onTap: () => FocusManager.instance.primaryFocus
                                    ?.unfocus(),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child:
                                      SelectSavedTravellerOrAddNewTravellerBody(
                                    tripID: widget.tripID,
                                    travelerNo: index + 1,
                                    traveller: Traveller(
                                        name: "",
                                        mobileNo: "",
                                        relation: "",
                                        passport: "",
                                        email: ""),
                                  ),
                                ),
                              );
                            }),
                      },
                  child: AddTravellerCard(number: index + 1));
            } else {
              return TravellerInfoCard(
                onPressedDelete: () => {
                  c.removeTraveller(c.travellers[index]),
                  setState(() {
                    widget.showDefaultMessage = false;
                  }),
                },
                onPressedEdit: () => {
                  c.indexOfEdit = index,
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => viewDetailsEditTraveller(
                        traveller: c.travellers[index],
                        tripID: widget.tripID,
                        indexInCurrentList: index,
                        indexInSavedList: c.indexOfSavedTraveller(
                            c.travellers[index].name,
                            c.travellers[index].relation),
                      ),
                    ),
                  ),
                },
                showDetails: index == c.travellers.length - 1,
                name: c.travellers[index].name,
                emailId: c.travellers[index].email,
                passport: c.travellers[index].passport,
                phoneNumber: c.travellers[index].mobileNo,
                number: index + 1,
                relationship: c.travellers[index].relation,
                showDefaultMessage: widget.showDefaultMessage,
              );
            }
          },
          separatorBuilder: (BuildContext context, int index) =>
              const VerticalSpace(height: 16),
          itemCount: c.selectedNumberOfTravellers.value),
    );
  }
}
