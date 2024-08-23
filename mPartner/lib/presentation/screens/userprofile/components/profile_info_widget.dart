import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../network/api_constants.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../data/models/user_profile_model.dart';
import '../../../../data/models/user_upload_profile_photo.dart';
import '../../../../services/services_locator.dart';
import '../../../../state/contoller/app_setting_value_controller.dart';
import '../../../../state/contoller/language_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/localdata/shared_preferences_util.dart';
import '../../../../utils/requests.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_divider.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../widgets/something_went_wrong_widget.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../home/widgets/DeleteOption.dart';
import '../../home/widgets/chevron_right.dart';
import '../../secondarydevice/secondary_device.dart';
import '../bloc/user_profile_bloc.dart';
import '../clock_widget.dart';
import '../common_upload_bottom_sheet.dart';
import '../profile_info_common_widget.dart';
import '../secondary_device_details_widget.dart';
import '../view_details_widget.dart';
import 'certificate_widget.dart';
import 'change_app_language_widget.dart';
import 'logout_widget.dart';
import 'travel_document_widget.dart';


class UserProfileInfoWidget extends StatefulWidget {
  final bool showBottomSheet;
  final ProfileBottomSheetType type;

  const UserProfileInfoWidget(
      {super.key, required this.showBottomSheet, required this.type});

  @override
  State<UserProfileInfoWidget> createState() => _UserProfileInfoWidget();
}

class _UserProfileInfoWidget extends State<UserProfileInfoWidget> {
  late final Map<String, dynamic> responseData;
  late String status;
  late String userTypeFromSharedPref;
  UserDataController controller = Get.find();
  late String userPhone;
  LanguageController languageController = Get.find();
  String imagePath = '';
  var userUploadImageOutput = <UserUploadProfilePhoto>[];
  bool isLoading = false;


  AppSettingValueController appSettingValueController = Get.find();
  @override
  void initState() {
    super.initState();
    appSettingValueController.fetchAppSettingValues(AppConstants.IsUserDeleteEnable);
    fetchUserTypeFromSharedPref();
  }



  void fetchUserTypeFromSharedPref() async {
    String user = controller.userType;
    String phone = controller.phoneNumber;
    setState(() {
      if (user != null) {
        userTypeFromSharedPref = user;
        userPhone = phone;
      }
    });
  }

