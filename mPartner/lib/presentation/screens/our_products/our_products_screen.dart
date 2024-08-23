import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../state/contoller/scheme_tab_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../widgets/headers/back_button_header_widget.dart';
import '../../widgets/tab_widget.dart';
import '../base_screen.dart';
import '../userprofile/user_profile_widget.dart';

import 'tab_catalog/tab_catalog.dart';
import 'tab_pricelist/tab_pricelist.dart';
import 'tab_scheme/tabs_scheme.dart';

class Product extends StatefulWidget {
  const Product({
    super.key,
    this.initialIndex = 0,
  });
  
  final int initialIndex;

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends BaseScreenState<Product> {
  List<TabData> tabs = [];
  @override
  void initState() {
    super.initState();
    SchemeTabController schemeTabController = Get.find();
    schemeTabController.resetState();
  }

  @override
  Widget baseBody(BuildContext context) {
    

    tabs = [
      TabData(translation(context).catalogue, const TabCatalog()),
      TabData(translation(context).priceList, const TabPricelist()),
      TabData(translation(context).scheme, TabScheme()),
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidgetWithBackButton(
                  heading: translation(context).products,
                  onPressed: () => {Navigator.pop(context)}),
              UserProfileWidget(),
              TabWidget(
                initialIndex: widget.initialIndex,
                tabs: tabs,
              ),
            ]),
      ),
    );
  }
}
