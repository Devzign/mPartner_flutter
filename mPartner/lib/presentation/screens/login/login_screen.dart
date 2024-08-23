import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../services/services_locator.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../state/contoller/common_login_banners_controller.dart';
import '../../../utils/textfield_input_handler.dart';
import '../../screens/base_screen.dart';
import '../../widgets/common_button.dart';
import '../../widgets/upcoming_feature.dart';
import '../verifyotp/verify_otp_screen.dart';
import 'bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseScreenState<LoginScreen>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  final formKey = GlobalKey<FormState>();
  bool isButtonEnabled = false;
  String? phoneNumberError;
  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode phoneNumberFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  String? maxAttemptMsg;
  String unRegisterNoMsg = '';
  bool unRegisterNoMsgBool = false;
  late BuildContext shrinkContext;
  double topContainerHeight = 254.0;
  double topContainerShrinkPadding1 = 100;
  double topContainerShrinkPadding2 = 20.0;
  double topContainerHeight2 = 254.0;
  String mobileNumberWithoutPrefix = '';
  String validationInfoPhone = '';
  bool isValidPhone = false;
  bool enterPhoneText = false;
  bool isButtonEnabledContinue = false;
  bool showLoader = false;
  double variablePixelHeight = 0;
  double variablePixelWidth = 0;
  double textFontMultiplier = 0;
  double pixelMultiplier = 0;
  late double detectKeyboard;
  late BuildContext outerContext;
  Logger logger = Logger();
  CommonLoginBannerController commonLoginBannerController = Get.find();
  int currentIndex = 0;
  final controller = PageController(viewportFraction: 1.0, keepPage: true);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    commonLoginBannerController.clearLoginFlowBannerContainer();
    commonLoginBannerController.fetchLoginBanners();
    phoneNumberController.addListener(() {
      setState(() {});
    });

    phoneNumberFocusNode.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
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
  }

  void _scrollToTextField() {
    if (phoneNumberFocusNode.hasFocus) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final currentState = navigatorKey.currentState;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && currentState != null) {
        double keyboardHeight =
            MediaQuery.of(currentState.context).viewInsets.bottom;
        if (keyboardHeight == 0) {
          setState(() {
            enterPhoneText = false;
          });
        } else {
          setState(() {
            enterPhoneText = true;
          });
          _scrollToTextField();
        }
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
                          fontSize: 20 * textFontMultiplier,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.50,
                        ),
                        textAlign: TextAlign.left,
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
                  color: AppColors.darkGreyText,
                  margin:
                      EdgeInsets.symmetric(vertical: 8 * variablePixelHeight),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      24 * variablePixelWidth,
                      24 * variablePixelHeight,
                      16 * variablePixelWidth,
                      16 * variablePixelHeight),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    maxAttemptMessage,
                    style: GoogleFonts.poppins(
                      fontSize: 14 * textFontMultiplier,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.10,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              CommonButton(
                  onPressed: () {
                    try {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        SystemNavigator.pop();
                      }
                    } catch(e) {
                      logger.e("message: ${e.toString()}");
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

  String getPhoneNumberErrorText() {
    if (phoneNumberController.text.isEmpty) {
      isButtonEnabled = false;
      return translation(context).pleaseEnterNumber;
    } else if (!(AppConstants.VALIDATE_REGEX
        .hasMatch(phoneNumberController.text))) {
      isButtonEnabled = false;
      return translation(context).enterAvalidNumber;
    }
    isButtonEnabled = true;
    return '';
  }

  void validateMobileNumber(String mobileNumber) {
    RegExp regex = RegExp(r'^[0-9]{10}$');
    RegExp zeroPattern = RegExp(r'^0+$');

    if (mobileNumber.isEmpty) {
      setState(() {
        validationInfoPhone = 'Required';
        isButtonEnabledContinue = false;
      });
    } else if (!regex.hasMatch(mobileNumber)) {
      setState(() {
        validationInfoPhone =
            'Invalid mobile number. It should have exactly 10 digits.';
        isButtonEnabledContinue = false;
      });
    } else if (zeroPattern.hasMatch(mobileNumber)) {
      setState(() {
        validationInfoPhone = 'Invalid mobile number (all zeros).';
        isButtonEnabledContinue = false;
      });
    } else {
      setState(() {
        validationInfoPhone = '';
        isButtonEnabledContinue = true;
      });
    }
  }

  @override
  Widget baseBody(BuildContext context) {
    outerContext = context;
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return BlocProvider(
      create: (BuildContext context) => sl<LoginBloc>(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listenWhen: (previous, current) => current is LoginActionState,
        buildWhen: (previous, current) => current is! LoginActionState,
        listener: (context, state) {
          if (state is NavigateToFillingOtpActionState) {
            commonLoginBannerController.clearLoginFlowBannerContainer();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VerifyOtpStateScreen(
                          getId: state.id,
                          phoneNo: mobileNumberWithoutPrefix,
                          message: state.message,
                          timerData: state.timerData,
                        )));
          }
          if (state is LoginMaxAttemptState) {
            maxAttemptMsg = state.maxAttemptMsg;
            showBottomSheetMessage(outerContext, maxAttemptMsg!,
                variablePixelHeight, variablePixelWidth);
          }
          if (state is LoginUnregisterNotState) {
            setState(() {
              unRegisterNoMsg = state.unRegisterNoMsg;
              unRegisterNoMsgBool = true;
              isButtonEnabledContinue = false;
            });
          }
          if (state is LoginShowLoader) {
            setState(() {
              showLoader = state.showLoader;
            });
          }
        },
        builder: (context, state) {
          shrinkContext = context;
          return PopScope(
            onPopInvoked: (val){
              commonLoginBannerController.clearLoginFlowBannerContainer();
            },
            child: GestureDetector(
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
                            SizedBox(
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
                                  return SizedBox(
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
                            width: MediaQuery.of(context).size.width
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
                          color: AppColors.white,
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
                                                label: 'Arrow Back',
                                                child: const Icon(
                                                  Icons.arrow_back_outlined,
                                                  color: AppColors.iconColor,
                                                ),
                                              ),
                                              onTap: () {
                                                commonLoginBannerController.clearLoginFlowBannerContainer();
                                                if (Navigator.of(context).canPop()) {
                                                  Navigator.of(context).pop();
                                                } else {
                                                  SystemNavigator.pop();
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 24 * variablePixelWidth,
                                          right: 0,
                                          bottom: 4 * variablePixelHeight,
                                          top: 16 * variablePixelHeight,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              translation(outerContext)
                                                  .getLoginTitle,
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 28 * textFontMultiplier,
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
                                          bottom: 0,
                                          top: 4 * variablePixelHeight,
                                        ),
                                        child: Text(
                                          translation(outerContext)
                                              .enterYourMobileNumberToLogIn,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            color: AppColors.darkGreyText,
                                            fontSize: 14 * textFontMultiplier,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.25,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: variablePixelHeight * 32,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          24 * variablePixelWidth,
                                          0,
                                          24 * variablePixelWidth,
                                          0,
                                        ),
                                        child: TextField(
                                          maxLength: 10,
                                          controller: phoneNumberController,
                                          focusNode: phoneNumberFocusNode,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            HandleFirstDigitInMobileTextFieldFormatter(),
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          style: GoogleFonts.poppins(
                                            color: AppColors.darkGreyText,
                                            fontSize: 16 * textFontMultiplier,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.50,
                                          ),
                                          onChanged: (value) {
                                            mobileNumberWithoutPrefix = value
                                                .startsWith('+91 - ')
                                                ? value.substring('+91 - '.length)
                                                : value;
                                            setState(() {
                                              validateMobileNumber(
                                                  mobileNumberWithoutPrefix);
                                              unRegisterNoMsg = '';
                                              unRegisterNoMsgBool = false;
                                            });
                                          },
                                          onEditingComplete: () {
                                            setState(() {
                                              topContainerHeight =
                                                  254.0 * variablePixelHeight;
                                              topContainerHeight2 =
                                                  254.0 * variablePixelHeight;
                                              topContainerShrinkPadding1 =
                                                  100 * variablePixelHeight;
                                              topContainerShrinkPadding2 =
                                                  20 * variablePixelHeight;
                                            });
                                            FocusScope.of(context).unfocus();
                                          },
                                          onTap: () {
                                            setState(() {
                                              enterPhoneText = true;
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
                                          decoration: InputDecoration(
                                            counterText: "",
                                            labelText: enterPhoneText
                                                ? translation(outerContext)
                                                .mobileNumber
                                                : translation(outerContext)
                                                .enterPhoneNoHint,
                                            hintText: translation(outerContext)
                                                .enterPhoneNoHint,
                                            errorText: unRegisterNoMsg.isNotEmpty
                                                ? unRegisterNoMsg
                                                : null,
                                            prefixText: '+91 - ',
                                            prefixStyle: GoogleFonts.poppins(
                                              color: AppColors.lightGreyBorder,
                                              fontSize: 16 * textFontMultiplier,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.50,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      8 * pixelMultiplier)),
                                              borderSide: const BorderSide(
                                                  color:
                                                  AppColors.lumiBluePrimary),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      4 * pixelMultiplier)),
                                              borderSide: const BorderSide(
                                                  color: AppColors.hintColor),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      4 * pixelMultiplier)),
                                              borderSide: const BorderSide(
                                                  color: AppColors.errorRed),
                                            ),
                                            focusedErrorBorder:
                                            OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      4 * pixelMultiplier)),
                                              borderSide: const BorderSide(
                                                  color: AppColors.errorRed),
                                            ),
                                            labelStyle: GoogleFonts.poppins(
                                              color: unRegisterNoMsgBool
                                                  ? AppColors.errorRed
                                                  : (phoneNumberController
                                                  .text.isEmpty
                                                  ? (enterPhoneText
                                                  ? AppColors
                                                  .lumiBluePrimary
                                                  : AppColors.hintColor)
                                                  : AppColors
                                                  .lumiBluePrimary),
                                              fontSize: 16 * textFontMultiplier,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.40,
                                            ),
                                            hintStyle: GoogleFonts.poppins(
                                              fontSize: 16 * textFontMultiplier,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.50,
                                            ),
                                            errorStyle: GoogleFonts.poppins(
                                              color: AppColors.errorRed,
                                              fontSize: 12 * textFontMultiplier,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.40,
                                            ),
                                            contentPadding: EdgeInsets.fromLTRB(
                                              16 * variablePixelWidth,
                                              16 * variablePixelHeight,
                                              0,
                                              16 * variablePixelHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: variablePixelHeight * 200,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        child: Column(
                          children: [
                            CommonButton(
                                onPressed: () {
                                  phoneNumberFocusNode.unfocus();
                                  BlocProvider.of<LoginBloc>(context).add(
                                      LoginInitialActionEvent(
                                          mobileNumberWithoutPrefix));
                                },
                                isEnabled: isButtonEnabledContinue && !showLoader,
                                buttonText: translation(outerContext).sendOTP,
                                showLoader: showLoader,
                                containerBackgroundColor: AppColors.white,
                                containerHeight: variablePixelHeight * 56),
                            // Padding(
                            //   padding: EdgeInsets.fromLTRB(
                            //       0, 0, 0, 19 * variablePixelHeight),
                            //   child:
                            //
                            //   InkWell(
                            //     onTap: () {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) =>
                            //                   UpcomingFeatureScreen(
                            //                       navigateHomeLogin: false)));
                            //     },
                            //     child: Container(
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         children: [
                            //           Text(
                            //             '${translation(context).newUser}?',
                            //             style: GoogleFonts.poppins(
                            //               color: AppColors.grayText,
                            //               fontSize: 14 * textFontMultiplier,
                            //               fontWeight: FontWeight.w500,
                            //               letterSpacing: 0.10,
                            //             ),
                            //           ),
                            //           Text(
                            //             ' ${translation(context).signUp}',
                            //             style: GoogleFonts.poppins(
                            //               color: AppColors.lumiBluePrimary,
                            //               fontSize: 14 * textFontMultiplier,
                            //               fontWeight: FontWeight.w500,
                            //               letterSpacing: 0.10,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
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
    );
  }
}
