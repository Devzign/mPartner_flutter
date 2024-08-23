import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../utils/app_colors.dart';

class SvgContainer extends StatelessWidget {
  String path;
  bool isEnabled;
  SvgContainer({super.key,
  required this.path,
  required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: isEnabled ? AppColors.lumiLight4 : AppColors.lightGrey2,
              borderRadius: const BorderRadius.all(
                  Radius.circular(36))),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2, top: 1),
          child: isEnabled ? SvgPicture.asset(
              path,
              height: 26,
              width: 26,
            ) : ColorFiltered(
              colorFilter: const ColorFilter.mode(AppColors.lightGraySvg, BlendMode.modulate),
              child: SvgPicture.asset(
                path,
                height: 26,
                width: 26,
              ),
            )
        ),

      ],
    );
  }
}