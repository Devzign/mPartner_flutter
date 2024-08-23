import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/ismart/cash_coins_history/cash_coin_history_screen.dart';
import '../../presentation/screens/ismart/cash_coins_history/credit_txn_notification_detail_screen.dart';
import '../../presentation/screens/ismart/cash_coins_history/debit_txn_notification_detail_screen.dart';
import '../../presentation/screens/ismart/ismart_homepage/ismart_homepage.dart';
import '../../presentation/screens/ismart/redeem_coins_to_trips/tabBooked/booked_trip_details.dart';
import '../../presentation/screens/network_management/dealer_electrician/components/common_network_utils.dart';
import '../../presentation/screens/network_management/dealer_electrician/dealer_electrician_details.dart';
import '../../presentation/screens/network_management/dealer_electrician/new_dealer_electrician_status_screen.dart';
import '../../presentation/screens/network_management/network_home_page.dart';
import '../../presentation/screens/notification/screens/notification_webview.dart';
import '../../presentation/screens/our_products/our_products_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/userprofile/user_profile.dart';
import '../../solar/presentation/project_execution/common/common_project_view/common_project_view_tab.dart';
import '../../solar/presentation/solar_design/existing_leads/detailed_tab_view.dart';
import '../../solar/presentation/solar_finance/existing_leads/project_details_page.dart';
import '../../solar/utils/solar_app_constants.dart';
import '../app_constants.dart';
import '../app_string.dart';
import '../enums.dart';
import '../localdata/shared_preferences_util.dart';
import '../routes/app_routes.dart';
import 'notification_route.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FireBaseMessagingService extends GetxService {
  static BuildContext? _context;

  static void setContext(BuildContext context) => _context = context;

  final currentState = navigatorKey.currentState;

  Future<FireBaseMessagingService> init() async {
    await requestNotificationPermission();
    await fcmOnLaunchListeners();
    await fcmOnResumeListeners();
    await fcmOnMessageListeners();
    await fetchDeviceToken();
    await _initLocalNotifications();
    return this;
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
      carPlay: true,
      criticalAlert: false,
      provisional: false,
    );
    logger.d(
        "Notification permission authorization Status: ${settings.authorizationStatus}");
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      logger.d(
          "Notification permission granted: ${settings.authorizationStatus}");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      logger.d("Notification permission is provisional");
    } else {
      logger.d("No Notification permission");
    }
  }

  Future<void> _cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    // var iosInitializationSettings = const DarwinInitializationSettings();

    /// Note: permissions aren't requested here just to demonstrate that can be done later
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentBadge: true,
      defaultPresentAlert: true,
      defaultPresentBanner: true,
      defaultPresentSound: true,
      requestCriticalPermission: false,
      requestProvisionalPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);

    try {
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (payload) {
        logger.d("RA **** on Did Receive Notification Response...");
        logger.d("FCM payload: $payload");
        _displayNotificationWithPayload(payload);
      });
    } catch (e) {
      logger.e("Error in _flutterLocalNotificationsPlugin initialize");
      e.printError();
    }
  }

  void _displayNotificationWithPayload(NotificationResponse payload) {
    try {
      String payloadStr = payload.payload ?? "";
      logger.d("[RA_DEBUG] jsonPayload: $payloadStr");

      final String payloadTrimmed =
          payloadStr.substring(1, payloadStr.length - 1);
      List<String> splitParamList = [];
      payloadTrimmed.split(",").forEach((String s) {
        List<String> completeObject = s.split(":");
        logger.d("[RA_DEBUG] completeObject::>>>>>> $completeObject");
        if (completeObject.length > 2) {
          String firstPart = completeObject[0] ?? "";
          splitParamList.add(firstPart);
          final buffer = StringBuffer();
          for (int i = 1; i < completeObject.length; i++) {
            if (null != completeObject[i] && completeObject[i].isNotEmpty) {
              buffer.write(completeObject[i].trim());
              if (i == 1) {
                buffer.write(" : ");
              }
            }
          }
          splitParamList.add(buffer.toString());
        } else {
          splitParamList.addAll(s.split(":"));
        }
      });
      var payloadMapped = {};
      for (int i = 0; i < splitParamList.length + 1; i++) {
        if (i % 2 == 1) {
          logger.e(
              "[RA_DEBUG] [i=$i] splitParamList '${i - 1}': ${splitParamList[i - 1]}, '$i': ${splitParamList[i]}");
          payloadMapped.addAll({
            splitParamList[i - 1].trim().toString(): splitParamList[i].trim()
          });
        }
      }
      logger.d("payloadMapped: $payloadMapped");
      logger.e(
          "navigationModule: ${payloadMapped['NavigationModule']} , ticker: ${payloadMapped['ticker']}");
      _handleFcmNotification(payloadMapped);
    } catch (e) {
      e.printError();
      logger.e("Error in Json parsing: ${e.toString()}");
    }
  }

  // 1. This method call when app in terminated state and you get a notification
  // when you click on notification app open from terminated state and you can get notification data in this method
  Future<void> fcmOnLaunchListeners() async {
    logger.d("when app in terminated state and you get a notification...");
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    logger.d(
        "when app in terminated state and you get a notification...$message");
    if (message != null) {
      logger.d("[Notification DATA]: ${message.data}");
      _handleFcmNotification(message.data);
    }
  }

  // This method only call when App in background and not terminated(not closed)
  Future<void> fcmOnResumeListeners() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.d(
          "FirebaseMessaging Notification onMessageOpenedApp... when App in background");
      logger.d("[Notification DATA]: ${message.data}");
      _handleFcmNotification(message.data);
    });
  }

  // This method only call when App in foreground it mean app must be opened
  Future<void> fcmOnMessageListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.d(
          "FirebaseMessaging Notification onMessage listen... when App in foreground");
      logger.d("FCM message: $message");
      logger.d("title: ${message.notification?.title.toString()}");
      logger.d("body: ${message.notification?.body.toString()}");
      logger.d("data: ${message.data.toString()}");
      if (Platform.isIOS) {
        foregroundMessage();
      } else if (Platform.isAndroid) {
        showNotification(message);
      }
    });
  }

  Future<String> getUserId() async {
    return await SharedPreferencesUtil.getSapId() ?? "";
  }

  void _handleFcmNotification(Map<dynamic, dynamic> payloadMapped) {
    try {
      logger.d("RA:  $_context");
      _navigateToScreen(payloadMapped);
      // String userId = "";
      // var sapId = getUserId();
      // sapId.then((value) {
      //   userId = value;
      //   logger.i("RA userId: (=) $userId");
      //   if (userId.isEmpty) {
      //     logger.i(
      //         "RA If userId is empty than move to Splash for login: (=) $userId");
      //     // If userId is empty than move to Splash for login
      //     Navigator.pushReplacement(currentState!.context,
      //         MaterialPageRoute(builder: (context) => const SplashScreen()));
      //   } else {
      //     // User already logged in
      //     logger.i("RA User already logged in : (=) $userId");
      //     _navigateToScreen(route);
      //   }
      // });
    } catch (e) {
      Navigator.push(_context!,
          MaterialPageRoute(builder: (context) => const SplashScreen()));
      e.printError();
    }
  }

  void _navigateToScreen(Map<dynamic, dynamic> payloadMapped) {
    String isPromotion = payloadMapped['IsPromotion'] ?? "0";
    String notificationId = payloadMapped['NotificationId'] ?? "";

    if (isPromotion == '1') {
      // Navigate to promotion Screen
      logger.i("N_D: Promo Notification Screen::> (=) $notificationId");
      Navigator.pushReplacement(
          currentState!.context,
          MaterialPageRoute(
              builder: (context) =>
                  NotificationWebView(notificationId: notificationId)));
    } else {
      String route = payloadMapped['NavigationModule'] ?? "";
      String body = payloadMapped['ticker'] ?? "";
      String transactionType = payloadMapped['TransactionType'] ?? "";
      String transactionId = payloadMapped['TransactionId'] ?? "";
      String dealerElectricianCode = payloadMapped['UserCode'] ?? "";
      logger.e("RA_NOTI_Route is:::> (=) $route");
      if (route == NotificationRoute.homeScreen.name) {
        logger.i(
            "RA Notification[Help&Support] route is: HomeScreen::> (=) $route");
        Navigator.pushReplacement(currentState!.context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else if (route == NotificationRoute.secondaryDeviceScreen.name) {
        ProfileBottomSheetType profileBottomSheetType =
            ProfileBottomSheetType.none;
        if (body.toString().toLowerCase().contains('device 1')) {
          profileBottomSheetType = ProfileBottomSheetType.secondaryDevice1;
        } else if (body.toString().toLowerCase().contains('device 2')) {
          profileBottomSheetType = ProfileBottomSheetType.secondaryDevice2;
        }
        logger.i(
            "RA Notification[Secondary] route is: UserProfileScreen::> (=) $route");
        Navigator.pushReplacement(
            currentState!.context,
            MaterialPageRoute(
                builder: (context) => UserProfileScreen(
                    showBottomSheet: true, type: profileBottomSheetType)));
      } else if (route == NotificationRoute.profileDocScreen.name) {
        ProfileBottomSheetType profileBottomSheetType =
            ProfileBottomSheetType.none;
        if (body.toString().toLowerCase().contains('pan')) {
          profileBottomSheetType = ProfileBottomSheetType.pan;
        }
        logger.i(
            "RA Notification[Secondary] route is: UserProfileScreen::> (=) $route");
        Navigator.pushReplacement(
            currentState!.context,
            MaterialPageRoute(
                builder: (context) => UserProfileScreen(
                    showBottomSheet: true, type: profileBottomSheetType)));
      } else if (route == NotificationRoute.saleCashTxnDetailScreen.name) {
        logger.i(
            "RA Notification route is: saleCashTxnDetailScreen::> (=) $route");
        if (transactionId.isEmpty || transactionType.isEmpty) {
          Navigator.push(
              currentState!.context,
              MaterialPageRoute(
                  builder: (context) => const CashCoinHistoryScreen(
                      cardType: FilterCashCoin.cashType)));
        } else {
          Navigator.pushReplacement(
              currentState!.context,
              MaterialPageRoute(
                  builder: (context) => CreditCoinCashDetailedScreen(
                      txnId: transactionId,
                      txnType: transactionType,
                      cashOrCoinHistory: "Cash")));
        }
      } else if (route == NotificationRoute.saleCoinTxnDetailScreen.name) {
        logger.i(
            "RA Notification route is: saleCoinTxnDetailScreen::> (=) $route");
        if (transactionId.isEmpty || transactionType.isEmpty) {
          Navigator.push(
              currentState!.context,
              MaterialPageRoute(
                  builder: (context) => const CashCoinHistoryScreen(
                      cardType: FilterCashCoin.coinType)));
        } else {
          Navigator.pushReplacement(
              currentState!.context,
              MaterialPageRoute(
                  builder: (context) => CreditCoinCashDetailedScreen(
                      txnId: transactionId,
                      txnType: transactionType,
                      cashOrCoinHistory: "Coin")));
        }
      } else if (route == NotificationRoute.txnDetailScreen.name) {
        logger.i("RA Notification route is: txnDetailScreen::> (=) $route");
        if (transactionId.isEmpty || transactionType.isEmpty) {
          Navigator.push(
              currentState!.context,
              MaterialPageRoute(
                  builder: (context) => const CashCoinHistoryScreen(
                      cardType: FilterCashCoin.cashType)));
        } else {
          Navigator.pushReplacement(
              currentState!.context,
              MaterialPageRoute(
                  builder: (context) => DebitCoinCashDetailedNotification(
                      txnId: transactionId,
                      txnType: transactionType,
                      cashOrCoinHistory: "Cash")));
          //Navigator.popAndPushNamed(_context!, AppRoutes.cashDetailedHistory);
        }
      } else if (route == NotificationRoute.cashHistoryScreen.name) {
        logger.i("RA Notification route is: Cash History Screen::> (=) $route");
        Navigator.push(
            currentState!.context,
            MaterialPageRoute(
                builder: (context) => const CashCoinHistoryScreen(
                    cardType: FilterCashCoin.cashType)));
        //Navigator.popAndPushNamed(_context!, AppRoutes.cashDetailedHistory);
      } else if (route == NotificationRoute.coinsHistoryScreen.name) {
        logger
            .i("RA Notification route is: Coins History Screen::> (=) $route");
        Navigator.push(
            currentState!.context,
            MaterialPageRoute(
                builder: (context) => const CashCoinHistoryScreen(
                    cardType: FilterCashCoin.coinType)));
      } else if (route == NotificationRoute.bookedTripScreen.name) {
        try {
          int tripId = int.parse(transactionId);
          logger
              .i("RA Notification route is: Trip Booking Screen::> (=) $route");
          Navigator.pushReplacement(
              currentState!.context,
              MaterialPageRoute(
                  builder: (context) => BookedTripDetails(
                        tripID: tripId,
                        isNavigatingFromSystemTray: true,
                      )));
        } catch (error) {
          logger.e("Failed to parse trip ID $transactionId by $error");
        }
      } else if (route == NotificationRoute.solarDesignDetailScreen.name) {
        logger.i(
            "RA Notification route is: Solar Design Detail Screen::> (=) $route");
        try {
          bool isDigital = body.toString().toLowerCase().contains('digital');
          bool isCategoryComm =
              body.toString().toLowerCase().contains('commercial');
          String projectId = "";
          projectId = body.toString().toLowerCase().substring(
              body.toString().toLowerCase().indexOf('#') + 1,
              body.toString().toLowerCase().indexOf('#') + 1 + 14);
          Navigator.pushReplacement(
              currentState!.context,
              MaterialPageRoute(
                  builder: (context) => DetailedTabView(
                        projectId: projectId,
                        categoryId: isCategoryComm
                            ? SolarAppConstants.commercialCategory
                            : SolarAppConstants.residentialCategory,
                        isDigOrPhy: isDigital,
                        isNavigatedFrom: SolarAppConstants.fromPushNotification,
                      )));
        } catch (error) {
          logger.e("Failed to parse project ID $error");
        }
      } else if (route.toLowerCase() ==
              NotificationRoute.solarOnlineDetailScreen.name.toLowerCase() ||
          route.toLowerCase() ==
              NotificationRoute.solarOnsiteDetailScreen.name.toLowerCase() ||
          route.toLowerCase() ==
              NotificationRoute.solarETEDDetailScreen.name.toLowerCase()) {
        logger.i(
            "RA Notification route is: ${route.toLowerCase()} Detail Screen::> (=) $route");
        try {
          String typeValue = "";
          if (route.toLowerCase() ==
              NotificationRoute.solarOnlineDetailScreen.name.toLowerCase()) {
            typeValue = SolarAppConstants.online;
          } else if (route.toLowerCase() ==
              NotificationRoute.solarOnsiteDetailScreen.name.toLowerCase()) {
            typeValue = SolarAppConstants.onsite;
          } else {
            typeValue = SolarAppConstants.endToEnd;
          }
          String projectId = body.toString().toLowerCase().substring(
              body.toString().toLowerCase().indexOf('#') + 1,
              body.toString().toLowerCase().indexOf('#') + 1 + 14);

          Navigator.pushReplacement(
              currentState!.context,
              MaterialPageRoute(
                  builder: (context) => CommonProjectDetailTabView(
                      projectId: projectId,
                      typeValue: typeValue,
                      isFrom: SolarAppConstants.fromPushNotification)));
        } catch (error) {
          logger.e("Failed to parse project ID $error");
        }
      } else if (route == NotificationRoute.solarFinancingDetailScreen.name) {
        logger.i(
            "RA Notification route is: Solar Finance Detail Screen::> (=) $route");
        try {
          bool isResidential =
              body.toString().toLowerCase().contains('residential');
          bool isCommercial =
              body.toString().toLowerCase().contains('commercial');
          String projectId = body.toString().substring(
              body.toString().indexOf('#') + 1,
              body.toString().indexOf('#') + 1 + 14);
          Navigator.of(currentState!.context).pushReplacement(MaterialPageRoute(
              builder: (context) => ProjectDetailsPage(
                  isResidential: isResidential,
                  isCommercial: isCommercial,
                  projectId: projectId)));
        } catch (error) {
          logger.e("Failed to parse project ID $error");
        }
      } else if (route == NotificationRoute.networkmgntScreen.name) {
        Navigator.pushReplacement(currentState!.context,
            MaterialPageRoute(builder: (context) => const NetworkHomePage()));
      } else if (route == NotificationRoute.dealerStatusScreen.name) {
        logger
            .i("RA Notification route is: Dealer Status Screen::> (=) $route");
        Navigator.pushReplacement(
            currentState!.context,
            MaterialPageRoute(
                builder: (context) => const NewDealerElectricianStatusScreen(
                    selectedUserType: UserType.dealer)));
      } else if (route == NotificationRoute.electricianStatusScreen.name) {
        logger.i(
            "RA Notification route is: electrician Status Screen::> (=) $route");
        Navigator.pushReplacement(
            currentState!.context,
            MaterialPageRoute(
                builder: (context) => const NewDealerElectricianStatusScreen(
                    selectedUserType: UserType.electrician)));
      } else if (route == NotificationRoute.dealerDetailsScreen.name) {
        logger.i(
            "RA Notification route is: dealer Block redemption Screen::> (=) $route");
        Navigator.pushReplacement(
            currentState!.context,
            MaterialPageRoute(
                builder: (context) => DealerElectricianDetails(
                    selectedUserType: UserType.dealer,
                    id: dealerElectricianCode)));
      } else if (route == NotificationRoute.electricianDetailsScreen.name) {
        logger.i(
            "RA Notification route is: dealer Block redemption Screen::> (=) $route");
        Navigator.pushReplacement(
            currentState!.context,
            MaterialPageRoute(
                builder: (context) => DealerElectricianDetails(
                    selectedUserType: UserType.electrician,
                    id: dealerElectricianCode)));
      } else if (route == NotificationRoute.iSmartHomeScreen.name) {
        Navigator.pushReplacement(currentState!.context,
            MaterialPageRoute(builder: (context) => const IsmartHomepage()));
      } else if (route == NotificationRoute.viewProductCatalogueScreen.name) {
        logger.i("viewProductCatalogueScreen: (=) $route");
        Navigator.push(currentState!.context,
            MaterialPageRoute(builder: (context) => Product(initialIndex: 0)));
      } else if (route == NotificationRoute.viewPriceListScreen.name) {
        logger.i("viewPriceListScreen: (=) $route");
        Navigator.push(currentState!.context,
            MaterialPageRoute(builder: (context) => Product(initialIndex: 1)));
      } else if (route == NotificationRoute.viewSchemeScreen.name) {
        logger.i("viewSchemeScreen: (=) $route");
        Navigator.push(currentState!.context,
            MaterialPageRoute(builder: (context) => Product(initialIndex: 2)));
      } else {
        logger.i("Default should be Notification Screen: (=) $route");
        /*  Navigator.pushReplacement(currentState!.context,
            MaterialPageRoute(builder: (context) => const NotificationHome()));*/
        Navigator.of(currentState!.context)
            .pushNamed(AppRoutes.notificationHome);
      }
    }
  }

  Future<String> fetchDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    logger.d("getFcmToken: $token");
    SharedPreferencesUtil.saveFcmDeviceToken(token!);
    return token;
  }

  // Update the iOS foreground notification presentation options to allow heads up notifications.
  Future<void> foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, sound: true, badge: true);
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  Future<AndroidNotificationDetails> _getImageNotificationDetails(
      AndroidNotificationChannel androidNotificationChannel,
      String nBody,
      String nTitle,
      String imagePath) async {
    final ByteArrayAndroidBitmap largeIcon =
        ByteArrayAndroidBitmap(await _getByteArrayFromUrl(imagePath));
    final ByteArrayAndroidBitmap bigPicture =
        ByteArrayAndroidBitmap(await _getByteArrayFromUrl(imagePath));

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(bigPicture,
            largeIcon: largeIcon,
            contentTitle: nTitle,
            htmlFormatTitle: true,
            htmlFormatContent: true,
            htmlFormatContentTitle: true,
            summaryText: nBody,
            htmlFormatSummaryText: true);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      androidNotificationChannel.id, androidNotificationChannel.name,
      styleInformation: bigPictureStyleInformation,
      // styleInformation: styleInformation,
      channelDescription: "mPartner Offers",
      largeIcon: const DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
      importance: Importance.max,
      icon: '@mipmap/ic_launcher',
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      ticker: "mPartner",
      // setAsGroupSummary: true,
      // groupKey: androidNotificationChannel.groupId
    );

    return androidNotificationDetails;
  }

  Future<AndroidNotificationDetails> _getTextNotificationDetails(
      AndroidNotificationChannel androidNotificationChannel,
      String nBody,
      String nTitle) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        nBody,
        htmlFormatBigText: true,
        htmlFormatTitle: true,
        htmlFormatContent: true,
        contentTitle: nTitle,
        htmlFormatContentTitle: true,
        summaryText: 'mPartner',
        htmlFormatSummaryText: true);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      androidNotificationChannel.id, androidNotificationChannel.name,
      styleInformation: bigTextStyleInformation,
      // styleInformation: styleInformation,
      channelDescription: "mPartner Offers",
      largeIcon: const DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
      importance: Importance.max,
      icon: '@mipmap/ic_launcher',
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      ticker: "mPartner",
      // setAsGroupSummary: true,
      // groupKey: androidNotificationChannel.groupId
    );

    return androidNotificationDetails;
  }

  Future<void> showNotification(RemoteMessage message) async {
    String? tickerBody = message.data['ticker'] ?? "";
    String? id = message.data['NotificationId'] ?? "0";
    int notificationId = int.parse(id!);
    String? body = "";
    if (tickerBody!.isNotEmpty) {
      body = tickerBody;
    } else {
      body = message.notification?.body;
    }
    String? title = message.notification?.title;
    String nTitle = title ?? "Luminous mPartner";
    String nBody = body ?? "";

    if (nBody.isEmpty) {
      return;
    }

    String? imagePath;
    if (Platform.isAndroid) {
      imagePath = message.notification?.android?.imageUrl;
    } else if (Platform.isIOS) {
      imagePath = message.notification?.apple?.imageUrl;
    }

    // MediaStyleInformation styleInformation = const MediaStyleInformation(
    //   htmlFormatContent: true,
    //   htmlFormatTitle: true,
    // );

    logger.e("imagePath: $imagePath");

    AndroidNotificationChannel androidNotificationChannel =
        const AndroidNotificationChannel(
            "com.luminous.mPartner_notification", "mPartner",
            // groupId: "com.luminous.mPartner_notification",
            importance: Importance.high);

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    AndroidNotificationDetails? androidNotificationDetails;
    if (imagePath != null) {
      androidNotificationDetails = await _getImageNotificationDetails(
          androidNotificationChannel, nBody, nTitle, imagePath);
    } else {
      androidNotificationDetails = await _getTextNotificationDetails(
          androidNotificationChannel, nBody, nTitle);
    }

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    // NotificationPayload? payload;
    // if(message.data.isNotEmpty){
    //   payload = NotificationPayload(
    //       navigationModule: message.data.containsKey('NavigationModule') ? message.data['NavigationModule'] : "",
    //       transactionType: message.data.containsKey('transactionType') ? message.data['transactionType'] : "",
    //       transactionId: message.data.containsKey('transactionId') ? message.data['transactionId'] : "",
    //       body: message.notification!.body!, otherData: "");
    // }
    // logger.e("payload: $payload");
    // var jsonPay = payload != null ? json.encode(payload) : "";
    logger.e("passing jsonPay: $message.data");
    // var jsonPayload = {};
    // jsonPayload["NavigationModule"] = message.data['NavigationModule'];
    // jsonPayload["body"] = message.notification!.body!;
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        notificationId,
        message.notification?.title.toString(),
        message.notification?.body.toString(),
        notificationDetails,
        payload: message.data.toString(),
      );
    });
  }
}
