import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../data/models/notification/notification_list_model.dart';
import '../../../../state/contoller/notification_controller.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/fcm/notification_route.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/common_button.dart';
import '../../home/home_screen.dart';
import '../../ismart/ismart_homepage/ismart_homepage.dart';
import '../../ismart/redeem_coins_to_trips/redeem_coins_to_trips.dart';
import '../../menu/luminous_videos/luminous_videos.dart';
import '../../network_management/network_home_page.dart';
import '../../our_products/our_products_screen.dart';
import '../../redeemcoins/redeem_coins.dart';
import '../../userprofile/user_profile_widget.dart';
import '../../../widgets/headers/notification_header_widget.dart';

class NotificationWebViewDetails extends StatefulWidget {
  final NotificationData? notificationData;
  final String notificationId;
  final bool? isRouteFormNotification;

  const NotificationWebViewDetails(
      {super.key,
      this.notificationData,
      required this.notificationId,
      this.isRouteFormNotification});

  @override
  State<NotificationWebViewDetails> createState() =>
      _NotificationWebViewDetails();
}

class _NotificationWebViewDetails extends State<NotificationWebViewDetails> {
  late WebViewController _controller;
  NotificationController notificationController = Get.find();
  NotificationData _notificationDetail1 = NotificationData(
      notificationId: 0,
      userId: "",
      notificationMessage: "",
      notificationText: "",
      isSent: false,
      fcmId: "",
      fcmIdWeb: "",
      notificationType: "",
      isRead: false,
      isDelete: false,
      createdOn: "",
      createdBy: "",
      modifiedOn: "",
      modifiedBy: "",
      navigationUrl: "",
      imagePath: "",
      isPromotional: true,
      navigationModule: "",
      notificationDetailBody: "",
      enableExplore: true,
      externalLink: "",
      transactionId: "",
      transactionType: "",
      dealerElectricianCode: "");

  _fetchNotificationDetails(String notificationId) async {
    await notificationController.fetchNotificationsDetails(
        notificationId: notificationId);
    setState(() {
      _notificationDetail1 = notificationController.getNotificationDetail;
    });
    logger.i(
        "L_WEB_VIEW: API Details ${notificationController.getNotificationDetail}");
    _initWebView();
  }

  void _loadWebView() {
    try {
      if (widget.isRouteFormNotification == true) {
        logger.d(
            "L_WEB_VIEW: From Noti. : ${_notificationDetail1.notificationDetailBody}");
        _controller.loadHtmlString(_notificationDetail1.notificationDetailBody);
      } else {
        if (widget.notificationData!.notificationDetailBody == null) {
          _controller
              .loadRequest(Uri.parse(widget.notificationData!.externalLink));
        } else {
          _controller
              .loadHtmlString(widget.notificationData!.notificationDetailBody);
        }
      }
    } catch (e) {
      e.printError();
    }
  }

  void _initWebView() {
    final WebViewController controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            logger.d("L_WEB_VIEW: onPageStarted: $url");
          },
          onPageFinished: (String url) {
            logger.d("L_WEB_VIEW: onPageFinished: $url");
          },
          onWebResourceError: (WebResourceError error) {
            logger.d("L_WEB_VIEW: error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.isNotEmpty) {
              return NavigationDecision.prevent;
            }
            _navigateToBrowser(request.url);
            return NavigationDecision.navigate;
          },
        ),
      );
    _controller = controller;
    logger.e("L_WEB_VIEW: load web url: inti");
    _loadWebView();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isRouteFormNotification == true) {
      _fetchNotificationDetails(widget.notificationId);
    } else {
      _initWebView();
    }
    logger.e("L_WEB_VIEW: ${widget.notificationId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingNotificationWidget(
                    isDynamic: true,
                    title: widget.notificationData!.notificationText),
                UserProfileWidget(),
                Expanded(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return WebViewWidget(controller: _controller);
                    },
                  ),
                ),
                Visibility(
                    visible: widget.notificationData?.enableExplore ?? false,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: CommonButton(
                        onPressed: () {
                          _navigateToScreen();
                        },
                        containerBackgroundColor: Colors.white,
                        buttonText: translation(context).exploreFeature,
                        isEnabled: true,
                      ),
                    ))
              ]),
        ));
  }

  void _navigateToScreen() {
    String? route = widget.notificationData?.navigationModule;
    bool isExternalLink = widget.notificationData?.enableExplore ?? false;
    logger.e("Navigation Route: $route isExternalLink:: $isExternalLink");

    if (isExternalLink) {
      _navigateToBrowser(widget.notificationData!.externalLink);
    } else {
      logger.e("Navigation through Route: $route");

      if (route == NotificationRoute.iSmartHomeScreen.name) {
        // i-smart Home Screen
        logger.i("iSmartHomeScreen: (=) $route");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const IsmartHomepage()));
      } else if (route == NotificationRoute.redeemCashScreen.name) {
        // Cash redemption need to navigate UPI/pinelab screen
        logger.i("redeemCashScreen: (=) $route");
        Navigator.pushNamed(context, AppRoutes.redeemCashHome);
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => const RedeemCashHome()));
      } else if (route == NotificationRoute.redeemCoinScreen.name) {
        // Coin redemption need to navigate options screen
        logger.i("redeemCoinScreen: (=) $route");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RedeemCoins()));
      } else if (route == NotificationRoute.viewVideoScreen.name) {
        // Luminous Videos
        logger.i("viewVideoScreen: (=) $route");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LuminousVideos()));
      } else if (route == NotificationRoute.viewProductCatalogueScreen.name) {
        logger.i("viewProductCatalogueScreen: (=) $route");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Product(initialIndex: 0)));
      } else if (route == NotificationRoute.viewPriceListScreen.name) {
        logger.i("viewPriceListScreen: (=) $route");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Product(initialIndex: 1)));
      } else if (route == NotificationRoute.viewSchemeScreen.name) {
        logger.i("viewSchemeScreen: (=) $route");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Product(initialIndex: 2)));
      } else if (route == NotificationRoute.viewTripsScreen.name) {
        logger.e("viewTripsScreen: (=) $route");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const RedeemCoinsToTrip(initialIndex: 0)));
      } else if (route == NotificationRoute.networkmgntScreen.name) {
        logger.e("viewTripsScreen: (=) $route");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const NetworkHomePage()));
      } else {
        logger.i("Default should be HomeScreen: (=) $route");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }
  }

  void _navigateToBrowser(String weblink) async {
    if (await canLaunchUrlString(weblink)) {
      await launchUrl(Uri.parse(weblink), mode: LaunchMode.externalApplication);
    } else {
      logger.e("weblink is invalid");
    }
  }
}
