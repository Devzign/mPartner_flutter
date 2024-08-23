import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/models/network_management_model/dealer_electrician_details_model.dart';
import '../../../../data/models/user_profile_model.dart';
import '../../../../state/contoller/ISmartCashHistoryController.dart';
import '../../../../state/contoller/Ismart_coin_history_controller.dart';
import '../../../../state/contoller/cash_summary_controller.dart';
import '../../../../state/contoller/coins_summary_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/coin_with_image_widget.dart';
import '../../../widgets/rupee_with_sign_widget.dart';
import '../../base_screen.dart';
import '../../network_management/dealer_electrician/components/common_network_utils.dart';
import '../../network_management/dealer_electrician/components/performance_user_detail_widget.dart';
import '../../userprofile/user_profile_widget.dart';
import 'cash_transactions_list_screen.dart';
import 'coin_transactions_list_screen.dart';
import 'widgets/cash_coins_tabs_widget.dart';

class CashCoinHistoryScreen extends StatefulWidget {
  final String cardType;
  final bool? isFromPerformanceScreen;
  final DealerElectricianDetail? listItemData;
  final String? selectedUserType;

  const CashCoinHistoryScreen(
      {super.key,
      required this.cardType,
      this.isFromPerformanceScreen = false,
      this.listItemData,
      this.selectedUserType});

  @override
  State<CashCoinHistoryScreen> createState() => _CashCoinHistoryScreenState();
}

class _CashCoinHistoryScreenState
    extends BaseScreenState<CashCoinHistoryScreen> {
  late String selectedTab;
  ISmartCashHistoryController cashHistory = Get.find();
  ISmartCoinHistoryController coinHistory = Get.find();
  CoinsSummaryController coinsSummaryController = Get.find();
  CashSummaryController cashSummaryController = Get.find();
  List<UserProfile> storedUserProfile = [];

  @override
  void initState() {
    loadData();
    super.initState();
    selectedTab = widget.cardType.toLowerCase() == FilterCashCoin.cashType
        ? FilterCashCoin.cashType
        : FilterCashCoin.coinType;
  }

  Future<void> loadData() async {
    UserDataController controller = Get.find();
    storedUserProfile = controller.userProfile;
  }

  void changeTab(String tab) => setState(() => selectedTab = tab);

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Scaffold(
      backgroundColor: AppColors.lightWhite1,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(14 * variablePixelWidth,
                  24 * variablePixelHeight, 24 * variablePixelWidth, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_back_outlined,
                          color: AppColors.iconColor,
                          size: 24,
                        ),
                        onPressed: () {
                          cashHistory.clearIsmartCashHistory();
                          cashSummaryController.clearCashSummaryData(
                              code: widget.listItemData?.code);
                          coinHistory.clearIsmartCoinHistory();
                          coinsSummaryController.clearCoinSummaryData(
                              code: widget.listItemData?.code!);
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.homepage);
                          }
                        },
                      ),
                      Text(
                        (widget.isFromPerformanceScreen ?? false)
                            ? widget.selectedUserType == UserType.dealer
                                ? translation(context).dealerPerformance
                                : translation(context).electricianPerformance
                            : translation(context).history,
                        style: GoogleFonts.poppins(
                          color: AppColors.iconColor,
                          fontSize:
                              AppConstants.FONT_SIZE_LARGE * textMultiplier,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  (widget.isFromPerformanceScreen ?? false)
                      ? Container()
                      : selectedTab == FilterCashCoin.cashType
                          ? Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.lumiLight4,
                                borderRadius: BorderRadius.circular(
                                    10.0 * pixelMultiplier),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    5 * variablePixelWidth,
                                    0,
                                    5 * variablePixelWidth,
                                    0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GetBuilder<CashSummaryController>(
                                      builder: (_) {
                                        return RupeeWithSignWidget(
                                          cash: double.parse(
                                              cashSummaryController
                                                  .availableCash
                                                  .replaceAll(',', '')),
                                          color: AppColors.lumiBluePrimary,
                                          width: 120,
                                          weight: FontWeight.w500,
                                          size: 12,
                                        );
                                      },
                                    ),
                                    Text(
                                      " ${translation(context).available}",
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                        color: AppColors.lumiBluePrimary,
                                        fontSize: 12 * textMultiplier,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.goldCoinLight,
                                borderRadius: BorderRadius.circular(
                                    10.0 * pixelMultiplier),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    5 * variablePixelWidth,
                                    0,
                                    5 * variablePixelWidth,
                                    0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GetBuilder<CoinsSummaryController>(
                                        builder: (_) {
                                      return CoinWithImageWidget(
                                        coin: double.parse(
                                            coinsSummaryController
                                                .availableCoins
                                                .replaceAll(',', '')),
                                        width: 120,
                                        weight: FontWeight.w500,
                                        size: 12,
                                        color: AppColors.goldCoin,
                                      );
                                    }),
                                    Text(
                                      " ${translation(context).available}",
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                        color: AppColors.goldCoin,
                                        fontSize: 12 * textMultiplier,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                ],
              ),
            ),
            UserProfileWidget(),
            (widget.isFromPerformanceScreen ?? false)
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24 * variablePixelWidth),
                    child: PerformanceDealerElectricianViewWidget(
                        widget.listItemData!, 1, (value) {}, true),
                  )
                : Container(),
            (widget.isFromPerformanceScreen ?? false) ||
                    storedUserProfile[0].userType.toLowerCase() ==
                        FilterCashCoin.dealerType
                ? CashCoinTabs(
                    leftTabText: FilterCashCoin.coins,
                    rightTabText: FilterCashCoin.cash,
                    isLeftTabSelected: selectedTab == FilterCashCoin.coinType,
                    onLeftTabPressed: () => changeTab(FilterCashCoin.coinType),
                    onRightTabPressed: () => changeTab(FilterCashCoin.cashType),
                  )
                : Container(
                    height: variablePixelHeight * 24,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GetBuilder<CashSummaryController>(
                          builder: (_) {
                            return RupeeWithSignWidget(
                              cash: double.parse(cashSummaryController
                                  .availableCash
                                  .replaceAll(',', '')),
                              color: AppColors.lumiBluePrimary,
                              width: 100,
                              weight: FontWeight.w600,
                              size: 14,
                            );
                          },
                        ),
                        Text(
                          " ${translation(context).cash} ${translation(context).available}",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                            color: AppColors.lumiBluePrimary,
                            fontSize: 14 * textMultiplier,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
            SizedBox(
              height: variablePixelHeight * 16,
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  switch (selectedTab) {
                    case FilterCashCoin.cashType:
                      coinHistory.clearIsmartCoinHistory();
                      return (widget.isFromPerformanceScreen ?? false)
                          ? CashTransactionListScreen(
                              isFromPerformanceScreen:
                                  widget.isFromPerformanceScreen ?? false,
                              listItemData: widget.listItemData)
                          : const CashTransactionListScreen();
                    case FilterCashCoin.coinType:
                      cashHistory.clearIsmartCashHistory();
                      return (widget.isFromPerformanceScreen ?? false)
                          ? CoinTransactionListScreen(
                              isFromPerformanceScreen:
                                  widget.isFromPerformanceScreen ?? false,
                              listItemData: widget.listItemData,
                            )
                          : const CoinTransactionListScreen();
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
