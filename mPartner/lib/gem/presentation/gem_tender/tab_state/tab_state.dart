import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/localdata/language_constants.dart';
import '../../../../presentation/screens/base_screen.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/utils.dart';

import '../../../../presentation/widgets/common_divider.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../data/models/gem_tender_statedata_model.dart';
import '../../../data/models/gem_tender_statelist_model.dart';
import '../../../state/controller/gem_tender_module_controller.dart';
import '../component/statewise_details_widget.dart';

class TabState extends StatefulWidget {
  const TabState({super.key});
  @override
  State<TabState> createState() => _TabState();
}

class _TabState extends BaseScreenState<TabState> {
  GemTenderModuleController gemTenderManagementController = Get.find();
  TextEditingController textFieldControllerState = TextEditingController();
  bool isStateFilled = false;
  String stateWithoutCapitalization = '';
  List<dynamic> stateList = [];
  List<ListStateData>? states;
  List<Map<String, dynamic>> stateResponseDataList = [];

  bool isDataFound = false;

  @override
  void initState() {
    gemTenderManagementController.clearGemTenderModuleController();
    fetchStateList();
    super.initState();
  }

  String capitalizeEachWord(String text) {
    List<String> words = text.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        // Special case for "And"
        if (words[i].toLowerCase() == 'and') {
          words[i] = '&';
        } else {
          words[i] =
              words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
        }
      }
    }
    return words.join(' ');
  }

  fetchStateList() {
    gemTenderManagementController.fetchGemStateManagementStateList().then((_) {
      if (gemTenderManagementController
          .gemTenderManagementStateList.isNotEmpty) {
        GemTenderStateListModel result =
            gemTenderManagementController.gemTenderManagementStateList.first;
        if (result.status == '200') {
          states = result.data.toList();
          /* for (var stateData in states) {
            stateList.add(stateData.stateName);
          }*/
          print("stateList ${stateList}");
        } else {
          Utils().showToast("Error fetching State List", context);
        }
      } else {
        Utils().showToast("No data received or an error occurred.", context);
      }
    });
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    TextStyle textStyle = GoogleFonts.poppins(
      color: AppColors.darkGrey,
      fontSize: 14 * textMultiplier,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.50 * variablePixelWidth,
    );
    OutlineInputBorder focusedBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
      borderSide: const BorderSide(color: Colors.grey),
    );
    OutlineInputBorder enabledBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * pixelMultiplier)),
      borderSide: const BorderSide(color: Colors.grey),
    );
    TextStyle labelTextStyle = GoogleFonts.poppins(
      color: AppColors.darkGrey,
      fontSize: 12 * textMultiplier,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.40 * variablePixelWidth,
    );
    TextStyle hintTextStyle = GoogleFonts.poppins(
      color: AppColors.grayText,
      fontSize: 14 * textMultiplier,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.50 * variablePixelWidth,
    );
    TextStyle headingTextStyle = GoogleFonts.poppins(
      color: AppColors.titleColor,
      fontSize: 20 * textMultiplier,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.50 * variablePixelWidth,
    );
    TextStyle bottomSheetListStyle = GoogleFonts.poppins(
      color: AppColors.titleColor,
      fontSize: 16 * textMultiplier,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.50 * variablePixelWidth,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                const VerticalSpace(height: 32),
                Container(
                  height: 48 * variablePixelHeight,
                  margin: EdgeInsets.only(
                      left: 24 * variablePixelWidth,
                      right: 24 * variablePixelWidth),
                  child: TextField(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        isDismissible: false,
                        enableDrag: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0 * pixelMultiplier),
                          ),
                        ),
                        builder: (context) => Container(
                          margin: EdgeInsets.fromLTRB(
                              8 * variablePixelWidth,
                              8 * variablePixelHeight,
                              8 * variablePixelWidth,
                              8 * variablePixelHeight),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Center(
                                  child: Container(
                                    height: 5 * variablePixelHeight,
                                    width: 50 * variablePixelWidth,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(
                                          12 * pixelMultiplier),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  size: 28 * pixelMultiplier,
                                ),
                              ),
                              const VerticalSpace(height: 12),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 16.0 * variablePixelWidth),
                                child: Text(
                                  translation(context).selectState,
                                  style: headingTextStyle,
                                ),
                              ),
                              const VerticalSpace(height: 16),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 16 * variablePixelWidth),
                                child: const CustomDivider(
                                    color: AppColors.dividerColor),
                              ),
                              const VerticalSpace(height: 16),
                              Obx(() {
                                if (gemTenderManagementController
                                    .isLoading.value) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Container(
                                  height: 620 * variablePixelHeight,
                                  child: ListView.builder(
                                    itemCount: states!.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                            capitalizeEachWord(
                                                states![index].stateName),
                                            style: bottomSheetListStyle,
                                            softWrap: true),
                                        onTap: () {
                                          stateWithoutCapitalization =
                                              states![index].stateID;
                                          textFieldControllerState.text =
                                              capitalizeEachWord(
                                                  states![index].stateName);
                                          setState(() {
                                            isStateFilled = true;
                                          });
                                          gemTenderManagementController
                                              .clearGemTenderModuleController();
                                          gemTenderManagementController
                                              .fetchStateWiseDataList(
                                                  stateWithoutCapitalization)
                                              .then((_) {
                                            if (gemTenderManagementController
                                                .gemTenderStateWiseDataList
                                                .isNotEmpty) {
                                              GemTenderStateDataModel result =
                                                  gemTenderManagementController
                                                      .gemTenderStateWiseDataList
                                                      .first;
                                              if (result.status == '200') {
                                                setState(() {
                                                  stateResponseDataList.clear();
                                                });

                                                List<TenderStateData>
                                                    stateWiseData =
                                                    result.data.toList();
                                                print(
                                                    "new data is    ===>>>>>> ${stateWiseData.length}");
                                                if(stateWiseData.length > 0) {
                                                  for (var stateData
                                                  in stateWiseData) {
                                                    Map<String,
                                                        dynamic> jsonMap =
                                                    {
                                                      'nTenderID':
                                                      stateData.nTenderID,
                                                      'nTetnderTitle':
                                                      stateData.nTetnderTitle,
                                                      'dPostedOn':
                                                      stateData.dPostedOn,
                                                      'sBidNumber':
                                                      stateData.sBidNumber,
                                                      'dBidPublishDate': stateData
                                                          .dBidPublishDate,
                                                      'dBidDueDate':
                                                      stateData.dBidDueDate,
                                                      'nStateID':
                                                      stateData.nStateID,
                                                      'category':
                                                      stateData.category,
                                                    };
                                                    setState(() {
                                                      stateResponseDataList
                                                          .add(jsonMap);
                                                      isDataFound = true;
                                                    });
                                                  }
                                                }else{
                                                  setState(() {
                                                    isDataFound = false;
                                                  });

                                                }

                                              } else {
                                                setState(() {
                                                  isDataFound = false;
                                                });
                                                Utils().showToast(
                                                    "Error fetching State List",
                                                    context);
                                              }
                                            } else {
                                              setState(() {
                                                isDataFound = false;
                                                stateResponseDataList.clear();
                                              });
                                              Utils().showToast(
                                                  "There are no data found.",
                                                  context);
                                            }
                                          });

                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  ),
                                );
                              }),
                              const VerticalSpace(height: 16),
                            ],
                          ),
                        ),
                      );
                    },
                    style: textStyle,
                    readOnly: true,
                    controller: textFieldControllerState,
                    decoration: InputDecoration(
                      labelText: translation(context).state,
                      hintText: translation(context).selectState,
                      focusedBorder: focusedBorderStyle,
                      enabledBorder: enabledBorderStyle,
                      labelStyle: labelTextStyle,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintStyle: hintTextStyle,
                      contentPadding: EdgeInsets.fromLTRB(
                          16 * variablePixelWidth,
                          5 * variablePixelHeight,
                          0,
                          0),
                      suffixIcon: IgnorePointer(
                        ignoring: !isStateFilled,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: isStateFilled
                              ? AppColors.downArrowColor
                              : AppColors.hintColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalSpace(height: 25),
                !isDataFound
                    ? Container(
                        margin: EdgeInsets.only(
                            left: 24 * variablePixelWidth,
                            right: 24 * variablePixelWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const VerticalSpace(height: 28),
                            Center(
                              child: Text("No data Found",
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkGrey,
                                    fontSize: 14 * textMultiplier,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.50 * variablePixelWidth,
                                  )),
                            )
                          ],
                        ),
                      )
                    : Container(),
                textFieldControllerState.text.isNotEmpty
                    ? StateWiseDetailsWidget(
                        statewiseDetails: stateResponseDataList)
                    : Container(),
                const VerticalSpace(height: 16)
              ],
            ),
          )
        ],
      ),
    );
  }
}
