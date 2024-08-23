import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../data/models/digital_survey_request_list_model.dart';
import '../../../state/controller/digital_survey_request_list_controller.dart';
import '../../../utils/solar_app_constants.dart';
import '../../common/leads_list_detail_cards/custom_solar_leads_card.dart';
import 'detailed_tab_view.dart';
import 'detailed_view_card.dart';

class CommercialViewPage extends StatefulWidget {
  final bool isDigOrPhy;

  const CommercialViewPage({
    Key? key,
    required this.isDigOrPhy
  }) : super(key: key);

  @override
  State<CommercialViewPage> createState() => _CommercialViewPageState();
}

class _CommercialViewPageState extends State<CommercialViewPage> {
  final ScrollController _commController = ScrollController();
  DigitalSurveyRequestListController digitalSurveyRequestListController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      digitalSurveyRequestListController.insideResiOrComm.value = false;
      _commController.addListener(_scrollListener);
      digitalSurveyRequestListController.resetPagination();
      fetchDigitalSurveyRequests();
    });
  }

  @override
  void dispose() {
    _commController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_commController.position.pixels == _commController.position.maxScrollExtent) {
      if (!digitalSurveyRequestListController.isLoadingCommercial.value) {
        if (digitalSurveyRequestListController.totalRequestCountComm.value > digitalSurveyRequestListController.commDigitalSurveyRequests.length) {
          digitalSurveyRequestListController.hasMoreData.value = true;
          digitalSurveyRequestListController.pgNumber.value += 1;
          fetchDigitalSurveyRequests();
        } else {
          digitalSurveyRequestListController.hasMoreData.value = false;
        }
      }
    }
  }

  Future<void> fetchDigitalSurveyRequests() async {
    await digitalSurveyRequestListController.addAndRemoveValuesToList();
    await digitalSurveyRequestListController.fetchDigitalSurveyRequestList(
        SolarAppConstants.commercialCategory,
        digitalSurveyRequestListController.searchString.value,
        digitalSurveyRequestListController.finalDesignStatusString.value,
        digitalSurveyRequestListController.finalSolutionTypeString.value,
        widget.isDigOrPhy
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Obx( () {
      return Column(
        children: [
          Expanded(
            child: digitalSurveyRequestListController.isLoadingCommercial.value && !digitalSurveyRequestListController.hasMoreData.value
              ? Center(child: CircularProgressIndicator(),)
              : (digitalSurveyRequestListController.commDigitalSurveyRequests.isEmpty || digitalSurveyRequestListController.error.isNotEmpty)
                ? Center(child: Text(translation(context).dataNotFound))
                : Stack(
                  alignment: Alignment.center,
                  children: [
                    Visibility(
                      visible: digitalSurveyRequestListController.isLoadingCommercial.value && digitalSurveyRequestListController.hasMoreData.value,
                      child: Positioned(
                          bottom: 0,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20.0 * h),
                            child: Center(
                              child: CircularProgressIndicator(),),
                          )),
                    ),
                    ListView.builder(
                      controller: _commController,
                      padding: EdgeInsets.zero,
                      itemCount: digitalSurveyRequestListController.commDigitalSurveyRequests.length,
                      itemBuilder: (context, index) {
                        DigitalSurveyRequest request = digitalSurveyRequestListController.commDigitalSurveyRequests[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: (index == (digitalSurveyRequestListController.commDigitalSurveyRequests.length - 1)) ? 80.0 * h : 0),
                          child: CustomSolarLeadsCardWidget(
                            onItemSelected: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>  DetailedTabView(
                                        projectId: request.projectId,
                                        categoryId: SolarAppConstants.commercialCategory,
                                        isDigOrPhy: widget.isDigOrPhy,
                                        isNavigatedFrom: SolarAppConstants.fromDashboard,
                                      )
                                  )
                              );
                            },
                            id: request.projectId,
                            status: request.status,
                            label1: translation(context).contactPersonName,
                            value1: request.contactPersonName,
                            label2: translation(context).contactPersonMobile,
                            value2: digitalSurveyRequestListController.formatPhoneNumber(request.contactPersonMobileNo),
                            label3: translation(context).projectName,
                            value3: request.projectName,
                            label4: translation(context).solutionType,
                            value4: request.solutionType,
                          ),
                        );
                    },),
                  ],
                ),
          ),
        ],);
    });
  }
}