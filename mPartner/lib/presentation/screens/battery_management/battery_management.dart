import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../data/models/battery_management_address_model.dart';
import '../../../data/models/battery_management_city_list.dart';
import '../../../data/models/battery_management_state_list_model.dart';
import '../../../state/contoller/battery_management_controller.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/utils.dart';
import '../../screens/battery_management/components/address_detail_widget.dart';
import '../../widgets/headers/header_widget_with_right_align_action_button.dart';
import '../../widgets/common_divider.dart';
import '../../widgets/verticalspace/vertical_space.dart';
import '../base_screen.dart';
import '../userprofile/user_profile_widget.dart';

class BatteryManagement extends StatefulWidget {
  const BatteryManagement({super.key});

  @override
  State<BatteryManagement> createState() => _BatteryManagementState();
}

class _BatteryManagementState extends BaseScreenState<BatteryManagement> {
  BatteryManagementController batteryManagementController = Get.find();
  TextEditingController textFieldControllerState = TextEditingController();
  TextEditingController textFieldControllerCity = TextEditingController();
  bool isStateFilled = false;
  String stateWithoutCapitalization = '';
  String cityWithoutCapitalization = '';
  List<dynamic> stateList = [];
  List<dynamic> cityList = [];
  List<Map<String, dynamic>> addressDetails = [];
  bool isAddressFound = true;

  @override
  void initState() {
    batteryManagementController.clearBatteryManagementController();
    fetchStateList();
    super.initState();
  }

