import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:pinput/pinput.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../services/services_locator.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../data/models/user_data_model.dart';
import '../../../state/contoller/auth_contoller.dart';
import '../../../state/contoller/common_login_banners_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../widgets/common_button.dart';
import '../base_screen.dart';
import '../home/Homescreen/dummy_homescreen/dummy_homescreen.dart';
import 'bloc/verify_otp_bloc.dart';

class VerifyOtpStateScreen extends StatefulWidget {
  final String getId;
  final String phoneNo;
  final String message;
  final String timerData;

  const VerifyOtpStateScreen(
      {super.key,
      required this.getId,
      required this.phoneNo,
      required this.message,
      required this.timerData});

  @override
  State<VerifyOtpStateScreen> createState() => _VerifyOtpStateState();
}

class _VerifyOtpStateState extends BaseScreenState<VerifyOtpStateScreen>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  late TextEditingController _controller;
  bool isOtpValid = true;
  String otpValidMessage = '';
  String getOtpData = '';
  bool first = true;
  bool last = false;
  bool isResendButtonEnabled = true;
  bool isReResendButtonEnabled = true;
  late int timer;
  int timerMax = 60;
  bool isButtonEnabled = false;
  late BuildContext outerContext;
  late BuildContext blocOuterContext;
  int? userDataIndex;
  String? maxAttemptMsg;
  String? timerMaxData;
  double topContainerHeight = 254.0;
  double topContainerShrinkPadding1 = 100;
  double topContainerShrinkPadding2 = 20.0;
  double topContainerHeight2 = 254.0;
  bool isSnackBarShown = true;
  double variablePixelHeight = 0;
  double variablePixelWidth = 0;
  double textFontMultiplier = 0;
  double pixelMultiplier = 0;
  Logger logger = Logger();
  bool showLoader = false;
  final ScrollController _scrollController = ScrollController();
  final controller = PageController(viewportFraction: 1.0, keepPage: true);
  CommonLoginBannerController commonLoginBannerController = Get.find();
  Timer? controllerTimer;
  final FocusNode phoneNumberFocusNode = FocusNode();
  AuthController authController=Get.find();

  @override
  void initState() {
    commonLoginBannerController.fetchLoginBanners();
    timer = int.tryParse(widget.timerData) ?? 0;
    if (timer > 0 && timer <= 60) {
      startTimer();
    } else {
      isResendButtonEnabled = false;
    }
    phoneNumberFocusNode.addListener(() {
      setState(() {});
    });
    _controller = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controllerTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
        if (controller.hasClients && controller.page != null && commonLoginBannerController.cardData.isNotEmpty) {
          final pageCount = commonLoginBannerController.cardData.length;
          controller.animateToPage(
            (controller.page!.toInt() + 1) % pageCount,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    });
    super.initState();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      if (timer.isActive && mounted) {
        setState(() {
          if (this.timer > 0 && this.timer <= 60) {
            this.timer--;
          } else {
            timer.cancel();
            setState(() {
              isResendButtonEnabled = false;
            });
          }
        });
      }
    });
  }

  void startTimer2() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      if (timer.isActive && mounted) {
        setState(() {
          if (this.timer > 0 && this.timer <= 60) {
            this.timer--;
          } else {
            timer.cancel();
            setState(() {
              isReResendButtonEnabled = true;
            });
          }
        });
      }
    });
  }

  void showBottomSheetMessage(
      BuildContext innerContext,
      String maxAttemptMessage,
      double variablePixelHeight,
      double variablePixelWidth) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: variablePixelHeight * 250,
          decoration: BoxDecoration(
            color: AppColors.lightWhite1,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30 * pixelMultiplier),
              topRight: Radius.circular(30 * pixelMultiplier),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24 * variablePixelWidth,
                    24 * variablePixelHeight, 24 * variablePixelWidth, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translation(context).loginAlert,
                        style: GoogleFonts.poppins(
                          color: AppColors.titleColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24 * variablePixelWidth,
                    16 * variablePixelHeight, 24 * variablePixelWidth, 0),
                child: Container(
                  height: 1 * variablePixelHeight,
                  color: AppColors.grayText,
                  margin:
                      EdgeInsets.symmetric(vertical: 8 * variablePixelHeight),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      24 * variablePixelWidth,
                      24 * variablePixelHeight,
                      16 * variablePixelWidth,
                      16 * variablePixelHeight),
                  child: Text(
                    maxAttemptMessage,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGreyText,
                      fontSize: 14 * textFontMultiplier,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.10,
                    ),
                  ),
                ),
              ),
              CommonButton(
                  onPressed: () {
                    try {
                      if(Navigator.of(context).canPop()){
                        Navigator.pop(context);
                      }
                      if(Navigator.of(innerContext).canPop()){
                        Navigator.pop(innerContext);
                      }
                    } catch (e){
                      //printError(e);
                    }
                  },
                  isEnabled: true,
                  buttonText: translation(context).buttonOkay,
                  containerBackgroundColor: AppColors.lightWhite1,
                  containerHeight: variablePixelHeight * 56),
            ],
          ),
        );
      },
    );
  }

  void showBottomSheetSAPID(
      BuildContext innerContext,
      List<UserData> splashScreenData,
      double variablePixelHeight,
      double variablePixelWidth,
      String otpVerifiedMsg) {
    int? selectedValue;
    bool enableButtonSapIdSelection = false;

    showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      context: innerContext,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    setState(() {
                      isSnackBarShown = false;
                    });
                  }
                });

                return GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.60,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightWhite1,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30 * pixelMultiplier),
                          topRight: Radius.circular(30 * pixelMultiplier),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(variablePixelWidth * 24,
                                variablePixelHeight * 25, variablePixelWidth * 24, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translation(context).pleaseSelectYourSAPID,
                                    style: GoogleFonts.poppins(
                                      fontSize: 20 * textFontMultiplier,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.50,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: variablePixelHeight * 8),
                          Padding(
                            padding: EdgeInsets.fromLTRB(variablePixelWidth * 24, 0,
                                variablePixelWidth * 24, 0),
                            child: Container(
                              height: 1 * variablePixelHeight,
                              color: AppColors.dividerGreyColor,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8 * variablePixelHeight),
                            ),
                          ),
                          SizedBox(height: variablePixelHeight * 12),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, variablePixelWidth * 7,
                                  variablePixelHeight * 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: variablePixelWidth * 410,
                                  height: variablePixelHeight * 295,
                                  alignment: Alignment.centerLeft,
                                  child: ListView.builder(
                                    itemCount: splashScreenData.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      UserData userData = splashScreenData[index];
                                      bool isUserBlocked = userData.message.isNotEmpty;

                                      return GestureDetector(
                                        onTap: isUserBlocked
                                            ? null
                                            : () {
                                          setState(() {
                                            selectedValue = index;
                                            userDataIndex = index;
                                            if (selectedValue != null) {
                                              enableButtonSapIdSelection = true;
                                            }
                                          });
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 10 * variablePixelHeight),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 24 * variablePixelWidth),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      Radio<int>(
                                                        visualDensity:
                                                        const VisualDensity(
                                                            horizontal:
                                                            VisualDensity
                                                                .minimumDensity,
                                                            vertical: VisualDensity
                                                                .minimumDensity),
                                                        materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                        value: index,
                                                        activeColor:
                                                        AppColors.lumiBluePrimary,
                                                        groupValue: selectedValue,
                                                        onChanged: isUserBlocked
                                                            ? null
                                                            : (value) {
                                                          setState(() {
                                                            selectedValue = value;
                                                            userDataIndex = value;
                                                            if (selectedValue != null) {
                                                              enableButtonSapIdSelection =
                                                              true;
                                                            }
                                                          });
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width: 9 * variablePixelWidth,
                                                      ),
                                                      Text(
                                                        userData.id,
                                                        style: GoogleFonts.poppins(
                                                          color: isUserBlocked
                                                              ? AppColors.grey
                                                              : AppColors.darkText2,
                                                          fontSize:
                                                          textFontMultiplier * 16,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: 0.50,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      60 * variablePixelWidth,
                                                      0,
                                                      8 * variablePixelWidth,
                                                      0),
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    "${userData.name}, ${userData.city}",
                                                    style: GoogleFonts.poppins(
                                                      color: isUserBlocked
                                                          ? AppColors.grey
                                                          : AppColors.darkGrey,
                                                      fontSize: textFontMultiplier * 14,
                                                      fontWeight: FontWeight.w500,
                                                      letterSpacing: 0.25,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: variablePixelHeight * 5),
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      60 * variablePixelWidth,
                                                      0,
                                                      8 * variablePixelWidth,
                                                      0),
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    userData.type,
                                                    style: GoogleFonts.poppins(
                                                      color: isUserBlocked
                                                          ? AppColors.grey
                                                          : AppColors.darkGrey,
                                                      fontSize: textFontMultiplier * 14,
                                                      fontWeight: FontWeight.w400,
                                                      letterSpacing: 0.50,
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                    visible: isUserBlocked,
                                                    child: SizedBox(
                                                        height:
                                                        variablePixelHeight * 5)),
                                                Visibility(
                                                  visible: isUserBlocked,
                                                  child: Container(
                                                    padding: EdgeInsets.fromLTRB(
                                                        60 * variablePixelWidth,
                                                        0,
                                                        8 * variablePixelWidth,
                                                        0),
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      userData.message,
                                                      style: GoogleFonts.poppins(
                                                        color: AppColors.red,
                                                        fontSize:
                                                        textFontMultiplier * 14,
                                                        fontWeight: FontWeight.w400,
                                                        letterSpacing: 0.50,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CommonButton(
                            onPressed: () {
                              logger.i(userDataIndex);
                              BlocProvider.of<VerifyOtpBloc>(blocOuterContext).add(
                                  SAPIDSelectionActionEvent(
                                      userDataIndex!, getOtpData));
                            },
                            isEnabled: enableButtonSapIdSelection && !showLoader,
                            showLoader: showLoader,
                            buttonText: translation(context).continueButtonText,
                            containerBackgroundColor: AppColors.lightWhite1,
                            containerHeight: variablePixelHeight * 56,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }


  @override
  void dispose() {
    animationController?.dispose();
    controllerTimer?.cancel();
    super.dispose();
  }

  void _scrollToTextField() {
    if (phoneNumberFocusNode.hasFocus) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void didChangeMetrics() {
    final currentState = navigatorKey.currentState;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && currentState != null) {
        double keyboardHeight =
            MediaQuery.of(currentState.context).viewInsets.bottom;
        if (keyboardHeight != 0) {
          _scrollToTextField();
        }
      }
    });
  }

  @override
  Widget baseBody(BuildContext context) {
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    var otpVerified = SnackBar(
      width: 345 * variablePixelWidth,
      padding: EdgeInsets.symmetric(vertical: 6 * variablePixelHeight),
      content: Container(
        child: Center(
          child: Text(
            "OTP Verified!",
            style: GoogleFonts.poppins(
              color: AppColors.darkText2,
              fontSize: 14 * textFontMultiplier,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: AppColors.lightGreen, width: 1 * variablePixelWidth),
        borderRadius: BorderRadius.circular(4 * pixelMultiplier),
      ),
      backgroundColor: AppColors.lightGreen,
      duration: const Duration(milliseconds: 500),
    );

    final defaultPinTheme = PinTheme(
      margin: EdgeInsets.symmetric(horizontal: 2 * variablePixelWidth),
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.07,
      textStyle: TextStyle(
          fontSize: 20 * textFontMultiplier,
          color: AppColors.darkBlueText,
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGreyBorder),
        borderRadius: BorderRadius.circular(4 * pixelMultiplier),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.lumiBluePrimary),
      borderRadius: BorderRadius.circular(4),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
            color: isOtpValid ? AppColors.lumiBluePrimary : AppColors.lightRed),
        borderRadius: BorderRadius.circular(4 * pixelMultiplier),
      ),
    );

    return BlocProvider(
      create: (BuildContext context) => sl<VerifyOtpBloc>(),
      child: BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
        listenWhen: (previous, current) => current is VerifyActionState,
        buildWhen: (previous, current) => current is! VerifyActionState,
        listener: (context, state) {
          if (state is NavigateToVerifyOtpActionState) {
            if (state.splashScreenData.isNotEmpty) {
              if (state.splashScreenData.length > 1) {
                showBottomSheetSAPID(
                    blocOuterContext,
                    state.splashScreenData,
                    variablePixelHeight,
                    variablePixelWidth,
                    state.otpVerifiedMsg);
                ScaffoldMessenger.of(context).showSnackBar(otpVerified);
              } else if (state.splashScreenData.length == 1) {
                BlocProvider.of<VerifyOtpBloc>(context)
                    .add(const GetProfileInfoEvent());
              }
            }
          }
          if (state is NavigateToDummyScreenSuccessActionState) {
            commonLoginBannerController.clearLoginFlowBannerContainer();
            authController
                .updateIsSessionExpiredBottomSheetActive(
                false);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DummyHomescreen()));
          }
          if (state is VerifyOtpErrorState) {
            setState(() {
              isOtpValid = false;
              otpValidMessage = state.message;
              isButtonEnabled = false;
            });
          }
          if (state is VerifyOtpResendState) {
            maxAttemptMsg = state.maxAttemptMsg;
            showBottomSheetMessage(outerContext, maxAttemptMsg!,
                variablePixelHeight, variablePixelWidth);
          }
          if (state is ShowIncorrectOtpMaxLimitAlertState) {
            showBottomSheetMessage(outerContext, state.maxAttemptMsg,
                variablePixelHeight, variablePixelWidth);
          }
          if (state is ShowLoginFailedAlertState) {
            showBottomSheetMessage(outerContext, state.alertMessage,
                variablePixelHeight, variablePixelWidth);
          }
          if (state is OtpSuccessResendState) {
            setState(() {
              isReResendButtonEnabled = false;
              timer = int.tryParse(state.timerMaxData) ?? 60;
            });
            if (timer > 0 && timer <= 60) {
              startTimer2();
            } else {
              isReResendButtonEnabled = true;
            }
          }

          if (state is NavigateToVerifyOtpSuccessActionState) {
            authController
                .updateIsSessionExpiredBottomSheetActive(
                false);
            commonLoginBannerController.clearLoginFlowBannerContainer();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DummyHomescreen()));
          }

          if (state is LoginShowLoader) {
            setState(() {
              showLoader = state.showLoader;
            });
          }
        },
        builder: (context, state) {
          outerContext = context;
          blocOuterContext = context;
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              backgroundColor: AppColors.white,
              resizeToAvoidBottomInset: true,
              body: Stack(
                children: <Widget>[
                  ListView(
                    controller: _scrollController,
                    physics: phoneNumberFocusNode.hasFocus
                        ? const NeverScrollableScrollPhysics()
                        : const AlwaysScrollableScrollPhysics(),
                    children: [
                      Obx(() => commonLoginBannerController.cardData.isNotEmpty ? Stack(
                        children: [
                          Container(
                            height: 201 * variablePixelHeight,
                            width: MediaQuery.of(context).size.width,
                            child: PageView.builder(
                              controller: controller,
                              padEnds: false,
                              itemCount:
                              commonLoginBannerController.cardData.length,
                              itemBuilder: (_, index) {
                                final banner = commonLoginBannerController
                                    .cardData[index];
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 201 * variablePixelHeight,
                                  child: CircleAvatar(
                                    backgroundColor: AppColors.white,
                                    radius: 30.0 * pixelMultiplier,
                                    child: commonLoginBannerController
                                        .cardData.isNotEmpty
                                        ? CachedNetworkImage(
                                      imageUrl: banner.backgroundImage,
                                      imageBuilder:
                                          (context, imageProvider) =>
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fitWidth),
                                            ),
                                          ),
                                      placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                      errorWidget: (context, url,
                                          error) =>
                                          SvgPicture.asset(
                                              'assets/mpartner/error.svg'),
                                    )
                                        : CircleAvatar(
                                      backgroundColor: AppColors.white,
                                      radius: 30.0 * pixelMultiplier,
                                      child: SvgPicture.asset(
                                          'assets/mpartner/error.svg'),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 160 * variablePixelHeight,
                            right: 40 * variablePixelWidth,
                            child: Container(
                              height: 20 * variablePixelHeight,
                              padding: EdgeInsets.fromLTRB(
                                  5 * variablePixelWidth,
                                  0,
                                  5 * variablePixelWidth,
                                  0),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(16 * pixelMultiplier),
                                color: AppColors.dividerColor.withOpacity(0.2),
                              ),
                              child: SmoothPageIndicator(
                                  controller: controller,
                                  count: commonLoginBannerController.cardData.length,
                                  effect: WormEffect(
                                      dotHeight: 6 * variablePixelHeight,
                                      dotWidth: 6 * variablePixelWidth,
                                      type: WormType.thinUnderground,
                                      dotColor: AppColors.darkText,
                                      activeDotColor: AppColors.statusBarColor),
                                  onDotClicked: (index) {}),
                            ),
                          ),
                        ],
                      ): SizedBox(
                        height: 201 * variablePixelHeight,
                        width: MediaQuery.of(context).size.width,
                      )),
                      Obx(() {
                        return Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 24 * variablePixelWidth,
                                top: 10 * variablePixelHeight),
                            child: SizedBox(
                              width: variablePixelWidth * 120,
                              child: CircleAvatar(
                                backgroundColor: AppColors.white,
                                radius: 30.0 * pixelMultiplier,
                                child: commonLoginBannerController
                                        .bannerCardData.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: commonLoginBannerController
                                            .bannerCardData[0].backgroundImage,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.scaleDown),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            SvgPicture.asset(
                                                'assets/mpartner/error.svg'),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: AppColors.white,
                                        radius: 30.0 * pixelMultiplier,
                                        child: SvgPicture.asset(
                                            'assets/mpartner/error.svg'),
                                      ),
                              ),
                            ),
                          ),
                        );
                      }),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 8 * variablePixelWidth,
                              right: 8 * variablePixelWidth),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).padding.top *
                                        0.25,
                                    left: MediaQuery.of(context).padding.left +
                                        20,
                                    right: MediaQuery.of(context).padding.right,
                                  ),
                                  child: SizedBox(
                                    width: AppBar().preferredSize.width,
                                    height: AppBar().preferredSize.height,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          InkWell(
                                            borderRadius: BorderRadius.circular(
                                              AppBar().preferredSize.height,
                                            ),
                                            child: Semantics(
                                              label:
                                                  'Add Remote Screen Arrow Back',
                                              child: const Icon(
                                                Icons.arrow_back_outlined,
                                                color: AppColors.iconColor,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 24 * variablePixelWidth,
                                    right: 0,
                                    bottom: 5 * variablePixelHeight,
                                    top: 16 * variablePixelHeight,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        translation(context).verifyOTP,
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 30 * textFontMultiplier,
                                          letterSpacing: 0.27,
                                          color: AppColors.darkText2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 24 * variablePixelWidth,
                                    right: 0,
                                    bottom: 5 * variablePixelHeight,
                                    top: 16 * variablePixelHeight,
                                  ),
                                  child: Text(
                                    widget.message,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.darkGreyText,
                                      fontSize: 14 * textFontMultiplier,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.25,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: variablePixelHeight * 20,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                  child: Pinput(
                                    controller: _controller,
                                    length: 6,
                                    defaultPinTheme: defaultPinTheme,
                                    focusedPinTheme: focusedPinTheme,
                                    focusNode: phoneNumberFocusNode,
                                    submittedPinTheme: submittedPinTheme,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    pinputAutovalidateMode:
                                        PinputAutovalidateMode.onSubmit,
                                    androidSmsAutofillMethod:
                                        AndroidSmsAutofillMethod
                                            .smsRetrieverApi,
                                    showCursor: true,
                                    onTap: () {
                                      setState(() {
                                        topContainerHeight =
                                            variablePixelHeight * 120;
                                        topContainerHeight2 =
                                            variablePixelHeight * 120;
                                        topContainerShrinkPadding1 =
                                            variablePixelHeight * 45;
                                        topContainerShrinkPadding2 =
                                            variablePixelHeight * 5;
                                      });
                                    },
                                    onCompleted: (pin) {
                                      getOtpData = pin;
                                      logger.i(
                                          "[onCompleted] OTP after completion: $pin");
                                      setState(() {
                                        isButtonEnabled = true;
                                      });
                                      if (pin.length == 6) {
                                        BlocProvider.of<VerifyOtpBloc>(context)
                                            .add(VerifyOtpInitialActionEvent(
                                                widget.getId,
                                                getOtpData,
                                                widget.phoneNo));
                                      }
                                    },
                                    onSubmitted: (pin) {
                                      setState(() {
                                        topContainerHeight =
                                            254.0 * variablePixelHeight;
                                        topContainerHeight2 =
                                            254.0 * variablePixelHeight;
                                        topContainerShrinkPadding1 =
                                            variablePixelHeight * 100;
                                        topContainerShrinkPadding2 =
                                            variablePixelHeight * 20;
                                      });
                                    },
                                    onChanged: (pin) {
                                      logger
                                          .i("[onChanged] OTP onChanged: $pin");
                                      setState(() {
                                        isButtonEnabled = false;
                                        otpValidMessage = '';
                                        isOtpValid = true;
                                      });
                                      if (pin.length == 6) {
                                        setState(() {
                                          topContainerHeight =
                                              254.0 * variablePixelHeight;
                                          topContainerHeight2 =
                                              254.0 * variablePixelHeight;
                                          topContainerShrinkPadding1 =
                                              variablePixelHeight * 100;
                                          topContainerShrinkPadding2 =
                                              variablePixelHeight * 20;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                      left: 24 * variablePixelWidth,
                                      right: 24 * variablePixelWidth,
                                      bottom: 0,
                                      top: 16 * variablePixelHeight,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        isResendButtonEnabled
                                            ? Text(
                                                "${translation(context).resendOTPin} ${timer}s ",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  color: AppColors.darkGrey,
                                                  fontSize:
                                                      14 * textFontMultiplier,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.10,
                                                ),
                                              )
                                            : isReResendButtonEnabled
                                                ? InkWell(
                                                    onTap: () async {
                                                      BlocProvider.of<
                                                                  VerifyOtpBloc>(
                                                              context)
                                                          .add(VerifyOtpResendActionEvent(
                                                              widget.getId,
                                                              widget.phoneNo));
                                                      setState(() {
                                                        _controller.clear();
                                                      });
                                                    },
                                                    child: Text(
                                                      translation(context)
                                                          .resendOTP,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: AppColors
                                                            .lumiBluePrimary,
                                                        fontSize: 16,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    ),
                                                  )
                                                : Text(
                                                    "${translation(context).resendOTP} ${timer}s",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                      color: AppColors.darkGrey,
                                                      fontSize: 14 *
                                                          textFontMultiplier,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.10,
                                                    ),
                                                  ),
                                        Expanded(
                                          child: isOtpValid
                                              ? const SizedBox()
                                              : Text(
                                                  otpValidMessage,
                                                  textAlign: TextAlign.right,
                                                  style: GoogleFonts.poppins(
                                                    color: AppColors.errorRed,
                                                    fontSize:
                                                        14 * textFontMultiplier,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.15,
                                                  ),
                                                ),
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: variablePixelHeight * 200,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: CommonButton(
                          onPressed: () {
                            BlocProvider.of<VerifyOtpBloc>(context).add(
                                VerifyOtpInitialActionEvent(
                                    widget.getId, getOtpData, widget.phoneNo));
                          },
                          isEnabled: isButtonEnabled && !showLoader,
                          showLoader: showLoader,
                          buttonText: translation(context).verify,
                          containerBackgroundColor: AppColors.white,
                          containerHeight: variablePixelHeight * 56))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
