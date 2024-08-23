import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/utils.dart';

import '../../../../presentation/screens/base_screen.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../data/models/gem_tender_statedata_model.dart';
import '../../../state/controller/gem_tender_module_controller.dart';
import '../component/statewise_details_widget.dart';

class TabCentralPSU extends StatefulWidget {
  const TabCentralPSU({Key? key}) : super(key: key);

  @override
  State<TabCentralPSU> createState() => _TabCentralPSUState();
}

class _TabCentralPSUState extends BaseScreenState<TabCentralPSU> {
  GemTenderModuleController gemTenderManagementController = Get.find();
  bool isDataFound = false;
  List<Map<String, dynamic>> stateResponseDataList = [];

  @override
  void initState() {
    gemTenderManagementController.clearGemTenderModuleController();
    fetchServerData();
    super.initState();
  }

  void fetchServerData() {
    gemTenderManagementController.fetchStateWiseDataList('0').then((_) {
      if (gemTenderManagementController.gemTenderStateWiseDataList.isNotEmpty) {
        GemTenderStateDataModel result =
            gemTenderManagementController.gemTenderStateWiseDataList.first;
        if (result.status == '200') {
          setState(() {
            stateResponseDataList.clear();
          });

          List<TenderStateData> stateWiseData = result.data.toList();
          if (stateWiseData.length > 0) {
            for (var stateData in stateWiseData) {
              Map<String, dynamic> jsonMap = {
                'nTenderID': stateData.nTenderID,
                'nTetnderTitle': stateData.nTetnderTitle,
                'dPostedOn': stateData.dPostedOn,
                'sBidNumber': stateData.sBidNumber,
                'dBidPublishDate': stateData.dBidPublishDate,
                'dBidDueDate': stateData.dBidDueDate,
                'nStateID': stateData.nStateID,
                'category': stateData.category,
              };
              setState(() {
                stateResponseDataList.add(jsonMap);
                isDataFound = true;
              });
            }
          } else {
            setState(() {
              isDataFound = false;
            });
          }
        } else {
          Utils().showToast("Error fetching City List", context);
        }
      } else {
        setState(() {
          isDataFound = false;
          stateResponseDataList.clear();
        });
        Utils().showToast("There are no data found.", context);
      }
    });
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Obx(() {
              if (gemTenderManagementController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (gemTenderManagementController.error.isNotEmpty) {
                return Center(
                  child: Text(
                    gemTenderManagementController.error.value,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return ListView(
                  children: [
                    !isDataFound
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 24 * variablePixelWidth),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const VerticalSpace(height: 28),
                                Center(
                                  child: Text(
                                    "No data Found",
                                    style: GoogleFonts.poppins(
                                      color: AppColors.darkGrey,
                                      fontSize: 14 * textMultiplier,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.50 * variablePixelWidth,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    StateWiseDetailsWidget(
                      statewiseDetails: stateResponseDataList,
                    ),
                    const VerticalSpace(height: 16),
                  ],
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
