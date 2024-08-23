import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/network_management_model/dealer_electrician_details_model.dart';
import '../../../../../state/contoller/dealer_electrician_view_detailController.dart';
import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../dealer_electrician_details.dart';
import 'common_network_utils.dart';
import 'dealer_electrician_view_list_item.dart';

class DealerElectricianViewListPage extends StatefulWidget {
  final String selectedUserType;
  final String searchString;

  const DealerElectricianViewListPage(this.selectedUserType, this.searchString,
      {super.key});

  @override
  State<DealerElectricianViewListPage> createState() =>
      _DealerElectricianViewListPageState();
}

class _DealerElectricianViewListPageState
    extends State<DealerElectricianViewListPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<DealerElectricianDetail> dealerElectricianList = [];
  UserDataController userController = Get.find();

  DealerElectricianViewDetailsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    final variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    var textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Obx(() {
      dealerElectricianList.clear();
      if (widget.selectedUserType == UserType.dealer) {
        controller.dealerElectricianStatusList.forEach((state) {
          String query = widget.searchString.toLowerCase();
          String code = state.code!.toLowerCase();
          String name = (state.name ?? "").toLowerCase();
          String number = (state.phoneNo ?? "").toLowerCase();
          if (code.contains(query) ||
              name.contains(query) ||
              number.contains(query)) {
            dealerElectricianList.add(state);
          }
        });
      } else {
        controller.dealerElectricianStatusList.forEach((state) {
          String query = widget.searchString.toLowerCase();
          String? code = state.code?.toLowerCase();
          String name = (state.name ?? "").toLowerCase();
          String number = (state.phoneNo ?? "").toLowerCase();
          if (code?.contains(query) == true ||
              name.contains(query) ||
              number.contains(query)) {
            dealerElectricianList.add(state);
          }
        });
      }

      return Obx(() => controller.isApiLoading.value
          ? Center(
              child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                      left: 20 * variablePixelWidth,
                      top: 120 * variablePixelHeight,
                      right: 20 * variablePixelWidth),
                  child: const CircularProgressIndicator()),
            )
          : Container(
              margin: EdgeInsets.only(
                  left: 24 * variablePixelWidth,
                  right: 24 * variablePixelWidth),
              child: (dealerElectricianList.length == 0)
                  ? Center(
                      child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                          left: 20 * variablePixelWidth,
                          top: 120 * variablePixelHeight,
                          right: 20 * variablePixelWidth),
                      child: Text(
                          /*translation(context).noDataFound*/
                          (!controller.isActive.value &&
                                  !controller.isInActive.value)
                              ? (controller.userType == UserType.dealer)
                                  ? translation(context).dealerListNoFilter
                                  : translation(context).electricianListNoFilter
                              : translation(context).emptyData,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14.0 * textMultiplier,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackText,
                          )),
                    ))
                  : ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      prototypeItem: DealerElectricianViewListItemPage(dealerElectricianList[0], 0, (p0) => null),
                      padding: EdgeInsets.only(top: 10 * variablePixelHeight),
                      itemCount: dealerElectricianList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (viewContext, index) {
                        return DealerElectricianViewListItemPage(
                          dealerElectricianList[index],
                          index,
                          (selectedItemIndex) async {
                            // _handleDateSelected(value, type);
                            if (userController.isPrimaryNumberLogin) {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DealerElectricianDetails(
                                              selectedUserType:
                                              widget.selectedUserType,
                                                id:widget
                                                    .selectedUserType ==
                                                    UserType.electrician?
                                                  dealerElectricianList[index]
                                                      .code!:dealerElectricianList[index].code!
                                          )));
                              controller.getDealerElectricanList();
                            }
                          },
                        );
                      }),
            ));
    });
  }
}
