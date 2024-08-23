import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../data/models/hkva_item_model.dart';
import '../../../widgets/common_confirmation_alert.dart';
import 'components/list_of_button.dart';
import 'components/no_of_battery_message.dart';
import 'components/pre_sale_combo_card.dart';
import 'components/sale_registered.dart';
import 'components/verify_sales.dart';
import '../../../../data/models/tertiary_sales_userinfo_model.dart';
import '../../userprofile/user_profile_widget.dart';
import '../../../widgets/headers/back_button_header_widget.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../../../state/contoller/tertiary_sales_combo_controller.dart';
 
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/common_button.dart';
 
class ComboScreen extends StatelessWidget {
  ComboScreen({
    super.key,
  });
  TertiarySalesHKVAcombo controller = Get.find();
 
  // final UserInfo userInfo;
 
  @override
  Widget build(BuildContext context) {
    // controller.intialize(jsonResponse);
    // final String serialNo =
    //     ModalRoute.of(context)!.settings.arguments as String;
    // print(serialNo);
    TertiarySalesUserInfo userInfo = controller.userInfo.value;
    List<HkvaItemModel> dataFromAPI = controller.hkvaItemModels;
    print("data from API working? ${dataFromAPI}");
 
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
 
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Obx(() => WillPopScope(
          onWillPop: () async {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return CommonConfirmationAlert(
                  confirmationText1: translation(context).goingBackWillDelete,
                  confirmationText2: translation(context).sureToContinue,
                  onPressedYes: () {
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName(AppRoutes.tertiarySales));
                  },
                );
              },
            );
            return false;
          },
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24 * w),
              child: SafeArea(
                  child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 24 * h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          padding: EdgeInsets.only(right: 12 * w),
                          constraints: const BoxConstraints(),
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: Icon(
                            Icons.arrow_back_outlined,
                            color: AppColors.titleColor,
                            size: 24 * r,
                          ),
                          onPressed: () => {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return CommonConfirmationAlert(
                                  confirmationText1:
                                  translation(context).goingBackWillDelete,
                                  confirmationText2:
                                  translation(context).sureToContinue,
                                  onPressedYes: () {
                                    Navigator.of(context).popUntil(
                                        ModalRoute.withName(AppRoutes.tertiarySales));
                                  },
                                );
                              },
                            ),
                          },
                        ),
                        Expanded(
                          child: Text(
                            translation(context).tertiarySaleRegistration,
                            softWrap: true,
                            style: GoogleFonts.poppins(
                              color: AppColors.titleColor,
                              fontSize: 22 * f,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  UserProfileWidget(
                    top: 28,
                    bottom: 24,
                    horizontalPadding: 0,
                  ),
                  SaleRegistered(
                    text1: translation(context).saleRegisteringTo,
                    text2: "${userInfo.name} (${userInfo.mobileNumber})",
                  ),
                  const VerticalSpace(height: 16),
                  Expanded(
                      child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: dataFromAPI.length,
                        itemBuilder: (context, index) {
                          if (dataFromAPI[index].id != 0) {
                            return PreSaleComboCard(
                              showCoinsAndCash: false,
                              productType: dataFromAPI[index].productType,
                              serialNumber: dataFromAPI[index].serial,
                              productName: dataFromAPI[index].model,
                              remark: dataFromAPI[index].readMore,
                              status: dataFromAPI[index].status,
                              coins: dataFromAPI[index].tentativeCoins,
                              cashback: dataFromAPI[index].tentativePoints,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      NoOfBatteryMessage(
                        number: (dataFromAPI.isNotEmpty
                            ? (dataFromAPI[0].capacity / 12).round().toString()
                            : "4"),
                      ),
                      const VerticalSpace(height: 4),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: dataFromAPI.length,
                        itemBuilder: (context, index) {
                          if (dataFromAPI[index].id == 0) {
                            return AddBatteryButton(
                              number: dataFromAPI[index]
                                  .productType
                                  .toString()
                                  .split(": ")[1],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  )
                    // : const Center(child: CircularProgressIndicator()),
                  ),
                  CommonButton(
                    onPressed: () => {
                      controller.postCreateOtp(),
                      showModalBottomSheet(
                          enableDrag: false,
                          isScrollControlled: true,
                          isDismissible: false,
                          useSafeArea: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(28 * r),
                                  topRight: Radius.circular(28 * r))),
                          showDragHandle: false,
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (BuildContext ctx) {
                            print("------>${controller.isLoading.value}");
                            return HkvaVerifySaleSheet();
                          }),
                    },
                    isEnabled: controller.isVerifiable(),
                    buttonText: translation(context).verifySale,
                    containerBackgroundColor: Colors.white,
                    horizontalPadding: 0,
                    topPadding: 20,
                    bottomPadding: 12,
                  ),
                  
                ],
              )),
            ),
          ),
        ));
  }
}
