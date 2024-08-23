import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DisplayMethods {
  final BuildContext context;
  const DisplayMethods({required this.context});

  double getVariablePixelWidth() {
    double width = MediaQuery.of(context).size.width;
    double variablePixelWidth = width / 393;
    return variablePixelWidth;
  }

  double getVariablePixelHeight() {
    double height = MediaQuery.of(context).size.height;
    double getVariablePixelHeight = height / 852;
    return getVariablePixelHeight;
  }

  double getLabelFontSize() {
    double height = getVariablePixelHeight();
    return 14 * height;
  }

  double getTextFontMultiplier() {
    double variablePixelWidth = MediaQuery.of(context).size.width / 393;
    double variablePixelHeight = MediaQuery.of(context).size.height / 852;
    double multiplier = max(variablePixelHeight, variablePixelWidth);
    return multiplier;
  }

  double getPixelMultiplier() {
    double variablePixelWidth = MediaQuery.of(context).size.width / 393;
    double variablePixelHeight = MediaQuery.of(context).size.height / 852;
    double multiplier = min(variablePixelHeight, variablePixelWidth);
    return multiplier;
  }

  void portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
