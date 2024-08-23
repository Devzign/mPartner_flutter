import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../data/models/user_profile_model.dart';
import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../../utils/animated_check.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/localdata/shared_preferences_util.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../../../../widgets/common_button.dart';
import '../../../../widgets/headers/home_header_widget.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import 'dummy_container.dart';

class DummyHomescreen extends StatefulWidget {
  const DummyHomescreen({super.key});

  @override
  State<DummyHomescreen> createState() => _DummyHomescreenState();
}

class _DummyHomescreenState extends State<DummyHomescreen> {
  String token = "";
  String sapId = "";
  String userType = "";
  String phoneNo = "";
  bool showBottomSheet = false;
  bool bottomSheetShown = false;
  bool isButtonEnabled = false;
  bool firstBodyVisible = true;
  bool secondBodyVisible = false;
  List<UserProfile> storedUserProfile = [];
  bool showInHomepage = true;
  bool showAnimatedCheck = false;
  bool isScrollingDown = false;
  bool showHomepage = false;
  double variablePixelHeight = 0;
  double variablePixelWidth = 0;
  double textFontMultiplier = 0;
  double pixelMultiplier = 0;
  UserDataController userPreferencesController = Get.find();

  void showBottomSheetLoader(BuildContext context, double variablePixelHeight,
      double variablePixelWidth) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted) {
                setState(() {
                  isButtonEnabled = true;
                  firstBodyVisible = false;
                  secondBodyVisible = true;
                });
              }
            });
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  showAnimatedCheck = true;
                });
              }
            });
            return Container(
              decoration: BoxDecoration(
                color: AppColors.lightWhite1,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30 * pixelMultiplier),
                  topRight: Radius.circular(30 * pixelMultiplier),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    24 * variablePixelWidth,
                    10 * variablePixelHeight,
                    24 * variablePixelWidth,
                    10 * variablePixelHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: firstBodyVisible,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(height: variablePixelHeight * 64),
                          SizedBox(
                            width: 360 * pixelMultiplier,
                            height: 360 * pixelMultiplier,
                            child: GetBuilder<UserDataController>(builder: (_) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  showAnimatedCheck
                                      ? AnimatedCheck()
                                      : Container(),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: TweenAnimationBuilder<double>(
                                        tween:
                                            Tween<double>(begin: 0.0, end: 1.0),
                                        duration:
                                            const Duration(milliseconds: 2000),
                                        builder: (context, value, _) {
                                          if (value < 1.0) {
                                            return SizedBox(
                                              height: 280 * pixelMultiplier,
                                              width: 280 * pixelMultiplier,
                                              child: CircularProgressIndicator(
                                                value: value,
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                        Color>(
                                                  AppColors.lumiLight4,
                                                ),
                                                strokeWidth: 10.0,
                                              ),
                                            );
                                          } else {
                                            return SizedBox(
                                              height: 280 * pixelMultiplier,
                                              width: 280 * pixelMultiplier,
                                              child: CircularProgressIndicator(
                                                value: value,
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                        Color>(
                                                  AppColors.successGreen,
                                                ),
                                                strokeWidth: 10.0,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          AppColors.backgroundColor,
                                      radius: 40.0 * pixelMultiplier,
                                      child: userPreferencesController
                                                          .sapIdImageMap[
                                                      userPreferencesController
                                                          .sapId] !=
                                                  null &&
                                              userPreferencesController
                                                          .sapIdImageMap[
                                                      userPreferencesController
                                                          .sapId] !=
                                                  ""
                                          ? SizedBox(
                                              height: variablePixelHeight * 80,
                                              width: variablePixelWidth * 80,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    userPreferencesController
                                                            .sapIdImageMap[
                                                        userPreferencesController
                                                            .sapId]!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(
                                                        'assets/mpartner/Profile_placeholder.png'),
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundColor:
                                                  AppColors.backgroundColor,
                                              radius: 40.0 * pixelMultiplier,
                                              child: SizedBox(
                                                height:
                                                    variablePixelHeight * 80,
                                                width: variablePixelWidth * 80,
                                                child: Image.asset(
                                                    'assets/mpartner/Profile_placeholder.png'),
                                              ),
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 40.0 * pixelMultiplier,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.lightWhite1,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    40 * pixelMultiplier)),
                                            border: Border.all(
                                              color: AppColors.darkText2,
                                              width: 1.0 * pixelMultiplier,
                                            ),
                                          ),
                                          child: Container(
                                            width: 80 * variablePixelWidth,
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/mpartner/logo.png',
                                                  width:
                                                      variablePixelWidth * 50,
                                                  height:
                                                      variablePixelHeight * 11,
                                                ),
                                                Image.asset(
                                                  'assets/mpartner/mPartner.png',
                                                  width:
                                                      variablePixelWidth * 29,
                                                  height:
                                                      variablePixelHeight * 11,
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                          CommonButton(
                            onPressed: () {},
                            isEnabled: isButtonEnabled,
                            buttonText: translation(context).continueButtonText,
                            containerBackgroundColor: AppColors.lightWhite1,
                            withContainer: false,
                          ),
                          Container(height: variablePixelHeight * 32),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: secondBodyVisible,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: variablePixelHeight * 28),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 80.0 * pixelMultiplier,
                            child: GetBuilder<UserDataController>(builder: (_) {
                              return Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          AppColors.backgroundColor,
                                      radius: 40.0 * pixelMultiplier,
                                      child: userPreferencesController
                                                          .sapIdImageMap[
                                                      userPreferencesController
                                                          .sapId] !=
                                                  null &&
                                              userPreferencesController
                                                          .sapIdImageMap[
                                                      userPreferencesController
                                                          .sapId] !=
                                                  ""
                                          ? SizedBox(
                                              height: 80.0 * pixelMultiplier,
                                              width: 80.0 * pixelMultiplier,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    userPreferencesController
                                                            .sapIdImageMap[
                                                        userPreferencesController
                                                            .sapId]!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(
                                                        'assets/mpartner/Profile_placeholder.png'),
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundColor:
                                                  AppColors.backgroundColor,
                                              radius: 40.0 * pixelMultiplier,
                                              child: SizedBox(
                                                height:
                                                    variablePixelHeight * 80,
                                                width: variablePixelWidth * 80,
                                                child: Image.asset(
                                                    'assets/mpartner/Profile_placeholder.png'),
                                              ),
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 50,
                                    child: CircleAvatar(
                                      radius: 40.0 * pixelMultiplier,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.lightWhite1,
                                            borderRadius: BorderRadius.circular(
                                                40 * pixelMultiplier),
                                            border: Border.all(
                                              color: AppColors.darkText2,
                                              width: 1 * pixelMultiplier,
                                            ),
                                          ),
                                          child: Container(
                                            width: 80.0 * pixelMultiplier,
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/mpartner/logo.png',
                                                  width:
                                                      variablePixelWidth * 50,
                                                  height:
                                                      variablePixelHeight * 11,
                                                ),
                                                Image.asset(
                                                  'assets/mpartner/mPartner.png',
                                                  width:
                                                      variablePixelWidth * 29,
                                                  height:
                                                      variablePixelHeight * 11,
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                          Container(height: variablePixelHeight * 12),
                          Text(
                            storedUserProfile[0].sap_Code,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: textFontMultiplier * 20,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.10,
                            ),
                          ),
                          Text(
                            "${storedUserProfile[0].name},${storedUserProfile[0].city}",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkText2,
                              fontSize: textFontMultiplier * 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10,
                            ),
                          ),
                          Container(height: variablePixelHeight * 20),
                          Text(
                            () {
                              if (userPreferencesController
                                      .isPrimaryNumberLogin ==
                                  true) {
                                return translation(context)
                                    .registeredSapPhoneNo;
                              } else {
                                return translation(context).name;
                              }
                            }(),
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: textFontMultiplier * 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10,
                            ),
                          ),
                          Text(
                            () {
                              if (userPreferencesController
                                      .isPrimaryNumberLogin ==
                                  true) {
                                return "+91-${storedUserProfile[0].phone}";
                              } else if (userPreferencesController
                                      .getSecondaryDeviceInfo ==
                                  "secondaryDevice1") {
                                return storedUserProfile[0].secondaryName;
                              } else {
                                if (storedUserProfile.length > 1) {
                                  return storedUserProfile[1].secondaryName;
                                } else {
                                  return storedUserProfile[0].secondaryName;
                                }
                              }
                            }(),
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: textFontMultiplier * 12,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.10,
                            ),
                          ),
                          Container(height: variablePixelHeight * 12),
                          Text(
                            () {
                              if (userPreferencesController
                                      .isPrimaryNumberLogin ==
                                  true) {
                                return translation(context).emailAddress;
                              } else {
                                return translation(context)
                                    .relationshipWithOwner;
                              }
                            }(),
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: textFontMultiplier * 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10,
                            ),
                          ),
                          Text(
                            () {
                              if (userPreferencesController
                                      .isPrimaryNumberLogin ==
                                  true) {
                                return storedUserProfile[0].email;
                              } else if (userPreferencesController
                                      .getSecondaryDeviceInfo ==
                                  "secondaryDevice1") {
                                return storedUserProfile[0].relationShip;
                              } else {
                                if (storedUserProfile.length > 1) {
                                  return storedUserProfile[1].relationShip;
                                } else {
                                  return storedUserProfile[0].relationShip;
                                }
                              }
                            }(),
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: textFontMultiplier * 12,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.10,
                            ),
                          ),
                          Container(height: variablePixelHeight * 12),
                          Text(
                            () {
                              if (userPreferencesController
                                      .isPrimaryNumberLogin ==
                                  true) {
                                return translation(context).address;
                              } else {
                                return translation(context)
                                    .secondaryDeviceNumber;
                              }
                            }(),
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: textFontMultiplier * 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10,
                            ),
                          ),
                          Text(
                            () {
                              if (userPreferencesController
                                      .isPrimaryNumberLogin ==
                                  true) {
                                return '${storedUserProfile[0].address1} ${storedUserProfile[0].address2}, '
                                    '${storedUserProfile[0].city},${storedUserProfile[0].district}, '
                                    '${storedUserProfile[0].state}';
                              } else if (userPreferencesController
                                      .getSecondaryDeviceInfo ==
                                  "secondaryDevice1") {
                                return "+91-${storedUserProfile[0].secondaryDevice1}";
                              } else {
                                if (storedUserProfile.length > 1) {
                                  return "+91-${storedUserProfile[1]
                                      .secondaryDevice2}";
                                } else {
                                  return "+91-${storedUserProfile[0]
                                      .secondaryDevice2}";
                                }
                              }
                            }(),
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: textFontMultiplier * 12,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.10,
                            ),
                          ),
                          Container(height: variablePixelHeight * 30),
                          CommonButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.homepage,
                                (Route<dynamic> route) => false,
                              );
                              showHomepage = false;
                            },
                            isEnabled: true,
                            buttonText: translation(context).continueButtonText,
                            containerBackgroundColor: AppColors.lightWhite1,
                            withContainer: false,
                          ),
                          Container(height: variablePixelHeight * 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  @override
  void initState() {
    loadData();
    if (!bottomSheetShown && !showBottomSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!bottomSheetShown) {
          showBottomSheetLoader(
              context, variablePixelHeight, variablePixelWidth);
          SharedPreferencesUtil.setBottomSheetShown(true);
          setState(() {
            showBottomSheet = true;
          });
        }
      });
    }
    super.initState();
  }

  Future<void> loadData() async {
    UserDataController controller = Get.find();

    bool? val = await SharedPreferencesUtil.getBottomSheetShown();
    storedUserProfile = controller.userProfile;
    setState(() {
      token = controller.token;
      sapId = controller.sapId;
      phoneNo = controller.phoneNumber;
      bottomSheetShown = val ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            const HomeHeaderWidget(),
            VerticalSpace(height: 24 * variablePixelHeight),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 24 * variablePixelWidth),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DummyContainer(
                          containerHeight: 44 * variablePixelHeight,
                          containerWidth: 133 * variablePixelWidth,
                          roundedBorder: false,
                        ),
                        DummyContainer(
                          containerHeight: 44 * variablePixelHeight,
                          containerWidth: 77 * variablePixelWidth,
                          roundedBorder: false,
                        )
                      ],
                    ),
                    const VerticalSpace(height: 24),
                    DummyContainer(
                      containerHeight: 24 * variablePixelHeight,
                      containerWidth: double.infinity,
                      roundedBorder: false,
                    ),
                    VerticalSpace(height: 24 * variablePixelHeight),
                    DummyContainer(
                      containerHeight: 180 * variablePixelHeight,
                      containerWidth: double.infinity,
                      roundedBorder: true,
                    ),
                    const VerticalSpace(height: 24),
                    DummyContainer(
                      containerHeight: 24,
                      containerWidth: double.infinity,
                      roundedBorder: false,
                    ),
                    const VerticalSpace(height: 24),
                    DummyContainer(
                        containerHeight: 86 * variablePixelHeight,
                        containerWidth: double.infinity,
                        roundedBorder: true),
                    const VerticalSpace(height: 24),
                    DummyContainer(
                        containerHeight: 89 * variablePixelHeight,
                        containerWidth: double.infinity,
                        roundedBorder: true),
                    const VerticalSpace(height: 24),
                    DummyContainer(
                        containerHeight: 24 * variablePixelHeight,
                        containerWidth: double.infinity,
                        roundedBorder: false),
                    const VerticalSpace(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
