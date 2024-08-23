import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../data/models/get_dealer_list_model.dart';
import '../../../../../../state/contoller/dealer_list_controller.dart';
import '../../../../../../state/contoller/dealer_wise_summary_controller.dart';
import '../../../../../../state/contoller/secondary_report_distributor_controller.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../../widgets/common_button.dart';
import '../../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../../widgets/verticalspace/vertical_space.dart';
import '../../../widgets/user_checkbox_widget.dart';

class UserListFilterWidget extends StatefulWidget {
  final List<Dealer> dealerList;
  final void Function(int selectedCount) updateFilterText;

  const UserListFilterWidget(
      {Key? key, required this.dealerList, required this.updateFilterText})
      : super(key: key);

  @override
  State<UserListFilterWidget> createState() => _UserListFilterWidgetState();
}

class _UserListFilterWidgetState extends State<UserListFilterWidget> {
  bool? value = false;
  TextEditingController searchController = TextEditingController();
  DealerSummaryController dealerSummaryController = Get.find();
  SecondaryReportDistrubutorController dealerWiseListController = Get.find();

  String searchText = "";
  late List<Dealer> dealerList;
  late List<Dealer> filteredDealerList;
  List<String> checkedDealerId = [];
  bool isSelectAll = true;
  String checkedDealerIdString = "";
  DealerList dealerListController = Get.find();

  @override
  void initState() {
    super.initState();
    dealerList = widget.dealerList;
    filteredDealerList = dealerList;
    checkedDealerIdString = getCheckedDealerIdString();
    isSelectAll = dealerListController.dealersSelected.isEmpty;
    if (!isSelectAll) {
      checkedDealerId = dealerListController.dealersSelected.value.split(',');
    }
  }

