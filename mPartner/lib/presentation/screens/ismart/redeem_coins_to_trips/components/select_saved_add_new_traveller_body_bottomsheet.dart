import 'package:flutter/material.dart';

import '../../../../../data/models/traveller_model.dart';
import '../../../../../utils/app_string.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/tab_widget.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../../our_products/components/title_bottom_modal.dart';
import 'add_new_traveller_tab.dart';
import 'select_saved_traveller_tab.dart';

class SelectSavedTravellerOrAddNewTravellerBody extends StatelessWidget {
  SelectSavedTravellerOrAddNewTravellerBody({
    super.key,
    required this.tripID,
    required this.travelerNo,
    this.initialIndex = 0,
    required this.traveller,
  });
  final int tripID;
  final int travelerNo;
  final int initialIndex;
  final Traveller traveller;

  @override
  Widget build(BuildContext context) {
    List<TabData> tabs = [
      TabData(
          AppStringCoinsToTrip.tabString0,
          SelectSavedTravellerTab(
            tripID: tripID,
          )),
      TabData(
          AppStringCoinsToTrip.tabString1,
          AddNewOrEditTravellerTab(
            tripID: tripID,
            indexOfCurrent: null,
            indexOfSaved: null,
            traveller: traveller,
          )),
    ];
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        height: 640 * h,
        padding: EdgeInsets.fromLTRB(24 * w, 4 * h, 24 * w, 32 * w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            titleBottomModal(
                title: "${translation(context).traveller} $travelerNo",
                onPressed: () => {
                      Navigator.pop(context),
                    }),
            VerticalSpace(height: 16),
            TabWidget(
              tabs: tabs,
              initialIndex: initialIndex,
            ),
          ],
        ),
      ),
    );
  }
}
