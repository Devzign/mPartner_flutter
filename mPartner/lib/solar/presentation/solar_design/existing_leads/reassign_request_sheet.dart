import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../presentation/widgets/common_button.dart';
import '../../../../presentation/widgets/common_divider.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/utils.dart';
import '../../../data/datasource/solar_remote_data_source.dart';
import '../../../data/models/reassign_request_model.dart';
import '../../../state/controller/solar_design_count_details_controller.dart';
import '../../../utils/solar_app_constants.dart';
import '../../common/something_went_wrong_solar_screen.dart';

class ReassignRequestSheet extends StatefulWidget {
  final String projectId;
  final bool isDigOrPhy;
  final String? isNavigatedFrom;

  const ReassignRequestSheet({
    super.key,
    required this.projectId,
    required this.isDigOrPhy,
    this.isNavigatedFrom,
  });

  @override
  State<ReassignRequestSheet> createState() => _ReassignRequestSheetState();
}

class _ReassignRequestSheetState extends State<ReassignRequestSheet> {
  SolarRemoteDataSource solarRemoteDataSource = SolarRemoteDataSource();
  ReassignRequestResponse? reassignRequestResponse;
  UserDataController controller = Get.find();
  SolarDesignCountDetailsController solarDesignCountDetailsController = Get.find();
  TextEditingController _remarkController = TextEditingController();
  String remark = "";
  int retryCount=0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Container(
      height: 600 * h,
      decoration: BoxDecoration(
        color: AppColors.lightWhite1,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30 * r),
          topRight: Radius.circular(30 * r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
          24 * w,
          16 * h,
          24 * w,
          16 * h
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Opacity(
                    opacity: 0.40,
                    child: Container(
                      width: 32 * w,
                      height: 4 * h,
                      margin: EdgeInsets.only(bottom: 16 * h),
                      decoration: ShapeDecoration(
                        color: AppColors.lightGrey3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100 * r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3 * h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: AppColors.titleColor,
                          ),
                        ),
                        SizedBox(height: 6 * h),
                        Text(
                          translation(context).reassignRequest,
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
                    height: 1 * h,
                    color: AppColors.dividerGreyColor,
                    margin: EdgeInsets.symmetric(vertical: 8 * h),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 24.0 * w, bottom: 10 * h, top: 15 * h),
                    child: Text(
                      translation(context).pleaseProvideReasonForReassigning,
                      style: GoogleFonts.poppins(
                          color: AppColors.darkText2,
                          fontSize: 16 * f,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.50 * w
                      ),
                    ),
                  ),
                  Container(
                      child:  Padding(
                        padding: EdgeInsets.only(top: 8 * h),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 345 * w,
                                height: 145 * h,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1 * w,
                                        color: AppColors.lightGrey2
                                    ),
                                    borderRadius: BorderRadius.circular(8 * r),
                                  ),
                                ),
                                child:TextField(
                                  onTapOutside: (event) {
                                    print('onTapOutside');
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                  controller: _remarkController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(SolarAppConstants.NO_LEADING_SPACE_REGEX),
                                  ],
                                  maxLines: null,
                                  maxLength: SolarAppConstants.remarkInputMaxLength,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    hintText: translation(context).writeYourReasonHere,
                                    counterText: "",
                                    hintStyle: GoogleFonts.poppins(
                                      color: AppColors.lightGrey1,
                                      fontSize: 12 * w,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.50,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.lightWhite1,
                                        width: 1.0 * w,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.lightWhite1,
                                        width: 1.0 * w,
                                      ),
                                    ),
                                    isCollapsed: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8 * h,
                                        horizontal: 12 * w
                                    ),
                                  ),
                                ),
                              ),
                            ]
                        ),
                      )
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                  Container(
                    width: double.infinity,
                    child: CommonButton(
                      onPressed: () async {
                        setState(() {
                          isLoading=true;
                        });
                        await handleOnSubmitButtonEvent(widget.projectId,_remarkController.text);
                      },
                      showLoader: isLoading,
                      isEnabled: !isLoading && _remarkController.text.isNotEmpty,
                      buttonText: translation(context).submit,
                      backGroundColor: AppColors.lumiBluePrimary,
                      textColor: AppColors.lightWhite1,
                      defaultButton: true,
                      containerBackgroundColor: AppColors.white,
                      horizontalPadding : 0,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  handleOnSubmitButtonEvent(String projectId, String remark) async {
    try{
      final result =
      await solarRemoteDataSource.postReassignRequest(projectId, remark);
      result.fold(
            (l) {
          retryCount++;
          print(retryCount);
          logger.e(l);
          if(retryCount<=2){
            Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
          }
          else {
            Navigator.of(context).pop();
            Navigator.push(context, (MaterialPageRoute(builder: (context) => SomethingWentWrongSolarScreen(
              previousRoute: widget.isDigOrPhy
                ? SolarAppConstants.digitalDesRouteName
                : SolarAppConstants.physicalDesRouteName,
              onPressed: (){
                Navigator.pop(context);
              },
            ))));
          }
        },
            (right) {
          setState(() {
            reassignRequestResponse = right;
          });
          if(reassignRequestResponse?.status=='200'){
            Navigator.of(context).pop();
            solarDesignCountDetailsController.fetchSolarDesignCountDetails(widget.isDigOrPhy ? true : false);
            showSubmitSuccessfullyBottomSheet(context, reassignRequestResponse, widget.projectId, widget.isNavigatedFrom, widget.isDigOrPhy);
          }
          else {
            retryCount++;
            print(retryCount);
            if(retryCount<=2){
              Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
            }
            else {
              Navigator.of(context).pop();
              Navigator.push(context, (MaterialPageRoute(builder: (context) => SomethingWentWrongSolarScreen(
                previousRoute: widget.isDigOrPhy
                  ? SolarAppConstants.digitalDesRouteName
                  : SolarAppConstants.physicalDesRouteName,
                onPressed: (){
                  Navigator.pop(context);
                },
              ))));
            }
          }
        },
      );
    }
    catch (e){
      logger.e('Error $e');
    }
    finally {
      setState(() {
        isLoading=false;
      });
    }
  }
}

void showSubmitSuccessfullyBottomSheet(BuildContext context, ReassignRequestResponse? response, String projectId, String? isNavigatedFrom, bool isDigOrPhy) {
  double h = DisplayMethods(context: context).getVariablePixelHeight();
  double w = DisplayMethods(context: context).getVariablePixelWidth();
  double f = DisplayMethods(context: context).getTextFontMultiplier();
  double r = DisplayMethods(context: context).getPixelMultiplier();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0 * r),
      ),
    ),
    builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  8 * w,
                  8 * h,
                  8 * w,
                  8 * h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 36 * h,
                    child: Center(
                      child: Opacity(
                        opacity: 0.40,
                        child: Container(
                          width: 32,
                          height: 4,
                          decoration: ShapeDecoration(
                            color: Color(0xFF79747E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 16 * w,
                        top: 16 * h),
                    child: Text(
                      translation(context).submittedSuccessfully,
                      style: GoogleFonts.poppins(
                        color: AppColors.titleColor,
                        fontSize: 20 * f,
                        fontWeight: FontWeight.w600,
                        height: 24 / 20,
                        letterSpacing: 0.50,
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 16),
                  Padding(
                    padding: EdgeInsets.only(left: 16 * r),
                    child: const CustomDivider(color: AppColors.dividerColor),
                  ),
                  const VerticalSpace(height: 16),
                  Padding(
                    padding: EdgeInsets.only(
                        right: 24 * w,
                        left: 16 * w),
                    child: RichText(
                      text: TextSpan(
                        text: '${translation(context).theRequest} ',
                        style: GoogleFonts.poppins(
                          color: AppColors.darkGrey,
                          fontSize: 16 * f,
                          fontWeight: FontWeight.w400,
                          height: 24 / 16,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: projectId.toUpperCase(),
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 16 * f,
                              fontWeight: FontWeight.w700,
                              height: 24 / 16,
                            ),
                          ),
                          TextSpan(
                            text: ' ${translation(context).hasBeenSentForRedesigning}',
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 16 * f,
                              fontWeight: FontWeight.w400,
                              height: 24 / 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 24),
                  CommonButton(
                    onPressed: () {
                      if(isNavigatedFrom == SolarAppConstants.fromNotificationActiveTab) {
                        Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.notificationHome));
                      } else if(isNavigatedFrom == SolarAppConstants.fromPushNotification) {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context,  AppRoutes.homepage);
                      } else if(isNavigatedFrom == SolarAppConstants.fromDashboard) {
                        if (isDigOrPhy) {
                          Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.solarDigDesignDashboard));
                        } else {
                          Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.solarPhyDesignDashboard));
                        }
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    isEnabled: true,
                    buttonText: translation(context).done,
                    leftPadding: 8 * w,
                    rightPadding: 24 * w,
                    textColor: AppColors.white,
                    backGroundColor: AppColors.lumiBluePrimary,
                    containerHeight: 48 * h,
                    containerBackgroundColor: AppColors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}