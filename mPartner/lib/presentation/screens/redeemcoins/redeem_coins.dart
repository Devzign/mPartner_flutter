import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../state/contoller/coin_redemption_options_controller.dart';
import '../../../state/contoller/coins_summary_controller.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/utils.dart';
import '../../widgets/upcoming_feature.dart';
import '../base_screen.dart';
import '../ismart/cash_coins_history/cash_coin_history_screen.dart';
import '../userprofile/user_profile_widget.dart';
import '../../widgets/headers/header_widget_with_history_action.dart';

class RedeemCoins extends StatefulWidget {
  const RedeemCoins({super.key});

  @override
  State<RedeemCoins> createState() => _RedeemCoinsState();
}

class _RedeemCoinsState extends BaseScreenState<RedeemCoins> {
  @override
  Widget baseBody(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    const String svgString = '''
<svg width="28" height="28" viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M14 26.25C20.7655 26.25 26.25 20.7655 26.25 14C26.25 7.2345 20.7655 1.75 14 1.75C7.2345 1.75 1.75 7.2345 1.75 14C1.75 20.7655 7.2345 26.25 14 26.25Z" fill="#F9C23C"/>
<path opacity="0.53" d="M23.625 14C23.625 19.3156 19.3156 23.625 14 23.625C8.68438 23.625 4.375 19.3156 4.375 14C4.375 8.68438 8.68438 4.375 14 4.375C19.3156 4.375 23.625 8.68438 23.625 14ZM19.53 17.4037C19.4992 17.3097 19.4395 17.2277 19.3593 17.1695C19.2792 17.1114 19.1828 17.0801 19.0837 17.08H19.11V10.29C19.4862 10.045 19.5562 9.44125 19.1012 9.17L14.385 6.3175C14.2828 6.25316 14.1645 6.21902 14.0437 6.21902C13.923 6.21902 13.8047 6.25316 13.7025 6.3175L8.9775 9.17C8.5225 9.44125 8.5925 10.045 8.96 10.29V17.0888H8.86375C8.65375 17.0888 8.47 17.2288 8.4175 17.43L8.11125 18.5238C8.02375 18.8212 8.25125 19.1188 8.5575 19.1188H19.4513C19.7575 19.11 19.985 18.8037 19.8888 18.4975L19.53 17.4037ZM10.4125 10.395V17.08H11.865V10.395H10.4125ZM13.3088 10.395V17.08H14.7875V10.395H13.3088ZM16.24 10.395V17.08H17.6575V10.395H16.24Z" fill="#D3883E"/>
</svg>
''';

    CoinsSummaryController coinsSummaryController = Get.find();
    CoinRedemptionOptionsController coinRedemptionOptionsController = Get.find();
    final UserDataController udc = Get.find();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(children: [
              HeadingWithHistoryAction(
                heading: translation(context).redeemCoins,
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
                                cardType: FilterCashCoin.coinType)));
                  }
                },
              ),
              UserProfileWidget(),
              Container(
                padding: EdgeInsets.fromLTRB(24.0 * w, 0.0, 24.0 * w, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.lumiLight5, // Background color
                        foregroundColor: AppColors.lumiBluePrimary, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0 * r), // Border radius
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5 * w,
                          vertical: 5 * h,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: SvgPicture.string(
                                svgString,
                                width: 28 * r,
                                height: 28 * r,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: SizedBox(width: w * 10),
                            ), // Icon
                            Expanded(
                              flex: 17,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GetBuilder<CoinsSummaryController>(
                                    builder: (_) {
                                      return Text(
                                        rupeeNoSign.format(double.parse(
                                            coinsSummaryController.availableCoins
                                                .replaceAll(',', ''))),
                                        style: GoogleFonts.poppins(
                                          color: AppColors.lumiBluePrimary,
                                          fontSize: 16 * f,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: h * 2),
                                  Text(
                                    translation(context).availableCoinsBalance,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.darkGreyText,
                                      fontSize: 12 * f,
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
                    SizedBox(height: h * 24),
                    Text(
                      translation(context).redeemYouCoinsHere,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 16 * f,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: h * 16),
                    GetBuilder<CoinRedemptionOptionsController>(
                      builder: (_) {
                        return Column(
                          children: [
                            for (int i = 0;
                                i <
                                    coinRedemptionOptionsController
                                        .iconKeys.length;
                                i++)
                              Column(
                                children: [
                                  Container(
                                    child: TextButton(
                                        onPressed: () {
                                          if (coinRedemptionOptionsController
                                                  .headings[i] ==
                                              'Cashback') {
                                            Navigator.of(context).pushNamed(
                                                AppRoutes.coinsToCashback);
                                          } else if (coinRedemptionOptionsController
                                                  .headings[i] ==
                                              'Trips & Mega Events') {
                                            Navigator.of(context)
                                                .pushNamed(AppRoutes.coinsToTrip);
                                          }
                                          else if (coinRedemptionOptionsController.headings[i] == 'Gifts'){
                                             Navigator.push(context,MaterialPageRoute(builder: (context) => UpcomingFeatureScreen()),);
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: AppColors.lightWhite1,
                                          // Background color
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0 * r),
                                            side: const BorderSide(
                                              color: AppColors.lightGrey2,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 5 * w,
                                            vertical: 5 * h,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 8,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      coinRedemptionOptionsController
                                                              .headings[i] ??
                                                          " ",
                                                      style: GoogleFonts.poppins(
                                                        color: AppColors.black,
                                                        fontSize: 16 * f,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(height: h * 10),
                                                    Text(
                                                      coinRedemptionOptionsController
                                                              .subHeadings[i] ??
                                                          " ",
                                                      style: GoogleFonts.poppins(
                                                        color: AppColors.grayText,
                                                        fontSize: 14 * f,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Image.network(
                                                      coinRedemptionOptionsController
                                                              .gifURLs[i] ??
                                                          " ",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                  SizedBox(height: h * 16),
                                ],
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
