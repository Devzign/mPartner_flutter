import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';

class ClockWidget extends StatefulWidget {
  final double? fontSize;

  const ClockWidget({super.key, this.fontSize});

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  late Timer _timer;
  late String _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateFormat('hh:mm a').format(DateTime.now());
    _startTimer();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('hh:mm a').format(DateTime.now());
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double variablePixel =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Center(
      child: Text(
        _currentTime,
        textAlign: TextAlign.right,
        style: GoogleFonts.poppins(
          color: AppColors.darkGreyText,
          fontSize: widget.fontSize != null
              ? widget.fontSize! * variablePixel
              : 12.0 * variablePixel,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.10,
        ),
      ),
    );
  }
}
