import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/traveller_model.dart';
import '../../../../../state/contoller/booked_trip_details_controller.dart';
import '../../../../../state/contoller/coin_to_trips_redemption_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/radio_list/common_radio_list_tile_with_custom_widget.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import 'view_details_edit_traveller.dart';

extension ListExtension<T> on List<T> {
  T? get firstOrNull {
    return isEmpty ? null : first;
  }
}

class SelectSavedTravellerTab extends StatefulWidget {
  SelectSavedTravellerTab({super.key, required this.tripID});
  CoinsToTripController c = Get.find();
  final int tripID;
  @override
  State<SelectSavedTravellerTab> createState() =>
      _SelectSavedTravellerTabState();
}

class _SelectSavedTravellerTabState extends State<SelectSavedTravellerTab> {
  CoinsToTripController c = Get.find();
  Map<Traveller, int> isEnabled = {};
  List<Traveller> filteredTravellers = [];
  List<Traveller> selectedTravellers = [];
  List<Traveller> travellers = [];
  TextEditingController searchController = TextEditingController();
  BookedTripDetailsController b = Get.find();
  bool isSearchActive = false;

  void initialization() {
    if (!isSearchActive) {
      travellers.clear();
      filteredTravellers.clear();
      travellers.addAll(c.savedTravellers);
      travellersAvailableForSelection();
      filteredTravellers.addAll(travellers);
    }
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void travellersAvailableForSelection() {
    var availableForSelectionflag = true;
    var availableForBookMoreFlag = true;
    for (Traveller i in c.savedTravellers) {
      availableForSelectionflag = true;
      availableForBookMoreFlag = true;
      if (c.indexOfCurrentTraveller(i.name, i.relation) != null) {
        availableForSelectionflag = false;
      }
      if (b.isUserAlreadyBooked(i.name, i.relation)) {
        availableForBookMoreFlag = false;
      }
      if (!availableForBookMoreFlag) {
        isEnabled[i] = 2;
      } else if (!availableForSelectionflag) {
        isEnabled[i] = 1;
      } else {
        isEnabled[i] = 0;
      }
    }
  }

  void filterTravellers(String query) {
    setState(() {
      if (query.isEmpty) {
        isSearchActive = false;
      } else {
        isSearchActive = true;
      }

      filteredTravellers = travellers
          .where((Traveller) =>
              Traveller.name.toLowerCase().contains(query.toLowerCase()) ||
              Traveller.mobileNo.contains(query))
          .toList();
    });
  }

  void clearSearch() {
    setState(() {
      filteredTravellers.clear();
      filteredTravellers.addAll(travellers);
      searchController.clear();
      if (!filteredTravellers.contains(selectedTravellers.firstOrNull)) {
        selectedTravellers.clear();
      }
      isSearchActive = false;
      initialization();
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Visibility(
      visible: travellers.isNotEmpty,
      replacement: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              translation(context).sorryWeHaveNoSavedTravellers,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: 16 * f,
                fontWeight: FontWeight.w500,
                height: 24 / 16,
                letterSpacing: 0.10 * w,
              ),
            ),
          ]),
      child: Column(
        children: [
          TextField(
            cursorColor: AppColors.lightGrey1,
            maxLength: 50,
            style: GoogleFonts.poppins(
              color: AppColors.titleColor,
              fontSize: 14 * f,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              letterSpacing: 0.50,
            ),
            controller: searchController,
            onChanged: (query) {
              filterTravellers(query);
            },
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.fromLTRB(16 * w, 12 * h, 8 * w, 12 * h),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.lightGrey1),
                borderRadius: BorderRadius.circular(12),
              ),
              counterText: "",
              hintText: translation(context).searchSavedTraveller,
              hintStyle: GoogleFonts.poppins(
                color: AppColors.hintColor,
                fontSize: 14 * f,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                letterSpacing: 0.50 * w,
              ),
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  clearSearch();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          VerticalSpace(height: 16),
          GetBuilder<CoinsToTripController>(builder: (_) {
            initialization();

            return Expanded(
              child: ListView.builder(
                itemCount: filteredTravellers.length,
                itemBuilder: (context, index) {
                  return CommonRadioListTileWithCustomWidget<String>(
                    isEnabled: isEnabled[filteredTravellers[index]]! == 0,
                    value:
                        '${filteredTravellers[index].relation}-${filteredTravellers[index].name}',
                    groupValue: travellers.isEmpty
                        ? null
                        : '${selectedTravellers.firstOrNull?.relation}-${selectedTravellers.firstOrNull?.name}',
                    onChanged: (String? value) {
                      setState(() {
                        selectedTravellers.clear();
                        if (value != null) {
                          final List<String> parts = value.split('-');
                          final String relationship = parts[0];
                          final String name = parts[1];
                          selectedTravellers.add(travellers.firstWhere((t) =>
                              t.relation == relationship &&
                              t.name == name));
                        }
                      });
                    },
                    widget: TravellerCardofRadioButton(
                      tripID: widget.tripID,
                      t: filteredTravellers[index],
                      isEnabled: isEnabled[filteredTravellers[index]] ?? 0,
                      indexOfSavedTraveller: index,
                      onViewDetails: () {
                        clearSearch();
                      },
                    ),
                  );
                },
              ),
            );
          }),
          Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  PrimaryButton(
                      buttonText: translation(context).submit,
                      buttonHeight: 48,
                      onPressed: () => {
                            c.addTraveller(selectedTravellers[0]),
                            Navigator.pop(context)
                          },
                      isEnabled: c.currNumberOfTravellers.value <
                          c.selectedNumberOfTravellers.value)
                ],
              ))
        ],
      ),
    );
  }
}

