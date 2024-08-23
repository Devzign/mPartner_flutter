import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'utils/fcm/notification_services.dart';
import 'app_config.dart';
import 'presentation/view/app.dart';
import 'services/services_locator.dart';
import 'state/init_controllers.dart';
import 'utils/app_constants.dart';

var _loggerProdDebug = Logger(
  printer: PrettyPrinter(
      methodCount: 5,
      errorMethodCount: 10,
      lineLength: 120,
      colors: true,
      printEmojis: false,
      printTime: false),
  output: MultiOutput([
    StreamOutput(),
    ConsoleOutput(),
  ]),
  level: Level.all,
  filter: ProductionFilter(),
);

var _loggerProdRelease = Logger(
  printer: PrettyPrinter(
      methodCount: 5,
      errorMethodCount: 10,
      lineLength: 120,
      colors: true,
      printEmojis: false,
      printTime: false),
  output: MultiOutput([
    StreamOutput(),
    ConsoleOutput(),
  ]),
  level: Level.all,
  filter: ProductionFilter(),// ENABLE LOGS IN PRODUCTION BUILD
);

Future<void> main() async {
  ServicesLocator().init();

  if (kDebugMode) {
    logger = _loggerProdDebug;
    logger.d("==========PRODUCTION BUILD (DEBUG)==========");
  } else {
    logger = _loggerProdRelease;
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() {
    logger.d("Firebase setup completed");
  });
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
   PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  initControllers();

  if (kDebugMode) {
    AppConfig.create(
      appName: "mPartner",
      urlMpartnerApi3: "https://mpartner.luminousindia.com/Api/MpartnerApi3/",
      urlHomeScreenApi:
          "https://mpartner.luminousindia.com/homescreenapi/api",
      urlISmartApi: "https://mpartner.luminousindia.com/ismartapi/api",
      urlBankingUpiApi:
          "https://mpartner.luminousindia.com/bankingupiapi/api/BankingUpi",
      urlUserEngagementApi:
          "https://mpartner.luminousindia.com/userEngagementapi/api",
      urlNonSapApi: "https://mpartner.luminousindia.com/nonsapapi",
      urlCommonApi: "https://mpartner.luminousindia.com/CommonApi",
      urlManagementApi:
          "https://mpartner.luminousindia.com/managementapi/api",
      urlReportManagementApi:
          "https://mpartner.luminousindia.com/managementapi/api/ReportManagement",
      urlSolar: "https://mpartner.luminousindia.com/SolarModuleAPI/api/v1/Solar",
      urlGem : "https://mpartner.luminousindia.com/solarapi/api",
      gemImageUrl: "https://mpartner.luminousindia.com/",
      flavor: Flavor.prod,
    );
  } else {
    AppConfig.create(
      appName: "mPartner",
      urlMpartnerApi3: "https://mpartner.luminousindia.com/Api/MpartnerApi3/",
      urlHomeScreenApi:
          "https://mpartner.luminousindia.com/homescreenapi/api",
      urlISmartApi: "https://mpartner.luminousindia.com/ismartapi/api",
      urlBankingUpiApi:
          "https://mpartner.luminousindia.com/bankingupiapi/api/BankingUpi",
      urlUserEngagementApi:
          "https://mpartner.luminousindia.com/userEngagementapi/api",
      urlNonSapApi: "https://mpartner.luminousindia.com/nonsapapi",
      urlCommonApi: "https://mpartner.luminousindia.com/CommonApi",
      urlManagementApi:
          "https://mpartner.luminousindia.com/managementapi/api",
      urlReportManagementApi:
          "https://mpartner.luminousindia.com/managementapi/api/ReportManagement",
      urlSolar: "https://mpartner.luminousindia.com/SolarModuleAPI/api/v1/Solar",
      urlGem : "https://mpartner.luminousindia.com/solarapi/api",
      gemImageUrl: "https://mpartner.luminousindia.com/",
      flavor: Flavor.prod,
    );
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(GetMaterialApp(
      onReady: () async {
        await Get.putAsync(() => FireBaseMessagingService().init());
      },
      debugShowCheckedModeBanner: false,
      builder: (context,child){
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)), child: child!);
      },
      home: const ProviderScope(child: MainApp()))));
}

@pragma('vm:entry-point')
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.d("[MAIN] Handling a background message: ${message.messageId}");
  await Firebase.initializeApp();
  logger.d('[MAIN] Handling a background message ${message.messageId}');
  logger.d('[MAIN] Notification Message: ${message.data}');
  // FireBaseMessagingService().showNotification(message);
}