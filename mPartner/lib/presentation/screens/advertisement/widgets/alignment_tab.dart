import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../providers/selected_text_overlay.dart';
import '../providers/text_overlay_provider.dart';

class AlignmentTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<AlignmentTab> createState() => _AlignmentTabState();
}

class _AlignmentTabState extends ConsumerState<AlignmentTab> {
  TextAlign _selectedAlignment = TextAlign.left;

  void changeAlignment(TextAlign alignment){
          var textListProvider = ref.watch(textOverlayListProvider.notifier);
          var selectedTextProvider = ref.watch(selectedTextOverlayProvider);
          int idx = textListProvider
              .findIndexOfOverlayWithId(selectedTextProvider.id);

          setState(() {
            _selectedAlignment = alignment;
            textListProvider.changeAlignment(idx, _selectedAlignment);
          });
          ref.read(selectedTextOverlayProvider.notifier).state =
              ref.watch(textOverlayListProvider)[idx];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    return Container(
      width: screenWidth,
      height: 50 * variablePixelHeight,
      color: AppColors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildAlignmentIcon(TextAlign.left),
          buildAlignmentIcon(TextAlign.center),
          buildAlignmentIcon(TextAlign.justify),
          buildAlignmentIcon(TextAlign.right),
        ],
      ),
    );
  }

  Widget buildAlignmentIcon(TextAlign alignment) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    var selectedTextProvider = ref.watch(selectedTextOverlayProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10 * variablePixelWidth),
      child: GestureDetector(
        onTap: ()=>changeAlignment(alignment),
        child: Container(
          height: 32 * variablePixelHeight,
          width: 32 * variablePixelWidth,
          decoration: selectedTextProvider.alignment == alignment
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(4 * pixelMultiplier),
                  border: Border.all(
                    color: AppColors.lightGreyBorder,
                    width: 0.5 * pixelMultiplier,
                  ),
                )
              : const BoxDecoration(),
          child: Icon(
            _getAlignmentIcon(alignment),
            size: 20*pixelMultiplier,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  IconData _getAlignmentIcon(TextAlign alignment) {
    switch (alignment) {
      case TextAlign.left:
        return Icons.format_align_left;
      case TextAlign.center:
        return Icons.format_align_center;
      case TextAlign.justify:
        return Icons.format_align_justify;
      case TextAlign.right:
        return Icons.format_align_right;
      default:
        return Icons.format_align_left;
    }
  }
}
