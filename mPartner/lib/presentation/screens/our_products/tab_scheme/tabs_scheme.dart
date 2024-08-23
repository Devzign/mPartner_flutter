import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../state/contoller/scheme_tab_controller.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../components/month_selector.dart';
import '../components/user_type_selector.dart';
import 'layout_card_scheme.dart';

import '../components/common_selection_buton.dart';
import '../../../../state/contoller/user_data_controller.dart';

import '../../../../../utils/displaymethods/display_methods.dart';
import 'Functions/format_functions.dart';
import 'components/Functions/constants/userType.dart';

class TabScheme extends StatefulWidget {
  TabScheme({super.key});

  @override
  State<TabScheme> createState() => _TabSchemeState();
}

class _TabSchemeState extends State<TabScheme> {
  UserDataController userDataController = Get.find();
  SchemeTabController schemeTabController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserTypeFromSharedPref();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await schemeTabController.fetchScheme();
    });
   
  }

  String? userTypeFromSharedPref;
  // LuminuousUserType userType = LuminuousUserType.ALL;
  void fetchUserTypeFromSharedPref() {
    String user = userDataController.userType;

    setState(() {
      if (user != null) {
        userTypeFromSharedPref = user;
      } else {
        userTypeFromSharedPref = "ELECTRICIAN";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Obx(() {
      return Visibility(
        replacement: SizedBox(
          height: 400.0,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        visible: !schemeTabController.isLoadingScheme.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24 * w,
              ),
              child: Row(
                children: [
                  commonSelectionButton(
                    flex: 1,
                    hide:
                        userTypeFromSharedPref == "ELECTRICIAN" ? true : false,
                    myState: formatLuminousUserTypeToString(
                        schemeTabController.userType.value),
                    icon: Icons.keyboard_arrow_down_outlined,
                    label: translation(context).userType,
                    modalBody: UserTypeSelection(
                        sharedPrefType: LuminuousUserType.values
                            .byName(userTypeFromSharedPref ?? "ELECTRICIAN"),
                        radioState: schemeTabController.userType.value),
                    // bloc: SchemeBloc),
                  ),
                  SizedBox(
                    width: userTypeFromSharedPref == "ELECTRICIAN" ? 0 : 8 * w,
                  ),
                  commonSelectionButton(
                    flex: 1,
                    myState: schemeTabController.currMonth.value != "All"
                        ? formatCurrentMonth(
                            schemeTabController.currMonth.split(' '))
                        : "All",
                    icon: Icons.keyboard_arrow_down_outlined,
                    label: translation(context).month,
                    modalBody: const monthSelectorBody(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutCardScheme(
                currMonth: schemeTabController.currMonth.value,
                catalogData: schemeTabController.fetchedSchemes.toList(),
                headingforCard: false,
              ),
            ),
          ],
        ),
      );
    });
  }
}
