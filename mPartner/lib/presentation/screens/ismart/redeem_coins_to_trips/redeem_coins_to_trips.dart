import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../state/contoller/coin_to_trips_redemption_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/CommonCoins/available_coins_widget.dart';
import '../../../widgets/headers/back_button_header_widget.dart';
import '../../../widgets/headers/header_widget_with_coins_info.dart';
import '../../../widgets/tab_widget.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../base_screen.dart';
import '../../cashredemption/widgets/verification_failed_alert.dart';
import '../../userprofile/user_profile_widget.dart';
import 'no_trips_available.dart';
import 'tabBooked/tab_booked.dart';
import 'tabUpcoming/tab_upcoming.dart';
import 'tab_all/tab_all.dart';

class RedeemCoinsToTrip extends StatefulWidget {
  final int initialIndex;
  const RedeemCoinsToTrip({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<RedeemCoinsToTrip> createState() => _RedeemCoinsToTripState();
}

class _RedeemCoinsToTripState extends BaseScreenState<RedeemCoinsToTrip> {
  CoinsToTripController coinController = Get.find();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      coinController.fetchTrips("ALL");
    });
  }

  void showAlert(String message) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultipler =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    showVerificationFailedAlert(message, context, variablePixelHeight,
        variablePixelWidth, textMultiplier, pixelMultipler);
  }

  @override
  Widget baseBody(BuildContext context) {
    List<TabData> tabs = [
      TabData(translation(context).upcoming, const TabUpcoming()),
      TabData(translation(context).booked, const TabBooked()),
      TabData(translation(context).all, tabAll()),
    ];

    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: WillPopScope(
            onWillPop: () async {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.of(context).pushReplacementNamed(AppRoutes.homepage);
              }
              return false;
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                HeaderWidgetWithCoinInfo(
                  heading: translation(context).trips,
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.homepage);
                    }
                  }, icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: AppColors.iconColor,
                  size: 24,
                ),
                ),
                UserProfileWidget(),
                Obx(() {
                  if (coinController.isApiSuccess.value == false) {
                    return const Visibility(child: NoTripsAvailable());
                  } else {
                    return Visibility(
                        replacement: const Flexible(
                            child: Center(child: CircularProgressIndicator())),
                        visible: !coinController.isTripsLoading.value,
                        child: TabWidget(
                            initialIndex: widget.initialIndex, tabs: tabs));
                  }
                })
              ],
            ),
          ),
        ));
  }
}
