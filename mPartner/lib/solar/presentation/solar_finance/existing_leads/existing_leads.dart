import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../presentation/screens/network_management/dealer_electrician/components/custom_calender.dart';
import '../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../presentation/widgets/headers/back_button_header_widget.dart';
import '../../../../presentation/widgets/horizontalspace/horizontal_space.dart';
import '../../../../presentation/widgets/tab_widget.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../state/controller/finance_request_list_commercial_controller.dart';
import '../../../state/controller/finance_requests_lists_controller.dart';
import '../../../utils/solar_app_constants.dart';
import '../../common/heading_solar.dart';
import '../solar_finance_request/solar_finance_request_form.dart';
import 'existing_leads_tabs/commercial_tab.dart';
import 'existing_leads_tabs/residential_tab.dart';
import 'finance_status_filter.dart';

class ExistingLeads extends StatefulWidget {
  const ExistingLeads({super.key});

  @override
  State<ExistingLeads> createState() => _ExistingLeadsState();
}

class _ExistingLeadsState extends State<ExistingLeads> {
  TextEditingController searchController = TextEditingController();
  bool isFilterApplied = false;
  int initialIndex = 0;
  bool enableSearch = false;
  FinanceRequestsListController financeRequestsListController = Get.find();
  FinanceRequestsListCommercialController
      financeRequestsListCommercialController = Get.find();

  void updateFilterStatus(bool applied) {
    setState(() {
      isFilterApplied = applied;
    });
  }

  @override
  void initState() {
    super.initState();
    if(financeRequestsListController.financeStatusSelected.isNotEmpty){
      isFilterApplied = true;
    }
    financeRequestsListController.fetchFinanceRequestsList(
      SolarAppConstants.residentialCategory,
      financeRequestsListController.pageNumberResidential,
      SolarAppConstants.pageSize,
      filterStatus: financeRequestsListController.financeStatusSelected.value,
      searchString: financeRequestsListController.searchStringFinance.value,
    );
    financeRequestsListCommercialController.fetchFinanceRequestsList(
        SolarAppConstants.commercialCategory,
        financeRequestsListCommercialController.pageNumberCommercial,
        SolarAppConstants.pageSize,
        filterStatus: financeRequestsListController.financeStatusSelected.value,
        searchString: financeRequestsListController.searchStringFinance.value);
  }

