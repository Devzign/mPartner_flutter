import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../providers/selected_text_overlay.dart';
import '../providers/text_overlay_provider.dart';

class StyleTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<StyleTab> createState() => _StyleTabState();
}

class _StyleTabState extends ConsumerState<StyleTab> {
  bool isBold = false;
  bool isItalic = false;
  bool isUnderlined = false;

  void changeBold() {
    var textListProvider = ref.watch(textOverlayListProvider.notifier);
    var selectedTextProvider = ref.watch(selectedTextOverlayProvider);
    int idx =
        textListProvider.findIndexOfOverlayWithId(selectedTextProvider.id);

    setState(() {
      isBold = !isBold;
      textListProvider.updateBold(idx, isBold);
    });
    ref.read(selectedTextOverlayProvider.notifier).state =
        ref.watch(textOverlayListProvider)[idx];
  }

  void changeItalic() {
    var textListProvider = ref.watch(textOverlayListProvider.notifier);
    var selectedTextProvider = ref.watch(selectedTextOverlayProvider);
    int idx =
        textListProvider.findIndexOfOverlayWithId(selectedTextProvider.id);

    setState(() {
      isItalic = !isItalic;
      textListProvider.updateItalic(idx, isItalic);
    });
    ref.read(selectedTextOverlayProvider.notifier).state =
        ref.watch(textOverlayListProvider)[idx];
  }

  void changeUnderline() {
    var textListProvider = ref.watch(textOverlayListProvider.notifier);
    var selectedTextProvider = ref.watch(selectedTextOverlayProvider);
    int idx =
        textListProvider.findIndexOfOverlayWithId(selectedTextProvider.id);

    setState(() {
      isUnderlined = !isUnderlined;
      textListProvider.updateUnderline(idx, isUnderlined);
    });
    ref.read(selectedTextOverlayProvider.notifier).state =
        ref.watch(textOverlayListProvider)[idx];
  }

  @override
  Widget build(BuildContext context) {
    var selectedTextProvider = ref.watch(selectedTextOverlayProvider);
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10 * variablePixelWidth),
            child: GestureDetector(
              onTap: () => changeBold(),
              child: Container(
                height: 32 * variablePixelHeight,
                width: 32 * variablePixelWidth,
                decoration: selectedTextProvider.bold
                    ? BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(4 * pixelMultiplier),
                        border: Border.all(
                          color: AppColors.lightGreyBorder,
                          width: 0.5 *pixelMultiplier,
                        ),
                      )
                    : const BoxDecoration(),
                child: Icon(
                  Icons.format_bold,
                  size: 20 *pixelMultiplier,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10 * variablePixelWidth),
            child: GestureDetector(
              onTap: () => changeItalic(),
              child: Container(
                height: 32 * variablePixelHeight,
                width: 32 * variablePixelWidth,
                decoration: selectedTextProvider.italic
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(4 *pixelMultiplier),
                        border: Border.all(
                          color: AppColors.lightGreyBorder,
                          width: 0.5 *pixelMultiplier,
                        ),
                      )
                    : const BoxDecoration(),
                child: Icon(
                  Icons.format_italic,
                  size: 20 *pixelMultiplier,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10 * variablePixelWidth),
            child: GestureDetector(
              onTap: () => changeUnderline(),
              child: Container(
                height: 32 * variablePixelHeight,
                width: 32 * variablePixelWidth,
                decoration: selectedTextProvider.underline
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(4 * pixelMultiplier),
                        border: Border.all(
                          color: AppColors.lightGreyBorder,
                          width: 0.5 *pixelMultiplier,
                        ),
                      )
                    : const BoxDecoration(),
                child: Icon(
                  Icons.format_underline,
                  size: 20*pixelMultiplier,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
