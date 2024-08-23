import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/products_card.dart';
import '../../../../../../state/contoller/scheme_controller.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';

class SchemeListWidget extends StatefulWidget {
  const SchemeListWidget({super.key});

  @override
  State<SchemeListWidget> createState() => _SchemeListWidgetState();
}

class _SchemeListWidgetState extends State<SchemeListWidget> {
  SchemeController schemeController = Get.find();

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();

    return GetBuilder<SchemeController>(builder: (_) {
      if (schemeController.isLoading.value) {
        return Center(child: CircularProgressIndicator(),);
      }
      return Container(
        height: variablePixelHeight * 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: schemeController.schemeList.length,
          itemBuilder: (context, index) {
            final schemeUrl = schemeController.schemeList[index].mainImage;
            final schemeName = schemeController.schemeList[index].customerType;
            return ProductsCard(
              imagePath: schemeUrl ?? "",
              text: schemeName ?? "",
              index: 2,
            );
          },
        ),
      );
    });
  }
}
