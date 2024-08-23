import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/utils/app_colors.dart';

import '../../../../../../state/contoller/user_data_controller.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';


class HeadingGem extends StatefulWidget {
  const HeadingGem({super.key});

  @override
  State<HeadingGem> createState() => _HeadingGemState();
}

class _HeadingGemState extends State<HeadingGem> {
  final UserDataController udc = Get.find();

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double sizeMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              child: SizedBox(
                height: 24 * variablePixelWidth,
                width: 24 * variablePixelWidth,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back_outlined,
                    color: AppColors.titleColor,
                  ),
                  onPressed: () => {Navigator.pop(context)},
                ),
              ),
            ),
            SizedBox(
              width: 12 * variablePixelWidth,
            ),
            Text(
              'Gem Support',
              style: GoogleFonts.poppins(
                color: AppColors.titleColor,
                fontSize: 22 * textFontMultiplier,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
