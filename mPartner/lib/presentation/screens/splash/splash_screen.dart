import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../state/contoller/splash_screen_controller.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/enums.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/common_divider.dart';
import '../../widgets/horizontalspace/horizontal_space.dart';
import '../../widgets/verticalspace/vertical_space.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenComponentState createState() => _SplashScreenComponentState();
}

class _SplashScreenComponentState extends State<SplashScreen> {
  final SplashScreenController splashScreenController = Get.find();
  double variablePixelHeight = 0;
  double variablePixelWidth = 0;
  double textFontMultiplier = 0;
  double pixelMultiplier = 0;
  UserDataController userDataController = Get.find();

  @override
  void initState() {
    checkInternetAndFetchData();
    super.initState();
  }

  Future<void> checkInternetAndFetchData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    logger.d("connectivityResult ***** ${connectivityResult.first.name}");
    logger.d("connectivityResult ***** ${connectivityResult.isEmpty}");
    if (null != connectivityResult &&
        connectivityResult.first != ConnectivityResult.none) {
      splashScreenController.fetchSplashScreenImage();
      navigateAfterDelay();
    } else {
      // show bottom sheet
      logger.d("No Internet connectivity ***** $connectivityResult");
      showBottomSheet(
          "No Internet Connection",
          "It seems that your device has no internet connectivity.\nPlease enable internet and try again.\n",
          "Refresh");
    }
  }

  void navigateAfterDelay() {
    Future.delayed(const Duration(seconds: 5), () async {
      logger.d(
          "5 Sec Thread complete ***** ${splashScreenController.navigationState.value}");
      logger.d(
          "splashScreenController.isLoggedIn.value ***** ${splashScreenController.isLoggedIn.value}");
      if (splashScreenController.navigationState.value ==
          NavigationState.homePage) {
        splashScreenController.clearSplashScreenController();
        Navigator.popAndPushNamed(context, AppRoutes.homepage);
      } else if (splashScreenController.navigationState.value ==
          NavigationState.welcomePage) {
        splashScreenController.clearSplashScreenController();
        if (userDataController.token != '' && userDataController.phoneNumber != '') {
          Navigator.popAndPushNamed(context, AppRoutes.homepage);
        } else {
          Navigator.popAndPushNamed(context, AppRoutes.welcome);
        }
      } else if (splashScreenController.navigationState.value ==
          NavigationState.httpFailure) {
        showBottomSheet(
            "Alert!", translation(context).somethingWentWrongPleaseRetry, null);
      } else if (splashScreenController.navigationState.value ==
          NavigationState.responseFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              splashScreenController.errorMessage.value,
              style: const TextStyle(
                color: AppColors.lumiDarkBlack,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
              ),
            ),
            elevation: 3,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.lightGreen, width: 1),
              borderRadius: BorderRadius.circular(4 * pixelMultiplier),
            ),
            backgroundColor: AppColors.lightGreen,
            duration: const Duration(seconds: 3),
          ),
        );
        await splashScreenController.checkUserLoggedIn();
        if (splashScreenController.navigationState.value ==
            NavigationState.homePage) {
          splashScreenController.clearSplashScreenController();
          Navigator.popAndPushNamed(context, AppRoutes.homepage);
        } else if (splashScreenController.navigationState.value ==
            NavigationState.welcomePage) {
          splashScreenController.clearSplashScreenController();
          if (userDataController.token != '' && userDataController.phoneNumber != '') {
            Navigator.popAndPushNamed(context, AppRoutes.homepage);
          } else {
            Navigator.popAndPushNamed(context, AppRoutes.welcome);
          }
        }
      }
    });
  }

  void showBottomSheet(
    String header,
    String message,
    String? primaryButtonText,
  ) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        // showDragHandle: true,
        builder: (BuildContext bc) {
          return PopScope(
            canPop: false,
            child: Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      16 * variablePixelWidth,
                      16 * variablePixelHeight,
                      16 * variablePixelWidth,
                      16 * variablePixelHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const VerticalSpace(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                        child: Text(
                          header,
                          style: GoogleFonts.poppins(
                            color: AppColors.titleColor,
                            fontSize: 20 * textFontMultiplier,
                            fontWeight: FontWeight.w600,
                            height: 0.06,
                            letterSpacing: 0.50,
                          ),
                        ),
                      ),
                      const VerticalSpace(height: 16),
                      Padding(
                        padding: EdgeInsets.only(left: 16 * pixelMultiplier),
                        child:
                            const CustomDivider(color: AppColors.dividerColor),
                      ),
                      const VerticalSpace(height: 16),
                      Padding(
                        padding: EdgeInsets.only(
                            right: 16 * variablePixelWidth,
                            left: 16 * variablePixelWidth),
                        child: SizedBox(
                          // width: 345 * variablePixelWidth,
                          // height: 40 * variablePixelHeight,
                          child: Text(
                            message,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 14 * textFontMultiplier,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ),
                      ),
                      const VerticalSpace(height: 24),
                      if (primaryButtonText != null) ...{
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SecondaryButton(
                              buttonText: "Exit",
                              onPressed: () => {
                                SystemNavigator.pop(),
                              },
                              buttonHeight: 48,
                              isEnabled: true,
                            ),
                            const HorizontalSpace(width: 16),
                            PrimaryButton(
                              buttonText: primaryButtonText,
                              onPressed: () async {
                                Navigator.pop(context);
                                checkInternetAndFetchData();
                              },
                              buttonHeight: 48,
                              isEnabled: true,
                            ),
                          ],
                        ),
                      } else ...{
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            PrimaryButton(
                              buttonText: "Okay",
                              onPressed: () async {
                                SystemNavigator.pop();
                              },
                              buttonHeight: 48,
                              isEnabled: true,
                            ),
                          ],
                        ),
                      }
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Obx(() {
          if (splashScreenController.isLoading.value) {
            return const CircularProgressIndicator();
          } else {
            return CachedNetworkImage(
              imageUrl: splashScreenController.splashScreenUrl.value,
              fit: BoxFit.fitWidth,
            );
          }
        }),
      ),
    );
  }
}
