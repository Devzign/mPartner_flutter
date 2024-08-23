import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/products_card.dart';
import '../../../../../../state/contoller/price_list_controller.dart';

class PriceListWidget extends StatefulWidget {
  const PriceListWidget({Key? key});

  @override
  State<PriceListWidget> createState() => _PriceListWidgetState();
}

class _PriceListWidgetState extends State<PriceListWidget> {
  PriceListController priceListController = Get.find();

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();

    return Container(
      height: variablePixelHeight * 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: priceListController.pricelistUrls.length,
        itemBuilder: (context, index) {
          final priceListType = priceListController.pricelistUrls[index].customerType;
          final pricelistUrl = priceListController.pricelistUrls[index].mainImage;
          return ProductsCard(
            imagePath: pricelistUrl ?? "",
            text: priceListType ?? '',
            index: 1,
          );
        },
      ),
    );
  }
}
