import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../network/internet_check_controller.dart';
import '../../../../state/contoller/cash_redemption_options_controller.dart';
import '../../../../state/contoller/cash_summary_controller.dart';
import '../../../../state/contoller/coin_redemption_options_controller.dart';
import '../../../../state/contoller/coins_summary_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/bottomNavigationBar/bottom_navigation_bar.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../userprofile/user_profile_widget.dart';
import 'components/check_warranty.dart';
import '../../../widgets/headers/ismart_header_widget.dart';
import 'components/subsection_header.dart';
import 'components/summary_card.dart';
import 'components/terms_conditions.dart';

class IsmartHomepage extends StatefulWidget {
  const IsmartHomepage({super.key});

  @override
  State<IsmartHomepage> createState() => _IsmartHomepageState();
}

class _IsmartHomepageState extends State<IsmartHomepage> with WidgetsBindingObserver{
  CoinRedemptionOptionsController coinRedemptionOptionsController = Get.find();
  CashRedemptionOptionsController cashRedemptionOptionsController = Get.find();
  UserDataController userDataController = Get.find();
  CoinsSummaryController coinsSummaryController = Get.find();
  CashSummaryController cashSummaryController = Get.find();
  // InternetController internetController  = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
    coinRedemptionOptionsController.fetchCoinRedemptionOptions();
    cashRedemptionOptionsController.fetchCashRedemptionOptions();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("DID CHANGE DEPENDENCIES CALLED");
    coinsSummaryController.fetchCoinsSummary();
    cashSummaryController.fetchCashSummary();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint("DID CHANGE APP LIFECYCLE STATE CALLED");
    switch (state) {
      case AppLifecycleState.resumed:
        logger.d("I-smart resumed");
        break;
      case AppLifecycleState.inactive:
        logger.d("I-smart inactive");
        break;
      case AppLifecycleState.paused:
        logger.d("I-smart paused");
        break;
      case AppLifecycleState.detached:
        logger.d("I-smart detached");
        break;
      case AppLifecycleState.hidden:
        logger.d("I-smart hidden");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultipler =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pushNamed(context, AppRoutes.homepage);
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.lightWhite1,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 24 * variablePixelWidth,
                    right: 24 * variablePixelWidth,
                    top: 24 * variablePixelHeight),
                child: ISmartHeaderWidget(title: translation(context).iSmart),
              ),
              UserProfileWidget(top: 24 * variablePixelHeight),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    SubsectionHeader(
                        sectionHeader: translation(context).yourmPartnerWallet),
                    if (userDataController.userType == "DEALER")
                      SummaryCardWidget(
                        cardType: CardType.Coins,
                      ),
                    SummaryCardWidget(
                      cardType: CardType.Cash,
                    ),
                    const CheckWarrantyStatusWidget(),
                    //SubsectionHeader(sectionHeader: translation(context).offers),
                    //const VerticalSpace(height: 12),
                    // Obx(() {
                    //   if (ismartOffersController.isLoading.value) {
                    //     return const Center(
                    //       child: CircularProgressIndicator(),
                    //     );
                    //   } else if (ismartOffersController.error.isNotEmpty) {
                    //     return Center(
                    //       child: Text(
                    //         'Error: ${ismartOffersController.error.value}',
                    //         style: TextStyle(color: AppColors.errorRed),
                    //       ),
                    //     );
                    //   } else {
                    //     final bool isDataEmpty = ismartOffersController
                    //         .ismartOffersThumbnailURLs.isEmpty;
                    //     if (isDataEmpty) {
                    //       return Container();
                    //     } else {
                    //       return OffersWidget(
                    //           offerImageURLs:
                    //               ismartOffersController.ismartOffersThumbnailURLs);
                    //     }
                    //   }
                    // }),
                    const TermsConditionsWidget(),
                    const VerticalSpace(height: 80)
                  ],
                ),
              ))
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          currentIndex: 1,
          onTabTapped: (value) => 1,
        ),
        floatingActionButton: SizedBox(
          width: 165 * variablePixelWidth,
          height: 56 * variablePixelHeight,
          child: FloatingActionButton.extended(
            heroTag: "registerSalesFloatingActionButton",
            onPressed: () {
              userDataController.isFromHomePageRoute = false;
              Navigator.pushNamed(context, AppRoutes.registerSales);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100 * pixelMultipler),
            ),
            backgroundColor: AppColors.darkBlue,
            icon: const Icon(
              Icons.qr_code_2,
              color: Colors.white,
            ),
            label: Text(
              translation(context).registerSalesFloating,
              style: GoogleFonts.poppins(
                  color: AppColors.white_234,
                  fontSize: 14 * textMultiplier,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

}
