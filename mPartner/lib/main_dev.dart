import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'app_config.dart';
import 'presentation/view/app.dart';
import 'services/services_locator.dart';
import 'state/init_controllers.dart';
import 'utils/app_constants.dart';
import 'utils/fcm/notification_services.dart';

var _loggerDev = Logger(
  printer: PrettyPrinter(
      methodCount: 10,
      errorMethodCount: 20,
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

Future<void> main() async {
  ServicesLocator().init();
  logger = _loggerDev;
  if (kDebugMode) {
    logger.d("==========DEVELOPMENT BUILD (DEBUG)==========");
  } else {
    logger.d("==========DEVELOPMENT BUILD (RELEASE)==========");
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() {
    logger.i("Firebase setup completed");
  });
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  initControllers();
  AppConfig.create(
    appName: "mPartner Dev",
    urlMpartnerApi3: "https://mpdev.luminousindia.com/Api/MpartnerApi3/",
    urlHomeScreenApi: "https://mpdev.luminousindia.com/homescreenapi/api",
    urlISmartApi: "https://mpdev.luminousindia.com/ismartapi/api",
    urlBankingUpiApi:
        "https://mpdev.luminousindia.com/bankingupiapi/api/BankingUpi",
    urlUserEngagementApi:
        "https://mpdev.luminousindia.com/userEngagementapi/api",
    urlNonSapApi: "https://mpdev.luminousindia.com/nonsapapi",
    urlCommonApi: "https://mpdev.luminousindia.com/CommonApi",
    urlManagementApi: "https://mpdev.luminousindia.com/managementapi/api",
    urlReportManagementApi:
        "https://mpdev.luminousindia.com/managementapi/api/ReportManagement",
    urlSolar: "https://mpdev.luminousindia.com/SolarModuleAPI/api/v1/Solar",
    urlGem: "https://mpdev.luminousindia.com/solarapi/api",
    gemImageUrl: "https://mpdev.luminousindia.com/",
    flavor: Flavor.dev,
  );

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
