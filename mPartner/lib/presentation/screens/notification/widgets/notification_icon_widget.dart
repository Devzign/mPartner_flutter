import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';

class ListIconWidget extends StatefulWidget {
  final bool isMessageRead;

  const ListIconWidget({
    super.key,
    required this.isMessageRead,
  });

  @override
  State<ListIconWidget> createState() => _ListIconWidgetState();
}

class _ListIconWidgetState extends State<ListIconWidget> {
  @override
  Widget build(BuildContext context) {
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();

    return Stack(
      children: [
        Container(
          width: 45 * variablePixelWidth,
          height: 45 * variablePixelWidth,
          decoration: ShapeDecoration(
            color: AppColors.lumiLight4,
            shape: OvalBorder(
              side: BorderSide(
                  width: 1 * variablePixelWidth, color: AppColors.lightGrey2),
            ),
          ),
          child: SizedBox(
            width: 24 * variablePixelWidth,
            height: 24 * variablePixelWidth,
            child: const Center(
              child: Icon(
                Icons.redeem,
                color: AppColors.lumiBluePrimary,
              ),
            ),
          ),
        ),
        if (!widget.isMessageRead)
          Positioned(
            bottom: 2 * variablePixelWidth,
            right: 2 * variablePixelWidth,
            child: Container(
              width: 8 * variablePixelWidth,
              height: 8 * variablePixelWidth,
              decoration: const ShapeDecoration(
                color: AppColors.successGreen,
                shape: OvalBorder(),
              ),
            ),
          ),
      ],
    );
  }
}
