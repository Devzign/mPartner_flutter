import 'package:flutter/material.dart';

import '../../../widgets/CommonCards/card_with_download_and_share.dart';
import '../../../../../utils/displaymethods/display_methods.dart';

class layoutCard extends StatelessWidget {
  layoutCard({
    super.key,
    required this.catalogData,
    this.headingforCard = false,
  });

  final List<dynamic> catalogData;
  bool headingforCard;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    print("working");
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(24 * w, 0, 24 * w, 47 * h),
      itemCount: catalogData.length,
      itemBuilder: (context, index) {
        return ContainerWithImageCardAndPDFDownload(
          key: key,
          title: catalogData[index].categoryname,
          subtitle: "Last Updated On: May 2023",
          Uri: catalogData[index].imageURL,
          pdfUri: catalogData[index].card_action,
          showCardHeading: headingforCard,
        );
      },
    );
  }
}
