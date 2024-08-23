import 'package:flutter/material.dart';

import '../../../../../data/models/traveller_model.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/headers/back_button_header_widget.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../../userprofile/user_profile_widget.dart';
import 'add_new_traveller_tab.dart';

class viewDetailsEditTraveller extends StatelessWidget {
  const viewDetailsEditTraveller(
      {super.key,
      required this.traveller,
      required this.tripID,
      required this.indexInCurrentList,
      required this.indexInSavedList});
  final Traveller traveller;
  final int tripID;
  final int? indexInCurrentList;
  final int? indexInSavedList;
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.fromLTRB(24 * w, 24 * h, 24 * w, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidgetWithBackButton(
                  heading: translation(context).viewDetails,
                  leftPadding: 0,
                  topPadding: 0,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              VerticalSpace(height: 24),
              UserProfileWidget(
                top: 0,
                bottom: 0,
                horizontalPadding: 0,
              ),
              VerticalSpace(height: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: AddNewOrEditTravellerTab(
                    tripID: tripID,
                    indexOfCurrent: indexInCurrentList,
                    indexOfSaved: indexInSavedList,
                    traveller: traveller,
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
