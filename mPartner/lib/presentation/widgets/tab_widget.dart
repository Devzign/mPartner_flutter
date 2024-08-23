import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/displaymethods/display_methods.dart';
import '../../../utils/app_colors.dart';

class TabData {
  final String title;
  final Widget content;

  TabData(this.title, this.content);
}

class TabWidget extends StatelessWidget {
  final List<TabData> tabs;
  final int initialIndex;
  final TabController? controller;

  const TabWidget({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Expanded(
      child: DefaultTabController(
        initialIndex: initialIndex,
        length: tabs.length,
        child: Column(
          children: [
            TabBar(
              controller: controller,
              padding: EdgeInsets.only(bottom: 20 * h),
              indicatorColor: AppColors.lumiBluePrimary,
              dividerColor: AppColors.lumiLight4,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelStyle: GoogleFonts.poppins(
                color: AppColors.hintColor,
                fontSize: 14 * f,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.10 * w,
              ),
              unselectedLabelColor: const Color.fromRGBO(141, 141, 141, 1),
              labelColor: AppColors.lumiBluePrimary,
              labelStyle: GoogleFonts.poppins(
                color: AppColors.lumiBluePrimary,
                fontSize: 14 * f,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.10 * w,
              ),
              tabs: tabs.map((tabData) => Tab(text: tabData.title)).toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: controller,
                physics: const BouncingScrollPhysics(),
                children: tabs.map((tabData) => tabData.content).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
