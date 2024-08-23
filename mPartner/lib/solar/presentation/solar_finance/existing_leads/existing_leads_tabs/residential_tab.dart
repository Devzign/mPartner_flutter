import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../state/controller/finance_customer_project_details_controller.dart';
import '../../../../state/controller/finance_request_list_commercial_controller.dart';
import '../../../../state/controller/finance_requests_lists_controller.dart';
import '../../../../utils/solar_app_constants.dart';
import '../customer_project_details.dart';
import '../project_card.dart';
import '../project_details_page.dart';

class ResidentialTab extends StatefulWidget {
  const ResidentialTab({Key? key}) : super(key: key);

  @override
  State<ResidentialTab> createState() => _ResidentialTabState();
}

class _ResidentialTabState extends State<ResidentialTab> {
  final ScrollController _scrollController = ScrollController();
  FinanceRequestsListController financeRequestsListController = Get.find();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (financeRequestsListController.residentialRequestsList.length <
        financeRequestsListController.totalCountResidential) {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        financeRequestsListController.fetchFinanceRequestsList(
          SolarAppConstants.residentialCategory,
          financeRequestsListController.pageNumberResidential,
          SolarAppConstants.pageSize,
          filterStatus:
              financeRequestsListController.financeStatusSelected.value,
          searchString: financeRequestsListController.searchStringFinance.value,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    FinanceRequestsListController financeRequestsListController = Get.find();
    return Scaffold(
      backgroundColor: AppColors.lightWhite1,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24 * w),
          child: Obx(() {
            if (financeRequestsListController.isLoading.value &&
                financeRequestsListController.residentialRequestsList.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else if (financeRequestsListController.error.isNotEmpty) {
              return Container();
            } else {
              if (financeRequestsListController
                  .residentialRequestsList.isEmpty) {
                return Center(child: Text(translation(context).dataNotFound));
              } else {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Visibility(
                      visible: (financeRequestsListController.isLoading.value && (financeRequestsListController.residentialRequestsList.length < financeRequestsListController.totalCountResidential)),
                      child: Positioned(
                          bottom: 0,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20 * h),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )),
                    ),
                    ListView.separated(
                      controller: _scrollController,
                      itemCount: financeRequestsListController
                          .residentialRequestsList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProjectDetailsPage(
                                    isResidential: true,
                                    projectId: financeRequestsListController
                                        .residentialRequestsList[index]
                                        .projectId)));
                          },
                          child: Column(
                            children: [
                              ProjectCard(
                                uniqueId: financeRequestsListController
                                    .residentialRequestsList[index].projectId,
                                name: financeRequestsListController
                                    .residentialRequestsList[index]
                                    .contactPersonName,
                                projectCost: financeRequestsListController
                                    .residentialRequestsList[index].projectCost
                                    .toString(),
                                financePartner: financeRequestsListController
                                    .residentialRequestsList[index]
                                    .approvedBankName,
                                status: financeRequestsListController
                                    .residentialRequestsList[index].status,
                                capacity: financeRequestsListController
                                    .residentialRequestsList[index]
                                    .projectCapacity,
                              ),
                              Visibility(
                                  visible: index == (financeRequestsListController.residentialRequestsList.length) - 1,
                                  child: VerticalSpace(height: 84)),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          VerticalSpace(height: 16),
                    ),
                  ],
                );
              }
            }
          }),
        ),
      ),
    );
  }
}
