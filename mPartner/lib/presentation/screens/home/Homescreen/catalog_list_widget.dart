import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../widgets/products_card.dart';
import '../../../../state/contoller/catalogue_controller.dart';

class CatalogWidget extends StatefulWidget {
  const CatalogWidget({Key? key});

  @override
  State<CatalogWidget> createState() => _CatalogWidgetState();
}

class _CatalogWidgetState extends State<CatalogWidget> {
  CatalogueController catalogController = Get.find();

  @override
  Widget build(BuildContext context) {
    double catalogueCardWidth = 107;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    return Container(
      height: variablePixelHeight * 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: catalogController.catalogueImageUrls.length,
        itemBuilder: (context, index) {
          final imageUrl = catalogController.catalogueImageUrls[index];
          final catalogText = catalogController.catalogName[index];
          return ProductsCard(
            imagePath: imageUrl ?? " ",
            text: catalogText ?? " ",
            width: catalogueCardWidth,
            index: 0,
          );
        },
      ),
    );
  }
}
