import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../services/location_services.dart';
import '../../../state/contoller/cash_redemption_options_controller.dart';
import '../../../state/contoller/cash_summary_controller.dart';
import '../../../state/contoller/coins_summary_controller.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_string.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/rupee_with_sign_widget.dart';
import '../base_screen.dart';
import '../cashredemption/pinelab/pinelab_webview.dart';
import '../ismart/cash_coins_history/cash_coin_history_screen.dart';
import '../../widgets/headers/header_widget_with_history_action.dart';
import '../userprofile/user_profile_widget.dart';
import 'components/headingRedeemCash.dart';

class RedeemCashHome extends StatefulWidget {
  const RedeemCashHome({super.key});

  @override
  State<RedeemCashHome> createState() => _RedeemCashHomeState();
}

class _RedeemCashHomeState extends BaseScreenState<RedeemCashHome> {
  double variablePixelHeight = 1;
  double variablePixelWidth = 1;
  double textFontMultiplier = 1;
  double pixelMultiplier = 1;
  bool isLoading = true;

  // bool _showUPI = true;
  // bool _showPayTm = true;
  // bool _showPinelab = true;
  CashSummaryController cashSummaryController = Get.find();
  CashRedemptionOptionsController cROController = Get.find();
  final UserDataController udc = Get.find();

  // @override
  // void currentLatLngAvailable() async {
  //
  // }

  @override
  void locationNowAvailable(Position position) async {
    setState(() {
      isLoading = true;
    });
    logger.d('[UPI_RA] init!! locationNowAvailable() called.... ');
    logger.d('[UPI_RA] fetching geo code.... ');
    logger.d('position ====>>> ${position.latitude}');
    // await determineGeoCode();

    logger.d('[UPI_RA] Fetching address.... ');
    await getAddress();
    logger.d('[UPI_RA] getAddress() called!');
    await udc.fetchUserProfile();
    if(udc.getUserProfileOutput.isNotEmpty && udc.isPrimaryNumberLogin){
      if(udc.getUserProfileOutput.first.phone.isNotEmpty){
        logger.d("[Phone number]:: ${udc.getUserProfileOutput.first.phone}");
        udc.updatePhoneNumber(udc.getUserProfileOutput.first.phone);
      }
    }
    setState(() {
      isLoading = false;
    });
    logger.d('[UPI_RA] loader closed!');
  }

  @override
  Widget build(BuildContext context) {
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    return super.build(context);
  }

