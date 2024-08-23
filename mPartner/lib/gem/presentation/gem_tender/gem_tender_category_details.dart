import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../state/contoller/scheme_tab_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';


import '../../../presentation/screens/base_screen.dart';
import '../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../presentation/widgets/tab_widget.dart';
import 'component/headingGemSupportCategory.dart';
import 'tab_centralpsu/tab_centralpsu.dart';
import 'tab_state/tab_state.dart';

class GemTenderCategoryDetails extends StatefulWidget {
  final int initialIndex;

  const GemTenderCategoryDetails({
    Key? key,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<GemTenderCategoryDetails> createState() =>
      _GemTenderCategoryDetailsState();
}

class _GemTenderCategoryDetailsState extends BaseScreenState<GemTenderCategoryDetails> {
  List<TabData> tabs = [];

  @override
  void initState() {
    super.initState();
    SchemeTabController schemeTabController = Get.find();
    schemeTabController.resetState();
  }

  @override
  Widget baseBody(BuildContext context) {

    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();

    final int index = ModalRoute.of(context)!.settings.arguments as int;
    tabs = [
      TabData(translation(context).state, const TabState()),
      TabData(translation(context).centralpsu, TabCentralPSU()),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: EdgeInsets.only(
                  left: 14 * variablePixelWidth,
                  top: 10 * variablePixelHeight),
              child: HeadingGemSupportCategory(
                icon: Icon(
                  Icons.arrow_back_outlined,
                  color: AppColors.iconColor,
                  size: 24 * variablePixelMultiplier,
                ),
                heading: "${translation(context).tenders}",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            UserProfileWidget(),
            TabWidget(
              initialIndex: index, // Accessing widget.initialIndex here
              tabs: tabs,
            ),
          ],
        ),
      ),
    );
  }
}