  postUserUploadProfileImage(String imagePathVal) async {
    try {
      setState(() {
        isLoading = true;
      });
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource
          .userUploadProfilePhoto(imagePathVal);
      result.fold((l) {
        setState(() {
          isLoading = false;
        });
        debugPrint("Error: $l");
      }, (r) async {
        if (r.status == "200") {
          userUploadImageOutput.clear();
          userUploadImageOutput.add(r);
          controller.profileImg.value =
              userUploadImageOutput.first.data.filepath;

          final getUserProfileResult =
              await baseMPartnerRemoteDataSource.getUserProfile();
          getUserProfileResult.fold(
            (l) {
              setState(() {
                isLoading = false;
              });
              debugPrint("Error: $l");
            },
            (r) async {
              setState(() {
                isLoading = false;
              });
              final List<UserProfile> userProfileData = [];
              userProfileData.addAll(r);
              if(userProfileData.isNotEmpty && controller.isPrimaryNumberLogin){
                if(userProfileData[0].phone.isNotEmpty){
                  logger.d("[userProfileData[0].phone profile photo]:: ${userProfileData[0].phone}");
                  controller.updatePhoneNumber(userProfileData[0].phone);
                }
              }
              final userProfileJson = jsonEncode(userProfileData);
              controller.updateUserProfile(userProfileJson);
            },
          );
        } else {
          setState(() {
            isLoading = false;
          });
          debugPrint("Error PP upload");
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error Captured: ${e}");
    }
  }

  DateTime? parseDate(String dateString) {
    try {
      return DateFormat('dd-MM-yyyy').parse(dateString);
    } catch (exception) {
      return null;
    }
  }

  String formattedDate(DateTime? date) {
    if (date == null) return '';

    return ' ${DateFormat('MMMM yyyy').format(date!)}';
  }

  Future<String> deleteDevice(String phone) async {
    String token = controller.token;
    String sapId = controller.sapId;
    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "phoneNumber": phone,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
    };
    try {
      final response = await Requests.sendPostRequest(
          ApiConstants.postDeleteDeviceEndPoint, body);
      if (response is! DioException && response.statusCode == 200) {
        return response.data['status'];
      } else {
        return response.data['status'];
      }
    } catch (error) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double fontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    void showDeleteDeviceBottomSheet(String title, String name,
        String relationship, String phone, String createdOn) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0 * pixelMultiplier),
          ),
        ),
        builder: (context) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    8 * variablePixelWidth,
                    8 * variablePixelHeight,
                    8 * variablePixelWidth,
                    8 * variablePixelHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const VerticalSpace(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Container(
                          height: 5 * variablePixelHeight,
                          width: 50 * variablePixelWidth,
                          decoration: BoxDecoration(
                            color: AppColors.dividerGreyColor,
                            borderRadius:
                                BorderRadius.circular(12 * pixelMultiplier),
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
                        color: AppColors.black,
                        size: 28 * pixelMultiplier,
                      ),
                    ),
                    const VerticalSpace(height: 12),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0 * variablePixelWidth),
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: AppColors.titleColor,
                          fontSize: 20 * fontMultiplier,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.50 * variablePixelWidth,
                        ),
                      ),
                    ),
                    const VerticalSpace(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                      child: const CustomDivider(color: AppColors.dividerColor),
                    ),
                    const VerticalSpace(height: 19),





                    Padding(
                      padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 16 * fontMultiplier,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10 * variablePixelWidth,
                            ),
                          ),
                          const VerticalSpace(height: 4),
                          Text(
                            relationship,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 16 * fontMultiplier,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10 * variablePixelWidth,
                            ),
                          ),
                          const VerticalSpace(height: 4),
                          Text(
                            '+91 - $phone',
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 16 * fontMultiplier,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10 * variablePixelWidth,
                            ),
                          ),
                          const VerticalSpace(height: 19),
                          Text(
                            '${translation(context).addedOn} ${DateFormat("MMMM ''yy").format(DateTime.parse(createdOn))}',
                            style: GoogleFonts.poppins(
                              color: AppColors.lightGreyBorder,
                              fontSize: 14 * fontMultiplier,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.10 * variablePixelWidth,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VerticalSpace(height: 16),
                    CommonButton(
                      onPressed: () {
                        deleteDevice(phone).then((status) {
                          if (status == "200") {
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(
                                context, AppRoutes.userprofile);
                          } else {
                            Utils().showToast(
                                'Secondary device not deleted!', context);
                          }
                        });
                      },
                      isEnabled: true,
                      buttonText: translation(context).delete,
                      backGroundColor: AppColors.logoutColor,
                      textColor: AppColors.lightWhite,
                      defaultButton: true,
                      containerBackgroundColor: AppColors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          logger.d("[RA_LOG] : BlocListener() called! ${state.userProfileScreenState}, ${widget.showBottomSheet}");
          if (state.userProfileScreenState == RequestState.loaded &&
              widget.showBottomSheet) {
            logger.d("[RA_LOG] : open() showBottomSheet  widget:: ${widget.type}");
            if (widget.type == ProfileBottomSheetType.pan &&
                userTypeFromSharedPref == UserTypeString.dealer) {
              final panImg = state.userProfileData[0].panImg;
              final panNo = state.userProfileData[0].permanentAccountNumber;
              final panStatus = state.userProfileData[0].panStatus;
              final panRemark = state.userProfileData[0].panRemarks;
              if(panStatus.isNotEmpty) {
                viewDetailsBottomSheet(
                  context,
                  'PAN',
                  translation(context).pan,
                  panImg,
                  null,
                  translation(context).panCardNumber,
                  panNo,
                  translation(context).status,
                  panStatus,
                  translation(context).remarks,
                  panRemark,
                );
              }
            } else if (widget.type == ProfileBottomSheetType.secondaryDevice1) {
              logger.d("[RA_LOG] : open() secondaryDevice1 ");
              if ((state.userProfileData.isNotEmpty &&
                  (state.userProfileData[0].secondaryDevice1 != null &&
                      state.userProfileData[0].secondaryDevice1.isNotEmpty)
                      ) ||
                  (state.userProfileData.length == 2 &&
                      (state.userProfileData[1].secondaryDevice1 != null &&
                      state.userProfileData[1].secondaryDevice1.isNotEmpty )
                      )) {
                logger.d("[RA_LOG] : Now open1() ");
                showDeleteDeviceBottomSheet(
                    translation(context).secondaryDevice1,
                    (state.userProfileData.isNotEmpty &&
                            state
                                .userProfileData[0].secondaryDevice1.isNotEmpty)
                        ? state.userProfileData[0].secondaryName
                        : (state.userProfileData.length == 2 &&
                                state.userProfileData[1].secondaryName
                                    .isNotEmpty)
                            ? state.userProfileData[1].secondaryName
                            : "",
                    (state.userProfileData.isNotEmpty &&
                            state
                                .userProfileData[0].secondaryDevice1.isNotEmpty)
                        ? state.userProfileData[0].relationShip
                        : (state.userProfileData.length == 2 &&
                                state
                                    .userProfileData[1].relationShip.isNotEmpty)
                            ? state.userProfileData[1].relationShip
                            : "",
                    (state.userProfileData.isNotEmpty &&
                            state
                                .userProfileData[0].secondaryDevice1.isNotEmpty)
                        ? state.userProfileData[0].secondaryDevice1
                        : (state.userProfileData.length == 2 &&
                                state.userProfileData[1].secondaryDevice1
                                    .isNotEmpty)
                            ? state.userProfileData[1].secondaryDevice1
                            : "",
                    (state.userProfileData.isNotEmpty &&
                            state
                                .userProfileData[0].secondaryDevice1.isNotEmpty)
                        ? state.userProfileData[0].createdOn
                        : (state.userProfileData.length == 2 &&
                                state.userProfileData[1].createdOn.isNotEmpty)
                            ? state.userProfileData[1].createdOn
                            : "");
              } else {
                logger.d("[RA_LOG] : ELSE NOT open() ");
              }
            } else if (widget.type.name == ProfileBottomSheetType.secondaryDevice2.name) {
              logger.d("[RA_LOG] : open() secondaryDevice2 ");
              if ((state.userProfileData.isNotEmpty &&
                  state.userProfileData[0].secondaryDevice2 != null &&
                      state.userProfileData[0].secondaryDevice2.isNotEmpty
                     ) ||
                  (state.userProfileData.length == 2 &&
                      state.userProfileData[1].secondaryDevice2 != null &&
                      state.userProfileData[1].secondaryDevice2.isNotEmpty)) {
                logger.d("[RA_LOG] : Now open2() ");
                showDeleteDeviceBottomSheet(
                    translation(context).secondaryDevice2,
                    (state.userProfileData.isNotEmpty &&
                            state
                                .userProfileData[0].secondaryDevice2.isNotEmpty)
                        ? state.userProfileData[0].secondaryName
                        : (state.userProfileData.length == 2 &&
                                state.userProfileData[1].secondaryName
                                    .isNotEmpty)
                            ? state.userProfileData[1].secondaryName
                            : "",
                    (state.userProfileData.isNotEmpty &&
                            state
                                .userProfileData[0].secondaryDevice2.isNotEmpty)
                        ? state.userProfileData[0].relationShip
                        : (state.userProfileData.length == 2 &&
                                state
                                    .userProfileData[1].relationShip.isNotEmpty)
                            ? state.userProfileData[1].relationShip
                            : "",
                    (state.userProfileData.isNotEmpty &&
                            state
                                .userProfileData[0].secondaryDevice2.isNotEmpty)
                        ? state.userProfileData[0].secondaryDevice2
                        : (state.userProfileData.length == 2 &&
                                state.userProfileData[1].secondaryDevice2
                                    .isNotEmpty)
                            ? state.userProfileData[1].secondaryDevice2
                            : "",
                    (state.userProfileData.isNotEmpty &&
                            state
                                .userProfileData[0].secondaryDevice2.isNotEmpty)
                        ? state.userProfileData[0].createdOn
                        : (state.userProfileData.length == 2 &&
                                state.userProfileData[1].createdOn.isNotEmpty)
                            ? state.userProfileData[1].createdOn
                            : "");
              } else {
                logger.d("[RA_LOG] : ELSE NOT open() ");
              }
            } else {
              logger.d("[RA_LOG] : ELSE NOT open() ${widget.type}");
            }
          }
          if (state.userProfileScreenState == RequestState.loaded) {
            if(state.userProfileData != null && state.userProfileData.isNotEmpty && controller.isPrimaryNumberLogin){
              if(state.userProfileData[0] !=null && state.userProfileData[0].phone.isNotEmpty){
                logger.d("[userProfileData[0].phone]:: ${state.userProfileData[0].phone}");
                controller.updatePhoneNumber(state.userProfileData[0].phone);
              }
            }
          }
        },
        child:Stack(
    children: [
            BlocBuilder<UserProfileBloc, UserProfileState>(
        buildWhen: (previous, current) =>
        previous.userProfileScreenState != current.userProfileScreenState,
        builder: (context, state) {
          bool isUserPhoneMatched = (state.userProfileData.isNotEmpty &&
              state.userProfileData[0].secondaryDevice1.isNotEmpty &&
              state.userProfileData[0].secondaryDevice1 == userPhone) ||
              (state.userProfileData.length == 2 &&
                  state.userProfileData[1].secondaryDevice1.isNotEmpty &&
                  state.userProfileData[1].secondaryDevice1 == userPhone) ||
              (state.userProfileData.isNotEmpty &&
                  state.userProfileData[0].secondaryDevice2.isNotEmpty &&
                  state.userProfileData[0].secondaryDevice2 == userPhone) ||
              (state.userProfileData.length == 2 &&
                  state.userProfileData[1].secondaryDevice2.isNotEmpty &&
                  state.userProfileData[1].secondaryDevice2 == userPhone);

          String secDev1 = (state.userProfileData.isNotEmpty &&
              state.userProfileData[0].secondaryDevice1.isNotEmpty)
              ? state.userProfileData[0].secondaryDevice1
              : (state.userProfileData.length == 2 &&
              state.userProfileData[1].secondaryDevice1.isNotEmpty)
              ? state.userProfileData[1].secondaryDevice1
              : "";

          bool isSecondaryDevice1 = secDev1 == controller.phoneNumber;

          switch (state.userProfileScreenState) {
            case RequestState.loading:
              return SizedBox(
                height: 400.0 * variablePixelHeight,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case RequestState.loaded:
              return Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20 * variablePixelHeight,
                          left: 20 * variablePixelWidth,
                          right: 16 * variablePixelWidth),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('MMM dd, yyyy').format(DateTime.now()),
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontWeight: FontWeight.w500,
                              fontSize: 14 * fontMultiplier,
                              letterSpacing: 0.10 * variablePixelWidth,
                            ),
                          ),
                          const HorizontalSpace(width: 8),
                          Transform(
                            transform: Matrix4.identity()
                              ..translate(7.0 * variablePixelWidth,
                                  -5.0 * variablePixelWidth)
                              ..rotateZ(1.57),
                            child: Container(
                              width: 14 * variablePixelWidth,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1 * variablePixelWidth,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: AppColors.lightGrey1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const HorizontalSpace(width: 8),
                          const ClockWidget(fontSize: 14),
                        ],
                      ),
                    ),
                    const VerticalSpace(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 20 * variablePixelWidth),
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    SizedBox(
                                      width: 77 * variablePixelWidth,
                                      height: 77 * variablePixelWidth,
                                      child: imagePath.isNotEmpty
                                          ? CircleAvatar(
                                        radius: 80.0 * pixelMultiplier,
                                        backgroundColor:
                                        AppColors.backgroundColor,
                                        child: isLoading
                                            ? const CircularProgressIndicator()
                                            : CircleAvatar(
                                          backgroundColor:
                                          AppColors
                                              .backgroundColor,
                                          radius: 80.0 *
                                              pixelMultiplier,
                                          backgroundImage:
                                          FileImage(File(
                                              imagePath)),
                                        ),
                                      )
                                          : state.userProfileData[0]
                                          .profileImg.isNotEmpty
                                          ? CircleAvatar(
                                        backgroundColor: AppColors
                                            .backgroundColor,
                                        radius:
                                        80.0 * pixelMultiplier,
                                        child: (isLoading)
                                            ? const CircularProgressIndicator()
                                            : CachedNetworkImage(
                                          imageUrl: controller
                                              .profileImg
                                              .value,
                                          imageBuilder: (context,
                                              imageProvider) =>
                                              Container(
                                                decoration:
                                                BoxDecoration(
                                                  shape: BoxShape
                                                      .circle,
                                                  image: DecorationImage(
                                                      image:
                                                      imageProvider,
                                                      fit: BoxFit
                                                          .cover),
                                                ),
                                              ),
                                          placeholder: (context,
                                              url) =>
                                          const CircularProgressIndicator(),
                                          errorWidget: (context,
                                              url,
                                              error) =>
                                              Image.asset(
                                                  'assets/mpartner/Profile_placeholder.png'),
                                        ),
                                      )
                                          : CircleAvatar(
                                        backgroundColor: AppColors
                                            .backgroundColor,
                                        radius:
                                        80.0 * pixelMultiplier,
                                        child: Image.asset(
                                            'assets/mpartner/Profile_placeholder.png'),
                                      ),
                                    ),
                                    Positioned(
                                      child: SizedBox(
                                        height: 24 * pixelMultiplier,
                                        width: 24 * pixelMultiplier,
                                        child: FloatingActionButton(
                                          onPressed: () async {
                                            await showUploadBottomSheet(
                                                context,
                                                translation(context)
                                                    .uploadProfilePicture,
                                                    (String imageCaptured) {
                                                  imagePath = imageCaptured;
                                                  if (imagePath.isNotEmpty) {
                                                    postUserUploadProfileImage(
                                                        imagePath);
                                                  }
                                                });
                                          },
                                          elevation: 0,
                                          backgroundColor:
                                          AppColors.lumiBluePrimary,
                                          shape: const CircleBorder(),
                                          child: Icon(Icons.edit_outlined,
                                              color: AppColors.white,
                                              size: 12 * pixelMultiplier),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const HorizontalSpace(
                                width: 16,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: 10 * variablePixelWidth),
                                      child: Text(
                                          state.userProfileData.isNotEmpty
                                              ? state.userProfileData[0].name
                                              : '',
                                          softWrap: true,
                                          style: GoogleFonts.poppins(
                                            color: AppColors.darkGreyText,
                                            fontSize: 16 * fontMultiplier,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing:
                                            0.10 * variablePixelWidth,
                                          )),
                                    ),
                                    const VerticalSpace(height: 5),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: 8 * variablePixelWidth),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              state.userProfileData.isNotEmpty
                                                  ? state.userProfileData[0]
                                                  .sap_Code
                                                  : '',
                                              style: GoogleFonts.poppins(
                                                color: AppColors.darkGreyText,
                                                fontSize: 16 * fontMultiplier,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          const HorizontalSpace(width: 4),
                                          Container(
                                            width: 5 * variablePixelWidth,
                                            height: 5 * variablePixelHeight,
                                            decoration: const ShapeDecoration(
                                              color: AppColors.lightGreyOval,
                                              shape: CircleBorder(),
                                            ),
                                          ),
                                          const HorizontalSpace(width: 4),
                                          Flexible(
                                            child: Text(
                                              state.userProfileData.isNotEmpty
                                                  ? state.userProfileData[0]
                                                  .userType
                                                  : '',
                                              style: GoogleFonts.poppins(
                                                color: AppColors.darkGreyText,
                                                fontSize: 16 * fontMultiplier,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                      state.userProfileData.isNotEmpty &&
                                          state.userProfileData[0]
                                              .anniversary.isNotEmpty &&
                                          formattedDate(parseDate(state
                                              .userProfileData[0]
                                              .anniversary))
                                              .isNotEmpty,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const VerticalSpace(height: 5),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right:
                                                16 * variablePixelWidth),
                                            child: Text(
                                              '${translation(context).since} ${formattedDate(parseDate(state.userProfileData[0].anniversary))}',
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.poppins(
                                                color:
                                                AppColors.lightGreyBorder,
                                                fontSize: 14 * fontMultiplier,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing:
                                                0.10 * variablePixelWidth,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                    const VerticalSpace(height: 30),
                    Container(
                        padding: EdgeInsets.only(
                            left: 20 * variablePixelWidth,
                            right: 16 * variablePixelWidth),
                        child: const ChangeAppLanguageWidget()),
                    const VerticalSpace(height: 32),







                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 20 * variablePixelWidth,
                                right: 16 * variablePixelWidth),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  translation(context).userDetails,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkGreyText,
                                    fontSize: 16 * fontMultiplier,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                                ProfileInfoWidget(
                                  title: translation(context).sapPhoneNumber,
                                  content: state.userProfileData.isNotEmpty
                                      ? "+91 - ${state.userProfileData[0].phone}"
                                      : '',
                                ),
                                const CustomDivider(
                                    color: AppColors.dividerColor),
                                ProfileInfoWidget(
                                  title: translation(context).emailAddress,
                                  content: state.userProfileData.isNotEmpty
                                      ? state.userProfileData[0].email
                                      : '',
                                ),
                                const CustomDivider(
                                    color: AppColors.dividerColor),
                                ProfileInfoWidget(
                                  title: translation(context).address,
                                  content: state.userProfileData.isNotEmpty
                                      ? "${state.userProfileData[0].address1}, ${state.userProfileData[0].address2}, ${state.userProfileData[0].city}, ${state.userProfileData[0].state}"
                                      : '',
                                ),
                                const CustomDivider(
                                    color: AppColors.dividerColor),
                                (userTypeFromSharedPref ==
                                    UserTypeString.electrician ||
                                    isUserPhoneMatched)
                                    ? const SizedBox(height: 0)
                                    : GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    if ((state.userProfileData
                                        .isNotEmpty &&
                                        state
                                            .userProfileData[0]
                                            .secondaryDevice1
                                            .isNotEmpty &&
                                        state.userProfileData[0]
                                            .secondaryDevice1 !=
                                            null) ||
                                        (state.userProfileData.length ==
                                            2 &&
                                            state
                                                .userProfileData[1]
                                                .secondaryDevice1
                                                .isNotEmpty &&
                                            state.userProfileData[1]
                                                .secondaryDevice1 !=
                                                null)) {
                                      showDeleteDeviceBottomSheet(
                                          translation(context)
                                              .secondaryDevice1,
                                          (state.userProfileData.isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice1
                                                  .isNotEmpty)
                                              ? state.userProfileData[0]
                                              .secondaryName
                                              : (state.userProfileData
                                              .length ==
                                              2 &&
                                              state
                                                  .userProfileData[
                                              1]
                                                  .secondaryName
                                                  .isNotEmpty)
                                              ? state
                                              .userProfileData[
                                          1]
                                              .secondaryName
                                              : "",
                                          (state.userProfileData.isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice1
                                                  .isNotEmpty)
                                              ? state.userProfileData[0]
                                              .relationShip
                                              : (state.userProfileData
                                              .length ==
                                              2 &&
                                              state
                                                  .userProfileData[
                                              1]
                                                  .relationShip
                                                  .isNotEmpty)
                                              ? state
                                              .userProfileData[
                                          1]
                                              .relationShip
                                              : "",
                                          (state.userProfileData.isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice1
                                                  .isNotEmpty)
                                              ? state.userProfileData[0]
                                              .secondaryDevice1
                                              : (state.userProfileData
                                              .length ==
                                              2 &&
                                              state
                                                  .userProfileData[1]
                                                  .secondaryDevice1
                                                  .isNotEmpty)
                                              ? state.userProfileData[1].secondaryDevice1
                                              : "",
                                          (state.userProfileData.isNotEmpty && state.userProfileData[0].secondaryDevice1.isNotEmpty)
                                              ? state.userProfileData[0].createdOn
                                              : (state.userProfileData.length == 2 && state.userProfileData[1].createdOn.isNotEmpty)
                                              ? state.userProfileData[1].createdOn
                                              : "");
                                    } else {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SecondaryDevice(
                                                secondaryScreenTitle:
                                                translation(context)
                                                    .secondaryDevice1,
                                                primaryNumber:
                                                controller
                                                    .phoneNumber,
                                                secondaryNumber: (state
                                                    .userProfileData
                                                    .isNotEmpty &&
                                                    state
                                                        .userProfileData[
                                                    0]
                                                        .secondaryDevice2
                                                        .isNotEmpty)
                                                    ? state
                                                    .userProfileData[
                                                0]
                                                    .secondaryDevice2
                                                    : (state.userProfileData
                                                    .length ==
                                                    2 &&
                                                    state
                                                        .userProfileData[
                                                    1]
                                                        .secondaryDevice2
                                                        .isNotEmpty)
                                                    ? state
                                                    .userProfileData[
                                                1]
                                                    .secondaryDevice2
                                                    : "");
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ProfileInfoWidget(
                                          title: translation(context)
                                              .secondaryDevice1,
                                          content: (state
                                              .userProfileData
                                              .isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice1
                                                  .isNotEmpty)
                                              ? '+91 - ${state.userProfileData[0].secondaryDevice1}'
                                              : (state.userProfileData
                                              .length ==
                                              2 &&
                                              state
                                                  .userProfileData[
                                              1]
                                                  .secondaryDevice1
                                                  .isNotEmpty)
                                              ? '+91 - ${state.userProfileData[1].secondaryDevice1}'
                                              : "",
                                        ),
                                      ),
                                      ChevronRightWidget(
                                        onPressed: () {
                                          if ((state.userProfileData
                                              .isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice1
                                                  .isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice1 !=
                                                  null) ||
                                              (state.userProfileData
                                                  .length ==
                                                  2 &&
                                                  state
                                                      .userProfileData[
                                                  1]
                                                      .secondaryDevice1
                                                      .isNotEmpty &&
                                                  state.userProfileData[1]
                                                      .secondaryDevice1 !=
                                                      null)) {
                                            showDeleteDeviceBottomSheet(
                                                translation(context)
                                                    .secondaryDevice1,
                                                (state.userProfileData.isNotEmpty &&
                                                    state
                                                        .userProfileData[
                                                    0]
                                                        .secondaryDevice1
                                                        .isNotEmpty)
                                                    ? state
                                                    .userProfileData[
                                                0]
                                                    .secondaryName
                                                    : (state.userProfileData.length == 2 &&
                                                    state
                                                        .userProfileData[
                                                    1]
                                                        .secondaryName
                                                        .isNotEmpty)
                                                    ? state
                                                    .userProfileData[
                                                1]
                                                    .secondaryName
                                                    : "",
                                                (state.userProfileData.isNotEmpty &&
                                                    state
                                                        .userProfileData[
                                                    0]
                                                        .secondaryDevice1
                                                        .isNotEmpty)
                                                    ? state
                                                    .userProfileData[
                                                0]
                                                    .relationShip
                                                    : (state.userProfileData.length == 2 &&
                                                    state
                                                        .userProfileData[
                                                    1]
                                                        .relationShip
                                                        .isNotEmpty)
                                                    ? state
                                                    .userProfileData[
                                                1]
                                                    .relationShip
                                                    : "",
                                                (state.userProfileData
                                                    .isNotEmpty &&
                                                    state
                                                        .userProfileData[
                                                    0]
                                                        .secondaryDevice1
                                                        .isNotEmpty)
                                                    ? state
                                                    .userProfileData[
                                                0]
                                                    .secondaryDevice1
                                                    : (state.userProfileData.length == 2 &&
                                                    state
                                                        .userProfileData[1]
                                                        .secondaryDevice1
                                                        .isNotEmpty)
                                                    ? state.userProfileData[1].secondaryDevice1
                                                    : "",
                                                (state.userProfileData.isNotEmpty && state.userProfileData[0].secondaryDevice1.isNotEmpty)
                                                    ? state.userProfileData[0].createdOn
                                                    : (state.userProfileData.length == 2 && state.userProfileData[1].createdOn.isNotEmpty)
                                                    ? state.userProfileData[1].createdOn
                                                    : "");
                                          } else {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return SecondaryDevice(
                                                      secondaryScreenTitle:
                                                      translation(
                                                          context)
                                                          .secondaryDevice1,
                                                      primaryNumber:
                                                      controller
                                                          .phoneNumber,
                                                      secondaryNumber: (state
                                                          .userProfileData
                                                          .isNotEmpty &&
                                                          state
                                                              .userProfileData[
                                                          0]
                                                              .secondaryDevice2
                                                              .isNotEmpty)
                                                          ? state
                                                          .userProfileData[
                                                      0]
                                                          .secondaryDevice2
                                                          : (state.userProfileData.length ==
                                                          2 &&
                                                          state
                                                              .userProfileData[
                                                          1]
                                                              .secondaryDevice2
                                                              .isNotEmpty)
                                                          ? state
                                                          .userProfileData[
                                                      1]
                                                          .secondaryDevice2
                                                          : "");
                                                },
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                (userTypeFromSharedPref ==
                                    UserTypeString.electrician ||
                                    isUserPhoneMatched)
                                    ? const SizedBox(height: 0)
                                    : const CustomDivider(
                                    color: AppColors.dividerColor),
                                (userTypeFromSharedPref ==
                                    UserTypeString.electrician ||
                                    isUserPhoneMatched)
                                    ? const SizedBox(height: 0)
                                    : GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    if ((state.userProfileData
                                        .isNotEmpty &&
                                        state
                                            .userProfileData[0]
                                            .secondaryDevice2
                                            .isNotEmpty &&
                                        state.userProfileData[0]
                                            .secondaryDevice2 !=
                                            null) ||
                                        (state.userProfileData.length ==
                                            2 &&
                                            state
                                                .userProfileData[1]
                                                .secondaryDevice2
                                                .isNotEmpty &&
                                            state.userProfileData[1]
                                                .secondaryDevice2 !=
                                                null)) {
                                      showDeleteDeviceBottomSheet(
                                          translation(context)
                                              .secondaryDevice2,
                                          (state.userProfileData.isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice2
                                                  .isNotEmpty)
                                              ? state.userProfileData[0]
                                              .secondaryName
                                              : (state.userProfileData
                                              .length ==
                                              2 &&
                                              state
                                                  .userProfileData[
                                              1]
                                                  .secondaryName
                                                  .isNotEmpty)
                                              ? state
                                              .userProfileData[
                                          1]
                                              .secondaryName
                                              : "",
                                          (state.userProfileData.isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice2
                                                  .isNotEmpty)
                                              ? state.userProfileData[0]
                                              .relationShip
                                              : (state.userProfileData
                                              .length ==
                                              2 &&
                                              state
                                                  .userProfileData[
                                              1]
                                                  .relationShip
                                                  .isNotEmpty)
                                              ? state
                                              .userProfileData[
                                          1]
                                              .relationShip
                                              : "",
                                          (state.userProfileData.isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice2
                                                  .isNotEmpty)
                                              ? state.userProfileData[0]
                                              .secondaryDevice2
                                              : (state.userProfileData
                                              .length ==
                                              2 &&
                                              state
                                                  .userProfileData[1]
                                                  .secondaryDevice2
                                                  .isNotEmpty)
                                              ? state.userProfileData[1].secondaryDevice2
                                              : "",
                                          (state.userProfileData.isNotEmpty && state.userProfileData[0].secondaryDevice2.isNotEmpty)
                                              ? state.userProfileData[0].createdOn
                                              : (state.userProfileData.length == 2 && state.userProfileData[1].createdOn.isNotEmpty)
                                              ? state.userProfileData[1].createdOn
                                              : "");
                                    } else {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SecondaryDevice(
                                                secondaryScreenTitle:
                                                translation(context)
                                                    .secondaryDevice2,
                                                primaryNumber:
                                                controller
                                                    .phoneNumber,
                                                secondaryNumber: (state
                                                    .userProfileData
                                                    .isNotEmpty &&
                                                    state
                                                        .userProfileData[
                                                    0]
                                                        .secondaryDevice1
                                                        .isNotEmpty)
                                                    ? state
                                                    .userProfileData[
                                                0]
                                                    .secondaryDevice1
                                                    : (state.userProfileData
                                                    .length ==
                                                    2 &&
                                                    state
                                                        .userProfileData[
                                                    1]
                                                        .secondaryDevice1
                                                        .isNotEmpty)
                                                    ? state
                                                    .userProfileData[
                                                1]
                                                    .secondaryDevice1
                                                    : "");
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ProfileInfoWidget(
                                          title: translation(context)
                                              .secondaryDevice2,
                                          content: (state
                                              .userProfileData
                                              .isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice2
                                                  .isNotEmpty)
                                              ? '+91 - ${state.userProfileData[0].secondaryDevice2}'
                                              : (state.userProfileData
                                              .length ==
                                              2 &&
                                              state
                                                  .userProfileData[
                                              1]
                                                  .secondaryDevice2
                                                  .isNotEmpty)
                                              ? '+91 - ${state.userProfileData[1].secondaryDevice2}'
                                              : "",
                                        ),
                                      ),
                                      ChevronRightWidget(
                                        onPressed: () {
                                          if ((state.userProfileData
                                              .isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice2
                                                  .isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice2 !=
                                                  null) ||
                                              (state.userProfileData
                                                  .length ==
                                                  2 &&
                                                  state
                                                      .userProfileData[
                                                  1]
                                                      .secondaryDevice2
                                                      .isNotEmpty &&
                                                  state.userProfileData[1]
                                                      .secondaryDevice2 !=
                                                      null)) {
                                            showDeleteDeviceBottomSheet(
                                                translation(context)
                                                    .secondaryDevice2,
                                                (state.userProfileData.isNotEmpty &&
                                                    state
                                                        .userProfileData[
                                                    0]
                                                        .secondaryDevice2
                                                        .isNotEmpty)
                                                    ? state
                                                    .userProfileData[
                                                0]
                                                    .secondaryName
                                                    : (state.userProfileData.length == 2 &&
                                                    state
                                                        .userProfileData[
                                                    1]
                                                        .secondaryName
                                                        .isNotEmpty)
                                                    ? state
                                                    .userProfileData[
                                                1]
                                                    .secondaryName
                                                    : "",
                                                (state.userProfileData.isNotEmpty &&
                                                    state
                                                        .userProfileData[
                                                    0]
                                                        .secondaryDevice2
                                                        .isNotEmpty)
                                                    ? state
                                                    .userProfileData[
                                                0]
                                                    .relationShip
                                                    : (state.userProfileData.length == 2 &&
                                                    state
                                                        .userProfileData[
                                                    1]
                                                        .relationShip
                                                        .isNotEmpty)
                                                    ? state
                                                    .userProfileData[
                                                1]
                                                    .relationShip
                                                    : "",
                                                (state.userProfileData
                                                    .isNotEmpty &&
                                                    state
                                                        .userProfileData[
                                                    0]
                                                        .secondaryDevice2
                                                        .isNotEmpty)
                                                    ? state
                                                    .userProfileData[
                                                0]
                                                    .secondaryDevice2
                                                    : (state.userProfileData.length == 2 &&
                                                    state
                                                        .userProfileData[1]
                                                        .secondaryDevice2
                                                        .isNotEmpty)
                                                    ? state.userProfileData[1].secondaryDevice2
                                                    : "",
                                                (state.userProfileData.isNotEmpty && state.userProfileData[0].secondaryDevice2.isNotEmpty)
                                                    ? state.userProfileData[0].createdOn
                                                    : (state.userProfileData.length == 2 && state.userProfileData[1].createdOn.isNotEmpty)
                                                    ? state.userProfileData[1].createdOn
                                                    : "");
                                          } else {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return SecondaryDevice(
                                                      secondaryScreenTitle:
                                                      translation(
                                                          context)
                                                          .secondaryDevice2,
                                                      primaryNumber:
                                                      controller
                                                          .phoneNumber,
                                                      secondaryNumber: (state
                                                          .userProfileData
                                                          .isNotEmpty &&
                                                          state
                                                              .userProfileData[
                                                          0]
                                                              .secondaryDevice1
                                                              .isNotEmpty)
                                                          ? state
                                                          .userProfileData[
                                                      0]
                                                          .secondaryDevice1
                                                          : (state.userProfileData.length ==
                                                          2 &&
                                                          state
                                                              .userProfileData[
                                                          1]
                                                              .secondaryDevice1
                                                              .isNotEmpty)
                                                          ? state
                                                          .userProfileData[
                                                      1]
                                                          .secondaryDevice1
                                                          : "");
                                                },
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                (isUserPhoneMatched)
                                    ? Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const VerticalSpace(height: 24),
                                    Text(
                                      translation(context).myDetails,
                                      style: GoogleFonts.poppins(
                                        color: AppColors.darkGreyText,
                                        fontSize: 16 * fontMultiplier,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing:
                                        0.10 * variablePixelWidth,
                                      ),
                                    ),
                                    isSecondaryDevice1
                                        ? Column(
                                      children: [
                                        const VerticalSpace(
                                            height: 24),
                                        SecondaryDevDetails(
                                          label:
                                          translation(context)
                                              .name,
                                          value: (state
                                              .userProfileData
                                              .isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice1
                                                  .isNotEmpty)
                                              ? state
                                              .userProfileData[
                                          0]
                                              .secondaryName
                                              : (state.userProfileData
                                              .length ==
                                              2 &&
                                              state
                                                  .userProfileData[
                                              1]
                                                  .secondaryName
                                                  .isNotEmpty)
                                              ? state
                                              .userProfileData[
                                          1]
                                              .secondaryName
                                              : "",
                                        ),
                                        const VerticalSpace(
                                            height: 24),
                                        SecondaryDevDetails(
                                          label: translation(
                                              context)
                                              .relationshipWithOwner,
                                          value: (state
                                              .userProfileData
                                              .isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice1
                                                  .isNotEmpty)
                                              ? state
                                              .userProfileData[
                                          0]
                                              .relationShip
                                              : (state.userProfileData
                                              .length ==
                                              2 &&
                                              state
                                                  .userProfileData[
                                              1]
                                                  .relationShip
                                                  .isNotEmpty)
                                              ? state
                                              .userProfileData[
                                          1]
                                              .relationShip
                                              : "",
                                        ),
                                        const VerticalSpace(
                                            height: 24),
                                        SecondaryDevDetails(
                                          label:
                                          translation(context)
                                              .mobileNumber,
                                          value: (state
                                              .userProfileData
                                              .isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice1
                                                  .isNotEmpty)
                                              ? '+91-${state.userProfileData[0].secondaryDevice1}'
                                              : (state.userProfileData
                                              .length ==
                                              2 &&
                                              state
                                                  .userProfileData[
                                              1]
                                                  .secondaryDevice1
                                                  .isNotEmpty)
                                              ? '+91-${state.userProfileData[1].secondaryDevice1}'
                                              : "",
                                        ),
                                        const VerticalSpace(
                                            height: 47),
                                      ],
                                    )
                                        : Column(
                                      children: [
                                        const VerticalSpace(
                                            height: 24),
                                        SecondaryDevDetails(
                                          label:
                                          translation(context)
                                              .name,
                                          value: (state
                                              .userProfileData
                                              .isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice2
                                                  .isNotEmpty)
                                              ? state
                                              .userProfileData[
                                          0]
                                              .secondaryName
                                              : (state.userProfileData
                                              .length ==
                                              2 &&
                                              state
                                                  .userProfileData[
                                              1]
                                                  .secondaryName
                                                  .isNotEmpty)
                                              ? state
                                              .userProfileData[
                                          1]
                                              .secondaryName
                                              : "",
                                        ),
                                        const VerticalSpace(
                                            height: 24),
                                        SecondaryDevDetails(
                                          label: translation(
                                              context)
                                              .relationshipWithOwner,
                                          value: (state
                                              .userProfileData
                                              .isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice2
                                                  .isNotEmpty)
                                              ? state
                                              .userProfileData[
                                          0]
                                              .relationShip
                                              : (state.userProfileData
                                              .length ==
                                              2 &&
                                              state
                                                  .userProfileData[
                                              1]
                                                  .relationShip
                                                  .isNotEmpty)
                                              ? state
                                              .userProfileData[
                                          1]
                                              .relationShip
                                              : "",
                                        ),
                                        const VerticalSpace(
                                            height: 24),
                                        SecondaryDevDetails(
                                          label:
                                          translation(context)
                                              .mobileNumber,
                                          value: (state
                                              .userProfileData
                                              .isNotEmpty &&
                                              state
                                                  .userProfileData[
                                              0]
                                                  .secondaryDevice2
                                                  .isNotEmpty)
                                              ? '+91-${state.userProfileData[0].secondaryDevice2}'
                                              : (state.userProfileData
                                              .length ==
                                              2 &&
                                              state
                                                  .userProfileData[
                                              1]
                                                  .secondaryDevice2
                                                  .isNotEmpty)
                                              ? '+91-${state.userProfileData[1].secondaryDevice2}'
                                              : "",
                                        ),
                                        const VerticalSpace(
                                            height: 47),
                                      ],
                                    )
                                  ],
                                )
                                    : const SizedBox(height: 0),
                                controller.isPrimaryNumberLogin
                                    ? CertificateWidget(
                                    authorisedCertificateUrl: state
                                        .userProfileData[0].authCertImg,
                                    authorisedCertificateIssueDate: state
                                        .userProfileData[0]
                                        .authCert_IssuedDate,
                                    certificateOfAppreciationUrl: state
                                        .userProfileData[0]
                                        .certOfApprectiationImg,
                                    certificateOfAppreciationIssueDate:
                                    state.userProfileData[0]
                                        .certOfAppreciation_IssuedDate)
                                    : const SizedBox(height: 0),
                                const VerticalSpace(height: 32),
                                controller.isPrimaryNumberLogin
                                    ? TravelDocumentsWidget(
                                  panImg:
                                  state.userProfileData[0].panImg,
                                  panNo: state.userProfileData[0]
                                      .permanentAccountNumber,
                                  panStatus: state
                                      .userProfileData[0].panStatus,
                                  panRemark: state
                                      .userProfileData[0].panRemarks,
                                  gstImg: state
                                      .userProfileData[0].gstCerImg,
                                  gstNo: state
                                      .userProfileData[0].gstNumber,
                                  gstStatus: state
                                      .userProfileData[0].gstStatus,
                                  gstRemark: state
                                      .userProfileData[0].gstRemarks,
                                  passportFront: state
                                      .userProfileData[0].passportFront,
                                  passportBack: state
                                      .userProfileData[0].passportBack,
                                  passportNo: state
                                      .userProfileData[0].passportNo,
                                  passportStatus: state
                                      .userProfileData[0]
                                      .passportStatus,
                                  passportRemark: state
                                      .userProfileData[0]
                                      .passportRemarks,
                                )
                                    : const SizedBox(height: 0),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

                    GetBuilder<AppSettingValueController>(builder: (con) {
                      return appSettingValueController.isdeleted.value=="1"
                          ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          DeleteOption(delete:() async {
                            if(appSettingValueController.getAccountDeleted.value=="1"){
                              Utils().showToast(translation(context).requestUnderProcess, context);
                            }else{
                              await show_delete(context).then((value){
                                appSettingValueController.fetchAppSettingValues(AppConstants.IsUserDeletemessage).then((value) async {
                                  await SharedPreferencesUtil.setAccountDeleted("1");
                                  await showDeleteMessage(context,appSettingValueController.deletemesssage.value.toString());
                                  Navigator.pop(context);
                                });

                              });



                            }







                          }),


                        ],
                      )
                          : Container();
                    }),


                    GetBuilder<AppSettingValueController>(builder: (con) {
                      return appSettingValueController.isdeleted.value=="1"
                          ?VerticalSpace(height: 20)
                          : Container();
                    }),
                  ],
                ),
              );
            case RequestState.error:
              return const SomethingWentWrongWidget();
          }
        },
        )
        ],
    ));
  }
}
