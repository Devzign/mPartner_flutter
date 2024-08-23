import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../state/contoller/app_setting_value_controller.dart';
import '../../../state/contoller/create_dealer_electrician_controller.dart';
import '../../../state/contoller/dealer_electrician_view_detailController.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/bottomNavigationBar/bottom_navigation_bar.dart';
import '../../widgets/headers/ismart_header_widget.dart';
import '../base_screen.dart';
import '../userprofile/user_profile_widget.dart';
import 'dealer_electrician/add_firm_personal_details.dart';
import 'dealer_electrician/components/common_network_utils.dart';
import 'dealer_electrician/components/custom_check_box.dart';
import 'dealer_electrician/components/custom_dialog.dart';
import 'dealer_electrician/components/dealer_electrician_view_list.dart';
import 'dealer_electrician/components/dropddown_widget.dart';
import 'dealer_electrician/new_dealer_electrician_status_screen.dart';

class NetworkHomePage extends StatefulWidget {
  const NetworkHomePage({super.key});

  @override
  State<NetworkHomePage> createState() => _NetworkHomePageState();
}

class _NetworkHomePageState extends BaseScreenState<NetworkHomePage> {
  CreateDealerElectricianController controller = Get.find();
  DealerElectricianViewDetailsController viewController = Get.find();
  final TextEditingController _searchController = TextEditingController();
  UserDataController userController = Get.find();
  AppSettingValueController appSettingValueController = Get.find();