  @override
  Widget baseBody(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                HeadingWithHistoryAction(
                  heading: 'Redeem Cash',
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.homepage);
                    }
                  },
                  onHistoryPressed: () {
                    if (udc.isPrimaryNumberLogin) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CashCoinHistoryScreen(
                                  cardType: FilterCashCoin.cashType)));
                    }
                  },
                ),
                UserProfileWidget(),
                (isLoading)
                    ? const Expanded(
                        child: Center(child: CircularProgressIndicator()))
                    : SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: 24 * variablePixelWidth,
                              left: 24 * variablePixelWidth,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                onPressed: () {
                                  if (udc.isPrimaryNumberLogin) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CashCoinHistoryScreen(
                                                    cardType: FilterCashCoin
                                                        .cashType)));
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      AppColors.lumiLight5, // Background color
                                  foregroundColor:
                                      AppColors.lumiBluePrimary, // Text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        12.0 * pixelMultiplier), // Border radius
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(5.0 * variablePixelWidth),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: SvgPicture.asset(
                                              'assets/mpartner/account_balance_wallet.svg')),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                            width: 10 * variablePixelWidth),
                                      ),
                                      // Icon
                                      Expanded(
                                        flex: 17,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                GetBuilder<
                                                    CoinsSummaryController>(
                                                  builder: (_) {
                                                    return RupeeWithSignWidget(
                                                      color: AppColors
                                                          .lumiBluePrimary,
                                                      size: 16,
                                                      weight: FontWeight.w600,
                                                      width: 300,
                                                      cash: double.parse(
                                                          cashSummaryController
                                                              .availableCash),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: 2 * variablePixelHeight),
                                            Text(
                                              translation(context)
                                                  .availableCashBalance,
                                              style: GoogleFonts.poppins(
                                                color: AppColors.darkGreyText,
                                                fontSize: 12 * textFontMultiplier,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20 * variablePixelHeight),
                              Text(
                                'Transfer your Cash here...',
                                style: GoogleFonts.poppins(
                                  color: AppColors.darkGreyText,
                                  fontSize: 16 * textFontMultiplier,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 16 * variablePixelHeight),
                              GetBuilder<CoinsSummaryController>(
                                builder: (_) {
                                  return _getPaytmContainer(
                                      cROController.isPayTmAvailable);
                                },
                              ),
                              GetBuilder<CoinsSummaryController>(
                                builder: (_) {
                                  return _getUpiContainer(
                                      cROController.isUpiAvailable);
                                },
                              ),
                              GetBuilder<CoinsSummaryController>(
                                builder: (_) {
                                  return _getPinelabContainer(
                                      cROController.isPinelabAvailable);
                                },
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 137 * variablePixelWidth,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1 * variablePixelWidth,
                                          strokeAlign:
                                              BorderSide.strokeAlignCenter,
                                          color: AppColors.lightGrey2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8 * variablePixelWidth),
                                  Text(
                                    'OR',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.blackText,
                                      fontSize: 14 * textFontMultiplier,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.50,
                                    ),
                                  ),
                                  SizedBox(width: 8 * variablePixelWidth),
                                  Container(
                                    width: 136 * variablePixelWidth,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1 * variablePixelWidth,
                                          strokeAlign:
                                              BorderSide.strokeAlignCenter,
                                          color: AppColors.lightGrey2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 40 * variablePixelHeight),
                              Text(
                                'Cash already added in brand voucher wallet? ',
                                style: GoogleFonts.poppins(
                                  color: AppColors.hintColor,
                                  fontSize: 14 * textFontMultiplier,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                width: double.maxFinite,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const PinelabWebview()));
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                              "assets/mpartner/open_in_new.svg"),
                                          SizedBox(width: 8 * variablePixelWidth),
                                          Text(
                                            'Open Pine Labs microsite',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              color: AppColors.lumiBluePrimary,
                                              fontSize: 14 * textFontMultiplier,
                                              fontWeight: FontWeight.w500,
                                              height: 0.10 * variablePixelHeight,
                                              letterSpacing: 0.10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
              ]),
        ),
      ),
    );
  }

  Widget _getPaytmContainer(bool isPaytmShown) {
    if (isPaytmShown) {
      return Column(
        children: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.paytmRedemption);
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.lightWhite1, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0 * pixelMultiplier),
                  side: const BorderSide(
                    color: AppColors.lightGrey2,
                  ),
                ),
              ),
              child: Padding(
                  padding: EdgeInsets.all(5.0 * variablePixelWidth),
                  child: Row(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      verticalDirection: VerticalDirection.down,
                      children: [
                        SvgPicture.asset(
                            "assets/mpartner/ismart/ic_paytm_expended.svg"),
                        SizedBox(height: 8 * variablePixelHeight),
                        Text(
                          'Transfer to Paytm wallet',
                          style: GoogleFonts.poppins(
                            color: AppColors.blackText,
                            fontSize: 14 * textFontMultiplier,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.50,
                          ),
                        ),
                      ],
                    ),
                  ]))),
          SizedBox(height: 16 * variablePixelHeight),
        ],
      );
    } else {
      return const Column();
    }
  }

  Widget _getUpiContainer(bool isUpiShown) {
    if (isUpiShown) {
      return Column(
        children: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.upiScreen);
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.lightWhite1, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0 * pixelMultiplier),
                  side: const BorderSide(
                    color: AppColors.lightGrey2,
                  ),
                ),
              ),
              child: Padding(
                  padding: EdgeInsets.all(5.0 * variablePixelWidth),
                  child: Row(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                            "assets/mpartner/ismart/ic_upi_expended.svg"),
                        SizedBox(height: 8 * variablePixelHeight),
                        Text(
                          'Transfer to UPI',
                          style: GoogleFonts.poppins(
                            color: AppColors.blackText,
                            fontSize: 14 * textFontMultiplier,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.50,
                          ),
                        ),
                      ],
                    ),
                  ]))),
          SizedBox(height: 16 * variablePixelHeight),
        ],
      );
    } else {
      return const Column();
    }
  }

  Widget _getPinelabContainer(bool isPinelabShown) {
    if (isPinelabShown) {
      return Column(
        children: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.pinelabRedemption);
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.lightWhite1, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0 * pixelMultiplier),
                  side: const BorderSide(
                    color: AppColors.lightGrey2,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(5.0 * variablePixelWidth),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                            "assets/mpartner/ismart/ic_pinelabs_expended.svg"),
                        SizedBox(height: 8 * variablePixelHeight),
                        Text(
                          'Transfer to Pine Labs wallet',
                          style: GoogleFonts.poppins(
                            color: AppColors.blackText,
                            fontSize: 14 * textFontMultiplier,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.50,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          SizedBox(height: 40 * variablePixelHeight),
        ],
      );
    } else {
      return const Column();
    }
  }
}