class TravellerCardofRadioButton extends StatefulWidget {
  TravellerCardofRadioButton({
    super.key,
    required this.t,
    required this.isEnabled,
    required this.indexOfSavedTraveller,
    required this.onViewDetails,
    required this.tripID,
  });
  final Traveller t;
  final int indexOfSavedTraveller;
  final int isEnabled;
  final int tripID;
  // bool showDetails = false;
  void Function() onViewDetails;
  @override
  State<TravellerCardofRadioButton> createState() =>
      _TravellerCardofRadioButtonState();
}

class _TravellerCardofRadioButtonState
    extends State<TravellerCardofRadioButton> {
  @override
  Widget build(BuildContext context) {
    CoinsToTripController coinsToTripController = Get.find();
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    final style2 = GoogleFonts.poppins(
      color: AppColors.grayText,
      fontSize: 12 * f,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
      letterSpacing: 0.50 * w,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.t.name,
              style: GoogleFonts.poppins(
                color: widget.isEnabled == 0
                    ? AppColors.darkGreyText
                    : AppColors.grayText,
                fontSize: 16 * f,
                fontWeight: FontWeight.w500,
                height: 24 / 16,
                letterSpacing: 0.50 * w,
              ),
            ),
            GestureDetector(
              onTap: () {
                widget.onViewDetails();
                coinsToTripController.indexOfEdit = -1;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => viewDetailsEditTraveller(
                            traveller: widget.t,
                            tripID: widget.tripID,
                            indexInCurrentList:
                                coinsToTripController.indexOfCurrentTraveller(
                                    widget.t.name, widget.t.relation),
                            indexInSavedList: widget.indexOfSavedTraveller,
                          )),
                );
              },
              child: Text(
                translation(context).viewDetails,
                style: GoogleFonts.poppins(
                  color: AppColors.lumiBluePrimary,
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                  height: 24 / 14,
                  letterSpacing: 0.50,
                ),
              ),
            )
          ],
        ),
        VerticalSpace(height: 4),
        Visibility(
          replacement: Text(
              widget.isEnabled == 1
                  ? translation(context).added
                  : translation(context).alreadyBooked,
              style: style2),
          visible: widget.isEnabled == 0,
          child: Text('${widget.t.relation} I ${widget.t.mobileNo}',
              style: style2),
        ),
      ],
    );
  }
}