  @override
  Widget build(BuildContext context) {
    FinanceRequestsListController financeRequestsListController = Get.find();
    FinanceRequestsListCommercialController
        financeRequestsListCommercialController = Get.find();
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    List<TabData> tabs = [
      TabData(translation(context).residential, const ResidentialTab()),
      TabData(translation(context).commercial, const CommercialTab()),
    ];
    return WillPopScope(
      onWillPop: () async {
        financeRequestsListController.clearFinanceRequestList();
        financeRequestsListCommercialController.clearFinanceRequestList();
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.lightWhite1,
        body: SafeArea(
          child: Column(
            children: [
              HeadingSolar(
                  heading: translation(context).finance,
                  onPressed: () {
                    financeRequestsListController.clearFinanceRequestList();
                    financeRequestsListCommercialController
                        .clearFinanceRequestList();
                    Navigator.pop(context);
                  }
              ),
              UserProfileWidget(
                top: 8 * h,
              ),
              const VerticalSpace(height: 4),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24 * w),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          width: variablePixelWidth * 297,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.lightWhite1,
                            borderRadius: BorderRadius.circular(8 * r),
                            border: Border.all(
                              color: AppColors.white_234,
                              width: 1 * variablePixelWidth,
                            ),
                          ),
                          child: Row(
                            children: [
                              HorizontalSpace(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  textInputAction: TextInputAction.search,
                                  maxLength: SolarAppConstants.existingLeadsSearchLength,
                                  maxLines: 1,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9a-zA-Z ]")),
                                  ],
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkGreyText,
                                    fontSize: 11 * f,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  onChanged: (value) {
                                    if (value.length >= 3) {
                                      setState(() {
                                        enableSearch = true;
                                        searchController.text = value;
                                      });
                                    } else {
                                      setState(() {
                                        enableSearch = false;
                                      });
                                      if (value.isEmpty) {
                                        financeRequestsListController
                                            .searchStringFinance.value = "";
                                        financeRequestsListController.residentialRequestsList.clear();
                                        financeRequestsListController.pageNumberResidential = 1;
                                        financeRequestsListCommercialController.commercialRequestsList.clear();
                                        financeRequestsListCommercialController.pageNumberCommercial = 1;
                                        financeRequestsListController
                                            .fetchFinanceRequestsList(
                                                SolarAppConstants
                                                    .residentialCategory,
                                                financeRequestsListController.pageNumberResidential,
                                                SolarAppConstants.pageSize,
                                                filterStatus:
                                                    financeRequestsListController
                                                        .financeStatusSelected
                                                        .value,
                                                searchString: "");
                                        financeRequestsListCommercialController
                                            .fetchFinanceRequestsList(
                                                SolarAppConstants
                                                    .commercialCategory,
                                                financeRequestsListCommercialController.pageNumberCommercial,
                                                SolarAppConstants.pageSize,
                                                filterStatus:
                                                    financeRequestsListController
                                                        .financeStatusSelected
                                                        .value,
                                                searchString: "");
                                      }
                                    }
                                  },
                                  enabled: true,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: translation(context).search,
                                    hintStyle: GoogleFonts.poppins(
                                      color: AppColors.lightGreyBorder,
                                      fontSize: f * 11,
                                      fontWeight: FontWeight.w400,
                                      height: 20 / 11,
                                      letterSpacing: 0.50,
                                    ),
                                    counterText: "",
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 5 * variablePixelHeight,
                                    bottom: 5 * variablePixelHeight),
                                child: VerticalDivider(
                                  color: AppColors.lightGrey1,
                                  width: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 8 * variablePixelWidth,
                                    right: 8 * variablePixelWidth,
                                    top: 0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (enableSearch) {
                                      financeRequestsListController
                                          .searchStringFinance
                                          .value = searchController.text;
                                          financeRequestsListController.residentialRequestsList.clear();
                                          financeRequestsListController.pageNumberResidential = 1;
                                          financeRequestsListCommercialController.commercialRequestsList.clear();
                                          financeRequestsListCommercialController.pageNumberCommercial = 1;
                                      financeRequestsListController
                                          .fetchFinanceRequestsList(
                                              SolarAppConstants
                                                  .residentialCategory,
                                              financeRequestsListController.pageNumberResidential,
                                              SolarAppConstants.pageSize,
                                              filterStatus:
                                                  financeRequestsListController
                                                      .financeStatusSelected
                                                      .value,
                                              searchString:
                                                  searchController.text);
                                      financeRequestsListCommercialController
                                          .fetchFinanceRequestsList(
                                              SolarAppConstants
                                                  .commercialCategory,
                                              financeRequestsListCommercialController.pageNumberCommercial,
                                              SolarAppConstants.pageSize,
                                              filterStatus:
                                                  financeRequestsListController
                                                      .financeStatusSelected
                                                      .value,
                                              searchString:
                                                  searchController.text);
                                    }
                                  },
                                  child: Icon(
                                    Icons.search,
                                    size: 20 * r,
                                    color: enableSearch
                                        ? AppColors.lumiBluePrimary
                                        : AppColors.grayText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8 * w),
                      Container(
                        padding: EdgeInsets.only(top: 8 * h,bottom: 8*h),
                        width: 40 * w,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1 * w,
                                color: isFilterApplied
                                    ? AppColors.lumiBluePrimary
                                    : AppColors.white_234),
                            borderRadius: BorderRadius.circular(8 * r),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FinanceStatusFilter(
                                          onFilterApplied: updateFilterStatus,
                                        )));
                          },
                          child: Center(
                              child: Icon(
                            isFilterApplied
                                ? Icons.filter_alt
                                : Icons.filter_alt_outlined,
                            color: isFilterApplied
                                ? AppColors.lumiBluePrimary
                                : AppColors.blackText,
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              VerticalSpace(height: 12),
              TabWidget(initialIndex: initialIndex, tabs: tabs),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SolarFinanceRequestForm()));
          },
          child: Container(
            width: 209 * variablePixelWidth,
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 24 * variablePixelHeight),
            height: 50 * variablePixelHeight,
            decoration: BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: BorderRadius.all(
                    Radius.circular(24 * variablePixelMultiplier))),
            child: Text(translation(context).raiseFinanceRequest,
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 14 * variableTextMultiplier,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                )),
          ),
        ),
      ),
    );
  }
}
