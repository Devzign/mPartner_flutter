import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../services/services_locator.dart';
import '../../../../state/contoller/cash_summary_controller.dart';
import '../../../../state/contoller/coin_redemption_options_controller.dart';
import '../../../../state/contoller/coin_to_cashback_conversion_controller.dart';
import '../../../../state/contoller/coin_to_cashback_submit_controller.dart';
import '../../../../state/contoller/coins_summary_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/RedeemDetailedHistory/redeem_detailed_history.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/headers/header_widget_with_coins_info.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../widgets/something_went_wrong_screen.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../base_screen.dart';
import '../../cashredemption/widgets/verification_failed_alert.dart';
import '../../userprofile/user_profile_widget.dart';
import '../ismart_homepage/ismart_homepage.dart';
import 'components/cashback_details_card.dart';
import 'components/redeemable_coins.dart';

class RedeemCoinsToCashback extends StatefulWidget {
  const RedeemCoinsToCashback({super.key});

  @override
  State<RedeemCoinsToCashback> createState() => _RedeemCoinsToCashbackState();
}

class _RedeemCoinsToCashbackState
    extends BaseScreenState<RedeemCoinsToCashback> {
  TextEditingController coinsController = TextEditingController();
  CoinToCashbackConversionController cashbackController = Get.find();
  CoinToCashbackSubmitController coinToCashbackSubmitController = Get.find();
  CoinRedemptionOptionsController coinRedemptionOptionsController = Get.find();
  CoinsSummaryController coinsSummaryController = Get.find();
  CashSummaryController cashSummaryController = Get.find();

  bool _showCurrencyIcon = false;
  bool _showDetailsCard = false;
  bool isButtonEnabled = false;
  String coinsErrorText = "";
  int coins = 0;
  String dateDetails = "";
  bool _isError = false;
  int apiFailureCount = 0;

  @override
  void initState() {
    super.initState();
    // coinRedemptionOptionsController.fetchCoinRedemptionOptions();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
            sl<BaseMPartnerRemoteDataSource>();
        final result = await baseMPartnerRemoteDataSource.coinRedemptionCheck();
        result.fold((l) {
          print("Error: $l");
        }, (r) async {
          if (r.status != "200") {
            showAlert(r.message);
          }
        });
      } catch (e) {
        print("Error Captured: ${e}");
      }
    });
    setState(() {
      coins = coinRedemptionOptionsController.redeemableBalance;
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

  String formatDate(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate);
    String formattedDateTime = DateFormat('dd MMM y, hh:mm a').format(dateTime);
    print(formattedDateTime);
    return formattedDateTime;
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultipler =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    CoinsSummaryController coinsSummaryController = Get.find();
    CoinRedemptionOptionsController coinRedemptionOptionsController =
        Get.find();
    int coins = coinRedemptionOptionsController.redeemableBalance;

    const OutlineInputBorder enabledOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      borderSide: BorderSide(color: AppColors.lightGrey1),
    );

    const OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      borderSide: BorderSide(color: AppColors.lightGrey1),
    );

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.lightWhite1,
        body: SafeArea(
          child: Column(
            children: [
              HeaderWidgetWithCoinInfo(
                  heading: translation(context).cashback, onPressed: () { Navigator.pop(context); }, icon: const Icon(
                Icons.arrow_back_outlined,
                color: AppColors.iconColor,
                size: 24,
              ),),
              UserProfileWidget(top: 8 * variablePixelHeight),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RedeemableCoinsWidget(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              24 * variablePixelWidth,
                              20 * variablePixelHeight,
                              24 * variablePixelWidth,
                              20 * variablePixelHeight),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 48 * variablePixelHeight,
                                          child: TextField(
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                              FilteringTextInputFormatter.deny(
                                                  RegExp('^0+'))
                                            ],
                                            maxLength: 9,
                                            onChanged: (value) {
                                              setState(() {
                                                if (_showDetailsCard) {
                                                  _showDetailsCard =
                                                      !_showDetailsCard;
                                                }
                                                _showCurrencyIcon = value
                                                        .isNotEmpty &&
                                                    int.tryParse(value) !=
                                                        null &&
                                                    int.parse(value) <=
                                                        coinRedemptionOptionsController
                                                            .redeemableBalance &&
                                                    (int.parse(value) != 0 &&
                                                        int.parse(value) %
                                                                100 ==
                                                            0);
                                                if (value.isEmpty) {
                                                  _showDetailsCard = false;
                                                  isButtonEnabled =
                                                      _showDetailsCard;
                                                }
                                                if (value == "0") {
                                                  coinsErrorText = translation(
                                                          context)
                                                      .enterValidTransferAmount;
                                                } else if (int.parse(value) %
                                                        100 !=
                                                    0) {
                                                  coinsErrorText =
                                                      translation(context)
                                                          .enterMultiplesOf100;
                                                } else if (int.parse(value) >
                                                    coinRedemptionOptionsController
                                                        .redeemableBalance) {
                                                  coinsErrorText = translation(
                                                          context)
                                                      .enteredCoinsMoreThanRedeemable;
                                                } else {
                                                  coinsErrorText = "";
                                                }

                                                if (coinsErrorText != "") {
                                                  _isError = true;
                                                } else {
                                                  _isError = false;
                                                }
                                              });
                                            },
                                            controller: coinsController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      16 * variablePixelWidth,
                                                      0,
                                                      0,
                                                      0),
                                              labelText: translation(context)
                                                  .enterCoins,
                                              hintText: translation(context)
                                                  .enterCoinsToTransfer,
                                              hintStyle: GoogleFonts.poppins(
                                                  fontSize: 14 * textMultiplier,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.hintColor),
                                              counterText: "",
                                              focusedBorder: _isError
                                                  ? const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0)),
                                                      borderSide: BorderSide(
                                                          color: AppColors
                                                              .errorRed),
                                                    )
                                                  : focusedOutlineInputBorder,
                                              enabledBorder: _isError
                                                  ? const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0)),
                                                      borderSide: BorderSide(
                                                          color: AppColors
                                                              .errorRed),
                                                    )
                                                  : enabledOutlineInputBorder,
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              errorStyle: GoogleFonts.poppins(
                                                fontSize: 12 * textMultiplier,
                                                fontWeight: FontWeight.w500,
                                                height:
                                                    0.12 * variablePixelHeight,
                                                letterSpacing: 0.50,
                                              ),
                                              floatingLabelStyle:
                                                  GoogleFonts.poppins(
                                                      color: _isError
                                                          ? AppColors.errorRed
                                                          : AppColors
                                                              .darkGreyText,
                                                      fontSize:
                                                          12 * textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w400),
                                              labelStyle: GoogleFonts.poppins(
                                                color: AppColors.darkGrey,
                                                fontSize: 12 * textMultiplier,
                                                fontWeight: FontWeight.w400,
                                                height:
                                                    0.11 * variablePixelHeight,
                                                letterSpacing: 0.40,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (_showCurrencyIcon)
                                        const HorizontalSpace(width: 8),
                                      if (_showCurrencyIcon)
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              _showCurrencyIcon =
                                                  !_showCurrencyIcon;
                                              _showDetailsCard = true;
                                              isButtonEnabled =
                                                  _showDetailsCard;
                                              cashbackController
                                                  .fetchCoinToCashbackConversion(
                                                      coinsController.text,
                                                      coinsSummaryController
                                                          .availableCoins,
                                                      coinRedemptionOptionsController
                                                          .redeemableBalance);
                                            });
                                          },
                                          child: Container(
                                              width: 56 * variablePixelWidth,
                                              height: 48 * variablePixelHeight,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      16 * variablePixelWidth,
                                                  vertical:
                                                      10 * variablePixelHeight),
                                              decoration: ShapeDecoration(
                                                color:
                                                    AppColors.lumiBluePrimary,
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                      width: 1,
                                                      color:
                                                          AppColors.lightGrey1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4 * pixelMultipler),
                                                ),
                                              ),
                                              child: Center(
                                                  child: SvgPicture.asset(
                                                      "assets/mpartner/currency_exchange.svg"))),
                                        )
                                    ],
                                  ),
                                  if (coinsErrorText != "")
                                    Container(
                                        padding: EdgeInsets.only(
                                            left: 8 * variablePixelWidth),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          coinsErrorText,
                                          style: GoogleFonts.poppins(
                                              color: AppColors.errorRed,
                                              fontSize: 12 * textMultiplier,
                                              fontWeight: FontWeight.w400),
                                        )),
                                  const VerticalSpace(height: 20),
                                  if (_showDetailsCard) CashbackDetailsCard(),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),
              if (_showDetailsCard)
                CommonButton(
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        useSafeArea: true,
                        enableDrag: false,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(28 * variablePixelWidth),
                                topRight:
                                    Radius.circular(28 * variablePixelWidth))),
                        showDragHandle: true,
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: Container(
                              // height: 268 * variablePixelHeight,
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                  left: 24 * variablePixelWidth,
                                  right: 24 * variablePixelWidth,
                                  bottom: 16 * variablePixelHeight),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Icon(Icons.close)),
                                      VerticalSpace(height: 24),
                                      Container(
                                        child: Text(
                                          translation(context)
                                              .confirmationAlert,
                                          style: GoogleFonts.poppins(
                                            color: AppColors.titleColor,
                                            fontSize: 20 * textMultiplier,
                                            fontWeight: FontWeight.w600,
                                            height: 0.06 * variablePixelHeight,
                                            letterSpacing: 0.50,
                                          ),
                                        ),
                                      ),
                                      VerticalSpace(height: 20),
                                      Container(
                                        width: double.infinity,
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 1,
                                              strokeAlign:
                                                  BorderSide.strokeAlignCenter,
                                              color: AppColors.dividerGreyColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      VerticalSpace(height: 20),
                                      Text(
                                        translation(context)
                                            .transactionOnceProcessed,
                                        style: GoogleFonts.poppins(
                                          color: AppColors.darkGreyText,
                                          fontSize: 14 * textMultiplier,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.10,
                                        ),
                                      ),
                                      VerticalSpace(height: 4),
                                      Text(
                                        translation(context).sureToContinue,
                                        style: GoogleFonts.poppins(
                                          color: AppColors.darkGreyText,
                                          fontSize: 16 * textMultiplier,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  VerticalSpace(height: 20),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 48 * variablePixelHeight,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.lightWhite1,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    side: BorderSide(
                                                        color: AppColors
                                                            .lumiBluePrimary,
                                                        width: 1)),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                translation(context).no,
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      AppColors.lumiBluePrimary,
                                                  fontSize: 14 * textMultiplier,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.10,
                                                ),
                                              )),
                                        ),
                                      ),
                                      HorizontalSpace(width: 20),
                                      Expanded(
                                        child: Container(
                                          height: 48 * variablePixelHeight,
                                          child: GetBuilder<
                                              CoinToCashbackSubmitController>(
                                            builder: (_) {
                                              return ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppColors
                                                          .lumiBluePrimary),
                                                  onPressed: () async {
                                                    await coinToCashbackSubmitController
                                                        .fetchCoinToCashbackSubmit(
                                                            cashbackController
                                                                .coinsForCashback,
                                                            cashbackController
                                                                .conversionRate);
                                                    if (coinToCashbackSubmitController
                                                        .error
                                                        .value
                                                        .isNotEmpty) {
                                                      apiFailureCount++;
                                                      if (apiFailureCount <=
                                                          2) {
                                                        Utils().showToast(
                                                            translation(context)
                                                                .somethingWentWrong,
                                                            context);
                                                      } else {
                                                        setState(() {
                                                          coinsController.text =
                                                              "";
                                                          _showCurrencyIcon =
                                                              false;
                                                          _showDetailsCard =
                                                              false;
                                                          isButtonEnabled =
                                                              false;
                                                        });
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        SomethingWentWrongScreen(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.popAndPushNamed(context,
                                                                                AppRoutes.ismartHomepage);
                                                                          },
                                                                        )));
                                                      }
                                                    } else {
                                                      setState(() {
                                                        coinsController.text =
                                                            "";
                                                        _showCurrencyIcon =
                                                            false;
                                                        _showDetailsCard =
                                                            false;
                                                        isButtonEnabled = false;
                                                        dateDetails = formatDate(
                                                            coinToCashbackSubmitController
                                                                .transactionDate);
                                                      });
                                                      coinsSummaryController
                                                          .fetchCoinsSummary();
                                                      cashSummaryController
                                                          .fetchCashSummary();
                                                      coinRedemptionOptionsController
                                                          .fetchCoinRedemptionOptions();
                                                      if (coinToCashbackSubmitController
                                                              .status ==
                                                          "Failure") {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PopScope(
                                                                          canPop:
                                                                              false,
                                                                          onPopInvoked:
                                                                              (didPop) {
                                                                            Navigator.pushAndRemoveUntil(
                                                                              context,
                                                                              MaterialPageRoute<void>(builder: (BuildContext context) => const IsmartHomepage()),
                                                                              ModalRoute.withName(AppRoutes.ismartHomepage),
                                                                            );
                                                                          },
                                                                          child: RedeemDetailedHistory(
                                                                              onTap: () {
                                                                                Navigator.pushAndRemoveUntil(
                                                                                  context,
                                                                                  MaterialPageRoute<void>(builder: (BuildContext context) => const IsmartHomepage()),
                                                                                  ModalRoute.withName(AppRoutes.ismartHomepage),
                                                                                );
                                                                              },
                                                                              state: coinToCashbackSubmitController.status,
                                                                              stateMsg: translation(context).transactionFailedExclamation,
                                                                              cashOrCoinHistory: "Coin",
                                                                              data1: coinToCashbackSubmitController.remarks,
                                                                              data2: coinsController.text,
                                                                              data3: "",
                                                                              transactionType: "Cashback",
                                                                              data4: dateDetails,
                                                                              data5: ""),
                                                                        )));
                                                      }
                                                      if (coinToCashbackSubmitController
                                                              .status ==
                                                          "Success") {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PopScope(
                                                                          canPop:
                                                                              false,
                                                                          onPopInvoked:
                                                                              (didPop) {
                                                                            Navigator.pushAndRemoveUntil(
                                                                              context,
                                                                              MaterialPageRoute<void>(builder: (BuildContext context) => const IsmartHomepage()),
                                                                              ModalRoute.withName(AppRoutes.ismartHomepage),
                                                                            );
                                                                          },
                                                                          child: RedeemDetailedHistory(
                                                                              onTap: () {
                                                                                Navigator.pushAndRemoveUntil(
                                                                                  context,
                                                                                  MaterialPageRoute<void>(builder: (BuildContext context) => const IsmartHomepage()),
                                                                                  ModalRoute.withName(AppRoutes.ismartHomepage),
                                                                                );
                                                                              },
                                                                              state: coinToCashbackSubmitController.status,
                                                                              stateMsg: translation(context).transactionSuccessfulExclamation,
                                                                              cashOrCoinHistory: "Coin",
                                                                              data1: coinToCashbackSubmitController.remarks,
                                                                              data2: cashbackController.coinsForCashback.toString(),
                                                                              data3: translation(context).coinsRedeemed,
                                                                              transactionType: "Cashback",
                                                                              data4: dateDetails,
                                                                              data5: coinToCashbackSubmitController.transactionId),
                                                                        )));
                                                      }
                                                    }
                                                  },
                                                  child: Text(
                                                    translation(context).yes,
                                                    style: GoogleFonts.poppins(
                                                      color:
                                                          AppColors.lightWhite,
                                                      fontSize:
                                                          14 * textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.10,
                                                    ),
                                                  ));
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  isEnabled: isButtonEnabled,
                  buttonText: "Confirm",
                  containerBackgroundColor: AppColors.lightWhite1,
                )
            ],
          ),
        ),
      ),
    );
  }
}
