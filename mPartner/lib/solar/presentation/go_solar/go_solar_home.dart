import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../presentation/screens/base_screen.dart';
import '../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../presentation/widgets/bottomNavigationBar/bottom_navigation_bar.dart';
import '../../../presentation/widgets/headers/ismart_header_widget.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../state/controller/go_solar_count_details_controller.dart';
import 'components/go_solar_home_body_widget.dart';

class GoSolarHome extends StatefulWidget {
  const GoSolarHome({super.key});

  @override
  State<GoSolarHome> createState() => _GoSolarHomeState();
}

class _GoSolarHomeState extends BaseScreenState<GoSolarHome> {
  UserDataController userController = Get.find();
  GoSolarCountDetailsController goSolarCountDetailsController = Get.find();

  @override
  void initState() {
    super.initState();
    goSolarCountDetailsController.fetchGoSolarCountDetails();
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pushNamed(context, AppRoutes.homepage);
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Obx(() {
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 24 * variablePixelWidth,
                      right: 24 * variablePixelWidth,
                      top: 24 * variablePixelHeight),
                  child:
                      ISmartHeaderWidget(title: translation(context).goSolar),
                ),
                UserProfileWidget(top: 24 * variablePixelHeight),
                goSolarCountDetailsController.isLoading.isTrue
                    ? SizedBox(
                        height: 420 * variablePixelHeight,
                        child: const Center(child: CircularProgressIndicator()))
                    : Expanded(child: GoSolarHomeBodyWidget()),
              ],
            ),
          );
        }),

        bottomNavigationBar: BottomNavigation(
          currentIndex: 2,
          onTabTapped: (value) => 2,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
