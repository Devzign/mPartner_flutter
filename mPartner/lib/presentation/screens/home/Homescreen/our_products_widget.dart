import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../state/contoller/catalogue_controller.dart';
import '../../../../state/contoller/price_list_controller.dart';
import '../../../../state/contoller/scheme_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../our_products/our_products_screen.dart';
import '../widgets/section_headings.dart';
import 'catalog_list_widget.dart';
import 'pricelist/component/price_list_widget.dart';
import 'scheme/component/scheme_list_widget.dart';

class OurProductsWidget extends StatefulWidget {
  const OurProductsWidget({super.key});

  @override
  State<OurProductsWidget> createState() => _OurProductsWidgetState();
}

class _OurProductsWidgetState extends State<OurProductsWidget> {
  PriceListController priceListController = Get.find();
  CatalogueController catalogueController = Get.find();
  SchemeController schemeController = Get.find();

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Obx(() {
      bool isProductsAvailable =
          catalogueController.isCatalogEmpty.value == false ||
              priceListController.isPriceListEmpty.value == false ||
              schemeController.isSchemeListEmpty.value == false;
      if (isProductsAvailable) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
              top: variablePixelHeight * 24,
              bottom: variablePixelHeight * 16,
              left: variablePixelWidth * 24,
              right: variablePixelWidth * 24),
          decoration: const BoxDecoration(color: AppColors.lumiLight5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeading(
                text: translation(context).ourProducts,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Product()));
                },
              ),
              const VerticalSpace(height: 26),
              Obx(() {
                if (catalogueController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (catalogueController.error.isNotEmpty) {
                  return Container();
                } else {
                  final bool isDataEmpty =
                      catalogueController.catalogueImageUrls.isEmpty;
                  if (isDataEmpty) {
                    return Container();
                  } else {
                    return Wrap(children: [
                      Text(translation(context).catalogue,
                          style: GoogleFonts.poppins(
                            color: AppColors.blackText,
                            fontSize: 14 * textMultiplier,
                            fontWeight: FontWeight.w500,
                            height: 0.09,
                          )),
                      const VerticalSpace(height: 16),
                      const CatalogWidget(),
                      const VerticalSpace(height: 14),
                    ]);
                  }
                }
              }),
              Obx(() {
                if (priceListController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (priceListController.error.isNotEmpty) {
                  return Container();
                } else {
                  final bool isDataEmpty =
                      priceListController.pricelistUrls.isEmpty;
                  if (isDataEmpty) {
                    return Container();
                  } else {
                    return Wrap(children: [
                      Text(translation(context).priceList,
                          style: GoogleFonts.poppins(
                            color: AppColors.blackText,
                            fontSize: 14 * textMultiplier,
                            fontWeight: FontWeight.w500,
                            height: 0.09,
                          )),
                      const VerticalSpace(height: 16),
                      const PriceListWidget(),
                      const VerticalSpace(height: 14),
                    ]);
                  }
                }
              }),
              Obx(() {
                if (schemeController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (schemeController.error.isNotEmpty) {
                  return Container();
                } else {
                  final bool isDataEmpty = schemeController.schemeList.isEmpty;
                  if (isDataEmpty) {
                    return Container();
                  } else {
                    return Wrap(
                      children: [
                        Text(translation(context).scheme,
                            style: GoogleFonts.poppins(
                              color: AppColors.blackText,
                              fontSize: 14 * textMultiplier,
                              fontWeight: FontWeight.w500,
                              height: 0.09,
                            )),
                        const VerticalSpace(height: 16),
                        const SchemeListWidget()
                      ],
                    );
                  }
                }
              }),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
