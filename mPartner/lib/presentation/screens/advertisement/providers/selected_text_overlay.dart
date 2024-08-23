import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utils/app_colors.dart';
import '../widgets/textoverlay_widget.dart';

final selectedTextOverlayProvider = StateProvider<TextOverlayWidget>(
  (ref) => TextOverlayWidget(
    charMultiplier: 1,
      height: 0,
      width: 0,
      angle: 0.0,
      id: '',
      text: '',
      offset: const Offset(0, 0),
      fontSize: 0,
      color: AppColors.white,
      screenHeight: 0,
      screenWidth: 0,
      isSelected: false),
);
