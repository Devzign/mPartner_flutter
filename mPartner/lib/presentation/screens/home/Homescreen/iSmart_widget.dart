import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../../state/contoller/cash_summary_controller.dart';
import '../../../../state/contoller/coins_summary_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/coin_with_image_widget.dart';
import '../../../widgets/rupee_with_sign_widget.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../ismart/cash_coins_history/cash_transactions_list_screen.dart';
import '../../ismart/cash_coins_history/coin_transactions_list_screen.dart';
import '../../ismart/ismart_homepage/ismart_homepage.dart';
import '../widgets/section_headings.dart';
import '../../ismartdisclaimer/ismart_disclaimer_alert.dart';
import 'secondary_user_access_denied_sheet.dart';

class iSmartWidget extends StatefulWidget {
  const iSmartWidget({super.key});

  @override
  State<iSmartWidget> createState() => _iSmartWidgetState();
}

class _iSmartWidgetState extends State<iSmartWidget> {
  String totalCoins = "100";
  String totalCash = "1000";
  var userType;
  UserDataController controller = Get.find();
  CoinsSummaryController coinsSummaryController = Get.find();
  CashSummaryController cashSummaryController = Get.find();

  @override
  void initState() {
    super.initState();
    fetchCoinsData();
    //fetchCashData();
    fetchUserType();
  }

  void fetchUserType() async {
    var user = controller.userType;

    setState(() {
      userType = user;
    });
  }

  void fetchCoinsData() async {
    var coins = coinsSummaryController.availableCoins;
    setState(() {
      totalCoins = coins;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserDataController userDataController= Get.find();
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultipler = DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
          vertical: variablePixelHeight * 16,
          horizontal: variablePixelWidth * 24),
      decoration: const BoxDecoration(color: AppColors.lumiLight5),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SectionHeading(text: translation(context).iSmartScanAndEarn, onPressed: (){
              // if (userDataController.isPrimaryNumberLogin){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ISmartDisclaimerAlert(screen: IsmartHomepage())),
              );
            // }
            // else{
            //   showSecondaryUserAccessDeniedBottomSheet(context, variablePixelHeight, variablePixelWidth, textMultiplier, pixelMultipler);
            // };
           },),
            const VerticalSpace(height: 16),
            if (userType != null && userType == 'DISTY')
              InkWell(
                onTap: (){
                  // if(userDataController.isPrimaryNumberLogin){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IsmartHomepage()));
                  // }
                  // else{
                  //   showSecondaryUserAccessDeniedBottomSheet(context, variablePixelHeight, variablePixelWidth, textMultiplier, pixelMultipler);
                  // }
                },
                child: Container(
                  padding: EdgeInsets.only(
                      left: 20 * variablePixelWidth,
                      top: 12 * variablePixelHeight,
                      bottom: 12 * variablePixelHeight),
                  alignment: Alignment.centerLeft,
                  height: variablePixelHeight * 86,
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: AppColors.lightWhite1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8 * pixelMultipler)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GetBuilder<CashSummaryController>(
                            builder: (_) {
                              return RupeeWithSignWidget(
                                cash: double.parse(
                                    cashSummaryController.availableCash),
                                color: AppColors.lumiBluePrimary,
                                size: 18,
                                weight: FontWeight.w600,
                                width: 300,
                              );
                            },
                          ),
                        ],
                      ),
                      Text(
                        translation(context).availableCash,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkGrey,
                          fontSize: 14 * textMultiplier,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            if (userType != null && userType == "DEALER")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      // if(userDataController.isPrimaryNumberLogin){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IsmartHomepage()));
                              // }
                      // else {
                      //   showSecondaryUserAccessDeniedBottomSheet(context, variablePixelHeight, variablePixelWidth, textMultiplier, pixelMultipler);
                      // }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      // height: variablePixelHeight * 86,
                      width: variablePixelWidth * 165,
                      padding: EdgeInsets.only(
                          top: 12 * variablePixelHeight,
                          bottom: 12 * variablePixelHeight),
                      decoration: ShapeDecoration(
                        color: AppColors.lightWhite1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8 * pixelMultipler)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (totalCoins != null)
                                GetBuilder<CoinsSummaryController>(builder: (_) {
                                  return CoinWithImageWidget(
                                    // coin: double.parse("12345678901234"),
                                    coin: double.parse(coinsSummaryController.availableCoins.replaceAll(",", "")),
                                    width: 160,
                                    weight: FontWeight.w600,
                                    size: 18,
                                    color: AppColors.lumiBluePrimary,
                                  );
                                }),
                            ],
                          ),
                          Text(
                            translation(context).availableCoins,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 14 * textMultiplier,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      // if(userDataController.isPrimaryNumberLogin) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IsmartHomepage()));
                      // }
                      // else {
                      //   showSecondaryUserAccessDeniedBottomSheet(context, variablePixelHeight, variablePixelWidth, textMultiplier, pixelMultipler);
                      // }
                    },
                    child: Container(
                      // height: variablePixelHeight * 86,
                      width: variablePixelWidth * 165,
                      padding: EdgeInsets.only(
                          top: 12 * variablePixelHeight,
                          bottom: 12 * variablePixelHeight),
                      decoration: ShapeDecoration(
                        color: AppColors.lightWhite1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8 * pixelMultipler)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GetBuilder<CashSummaryController>(
                                builder: (_) {
                                  return RupeeWithSignWidget(
                                      // cash: double.parse("12345678901234"),
                                      cash: double.parse(
                                          cashSummaryController.availableCash),
                                      color: AppColors.lumiBluePrimary,
                                      size: 18,
                                      weight: FontWeight.w600,
                                      width: 160);
                                },
                              ),
                            ],
                          ),
                          Text(
                            translation(context).availableCash,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 14 * textMultiplier,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            VerticalSpace(height: 16),
            GestureDetector(
              onTap: (){
                controller.isFromHomePageRoute=true;
                Navigator.pushNamed(context, AppRoutes.registerSales);
              },
              child: Container(
                height: variablePixelHeight * 61 + textMultiplier * 28,
                width: variablePixelWidth * 345,
                padding: EdgeInsets.only(left: variablePixelWidth * 20),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: AppColors.lightWhite1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12 * pixelMultipler),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: variablePixelHeight * 19),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translation(context).registerSales,
                            style: GoogleFonts.poppins(
                              color: AppColors.lumiBluePrimary,
                              fontSize: 16 * textMultiplier,
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                          VerticalSpace(height: 16),
                          Text(
                            translation(context).earnRewardsOnEveryScan,
                            style: GoogleFonts.rubik(
                              color: AppColors.darkGrey,
                              fontSize: 12 * textMultiplier,
                              fontWeight: FontWeight.w400,
                              height: 0.15,
                              letterSpacing: -0.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Lottie.asset('assets/mpartner/json_assets/img_qr_scaning.json'),
                  ],
                ),
              ),
            )
          ]),
    );
  }
}
