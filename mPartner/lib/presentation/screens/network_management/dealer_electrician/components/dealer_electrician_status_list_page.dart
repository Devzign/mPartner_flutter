import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/network_management_model/dealer_electrician_status_data_model.dart';
import '../../../../../state/contoller/new_dealer_electrician_status_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/common_bottom_sheet.dart';
import 'common_network_utils.dart';
import 'dealer_electrician_status_list_item_page.dart';
import 'varification_status_details.dart';

class DealerElectricianStatusListPage extends StatefulWidget {
  final String selectedUserType;
  final String searchString;

  const DealerElectricianStatusListPage(
      this.selectedUserType, this.searchString,
      {super.key});

  @override
  State<DealerElectricianStatusListPage> createState() =>
      _DealerElectricianStatusListPageState();
}

class _DealerElectricianStatusListPageState
    extends State<DealerElectricianStatusListPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<StatusData> filteredStateList = [];

  NewDealerElectricianStatusController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    final variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Obx(() {
      filteredStateList.clear();

      controller.dealerElectricianStatusList.forEach((state) {
        String query = widget.searchString.toLowerCase();
        String code = state.dealerCode!.toLowerCase();
        String name = state.dealerName!.toLowerCase();
        String number = state.phoneNo!.toLowerCase();
        if (code.contains(query) ||
            name.contains(query) ||
            number.contains(query)) {
          filteredStateList.add(state);
        }
      });

      var textMultiplier =
          DisplayMethods(context: context).getTextFontMultiplier();
   var h =
          DisplayMethods(context: context).getVariablePixelHeight();
   var w =
          DisplayMethods(context: context).getVariablePixelWidth();

      return Obx(() => controller.isApiLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : (filteredStateList.length == 0)
              ? Center(
                  child: Container(
                    alignment: Alignment.center,
                    padding:  EdgeInsets.only(left: 20*w,right:20*w ),
                    child: Text(
                        (!controller.isActive.value &&
                                !controller.isPending.value &&
                                !controller.isRejected.value)
                            ? (widget.selectedUserType == UserType.dealer)
                                ? translation(context).dealerStatusNoFilter
                                : translation(context).electricianStatusNoFilter
                            : translation(context).emptyData,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14.0 * textMultiplier,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackText,
                        )),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(
                      left: 24 * variablePixelWidth,
                      right: 24 * variablePixelWidth),
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: 10 * variablePixelHeight),
                      itemCount: filteredStateList.length,
                      itemBuilder: (context, index) {
                        return DealerElectricianStatusListItemPage(
                          filteredStateList[index],
                          index,
                          (selectedItemIndex) {
                            // _handleDateSelected(value, type);
                            CommonBottomSheet.show(
                                context,
                                VerificationStatusDetailsWidget(
                                    onItemSelected: (selectedState) {
                                      Navigator.of(context).pop();
                                    },
                                    filteredStateList: filteredStateList,
                                    contentTiltle:
                                        translation(context).verificationStatus,
                                    selectedIndex: selectedItemIndex),
                                variablePixelHeight,
                                variablePixelWidth);
                          },
                        );
                      }),
                ));
    });
  }
}
