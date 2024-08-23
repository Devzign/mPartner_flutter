import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/catalogue_model.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/CommonCards/card_with_download_and_share.dart';
import '../../../../../utils/displaymethods/display_methods.dart';

class LayoutCardCatalog extends StatelessWidget {
  const LayoutCardCatalog({
    super.key,
    required this.catalogData,
    this.headingforCard = false,
  });

  final List<Catalog> catalogData;
  final bool headingforCard;

  String formatDate(String givenDate){
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(givenDate));
  }

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
          title: catalogData[index].categoryname ?? "Not Recieved",
          subtitle:
              "${translation(context).lastUpdatedOn} ${formatDate(catalogData[index].lastUpdatedOn!)}",
          Uri: catalogData[index].imageURL ??
              '"https://mpdev.luminousindia.com/MpartnerNewApi/CatalogImage/INBT_THUMBNAIL.jpg",',
          pdfUri: catalogData[index].pdfURL ??
              '"https://mpdev.luminousindia.com/MpartnerNewApi/Pdf/INBT_Catalog_Mobile.pdf",',
          showCardHeading: headingforCard,
          height: 150 * h,
        );
      },
    );
  }
}
