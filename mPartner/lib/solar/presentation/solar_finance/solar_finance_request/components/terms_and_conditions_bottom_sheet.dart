import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' show parse;

import '../../../../../presentation/widgets/common_divider.dart';
import '../../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../state/controller/terms_and_condition_controller.dart';

void showTermsAndConditionsBottomSheet(BuildContext context, Function(bool) onScrolledCallback) {
  double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
  double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
  double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
  double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
  TermsAndConditionController termsAndConditionController = Get.find();

  ScrollController scrollController = ScrollController();

  scrollController.addListener(() {
    if (scrollController.position.atEdge && scrollController.position.pixels != 0) {
      onScrolledCallback(true);
    }
  });

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0 * pixelMultiplier),
      ),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8 * variablePixelWidth, 8 * variablePixelHeight, 8 * variablePixelWidth, 8 * variablePixelHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const VerticalSpace(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: Container(
                      height: 5 * variablePixelHeight,
                      width: 50 * variablePixelWidth,
                      decoration: BoxDecoration(
                        color: AppColors.grayText,
                        borderRadius: BorderRadius.circular(12 * pixelMultiplier),
                      ),
                    ),
                  ),
                ),
                const VerticalSpace(height: 16),
                Padding(
                  padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                  child: Text(
                    'Term & Conditions',
                    style: GoogleFonts.poppins(
                      color: AppColors.titleColor,
                      fontSize: 20 * textFontMultiplier,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.50,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16 * variablePixelWidth, right: 16 * variablePixelWidth),
                  child: const CustomDivider(color: AppColors.dividerColor),
                ),
                const VerticalSpace(height: 16),
                Obx(() {
                  if (termsAndConditionController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (termsAndConditionController.error.isNotEmpty) {
                    return Container();
                  } else {
                    final bool isDataEmpty = termsAndConditionController.termsAndConditionRes.first.data.isEmpty;
                    if (isDataEmpty) {
                      return Center(
                        child: Text(
                          translation(context).dataNotFound,
                          style: GoogleFonts.poppins(
                              fontSize: 14 * textFontMultiplier,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      );
                    } else {
                      final List<String> warrantyPoints = _parseHtmlToList(termsAndConditionController.termsAndConditionRes.first.data.first.termsConditionData);
                      return SizedBox(
                        height: 0.7 * MediaQuery.sizeOf(context).height,
                        child: Padding(
                          padding: EdgeInsets.only(left: 16 * variablePixelWidth, right: 16 * variablePixelWidth),
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: warrantyPoints.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.0 * variablePixelHeight),
                                child: Text(
                                  warrantyPoints[index],
                                  style: GoogleFonts.poppins(
                                      color: AppColors.darkGreyText,
                                      fontSize: 12 * textFontMultiplier,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.50,
                                      height: 1.5,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    }
                  }
                ),
                const VerticalSpace(height: 24),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

List<String> _parseHtmlToList(String htmlString) {
  final document = parse(htmlString);
  final List<String> points = document.querySelectorAll('p').map((e) => e.text.trim()).toList();
  return points;
}