  String capitalizeEachWord(String text) {
    List<String> words = text.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        // Special case for "And"
        if (words[i].toLowerCase() == 'and') {
          words[i] = '&';
        } else {
          words[i] =
              words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
        }
      }
    }
    return words.join(' ');
  }

  fetchStateList() {
    batteryManagementController.fetchBatteryManagementStateList().then((_) {
      if (batteryManagementController.batteryManagementStateList.isNotEmpty) {
        BatteryManagementStateListModel result =
            batteryManagementController.batteryManagementStateList.first;
        if (result.status == '200') {
          List<StateData> states = result.data.toList();
          for (var stateData in states) {
            stateList.add(stateData.disState);
          }
          print("stateList ${stateList}");
        } else {
          Utils().showToast("Error fetching State List", context);
        }
      } else {
        Utils().showToast("No data received or an error occurred.", context);
      }
    });
  }

  fetchAddressDetails() {
    batteryManagementController.clearBatteryManagementController();
    batteryManagementController
        .fetchBatteryManagementAddressList(
            stateWithoutCapitalization, cityWithoutCapitalization)
        .then((_) {
      if (batteryManagementController.batteryManagementAddressList.isNotEmpty) {
        BatteryManagementAddressModel result =
            batteryManagementController.batteryManagementAddressList.first;
        if (result.status == '200') {
          setState(() {
            addressDetails.clear();
          });
          List<AddressData> addresses = result.data.toList();
          for (var addressData in addresses) {
            Map<String, dynamic> jsonMap = {
              'dis_City': addressData.dis_City,
              'dis_Address1': addressData.dis_Address1,
              'dis_Address2': addressData.dis_Address2,
              'dis_District': addressData.dis_District,
              'dis_State': addressData.dis_State,
              'dis_ContactNo': addressData.dis_ContactNo,
            };
            setState(() {
              addressDetails.add(jsonMap);
              isAddressFound = true;
            });
          }
        } else {
          setState(() {
            isAddressFound = false;
          });
          Utils().showToast('No address present!', context);
        }
      } else {
        setState(() {
          isAddressFound = false;
        });
        Utils().showToast(
            "There are no addresses currently available for the specified city and state.",
            context);
      }
    });
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    TextStyle textStyle = GoogleFonts.poppins(
      color: AppColors.darkGrey,
      fontSize: 14 * textMultiplier,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.50 * variablePixelWidth,
    );
    OutlineInputBorder focusedBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
      borderSide: const BorderSide(color: Colors.grey),
    );
    OutlineInputBorder enabledBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
      borderSide: const BorderSide(color: Colors.grey),
    );
    TextStyle labelTextStyle = GoogleFonts.poppins(
      color: AppColors.darkGrey,
      fontSize: 12 * textMultiplier,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.40 * variablePixelWidth,
    );
    TextStyle hintTextStyle = GoogleFonts.poppins(
      color: AppColors.grayText,
      fontSize: 14 * textMultiplier,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.50 * variablePixelWidth,
    );
    TextStyle headingTextStyle = GoogleFonts.poppins(
      color: AppColors.titleColor,
      fontSize: 20 * textMultiplier,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.50 * variablePixelWidth,
    );
    TextStyle bottomSheetListStyle = GoogleFonts.poppins(
      color: AppColors.titleColor,
      fontSize: 16 * textMultiplier,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.50 * variablePixelWidth,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidgetWithRightAlignActionButton(text: translation(context).batteryManagement),
              UserProfileWidget(top: 8*variablePixelHeight),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 24 * variablePixelWidth,
                          right: 24 * variablePixelWidth),
                      child: Text(
                        translation(context).locateCollectionServiceCentre,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkGrey,
                          fontSize: 14 * textMultiplier,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.10 * variablePixelWidth,
                        ),
                      ),
                    ),
                    const VerticalSpace(height: 32),
                    Container(
                      height: 48 * variablePixelHeight,
                      margin: EdgeInsets.only(
                          left: 24 * variablePixelWidth,
                          right: 24 * variablePixelWidth),
                      child: TextField(
                        onTap: () {
                          setState(() {
                            isAddressFound = true;
                            addressDetails.clear();
                          });
                          textFieldControllerCity.text = '';
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            isDismissible: false,
                            enableDrag: false,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0 * pixelMultiplier),
                              ),
                            ),
                            builder: (context) => Container(
                              margin: EdgeInsets.fromLTRB(
                                  8 * variablePixelWidth,
                                  8 * variablePixelHeight,
                                  8 * variablePixelWidth,
                                  8 * variablePixelHeight),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Center(
                                      child: Container(
                                        height: 5 * variablePixelHeight,
                                        width: 50 * variablePixelWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                              12 * pixelMultiplier),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.black,
                                      size: 28 * pixelMultiplier,
                                    ),
                                  ),
                                  const VerticalSpace(height: 12),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 16.0 * variablePixelWidth),
                                    child: Text(
                                      translation(context).selectState,
                                      style: headingTextStyle,
                                    ),
                                  ),
                                  const VerticalSpace(height: 16),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 16 * variablePixelWidth),
                                    child: const CustomDivider(
                                        color: AppColors.dividerColor),
                                  ),
                                  const VerticalSpace(height: 16),
                                  Obx(() {
                                    if (batteryManagementController
                                        .isLoading.value) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return Container(
                                      height: 620 * variablePixelHeight,
                                      child: ListView.builder(
                                        itemCount: stateList.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(
                                                capitalizeEachWord(
                                                    stateList[index]),
                                                style: bottomSheetListStyle,
                                                softWrap: true),
                                            onTap: () {
                                              stateWithoutCapitalization =
                                                  stateList[index];
                                              textFieldControllerState.text =
                                                  capitalizeEachWord(
                                                      stateList[index]);
                                              setState(() {
                                                isStateFilled = true;
                                              });
                                              batteryManagementController
                                                  .clearBatteryManagementController();
                                              cityList.clear();
                                              batteryManagementController
                                                  .fetchBatteryManagementCityList(
                                                      stateWithoutCapitalization)
                                                  .then((_) {
                                                if (batteryManagementController
                                                    .batteryManagementCityList
                                                    .isNotEmpty) {
                                                  BatteryManagementCityListModel
                                                      result =
                                                      batteryManagementController
                                                          .batteryManagementCityList
                                                          .first;
                                                  if (result.status == '200') {
                                                    List<CityData> cities =
                                                        result.data.toList();
                                                    for (var cityData
                                                        in cities) {
                                                      cityList.add(
                                                          cityData.disCity);
                                                    }
                                                  } else {
                                                    setState(() {
                                                      isStateFilled = false;
                                                    });
                                                    Utils().showToast(
                                                        "Error fetching City List",
                                                        context);
                                                  }
                                                } else {
                                                  setState(() {
                                                    isStateFilled = false;
                                                  });
                                                  Utils().showToast(
                                                      "There are currently no cities listed for this state.",
                                                      context);
                                                }
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                  const VerticalSpace(height: 16),
                                ],
                              ),
                            ),
                          );
                        },
                        readOnly: true,
                        style: textStyle,
                        controller: textFieldControllerState,
                        decoration: InputDecoration(
                          labelText: translation(context).state,
                          hintText: translation(context).selectState,
                          focusedBorder: focusedBorderStyle,
                          enabledBorder: enabledBorderStyle,
                          labelStyle: labelTextStyle,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: hintTextStyle,
                          contentPadding: EdgeInsets.fromLTRB(
                              16 * variablePixelWidth,
                              5 * variablePixelHeight,
                              0,
                              0),
                          suffixIcon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.downArrowColor,
                          ),
                        ),
                      ),
                    ),
                    const VerticalSpace(height: 24),
                    Container(
                      height: 48 * variablePixelHeight,
                      margin: EdgeInsets.only(
                          left: 24 * variablePixelWidth,
                          right: 24 * variablePixelWidth),
                      child: TextField(
                        onTap: () {
                          addressDetails.clear();
                          if (isStateFilled) {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              isDismissible: false,
                              enableDrag: false,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0 * pixelMultiplier),
                                ),
                              ),
                              builder: (context) => Wrap(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        8 * variablePixelWidth,
                                        8 * variablePixelHeight,
                                        8 * variablePixelWidth,
                                        8 * variablePixelHeight),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Center(
                                            child: Container(
                                              height: 5 * variablePixelHeight,
                                              width: 50 * variablePixelWidth,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12 * pixelMultiplier),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.black,
                                            size: 28 * pixelMultiplier,
                                          ),
                                        ),
                                        const VerticalSpace(height: 12),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 16.0 * variablePixelWidth),
                                          child: Text(
                                            translation(context).selectCity,
                                            style: headingTextStyle,
                                          ),
                                        ),
                                        const VerticalSpace(height: 16),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 16 * variablePixelWidth),
                                          child: const CustomDivider(
                                              color: AppColors.dividerColor),
                                        ),
                                        const VerticalSpace(height: 16),
                                        Obx(() {
                                          if (batteryManagementController
                                              .isLoading.value) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          return Container(
                                            constraints: BoxConstraints(
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.74),
                                            height:
                                                (cityList.length * 48.0) + 25,
                                            child: ListView.builder(
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: cityList.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 16 *
                                                            variablePixelWidth,
                                                        right: 16 *
                                                            variablePixelWidth,
                                                        bottom: 4 *
                                                            variablePixelHeight,
                                                        top: 4 *
                                                            variablePixelHeight),
                                                    height: 44 *
                                                        variablePixelHeight,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 8 *
                                                              variablePixelHeight,
                                                          bottom: 8 *
                                                              variablePixelHeight),
                                                      child: Text(
                                                          capitalizeEachWord(
                                                              cityList[index]),
                                                          style:
                                                              bottomSheetListStyle,
                                                          softWrap: true),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    cityWithoutCapitalization =
                                                        cityList[index];
                                                    textFieldControllerCity
                                                            .text =
                                                        capitalizeEachWord(
                                                            cityList[index]);
                                                    Navigator.of(context).pop();
                                                    fetchAddressDetails();
                                                  },
                                                );
                                              },
                                            ),
                                          );
                                        }),
                                        const VerticalSpace(height: 16),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                        },
                        controller: textFieldControllerCity,
                        style: textStyle,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: translation(context).city,
                          hintText: translation(context).selectCity,
                          focusedBorder: focusedBorderStyle,
                          enabledBorder: enabledBorderStyle,
                          labelStyle: labelTextStyle,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: hintTextStyle,
                          contentPadding: EdgeInsets.fromLTRB(
                              16 * variablePixelWidth,
                              5 * variablePixelHeight,
                              0,
                              0),
                          suffixIcon: IgnorePointer(
                            ignoring: !isStateFilled,
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: isStateFilled
                                  ? AppColors.downArrowColor
                                  : AppColors.hintColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    textFieldControllerCity.text.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.only(
                                left: 24 * variablePixelWidth,
                                right: 24 * variablePixelWidth),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const VerticalSpace(height: 28),
                                Text(
                                  'Results (${addressDetails.length})',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkGrey,
                                    fontSize: 14 * textMultiplier,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.10 * variablePixelWidth,
                                  ),
                                ),
                                const CustomDivider(
                                    color: AppColors.dividerColor)
                              ],
                            ),
                          )
                        : Container(),
                    !isAddressFound
                        ? Container(
                            margin: EdgeInsets.only(
                                left: 24 * variablePixelWidth,
                                right: 24 * variablePixelWidth),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const VerticalSpace(height: 28),
                                Center(
                                  child: Text("No data Found",
                                      style: GoogleFonts.poppins(
                                        color: AppColors.darkGrey,
                                        fontSize: 14 * textMultiplier,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing:
                                            0.50 * variablePixelWidth,
                                      )),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    textFieldControllerCity.text.isNotEmpty
                        ? AddressDetailWidget(addressDetails: addressDetails)
                        : Container(),
                    const VerticalSpace(height: 16)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
