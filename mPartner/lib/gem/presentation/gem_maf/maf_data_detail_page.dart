import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../utils/localdata/language_constants.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';

import '../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../presentation/widgets/common_button.dart';
import '../../data/models/maf_filter_model.dart';
import '../../state/controller/gem_maf_data_deatails_controller.dart';

import '../../utils/app_checkbox.dart';
import '../gem_tender/component/headingGemSupportCategory.dart';

import 'component/maf_data_details_page_widget.dart';

class MafDataDetailsPage extends StatefulWidget {
  //final String id;
  final String bidNumber;
  Rx<MafFilterModel> filterModel = MafFilterModel().obs;
  MafDataDetailsPage({required this.bidNumber});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GemMafDataDetailsPage();
  }
}

class _GemMafDataDetailsPage extends State<MafDataDetailsPage> {
  GemMafDataDetailsController controller = Get.find();
  String bidStatusValue = "";
  @override
  void initState() {
    controller.getdata(context, widget.bidNumber);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(
                  left: 14 * variablePixelWidth, top: 45 * variablePixelHeight),
              child: HeadingGemSupportCategory(
                icon: Icon(
                  Icons.arrow_back_outlined,
                  color: AppColors.iconColor,
                  size: 24 * variablePixelMultiplier,
                ),
                heading: translation(context).mafText,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
          UserProfileWidget(
            top: 8 * variablePixelHeight,
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(() {
                    if (controller.loading == true) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                        margin: const EdgeInsets.only(top: 100),
                      );
                    }
                    return MefDataDetailsPageWidget(
                        controller.datalist[0], widget.bidNumber);
                  }),

                  const SizedBox(height: 10),

                  Obx(() {
                    if (controller.isBidStatusBarShow.value) {
                      return Container(
                        padding: EdgeInsets.only(
                            top: 0 * variablePixelWidth,
                            right: 10 * variablePixelWidth,
                            left: 10 * variablePixelWidth,
                            bottom: 0 * variablePixelWidth),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(translation(context).bidstatus,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkText2,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  )),
                              padding: EdgeInsets.only(left: 15, right: 15),
                            ),
                            Row(
                              children: [
                                AppCheckBox(
                                  Ischecked: widget.filterModel.value.win,
                                  checkedColor: AppColors.lumiBluePrimary,
                                  UcheckedColor: AppColors.grey,
                                  TextColor: AppColors.black,
                                  text: translation(context).win,
                                  OnChanged: (bool newValue) {
                                    setState(() {
                                      if (newValue) {
                                        widget.filterModel!.value.win = true;
                                        widget.filterModel!.value.lost = false;
                                        controller.bidStatusButtonEnable.value = true;
                                        bidStatusValue = "Won";
                                      } else {
                                        widget.filterModel!.value.win = false;
                                        controller.bidStatusButtonEnable.value = false;
                                        bidStatusValue = "";
                                      }
                                    });
                                  },
                                ),
                                SizedBox(width: 20), // Add spacing between checkboxes
                                AppCheckBox(
                                  Ischecked: widget.filterModel.value.lost,
                                  checkedColor: AppColors.lumiBluePrimary,
                                  UcheckedColor: AppColors.grey,
                                  TextColor: AppColors.black,
                                  text: translation(context).lost,
                                  OnChanged: (bool newValue) {
                                    setState(() {
                                      if (newValue) {
                                        widget.filterModel!.value.lost = true;
                                        widget.filterModel!.value.win = false;
                                        controller.bidStatusButtonEnable.value = true;
                                        bidStatusValue = "Lost";
                                      } else {
                                        widget.filterModel!.value.lost = false;
                                        controller.bidStatusButtonEnable.value = false;
                                        bidStatusValue = "";
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 10 * variablePixelWidth,
                                    right: 50 * variablePixelWidth,
                                    left: 50 * variablePixelWidth,
                                    bottom: 20 * variablePixelWidth),
                                child: CommonButton(
                                    onPressed: () async {
                                      controller.submitBidStatus(context, widget.bidNumber, bidStatusValue);
                                    },
                                    isEnabled: controller.bidStatusButtonEnable.value,
                                    buttonText: translation(context).submit,
                                    withContainer: false
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox.shrink(); // Return an empty widget if the condition is not met
                    }
                  })

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
