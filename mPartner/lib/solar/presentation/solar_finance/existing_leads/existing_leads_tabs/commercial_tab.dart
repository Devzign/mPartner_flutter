import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../state/controller/finance_request_list_commercial_controller.dart';
import '../../../../state/controller/finance_requests_lists_controller.dart';
import '../../../../utils/solar_app_constants.dart';
import '../customer_project_details.dart';
import '../project_card.dart';
import '../project_details_page.dart';

class CommercialTab extends StatefulWidget {
  const CommercialTab({super.key});

  @override
  State<CommercialTab> createState() => _CommercialTabState();
}

class _CommercialTabState extends State<CommercialTab> {
  final ScrollController _scrollController = ScrollController();
  FinanceRequestsListCommercialController
      financeRequestsListCommercialController = Get.find();
  FinanceRequestsListController financeRequestListController = Get.find();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (financeRequestsListCommercialController.commercialRequestsList.length <
        financeRequestsListCommercialController.totalCountCommercial) {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        financeRequestsListCommercialController.fetchFinanceRequestsList(
            SolarAppConstants.commercialCategory,
            financeRequestsListCommercialController.pageNumberCommercial,
            SolarAppConstants.pageSize,
            filterStatus:
                financeRequestListController.financeStatusSelected.value,
            searchString:
                financeRequestListController.searchStringFinance.value);
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
    FinanceRequestsListCommercialController
        financeRequestsListCommercialController = Get.find();
    return Scaffold(
      backgroundColor: AppColors.lightWhite1,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24 * w),
          child: Obx(() {
            if (financeRequestsListCommercialController.isLoading.value && financeRequestsListCommercialController.commercialRequestsList.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else if (financeRequestsListCommercialController
                .error.isNotEmpty) {
              return Container();
            } else {
              if (financeRequestsListCommercialController
                  .commercialRequestsList.isEmpty) {
                return Center(child: Text(translation(context).dataNotFound));
              } else {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Visibility(
                      visible: (financeRequestsListCommercialController.isLoading.value && (financeRequestsListCommercialController.commercialRequestsList.length < financeRequestsListCommercialController.totalCountCommercial)),
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
                        itemCount: financeRequestsListCommercialController
                            .commercialRequestsList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProjectDetailsPage(
                                      isCommercial: true,
                                      projectId:
                                          financeRequestsListCommercialController
                                              .commercialRequestsList[index]
                                              .projectId)));
                            },
                            child: Column(
                              children: [
                                ProjectCard(
                                  uniqueId:
                                      financeRequestsListCommercialController
                                          .commercialRequestsList[index]
                                          .projectId,
                                  name: financeRequestsListCommercialController
                                      .commercialRequestsList[index]
                                      .contactPersonName,
                                  projectCost:
                                      financeRequestsListCommercialController
                                          .commercialRequestsList[index]
                                          .projectCost
                                          .toString(),
                                  financePartner:
                                      financeRequestsListCommercialController
                                          .commercialRequestsList[index]
                                          .approvedBankName,
                                  status:
                                      financeRequestsListCommercialController
                                          .commercialRequestsList[index].status,
                                  capacity:
                                      financeRequestsListCommercialController
                                          .commercialRequestsList[index]
                                          .projectCapacity,
                                ),
                                Visibility(
                                    visible: index == (financeRequestsListCommercialController.commercialRequestsList.length) - 1,
                                    child: VerticalSpace(height: 84)),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            VerticalSpace(height: 16)),
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
