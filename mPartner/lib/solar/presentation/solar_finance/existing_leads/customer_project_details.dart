import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../state/controller/finance_customer_project_details_controller.dart';
import '../../../utils/solar_app_constants.dart';
import '../../common/leads_list_detail_cards/detailed_summary_card.dart';

class CustomerProjectDetails extends StatefulWidget {
  bool isResidential, isCommercial;
  String projectId;

  CustomerProjectDetails(
      {super.key,
      this.isResidential = false,
      this.isCommercial = false,
      required this.projectId});

  @override
  State<CustomerProjectDetails> createState() => _CustomerProjectDetailsState();
}

class _CustomerProjectDetailsState extends State<CustomerProjectDetails> {
  FinanceCustomerProjectDetailsController
      financeCustomerProjectDetailsController =
      FinanceCustomerProjectDetailsController();
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0,
    symbol: '\u{20B9} ',
  );

  String getRemarksString(String remarksValue, String status) {
    if (status == 'in progress' && remarksValue.isEmpty) {
      return translation(context).notApplicable;
    } else if ((status == 'approved' || status == 'rejected') &&
        remarksValue.isEmpty) {
      return "-";
    } else
      return remarksValue;
  }

  String getDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isResidential) {
      financeCustomerProjectDetailsController
          .fetchProjectDetailsById(widget.projectId);
    } else {
      financeCustomerProjectDetailsController
          .fetchProjectDetailsById(widget.projectId);
    }
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    return Scaffold(
      backgroundColor: AppColors.lightWhite1,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24 * w),
                child: Obx(() {
                  if (financeCustomerProjectDetailsController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (financeCustomerProjectDetailsController
                      .error.isNotEmpty) {
                    return Container();
                  } else {
                    return DetailedSummaryCard(labelData: {
                      translation(context).uniqueId: {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .projectId
                                .isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails.value.projectId
                            : '',
                        "type": "text"
                      },
                      translation(context).projectType: {
                        "val": widget.isCommercial == true
                            ? 'Commercial'
                            : 'Residential',
                        "type": "text"
                      },
                      widget.isCommercial == true
                          ? translation(context).firmName
                          : "": {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .firmName
                                .isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails.value.firmName
                            : "",
                        "type": "text"
                      },
                      translation(context).contactPersonName: {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .contactPersonName
                                .isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails.value.contactPersonName
                            : "",
                        "type": "text"
                      },
                      translation(context).contactPersonMobile: {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .contactPersonMobileNo
                                .isNotEmpty
                            ? "${SolarAppConstants.mobileNoPrefix}${financeCustomerProjectDetailsController.customerProjectDetails.value.contactPersonMobileNo}"
                            : "",
                        "type": "text"
                      },
                      translation(context).contactPersonEmailId: {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .contactPersonEmailId
                                .isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .contactPersonEmailId
                            : "",
                        "type": "text"
                      },
                      financeCustomerProjectDetailsController
                              .customerProjectDetails
                              .value
                              .secondaryContactName
                              .isNotEmpty
                          ? translation(context).secondaryContactName
                          : "": {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .secondaryContactName
                                .isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .secondaryContactName
                            : "",
                        "type": "text"
                      },
                      financeCustomerProjectDetailsController
                              .customerProjectDetails
                              .value
                              .secondaryContactMobileNo
                              .isNotEmpty
                          ? translation(context).secondaryContactMobileNumber
                          : "": {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .secondaryContactMobileNo
                                .isNotEmpty
                            ? "${SolarAppConstants.mobileNoPrefix}${financeCustomerProjectDetailsController.customerProjectDetails.value.secondaryContactMobileNo}"
                            : "",
                        "type": "text"
                      },
                      financeCustomerProjectDetailsController
                              .customerProjectDetails
                              .value
                              .secondaryContactEmailId
                              .isNotEmpty
                          ? translation(context).secondaryContactEmailId
                          : "": {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .secondaryContactEmailId
                                .isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .secondaryContactEmailId
                            : "",
                        "type": "text"
                      },
                      translation(context).projectName: {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .projectName
                                .isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails.value.projectName
                            : "",
                        "type": "text"
                      },
                      translation(context).pincode: {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails.value.pincode.isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails.value.pincode
                            : "",
                        "type": "text"
                      },
                      translation(context).state: {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails.value.state.isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails.value.state
                            : "",
                        "type": "text"
                      },
                      translation(context).city: {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails.value.city.isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails.value.city
                            : "",
                        "type": "text"
                      },
                      translation(context).solutionType: {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .solutionType
                                .isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails.value.solutionType
                            : "",
                        "type": "text"
                      },
                      translation(context).projectCapacity: {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .projectCapacity
                                .isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails.value.projectCapacity
                            : "",
                        "type": "text"
                      },
                      translation(context).projectCost: {
                        "val": financeCustomerProjectDetailsController
                                    .customerProjectDetails.value.projectCost !=
                                0
                            ? indianRupeesFormat
                                .format(financeCustomerProjectDetailsController
                                    .customerProjectDetails.value.projectCost)
                                .toString()
                            : "",
                        "type": "text"
                      },
                      translation(context).preferredBank: {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .preferredBankName
                                .isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails.value.preferredBankName
                            : "",
                        "type": "text"
                      },
                      widget.isCommercial == true
                          ? translation(context).firmGstinNumber
                          : "": {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .firmGSTINNumber
                                .isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails.value.firmGSTINNumber
                            : "",
                        "type": "text"
                      },
                      widget.isCommercial == true
                          ? translation(context).firmPanNumber
                          : translation(context).panNumber: {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .panNumber
                                .isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails.value.panNumber
                            : "",
                        "type": "text"
                      },
                      translation(context).requestDate: {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .requestDate
                                .isNotEmpty
                            ? getDateString(
                                financeCustomerProjectDetailsController
                                    .customerProjectDetails.value.requestDate)
                            : '',
                        "type": "text"
                      },
                      translation(context).lastUpdateDate: {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .lastUpdateDate
                                .isNotEmpty
                            ? getDateString(
                                financeCustomerProjectDetailsController
                                    .customerProjectDetails
                                    .value
                                    .lastUpdateDate)
                            : '-',
                        "type": "text"
                      },
                      translation(context).financeStatus: {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails.value.status.isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails.value.status
                            : "",
                        "type": "status"
                      },
                      financeCustomerProjectDetailsController
                              .customerProjectDetails
                              .value
                              .approvedBank
                              .isNotEmpty
                          ? translation(context).approvedBank
                          : "": {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails
                                .value
                                .approvedBank
                                .isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails.value.approvedBank
                            : "",
                        "type": "text"
                      },
                      translation(context).reason: {
                        "val": financeCustomerProjectDetailsController
                                .customerProjectDetails.value.reason.isNotEmpty
                            ? financeCustomerProjectDetailsController
                                .customerProjectDetails.value.reason
                            : "-",
                        "type": "text"
                      },
                    });
                  }
                }),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
