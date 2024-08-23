import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utils/app_constants.dart';

class InternetController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  RxBool checkConnectivityResult = false.obs;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

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
    // if (!mounted) {
    //   return Future.value(null);
    // }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;
    // ignore: avoid_print
    logger.e('Connectivity Status: $_connectionStatus');
    if (_connectionStatus.isEmpty ||
        _connectionStatus.first == ConnectivityResult.none) {
      // Means No Internet
      debugPrint('No Connectivity -=-=-=-=-=-: $_connectionStatus');
      checkConnectivityResult.value = false;
    } else {
      debugPrint('Have some Connectivity: $_connectionStatus');
      checkConnectivityResult.value = true;
    }
  }
}
