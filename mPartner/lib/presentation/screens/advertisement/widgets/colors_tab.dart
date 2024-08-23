import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../providers/selected_text_overlay.dart';
import '../providers/text_overlay_provider.dart';

class ColorTab extends ConsumerStatefulWidget {
  ColorTab({super.key});

  @override
  ConsumerState<ColorTab> createState() => _ColorTabState();
}

class _ColorTabState extends ConsumerState<ColorTab> {
  final List<Color> colors = [
    AppColors.white,
    AppColors.black,
    AppColors.red,
    AppColors.yellow,
    AppColors.green,
    AppColors.blue,
    AppColors.purple,
    AppColors.pink,
    AppColors.orange,
    AppColors.darkBlue,
  ];

  void changeColor(int index) {
    var textListProvider = ref.watch(textOverlayListProvider.notifier);
    var selectedTextProvider = ref.watch(selectedTextOverlayProvider);
    int idx =
        textListProvider.findIndexOfOverlayWithId(selectedTextProvider.id);
    setState(() {
      final selectedColor = colors[index];
      textListProvider.changeColorAtIndex(idx, selectedColor);
    });
    ref.read(selectedTextOverlayProvider.notifier).state =
        ref.watch(textOverlayListProvider)[idx];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      width: screenWidth,
      height: 50 * variablePixelHeight,
      color: AppColors.black,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: colors.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
                8 * variablePixelWidth,
                8 * variablePixelHeight,
                8 * variablePixelWidth,
                8 * variablePixelWidth),
            child: GestureDetector(
              onTap: () => changeColor(index),
              child: Container(
                height: 24 * variablePixelHeight,
                width: 24 * variablePixelWidth,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors[index],
                  border: Border.all(
                    color:AppColors.white,
                    width: 1.5 * pixelMultiplier,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
