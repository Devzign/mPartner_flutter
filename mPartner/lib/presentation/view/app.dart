import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';

import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../state/contoller/auth_contoller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/l10n/app_localizations.dart';
import '../screens/product_history_tnc/bloc/product_history_tnc_bloc.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MainAppState? state = context.findAncestorStateOfType<_MainAppState>();
    state?.setLocale(newLocale);
  }
}

class _MainAppState extends State<MainApp> {
  Locale? _locale;
  AuthController controller = Get.find();

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void getDeviceIdentifier() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
      deviceName = "${androidInfo.manufacturer} ${androidInfo.model}";
      osVersionName = "Android ${androidInfo.version.release}";
      osVersionCode = androidInfo.version.sdkInt.toString();
      deviceModel = androidInfo.model;
      networkType = await _getNetworkInterface();
      networkOperator = "";
      simCardIdentifier = "";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? "Unknown";
      deviceName = iosInfo.model;
      osVersionName = iosInfo.systemName;
      osVersionCode = iosInfo.systemVersion;
      deviceModel = iosInfo.utsname.machine;
      networkType = await _getNetworkInterface();
      networkOperator = "";
      simCardIdentifier = "";
    } else {
      deviceId = "Unknown";
      deviceName = "Unknown";
      osVersionName = "Unknown";
      osVersionCode = "Unknown";
      deviceModel = "Unknown";
      networkType = "Unknown";
      networkOperator = "Unknown";
      ipAddress = "Unknown";
      simCardIdentifier = "Unknown";
    }
    logger.d(
        "System Configurations: \n deviceId: #$deviceId# | deviceName: #$deviceName# | osVersionName: #$osVersionName# | osVersionCode: #$osVersionCode# | deviceModel: #$deviceModel# | networkType: #$networkType#");
    try {
      var ipAdd = IpAddress();
      dynamic data = await ipAdd.getIpAddress();
      ipAddress = data.toString();
    } on IpAddressException {
      ipAddress = "";
    }
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => setLocale(locale));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    getDeviceIdentifier();

    return Builder(builder: (buildContext) {
      controller.updateBuildContext(buildContext);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: AppColors.statusBarColor,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ));
      return  MultiBlocProvider(
          providers: [
          BlocProvider<ProductHistoryTncBloc>(
          create: (context) => ProductHistoryTncBloc()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        locale: _locale,
        theme: ThemeData(
            bottomSheetTheme: const BottomSheetThemeData(
                surfaceTintColor: AppColors.white,
                backgroundColor: AppColors.white)),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        navigatorObservers: [MyRouteObserver()],
      ));
    });
  }

  Future<String> _getNetworkInterface() async {
    var connectivity = Connectivity();
    var connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      return "Mobile";
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return "WiFi";
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return "Ethernet";
    } else if (connectivityResult == ConnectivityResult.vpn) {
      return "VPN";
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      return "Bluetooth";
    } else if (connectivityResult == ConnectivityResult.other) {
      return "Other";
    } else if (connectivityResult == ConnectivityResult.none) {
      return "None";
    }
    return "";
  }
}

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  static String? lastRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      lastRoute = route.settings.name;
      logger.d("didPush AppRoute: $lastRoute | previousRoute: ${previousRoute?.settings.name}");
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      lastRoute = newRoute.settings.name;
      logger.d("didReplace AppRoute: $lastRoute | oldRoute: ${oldRoute?.settings.name}");
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      lastRoute = previousRoute.settings.name;
      logger.d("didPop AppRoute: $lastRoute | previousRoute: ${previousRoute?.settings.name}");
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      lastRoute = previousRoute.settings.name;
      logger.d("didRemove AppRoute: $lastRoute | previousRoute: ${previousRoute?.settings.name}");
    }
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      lastRoute = previousRoute.settings.name;
      logger.d("didStartUserGesture AppRoute: $lastRoute | previousRoute: ${previousRoute?.settings.name}");
    }
  }
}
