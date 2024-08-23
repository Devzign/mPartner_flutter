import 'package:app_settings/app_settings.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/displaymethods/display_methods.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/localdata/language_constants.dart';
import '../../utils/routes/app_routes.dart';
import '../view/app.dart';
import '../widgets/common_button.dart';

class BaseScreenState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  BaseScreenState();

  double _variablePixelHeight = 1;
  double _variablePixelWidth = 1;
  double _variablePixelText = 1;

  final GeolocatorPlatform _geoLocatorPlatform = GeolocatorPlatform.instance;
  static bool isFakeLocation = true;

  static final List<String> _checkLocationRoutes = [
    AppRoutes.login,
    AppRoutes.redeemCashHome,
    // AppRoutes.upiScreen,
  ];

  static bool _isFakeLocationModalBottomSheetShown = false;
  static bool _isErrorOnLoginPage = false;
  late BuildContext _mockLocationBottomSheetContext;

  void _checkLocationPermission() async {
    if (MyRouteObserver.lastRoute == null ||
        !(_checkLocationRoutes.contains(MyRouteObserver.lastRoute))) {
      return;
    } else if (_isErrorOnLoginPage && MyRouteObserver.lastRoute == AppRoutes.login){
      return;
    }

    logger.d(
        "Performing Location Check for AppRoute: ${MyRouteObserver.lastRoute}");

    bool isGPSEnabled;
    LocationPermission permission = await _geoLocatorPlatform.checkPermission();
    logger.d("Location permission checked.... ${permission.name}");
    logger.d('[START] CHECKING :: _isFakeLocationModalBottomSheetShown:: $_isFakeLocationModalBottomSheetShown');

    if (!_isFakeLocationModalBottomSheetShown) {
      if (permission == LocationPermission.denied) {
        logger.d('Location permission Denied.');
        permission = await _geoLocatorPlatform.requestPermission();
        if (permission == LocationPermission.denied) {
          logger.d('Location Denied Again');
          if (!_isFakeLocationModalBottomSheetShown) {
            await _showLocationModalBottomSheet(
                translation(context).locationDenied,
                translation(context).locationDeniedPlAllow,
                PopupType.permission,
                () => AppSettings.openAppSettings());
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        logger.d('Location Denied Permanently.');
        if (!_isFakeLocationModalBottomSheetShown) {
          await _showLocationModalBottomSheet(
              translation(context).locationDenied,
              translation(context).locationPermissionDenied,
              PopupType.permission,
              () => AppSettings.openAppSettings());
        }
        return;
      }

      logger.d("----- Started to get GPS Location -----");
      isGPSEnabled = await _geoLocatorPlatform.isLocationServiceEnabled();
      if (!isGPSEnabled) {
        logger.d('GPS Location Disabled.');
        if (!_isFakeLocationModalBottomSheetShown) {
          await _showLocationModalBottomSheet(
              translation(context).locationDisabled,
              translation(context).locationDisabledPlEnable,
              PopupType.location,
              () => AppSettings.openAppSettings(
                  type: AppSettingsType.location, asAnotherTask: true));
        }
        return;
      }
      logger.d('GPS Location enable...');
      logger.d('updating Mock Location Value....');
      await _updateMockLocationValue();
    } else {
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        logger.d('AFTER PERMISSION GRANT --> CHECKING :: ${_mockLocationBottomSheetContext.mounted}');

        isGPSEnabled = await _geoLocatorPlatform.isLocationServiceEnabled();
        if (!isGPSEnabled) {
          logger.d(
              'Location Disabled.... _isFakeLocationModalBottomSheetShown:: $_isFakeLocationModalBottomSheetShown');
          if (!_isFakeLocationModalBottomSheetShown) {
            await _showLocationModalBottomSheet(
                translation(context).locationDisabled,
                translation(context).locationDisabledPlEnable,
                PopupType.location,
                () => AppSettings.openAppSettings(
                    type: AppSettingsType.location, asAnotherTask: true));
          }
          return;
        }

        await _updateMockLocationValue();
      }
    }
    if (!_isFakeLocationModalBottomSheetShown) locationNowAvailable(position);
    logger.d("##### Stopped to get GPS Position #####");
    logger.d("locationNowAvailable() called...");
  }

  Position position = Position(
    accuracy: 0.0,
    longitude: 77.069710,
    latitude: 28.679079,
    timestamp: DateTime.now(),
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );

  Future<void> _getCurrentPosition() async {
    position = await _geoLocatorPlatform.getLastKnownPosition() ??
        Position(
          accuracy: 0.0,
          longitude: 77.069710,
          latitude: 28.679079,
          timestamp: DateTime.now(),
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
    geoCode = "${position.latitude},${position.longitude}";
    logger
        .d("position::>> lat ${position.latitude}, lng ${position.longitude}");
  }

  Future<void> _updateMockLocationValue() async {
    await _getCurrentPosition();
    if (mounted) {
      setState(() {
        isFakeLocation = position.isMocked;
      });
    }
    logger.d(
        "[RA_LOC] _updateMockLocationValue().... isFakeLocation: $isFakeLocation ,_isFakeLocationModalBottomSheetShown:  $_isFakeLocationModalBottomSheetShown");
    if (isFakeLocation) {
      if (_isFakeLocationModalBottomSheetShown) {
        if (_mockLocationBottomSheetContext.mounted) {
          Navigator.pop(context);
        }
      }
      _showLocationModalBottomSheet(
          translation(context).alert,
          translation(context).mockLocationMsg,
          PopupType.location,
          () => AppSettings.openAppSettings(
              type: AppSettingsType.developer, asAnotherTask: true));
    } else {
      logger.d(
          "[RA_LOC] _updateMockLocationValue().... $_isFakeLocationModalBottomSheetShown");
      if (_isFakeLocationModalBottomSheetShown) {
        _isFakeLocationModalBottomSheetShown = false;
        if (_mockLocationBottomSheetContext.mounted) {
          Navigator.pop(context);
        }
      }
    }
    logger.d("===== STOP isFakeLocation = $isFakeLocation");
  }

  Future<void> _showLocationModalBottomSheet(String title, String message,
      PopupType popUpType, void Function()? pressEvent) async {

    if (MyRouteObserver.lastRoute == null || MyRouteObserver.lastRoute == AppRoutes.login) {
      _isErrorOnLoginPage = true;
      return;
    }

    _isFakeLocationModalBottomSheetShown = true;
    logger.d("[RA_LOC] message:: $message");

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        _mockLocationBottomSheetContext = context;
        return Wrap(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                  24 * _variablePixelWidth,
                  36 * _variablePixelHeight,
                  24 * _variablePixelWidth,
                  16 * _variablePixelHeight),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            color: AppColors.bottomSheetHeaderTextColor,
                            fontSize: 20 * _variablePixelText,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8 * _variablePixelHeight),
                  Container(
                    height: 1,
                    color: AppColors.bottomSheetSeparatorColor,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  SizedBox(height: 8 * _variablePixelHeight),
                  Text(
                    message,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGreyText,
                      fontSize: 14 * _variablePixelText,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.10,
                    ),
                  ),
                  SizedBox(height: 16 * _variablePixelHeight),
                  CommonButton(
                    onPressed: pressEvent,
                    isEnabled: true,
                    buttonText: translation(context).goToSettings,
                    containerBackgroundColor: Colors.transparent,
                    horizontalPadding: 0,
                  ),
                ],
              ),
            )
          ],
        );
      },
      isDismissible: false,
      enableDrag: false,
    );
  }

  @override
  void initState() {
    super.initState();
    logger.d("initState in base screen");
    _checkLocationPermission();
    WidgetsBinding.instance.addObserver(this);
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    logger.d(
        "[RA_LOC] myInterceptor : $stopDefaultButtonEvent || $_isFakeLocationModalBottomSheetShown");
    if (_isFakeLocationModalBottomSheetShown) {
      // SystemNavigator.pop(animated: true);
      return true;
    }
    return false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        logger.d("AppLifecycleState.resumed");
        logger.d("AppLifecycleState.resumed :: $_isFakeLocationModalBottomSheetShown");
        _checkLocationPermission();
        break;
      case AppLifecycleState.inactive:
        logger.d("AppLifecycleState.inactive");
        break;
      case AppLifecycleState.paused:
        logger.d("AppLifecycleState.paused :: $_isFakeLocationModalBottomSheetShown");
        try {
          if(_isFakeLocationModalBottomSheetShown) {
            Navigator.of(context).pop();
          }
          _isFakeLocationModalBottomSheetShown = false;
        } catch (e) {
          e.printError();
        }
        break;
      case AppLifecycleState.detached:
        logger.d("AppLifecycleState.detached");
        break;
      case AppLifecycleState.hidden:
        logger.d("AppLifecycleState.hidden");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    _variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    _variablePixelText =
        DisplayMethods(context: context).getTextFontMultiplier();
    return PopScope(
      canPop: true,
      child: baseBody(context),
    );
  }

  Widget baseBody(BuildContext context) {
    return Container();
  }

  void locationNowAvailable(Position position) async {}
}

enum PopupType { permission, location }
