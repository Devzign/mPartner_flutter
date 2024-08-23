import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';

class CommonTimer extends StatefulWidget {
  final int initialTime;
  final VoidCallback onTimerExpired;

  CommonTimer({required this.initialTime, required this.onTimerExpired});

  @override
  _CommonTimerState createState() => _CommonTimerState();
}

class _CommonTimerState extends State<CommonTimer> {
  late Timer _timer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.initialTime;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          widget.onTimerExpired();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatTime(_secondsRemaining),
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        color: AppColors.darkGreyText,
        fontStyle: FontStyle.normal,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 0.11,
        letterSpacing: 0.10,
      ),
    );
  }
}
