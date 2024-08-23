import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class InternetUtil {
  static InternetUtil? _instance;
  StreamController<bool>? _streamController;
  Connectivity connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? subscription;

  factory InternetUtil.getInstance() {
    _instance ??= InternetUtil._();
    return _instance!;
  }

  InternetUtil._();

  Future<bool> isInternetConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      return true;
    }
    return false;
  }

  Stream<bool>? checkInternetConnection() {
    if (_streamController?.isClosed ?? false) {
      _streamController = StreamController.broadcast();
      Connectivity().onConnectivityChanged.listen((connectivityResult) {
        var isConnected = connectivityResult == ConnectivityResult.wifi ||
            connectivityResult == ConnectivityResult.mobile;
        _streamController?.add(isConnected);

        final nState = isConnected ? "Active" : "Inactive";

        log("INTERNET_UTILS : $nState on network");
      });
    }
    return _streamController?.stream;
  }

  Future<bool> isInternetConnecting() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty) {
        return true;
      }
    } on SocketException catch (err) {
      if (kDebugMode) {
        print(err);
      }
      return false;
    }
    return false;
  }

  Future<bool>? checkConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      getConnectionValue(result);
    });

    return null;
  }

  bool getConnectionValue(var connectivityResult) {
    bool status = false;
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = true;
        break;
      case ConnectivityResult.wifi:
        status = true;
        break;
      case ConnectivityResult.none:
        status = true;
        break;
      default:
        status = false;
        break;
    }
    return status;
  }
}