  void filterDealers() {
    if (searchText.isEmpty) {
      filteredDealerList = dealerList;
    } else {
      filteredDealerList = dealerList
          .where((dealer) =>
              dealer.dealerName
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              dealer.dlr_Sap_Code
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    }
  }

  void onCheckBoxChanged(bool isChecked, String disCode) {
    setState(() {
      if (isChecked) {
        if (!checkedDealerId.contains(disCode)) {
          checkedDealerId.add(disCode);
        }
      } else {
        if (isSelectAll) {
          isSelectAll = false;
          for (var dealer in dealerList) {
            if (!checkedDealerId.contains(dealer.dlr_Sap_Code)) {
              checkedDealerId.add(dealer.dlr_Sap_Code);
            }
          }
          if (checkedDealerId.contains(disCode)) {
            checkedDealerId.remove(disCode);
          }
        } else {
          checkedDealerId.remove(disCode);
        }
      }
      checkedDealerIdString = getCheckedDealerIdString();
    });
  }

  String getCheckedDealerIdString() {
    return checkedDealerId.join(',');
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          Container(
            height: 717 * h,
            padding: EdgeInsets.symmetric(horizontal: 24 * w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (checkedDealerIdString.isNotEmpty) {
                      dealerSummaryController
                          .fetchSecondaryReportSummaryDistributor(
                              dealerCode: checkedDealerIdString);
                    }
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                ),
                const VerticalSpace(height: 12),
                Container(
                  child: Text(
                    translation(context).chooseYourDealers,
                    style: GoogleFonts.poppins(
                      color: AppColors.titleColor,
                      fontSize: 20 * f,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.50,
                    ),
                  ),
                ),
                VerticalSpace(height: 16),
                Container(
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: AppColors.dividerGreyColor,
                      ),
                    ),
                  ),
                ),
                VerticalSpace(height: 20),
                Container(
                  height: 56 * h,
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: AppColors.searchBlue,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: AppColors.white_234),
                      borderRadius: BorderRadius.circular(8 * r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20 * w),
                        child: Icon(
                          Icons.search,
                          color: AppColors.darkGreyText,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          maxLength: 50,
                          onChanged: (value) {
                            setState(() {
                              searchText = value;
                              filterDealers();
                            });
                          },
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: translation(context).search,
                            hintStyle: GoogleFonts.poppins(
                              color: AppColors.hintColor,
                              fontSize: 16.0 * f,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.poppins(
                            color: AppColors.blackText,
                            fontSize: 16.0 * f,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalSpace(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${filteredDealerList.length} dealers listed",
                      style: GoogleFonts.poppins(
                        color: AppColors.hintColor,
                        fontSize: 14 * f,
                        fontWeight: FontWeight.w600,
                        height: 0.12,
                        letterSpacing: 0.50,
                      ),
                    ),
                    Spacer(),
                    isSelectAll
                        ? Text(
                            "${dealerList.length}/${dealerList.length} selected",
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 14 * f,
                              fontWeight: FontWeight.w500,
                              height: 0.12,
                              letterSpacing: 0.50,
                            ),
                          )
                        : Text(
                            "${checkedDealerId.length}/${dealerList.length} selected",
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 14 * f,
                              fontWeight: FontWeight.w500,
                              height: 0.12,
                              letterSpacing: 0.50,
                            ),
                          ),
                    const VerticalSpace(height: 12),
                  ],
                ),
                const VerticalSpace(height: 16),
                GestureDetector(
                  onTap: () {
                    bool value = !isSelectAll;
                    setState(() {
                      if (value == false) {
                        checkedDealerId = [];
                        checkedDealerIdString = "";
                      }
                      isSelectAll = value!;
                      checkedDealerIdString = "";
                      widget.updateFilterText(filteredDealerList.length);
                      dealerListController.dealersSelected.value =
                          checkedDealerIdString;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 24 * h,
                          width: 24 * w,
                          child: Checkbox(
                            value: isSelectAll,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == false) {
                                  checkedDealerId = [];
                                  checkedDealerIdString = "";
                                }
                                isSelectAll = value!;
                                checkedDealerIdString = "";
                              });
                            },
                            checkColor: AppColors.lightWhite1,
                            activeColor: AppColors.lumiBluePrimary,
                          )),
                      const HorizontalSpace(width: 4),
                      Text(
                        translation(context).selectAll,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkText2,
                          fontSize: 14 * f,
                          fontWeight: FontWeight.w600,
                          height: 0.12,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalSpace(height: 16),
                Container(
                  height: 418 * h,
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredDealerList.length,
                      itemBuilder: (context, index) {
                        Dealer dealer = filteredDealerList[index];
                        return UserCheckBoxWidget(
                          dealer: dealer,
                          isSelected: isSelectAll ||
                              checkedDealerId.contains(dealer.dlr_Sap_Code),
                          onCheckBoxChanged: onCheckBoxChanged,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(children: [
                Expanded(
                  child: CommonButton(
                    onPressed: () {
                      if (checkedDealerId.length > 0 || isSelectAll) {
                        setState(() {
                          isSelectAll = true;
                          checkedDealerIdString = "";
                          widget.updateFilterText(filteredDealerList.length);
                          dealerListController.dealersSelected.value =
                              checkedDealerIdString;
                          dealerSummaryController
                              .fetchSecondaryReportSummaryDistributor(
                                  dealerCode: checkedDealerIdString,
                                  fromDate: dealerSummaryController.from.value,
                                  toDate: dealerSummaryController.to.value);
                          dealerWiseListController
                              .fetchSecondaryReportPdfDistributor(
                                  dealerCode: checkedDealerIdString);
                          Navigator.pop(context);
                        });
                      }
                    },
                    isEnabled: true,
                    containerBackgroundColor: AppColors.lightWhite1,
                    containerHeight: 48,
                    backGroundColor: AppColors.lightWhite1,
                    buttonText: translation(context).reset,
                    textColor: checkedDealerId.length > 0 || isSelectAll
                        ? AppColors.lumiBluePrimary
                        : AppColors.darkGreyText,
                  ),
                ),
                Expanded(
                  child: CommonButton(
                      onPressed: () {
                        if (checkedDealerIdString == "") {
                          widget.updateFilterText(filteredDealerList.length);
                        } else {
                          widget.updateFilterText(checkedDealerId.length);
                        }
                        dealerListController.dealersSelected.value =
                            checkedDealerIdString;
                        dealerWiseListController.customers.value =
                            checkedDealerIdString;
                        Navigator.pop(context);
                        dealerWiseListController
                            .applyFilter();

                      },
                      isEnabled: checkedDealerId.isNotEmpty || isSelectAll,
                      containerBackgroundColor: AppColors.lightWhite1,
                      containerHeight: 48,
                      buttonText: translation(context).submit),
                ),
              ]))
        ],
      ),
    );
  }
}
