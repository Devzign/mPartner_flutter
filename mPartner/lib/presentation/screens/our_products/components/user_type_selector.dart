import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../state/contoller/scheme_tab_controller.dart';

import '../../../../utils/localdata/language_constants.dart';
import 'title_bottom_modal.dart';

import '../../../widgets/radio_list/common_radio_list.dart';
import '../../../widgets/common_button.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../tab_scheme/Functions/format_functions.dart';
import '../tab_scheme/components/Functions/constants/userType.dart';

class UserTypeSelection extends StatefulWidget {
  UserTypeSelection({
    super.key,
    required this.radioState,
    required this.sharedPrefType,
  });
  final LuminuousUserType sharedPrefType;
  LuminuousUserType radioState;
  late var len = listOfRoles[sharedPrefType];

  @override
  State<UserTypeSelection> createState() => _UserTypeSelectionState();
}

class _UserTypeSelectionState extends State<UserTypeSelection> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24 * w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          titleBottomModal(
            title: translation(context).selectUserType,
            onPressed: () => {Navigator.pop(context)},
          ),
          const VerticalSpace(height: 8),
          Flexible(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: listOfRoles[widget.sharedPrefType]!.length,
                itemBuilder: (BuildContext context, int index) {
                  return CommonRadioListTile(
                      label: formatLuminousUserTypeToString(
                          listOfRoles[widget.sharedPrefType]![index]),
                      groupValue: widget.radioState,
                      value: listOfRoles[widget.sharedPrefType]![index],
                      onChanged: (LuminuousUserType? value) {
                        setState(() {
                          widget.radioState = value ?? LuminuousUserType.ALL;
                        });
                      });
                }),
          ),
          CommonButton(
            horizontalPadding: 0,
            bottomPadding: 0,
            onPressed: () {
              SchemeTabController schemeTabController = Get.find();
              schemeTabController.changeUserType(widget.radioState);
              schemeTabController.fetchScheme();
              Navigator.pop(context);
            },
            isEnabled: true,
            buttonText: translation(context).submit,
            containerBackgroundColor: Colors.white10,
          ),
          SizedBox(
            height: 32 * h,
          )
        ],
      ),
    );
  }
}


