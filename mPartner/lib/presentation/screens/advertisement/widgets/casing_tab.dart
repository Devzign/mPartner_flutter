import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../providers/selected_text_overlay.dart';
import '../providers/text_overlay_provider.dart';


enum TextTransform {
  lowercase,
  uppercase,
  title,
  none,
}

class CasingTab extends ConsumerStatefulWidget{
  @override
  ConsumerState<CasingTab> createState() => _CasingTabState();
}

class _CasingTabState extends ConsumerState<CasingTab> {
  TextTransform _selectedCasing = TextTransform.none;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    return Container(
      width: screenWidth,
      height: 50*variablePixelHeight,
      color: AppColors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildCasingIcon(TextTransform.uppercase),
          buildCasingIcon(TextTransform.lowercase),
          buildCasingIcon(TextTransform.title),
        ],
      ),
    );
  }

  Widget buildCasingIcon(TextTransform casing) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    var selectedTextProvider=ref.watch(selectedTextOverlayProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10*variablePixelWidth),
      child: GestureDetector(
        onTap: () {
          var textListProvider=ref.watch(textOverlayListProvider.notifier);
          var selectedTextProvider=ref.watch(selectedTextOverlayProvider);
          int idx = textListProvider.findIndexOfOverlayWithId(selectedTextProvider.id);
          
          setState(() {
            _selectedCasing = casing;
            textListProvider.changeCase(idx,_selectedCasing);
          });
          ref.read(selectedTextOverlayProvider.notifier).state=ref.watch(textOverlayListProvider)[idx];
        },
        child: Container(
          height: 32 * variablePixelHeight,
          width: 32 * variablePixelWidth,
          decoration:selectedTextProvider.casing==casing? BoxDecoration(
            borderRadius: BorderRadius.circular(4 * pixelMultiplier),
            border: Border.all(
              color: AppColors.lightGreyBorder,
              width: 0.5* pixelMultiplier,
            ),
          ):BoxDecoration(),
          child: Center(
            child: SvgPicture.asset(
              _getCasingText(casing),
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  String _getCasingText(TextTransform casing) {
    switch (casing) {
      case TextTransform.lowercase:
        return 'assets/mpartner/aj_small.svg';
      case TextTransform.uppercase:
        return 'assets/mpartner/AJ_caps.svg';
      case TextTransform.title:
        return 'assets/mpartner/Aj.svg';
      default:
        return 'assets/mpartner/Aj.svg';
    }
  }
}