  @override
  void initState() {
    viewController.isActive.value = true;
    viewController.isInActive.value = true;
    // logger.e("RA_TYPE:: controller: ${controller.userType} viewController: ${viewController.userType} userController: ${userController.userType}");
    // logger.e("RA_TYPE:: ");
    // logger.e("RA_TYPE:: ");
    // if ((controller.userType.isEmpty || viewController.userType.isEmpty)) {
      if (userController.userType == "DEALER") {
        controller.userType = UserType.electrician;
        viewController.userType = UserType.electrician;
      } else {
        controller.userType = UserType.dealer;
        viewController.userType = UserType.dealer;
      }
    // }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await viewController.getDealerElectricanList();
    });
    super.initState();
  }

  var iconContainerHeight = 55.00;
  ScrollController scrollController = ScrollController();

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    var variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    CustomDialog.initLoadingDialog(context);

    return WillPopScope(
      onWillPop: () async {
        //Navigator.pop(context);
        Navigator.pushNamed(context, AppRoutes.homepage);
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                  child:
                      ISmartHeaderWidget(title: translation(context).network),
                ),
                UserProfileWidget(top: 24 * variablePixelHeight),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      SizedBox(
                        height: 15 * variablePixelHeight,
                      ),
                      (userController.userType == "DEALER")
                          ? Container()
                          : Container(
                              margin: EdgeInsets.only(
                                left: 24 * variablePixelWidth,
                                right: 24 * variablePixelWidth,
                              ),
                              child: DropdownWidget(
                                  textEditController: TextEditingController(),
                                  errorText: "",
                                  labelText: translation(context).userType,
                                  hintText: "",
                                  userType: controller.userType,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  dropDownType: "user_type",
                                  onDateSelected: (value, type) {
                                    // _handleDateSelected(value, type);
                                  },
                                  onDropDownSelected: (value, type) {
                                    controller.setDefaultControllerValue();
                                    viewController.isActive.value = true;
                                    viewController.isInActive.value = true;
                                    setState(() {
                                      _searchController.text = "";
                                      controller.userType = value.toString();
                                      viewController.userType =
                                          value.toString();
                                    });
                                    viewController.getDealerElectricanList();
                                  },
                                  onDealerSelected: (value, type) {
                                    // _handleDealerSelected(value, type);
                                  }),
                            ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 24 * variablePixelWidth,
                          right: 24 * variablePixelWidth,
                          top: 10 * variablePixelHeight,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (controller.userType == UserType.dealer)
                                  ? translation(context).dealersList
                                  : translation(context).electricianList,
                              style: GoogleFonts.poppins(
                                color: AppColors.blackText,
                                fontSize: 20 * textMultiplier,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 24 * variablePixelWidth,
                            top: 5 * variablePixelWidth,
                            right: 24 * variablePixelWidth,
                            bottom: 10 * variablePixelHeight),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (controller.userType == UserType.dealer)
                                  ? translation(context).newDealersStatus
                                  : translation(context).newElectricianStatus,
                              style: GoogleFonts.poppins(
                                color: AppColors.blackText,
                                fontSize: 14 * textMultiplier,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewDealerElectricianStatusScreen(
                                                  selectedUserType:
                                                      controller.userType)));
                                },
                                child: Text(
                                  translation(context).view,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.lumiBluePrimary,
                                    fontSize: 14 * textMultiplier,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 24 * variablePixelWidth,
                            right: 24 * variablePixelWidth),
                        constraints: BoxConstraints(
                            maxHeight: variablePixelHeight * 100),
                        height: variablePixelHeight * 50,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(
                              color: AppColors.grayText.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(
                              8 * variablePixelMultiplier),
                        ),
                        child: TextField(
                          controller: _searchController,
                          maxLength: 50,
                          onChanged: (value) {
                            /* if(mounted){
                      return;
                    }*/
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.grayText,
                            ),
                            hintText: translation(context).search,
                            hintStyle: TextStyle(color: AppColors.grayText),
                            border:
                                InputBorder.none, // Remove the default border
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 24 * variablePixelWidth,
                            right: 24 * variablePixelWidth,
                            top: 10 * variablePixelHeight),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(
                              () => InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  bool value = !viewController.isActive.value;
                                  viewController.isActive.value = value;
                                  viewController.getDealerElectricanList();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomCheckbox(
                                      side: BorderSide(
                                          color: AppColors.grayText
                                              .withOpacity(0.7),
                                          width: 1.5),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      value: viewController.isActive.value,
                                      activeColor: AppColors.lumiBluePrimary,
                                      onChanged: (value) {
                                        viewController.isActive.value =
                                            value ?? false;
                                        viewController
                                            .getDealerElectricanList();
                                      },
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 10 * variablePixelWidth),
                                      child: Text(
                                        translation(context).active,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.0 * textMultiplier,
                                          letterSpacing: 0.10,
                                          height: 0.10,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.blackText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 100 * variablePixelWidth),
                            Obx(
                              () => InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  viewController.isInActive.value =
                                      !viewController.isInActive.value;
                                  viewController.getDealerElectricanList();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomCheckbox(
                                      side: BorderSide(
                                          color: AppColors.grayText
                                              .withOpacity(0.7),
                                          width: 1.5),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      value: viewController.isInActive.value,
                                      activeColor: AppColors.lumiBluePrimary,
                                      onChanged: (value) {
                                        viewController.isInActive.value =
                                            value ?? false;
                                        // CustomDialog.dialogStyle('Submitting data...');
                                        viewController
                                            .getDealerElectricanList();
                                      },
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 10 * variablePixelWidth),
                                      child: Text(
                                        translation(context).inActive,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.0 * textMultiplier,
                                          letterSpacing: 0.10,
                                          height: 0.10,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.blackText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DealerElectricianViewListPage(
                          controller.userType, _searchController.text)
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigation(
            currentIndex:appSettingValueController.solarviable=="1"? 3:2,
            onTabTapped: (value) => appSettingValueController.solarviable=="1"? 3:2,
          ),
          floatingActionButton: (!userController.isPrimaryNumberLogin)
              ? Container()
              : Container(
                  width: 165 * variablePixelWidth,
                  height: 56 * variablePixelHeight,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      controller.setDefaultControllerValue();
                      controller.getGovtIdTypeList();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateFirmPersonalDetails(
                                  selectedUserType: controller.userType)));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(100 * variablePixelMultiplier),
                    ),
                    backgroundColor: AppColors.darkBlue,
                    icon: const Icon(
                      Icons.add,
                      color: AppColors.white,
                    ),
                    label: Text(
                      controller.userType == UserType.dealer
                          ? translation(context).newDealer
                          : translation(context).newElectrician,
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }
}

enum ImageTypeData {
  pan,
  govt_doc_front,
  govt_doc_back,
}
