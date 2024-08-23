import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/models/terms_condition_model.dart';
import '../../../../network/api_constants.dart';
import '../../../../state/contoller/language_controller.dart';
import '../../../../state/contoller/save_terms_condition_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/localdata/shared_preferences_util.dart';
import '../../../../utils/requests.dart';
import '../../../widgets/something_went_wrong_screen.dart';
import '../../home/home_screen.dart';
import 'accept_button_widget.dart';

class TermsConditionsBottomSheet extends StatefulWidget {
  final bool firstAppearance;

  const TermsConditionsBottomSheet({super.key, required this.firstAppearance});

  @override
  State<TermsConditionsBottomSheet> createState() =>
      _TermsConditionsBottomSheetState();
}

class _TermsConditionsBottomSheetState
    extends State<TermsConditionsBottomSheet> {
  TermsConditionsResponse? termsConditionModel;
  SaveTermsConditionController saveTermsConditionController = Get.find();
  String? termsConditionData;
  String? token;
  String? user_Id;
  String? language;
  String termsConditionId = "0";
  UserDataController controller = Get.find();
  LanguageController languageController = Get.find();
  bool? isTermsAndConditionAccepted;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getTokenAndSapId();
    fetchData();
  }

  Future<void> _getTokenAndSapId() async {
    token = controller.token;
    user_Id = controller.sapId;
    language = languageController.language;
  }

  Future<void> fetchData() async {
    final Map<String, dynamic> body = {
      "user_Id": user_Id,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "device_Name": deviceName,
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "language": language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_Version": "",
      "pageName": AppConstants.pageName
    };

    try {
      final response = await Requests.sendPostRequest(
          ApiConstants.postTermsConditionsEndPoint, body);

      if (response is! DioException && response.statusCode == 200) {
        final TermsConditionsResponse model =
            TermsConditionsResponse.fromJson(response.data);

        setState(() {
          termsConditionModel = model;
        });
        for (TermsConditionData data in termsConditionModel!.data) {
          setState(() {
            termsConditionId = data.id.toString();
            print("Terms Condition ID: ${data.id}");
          });
        }
      } else {
        if (widget.firstAppearance) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SomethingWentWrongScreen(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (route) => false,
                          );
                        },
                      )));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SomethingWentWrongScreen(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )));
        }
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      if (widget.firstAppearance) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SomethingWentWrongScreen(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false,
                        );
                      },
                    )));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SomethingWentWrongScreen(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )));
      }
      print("Error fetching data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      double h = DisplayMethods(context: context).getVariablePixelHeight();
      double w = DisplayMethods(context: context).getVariablePixelWidth();
      double f = DisplayMethods(context: context).getTextFontMultiplier();
      double r = DisplayMethods(context: context).getPixelMultiplier();

      {
        return Container(
          height: widget.firstAppearance ? 780 * h : 680 * h,
          decoration: BoxDecoration(
            color: AppColors.lightWhite1,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30 * r),
              topRight: Radius.circular(30 * r),
            ),
          ),
          padding: widget.firstAppearance
              ? EdgeInsets.fromLTRB(24 * w, 18 * h, 24 * w, 5 * h)
              : EdgeInsets.fromLTRB(24 * w, 5 * h, 24 * w, 5 * h),
          child: Column(
            children: [
              if (!widget.firstAppearance)
                Opacity(
                  opacity: 0.40,
                  child: Container(
                    width: 32 * w,
                    height: 4 * h,
                    margin: EdgeInsets.symmetric(vertical: 16 * h),
                    decoration: ShapeDecoration(
                      color: AppColors.lightGrey3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100 * r),
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15 * h),
                    Text(
                      translation(context).termsAndConditons,
                      style: GoogleFonts.poppins(
                        color: AppColors.titleColor,
                        fontSize: 20 * f,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.50,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8 * h),
              Container(
                height: 1,
                color: AppColors.dividerGreyColor,
                margin: EdgeInsets.symmetric(vertical: 8 * h),
              ),
              SizedBox(height: 12 * h),
              Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: termsConditionModel != null
                        ? Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: termsConditionModel!.data
                                    .map(
                                      (data) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: data.termsConditionData
                                            .split('<p>')
                                            .where((element) =>
                                                element.trim().isNotEmpty)
                                            .map(
                                              (point) => Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${point.trim().replaceAll(RegExp('</p>'), '')}',
                                                    style: GoogleFonts.poppins(
                                                      color: AppColors
                                                          .darkGreyText,
                                                      fontSize: 14 * f,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 0.10,
                                                    ),
                                                  ),
                                                  SizedBox(height: 15 * h),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    )
                                    .toList(),
                              ),
                              if (widget.firstAppearance)
                                Column(
                                  children: [
                                    SizedBox(height: 5 * h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          value: isTermsAndConditionAccepted ??
                                              false,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isTermsAndConditionAccepted =
                                                  value ?? false;
                                              //SharedPreferencesUtil.setShowISmartDisclaimerAlert(isTermsAndConditionAccepted!);
                                            });
                                          },
                                          checkColor: AppColors.white,
                                          activeColor:
                                              AppColors.lumiBluePrimary,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: const VisualDensity(
                                              horizontal: -4, vertical: -4),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (isTermsAndConditionAccepted !=
                                                      null &&
                                                  isTermsAndConditionAccepted!) {
                                                isTermsAndConditionAccepted =
                                                    false;
                                              } else if (isTermsAndConditionAccepted !=
                                                      null &&
                                                  isTermsAndConditionAccepted! ==
                                                      false) {
                                                isTermsAndConditionAccepted =
                                                    true;
                                              } else {
                                                isTermsAndConditionAccepted =
                                                    true;
                                              }
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                8.0 * w, 0, 0, 0),
                                            child: Text(
                                              translation(context)
                                                  .acceptTermsConditions,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14.0 * f,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.darkGreyText,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20 * h),
                                    AcceptButton(
                                      isEnabled:
                                          isTermsAndConditionAccepted ?? false,
                                      onPressed: () {
                                        saveTermsConditionController
                                            .fetchSaveTermsCondition(
                                                termsConditionId);
                                        SharedPreferencesUtil
                                            .setShowISmartDisclaimerAlert(
                                                isTermsAndConditionAccepted!);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              SizedBox(height: 20 * h),
                            ],
                          )
                        : const Center(child: CircularProgressIndicator()),
                  )),
              SizedBox(height: 2 * h),
            ],
          ),
        );
      }
    });
  }
}
