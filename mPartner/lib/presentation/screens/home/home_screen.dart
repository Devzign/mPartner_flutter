import 'dart:async';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/get_alert_notification_model.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../state/contoller/alert_notification_controller.dart';
import '../../../state/contoller/app_setting_value_controller.dart';
import '../../../state/contoller/cash_summary_controller.dart';
import '../../../state/contoller/catalogue_controller.dart';
import '../../../state/contoller/coins_summary_controller.dart';
import '../../../state/contoller/fse_agreement_controller.dart';
import '../../../state/contoller/homepage_banners_controller.dart';
import '../../../state/contoller/price_list_controller.dart';
import '../../../state/contoller/report_type_controller.dart';
import '../../../state/contoller/scheme_controller.dart';
import '../../../state/contoller/survey_question_controller.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/shared_preferences_util.dart';
import '../../widgets/bottomNavigationBar/bottom_navigation_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/common_divider.dart';
import '../../widgets/headers/home_header_widget.dart';
import '../../widgets/horizontalspace/horizontal_space.dart';
import '../../widgets/verticalspace/vertical_space.dart';
import '../agreement_alert/agreement_alert.dart';
import '../base_screen.dart';
import '../help_and_support/help_and_support.dart';
import '../pop_up.dart';
import '../survey_form/survey_form.dart';
import '../userprofile/user_profile_widget.dart';
import 'Homescreen/get_solar_widget.dart';
import 'Homescreen/iSmart_widget.dart';
import 'Homescreen/our_products_widget.dart';
import 'Homescreen/promotional_videos_widget.dart';
import 'Homescreen/quicklinks_widget.dart';
import 'Homescreen/whats_new_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen>
    with TickerProviderStateMixin {
  CoinsSummaryController coinsSummaryController = Get.find();
  CashSummaryController cashSummaryController = Get.find();
  HomepageBannersController homepageBannersController = Get.find();
  UserDataController userDataController = Get.find();
  PriceListController priceListController = Get.find();
  CatalogueController catalogueController = Get.find();
  SchemeController schemeController = Get.find();
  ReportTypeController reportTypeController = Get.find();
  SurveyQuestionsController surveyQuestionsController = Get.find();
  AlertNotificationController alertNotificationController = Get.find();
  FseAgreementController fseAgreementController = Get.find();
  AppSettingValueController appSettingValueController = Get.find();

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  bool isNetworkBottomSheetShowing = false;

  final double infoHeight = 364.0;
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;

  String token = "";
  String sapId = "";
  String userType = "";
  String phoneNo = "";
  bool isFseAgreementAppeared = false;
  bool showBottomSheet = false;
  bool bottomSheetShown = false;
  bool isButtonEnabled = false;
  bool firstBodyVisible = true;
  bool secondBodyVisible = false;
  List<UserProfile> storedUserProfile = [];
  bool showInHomepage = true;
  bool showAnimatedCheck = false;

  final ScrollController _scrollBottomBarController = ScrollController();
  bool isScrollingDown = false;
  bool _show = true;
  bool showHomepage = false;

  void showBottomBar() {
    setState(() {
      _show = true;
    });
  }

  void hideBottomBar() {
    setState(() {
      _show = false;
    });
  }

  void myScroll() async {
    _scrollBottomBarController.addListener(() {
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          hideBottomBar();
        }
      }
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          showBottomBar();
        }
      }
    });
  }

  @override
  void initState() {
    // checkInternetAndFetchData();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    initConnectivity();
    super.initState();


    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    myScroll();
  }

  // Be sure to cancel subscription after you are done
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      logger.e('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    // ignore: avoid_print
    debugPrint('Connectivity Status: $_connectionStatus');
    if (_connectionStatus.isEmpty ||
        _connectionStatus.first == ConnectivityResult.none) {
      // Means No Internet
      debugPrint('No Connectivity -=-=-=-=-=-: $_connectionStatus');
      if (isNetworkBottomSheetShowing == false) {
        showNetworkBottomSheet(
            "No Internet Connection",
            "It seems that your device has no internet connectivity.\nPlease enable internet and try again.\n",
            "Refresh");

      }
    } else {
      if (isNetworkBottomSheetShowing == true) {
        Navigator.pop(context);
      }
      isNetworkBottomSheetShowing = false;
      fetchHomeData();
      debugPrint('Have some Connectivity: $_connectionStatus');
    }
  }

  Future<void> checkInternetAndFetchData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    logger.d("connectivityResult ***** ${connectivityResult.first.name}");
    if (null != connectivityResult &&
        connectivityResult.first != ConnectivityResult.none) {
      logger.d("Internet Available ***** ${connectivityResult.isEmpty}");
      fetchHomeData();
      loadData();
    } else {
      // show bottom sheet
      logger.d("No Internet connectivity ***** $connectivityResult");
      showNetworkBottomSheet(
          "No Internet Connection",
          "It seems that your device has no internet connectivity.\nPlease enable internet and try again.\n",
          "Refresh");
    }
  }

  Future<void> fetchHomeData() async {
    getSolarFlag();
    homepageBannersController.fetchHomepageBanners(AppConstants.mPartner);
    homepageBannersController.fetchHomepageBanners(AppConstants.solar);
    coinsSummaryController.fetchCoinsSummary();
    cashSummaryController.fetchCashSummary();
    reportTypeController.fetchReportTypes();

    priceListController.fetchPriceList(userDataController.userType);
    catalogueController.fetchCatalogList(userDataController.userType);
    schemeController.fetchSchemeList(userDataController.userType);
    appSettingValueController
        .fetchAppSettingValues(AppConstants.solarRequestRaisingDate);
  }

  Future<void> loadData() async {
    UserDataController controller = Get.find();
    bool? isMsgShown = await SharedPreferencesUtil.getBottomSheetShown();
    storedUserProfile = controller.userProfile;

    setState(() {
      token = controller.token;
      sapId = controller.sapId;
      phoneNo = controller.phoneNumber;
      bottomSheetShown = isMsgShown ?? false;
      isFseAgreementAppeared = controller.isFseAgreementAppeared;
    });
    debugPrint("isFseAgreementAppeared :: $isFseAgreementAppeared");
    checkToShowPopUpSurvey();
  }

  Future<void> checkToShowPopUpSurvey() async {
    if (isFseAgreementAppeared != true) {
      await fseAgreementController.fetchFseAgreement();
    }
    if (userDataController.isPopUpAppeared != true) {
      await alertNotificationController.fetchAlertNotifications();
    }
    if (userDataController.isSurveyFormAppeared != true) {
      await surveyQuestionsController.fetchSurveyQuestions();
    }

    if (isFseAgreementAppeared != true &&
        fseAgreementController.isFseAgreementPresent == true) {
      await checkToShowAgreementAlert();
    } else if (userDataController.isPopUpAppeared != true &&
        alertNotificationController.showAlerts == true) {
      await checkToShowPopUpAlert();
    } else if (userDataController.isSurveyFormAppeared != true &&
        surveyQuestionsController.showSurveyForm == true) {
      await checkToShowSurveyForm();
    }
  }

  Future<void> checkToShowSurveyForm() async {
    if (!mounted || !ModalRoute.of(context)!.isCurrent) {
      return;
    }

    userDataController.updateIsSurveyFormAppeared(true);
    List<int> selectedOptionIndexes = List.generate(
        surveyQuestionsController.totalQuestionsCount, (index) => -1);
    List<String> userAnswers = List.generate(
        surveyQuestionsController.totalQuestionsCount, (index) => "");
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SurveyForm(
          currentIndex: 0,
          selectedOptionIndexes: selectedOptionIndexes,
          userAnswers: userAnswers,
        );
      },
    );
  }

  Future<void> checkToShowAgreementAlert() async {
    if (!mounted || !ModalRoute.of(context)!.isCurrent) {
      return;
    }
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AgreementAlert(
          checkToShowPopUpAlert: checkToShowPopUpAlert,
          checkToShowSurveyForm: checkToShowSurveyForm,
        );
      },
    );
  }

  Future<void> checkToShowPopUpAlert() async {
    if (!mounted || !ModalRoute.of(context)!.isCurrent) {
      return;
    }
    int index = 0;
    userDataController.updateIsPopUpAppeared(true);
    showNextPopup(alertNotificationController.readAlertNotifications, index);
  }

  void showNextPopup(List<AlertNotification> notifications, int index) async {
    if (!mounted || !ModalRoute.of(context)!.isCurrent) {
      return;
    }
    if (index < notifications.length) {
      alertNotificationController.updateImageFile(index);
      await showPopupBanner(notifications, index).then((_) {
        showNextPopup(notifications, index + 1);
      });
    }
  }

  Future<bool> isValidImageUrl(String imageUrl) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));
      return response.statusCode == 200;
    } catch (error) {
      return false;
    }
  }

  Future<void> showPopupBanner(
      List<AlertNotification> notifications, int index) async {
    if (notifications.isNotEmpty &&
        index >= 0 &&
        index < notifications.length) {
      bool isLastPopUp = false;
      if (index == notifications.length - 1) {
        isLastPopUp = true;
      }

      AlertNotification notification = notifications[index];

      if (!mounted || !ModalRoute.of(context)!.isCurrent) {
        return;
      }

      if (await isValidImageUrl(notification.imagepath)) {
        return showDialog<void>(
          barrierDismissible: false,
          barrierColor: AppColors.black.withOpacity(0.4),
          context: context,
          builder: (BuildContext context) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: PopUp(
                id: notification.id,
                text: notification.text,
                isread: notification.isread,
                imagename: notification.imagename,
                imagepath: notification.imagepath,
                date: notification.date,
                type: notification.imageType,
                //type: notification.type,
                show_flag: notification.showFlag,
                isLastPopUp: isLastPopUp,
                checkToShowSurveyForm: checkToShowSurveyForm,
                filePathAndName: notification.imageFilePath ?? "",
              ),
            );
          },
        );
      }
    }
  }

  void showNetworkBottomSheet(
    String header,
    String message,
    String? primaryButtonText,
  ) {
    isNetworkBottomSheetShowing = true;
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        // showDragHandle: true,
        builder: (BuildContext bc) {
          double variablePixel =
              DisplayMethods(context: context).getPixelMultiplier();
          double textMultiplier =
              DisplayMethods(context: context).getTextFontMultiplier();
          return PopScope(
            canPop: false,
            child: Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      16 * variablePixel,
                      16 * variablePixel,
                      16 * variablePixel,
                      16 * variablePixel),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const VerticalSpace(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 16 * variablePixel),
                        child: Text(
                          header,
                          style: GoogleFonts.poppins(
                            color: AppColors.titleColor,
                            fontSize: 20 * textMultiplier,
                            fontWeight: FontWeight.w600,
                            height: 0.06,
                            letterSpacing: 0.50,
                          ),
                        ),
                      ),
                      const VerticalSpace(height: 16),
                      Padding(
                        padding: EdgeInsets.only(left: 16 * variablePixel),
                        child:
                            const CustomDivider(color: AppColors.dividerColor),
                      ),
                      const VerticalSpace(height: 16),
                      Padding(
                        padding: EdgeInsets.only(
                            right: 16 * variablePixel,
                            left: 16 * variablePixel),
                        child: SizedBox(
                          // width: 345 * variablePixelWidth,
                          // height: 40 * variablePixelHeight,
                          child: Text(
                            message,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGrey,
                              fontSize: 14 * textMultiplier,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ),
                      ),
                      const VerticalSpace(height: 24),
                      if (primaryButtonText != null) ...{
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SecondaryButton(
                              buttonText: "Exit",
                              onPressed: () {
                                isNetworkBottomSheetShowing = false;
                                SystemNavigator.pop();
                              },
                              buttonHeight: 48,
                              isEnabled: true,
                            ),
                            const HorizontalSpace(width: 16),
                            PrimaryButton(
                              buttonText: primaryButtonText,
                              onPressed: () async {
                                isNetworkBottomSheetShowing = false;
                                Navigator.pop(context);
                                checkInternetAndFetchData();
                              },
                              buttonHeight: 48,
                              isEnabled: true,
                            ),
                          ],
                        ),
                      } else ...{
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            PrimaryButton(
                              buttonText: "Okay",
                              onPressed: () async {
                                SystemNavigator.pop();
                              },
                              buttonHeight: 48,
                              isEnabled: true,
                            ),
                          ],
                        ),
                      }
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    var _currentIndex = 0;

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(animated: false);
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: CustomScrollView(
            controller: _scrollBottomBarController,
            slivers: [
              SliverAppBar(
                expandedHeight: 80 * variablePixelHeight,
                collapsedHeight: 80 * variablePixelHeight,
                toolbarHeight: 80 * variablePixelHeight,
                pinned: true,
                floating: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  // Status bar color
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                  // For Android (dark icons)
                  statusBarBrightness: Brightness.light, // For iOS (dark icons)
                ),
                flexibleSpace: const HomeHeaderWidget(),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    UserProfileWidget(top: 24 * variablePixelHeight),
                    GetBuilder<HomepageBannersController>(builder: (context) {
                      return homepageBannersController.bannerURLs.isNotEmpty
                          ? const WhatsNewWidget()
                          : Container();
                    }),
                    const iSmartWidget(),
                    const GetSolarWidget(),
                    //ServiceEscalationWidget(),
                    const QuicklinksWidget(),
                    const OurProductsWidget(),
                    const PromotionalVideosWidget(),
                    //TrainingVideosWidget(),
                    SizedBox(
                      height: 80 * variablePixelHeight,
                      width: double.infinity,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          onTabTapped: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          show: _show,
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "helpAndSupportFloatingActionButton",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpAndSupport()),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100 * pixelMultiplier),
          ),
          backgroundColor: AppColors.lumiBluePrimary,
          child: const Icon(
            Icons.headset_mic,
            color: AppColors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }

  getSolarFlag() async {
    await appSettingValueController
        .fetchAppSettingValues(AppConstants.solarvisible)
        .then((value) {
      setState(() {});
    });
  }
}
