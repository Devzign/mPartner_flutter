import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../our_products/our_products_screen.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

class ProductsCard extends StatefulWidget {
  String imagePath;
  String text;
  double width;
  int index;
  ProductsCard(
      {super.key,
      required this.imagePath,
      required this.text,
      this.width = 107,
      required this.index});

  @override
  State<ProductsCard> createState() => _ProductsCardState();
}

class _ProductsCardState extends State<ProductsCard> {
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultipler =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    String truncatedText = widget.text.length > 13
        ? widget.text.substring(0, 13) + '...'
        : widget.text;
    String finalImagePath = widget.imagePath.isNotEmpty
        ? widget.imagePath
        : 'https://uatmpartner.luminousindia.com/MpartnerNewApi/CatalogImage/SolarproductsCatalogue.jpg';
    print("Image path $finalImagePath");

    return GestureDetector(
      onTap: () async {
        if (widget.index == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Product(
                        initialIndex: 0,
                      )));
        }
        if (widget.index == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Product(
                        initialIndex: 1,
                      )));
        }
        if (widget.index == 2) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Product(
                        initialIndex: 2,
                      )));
        }
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: widget.width * variablePixelWidth,
                  height: 114 * variablePixelHeight,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(finalImagePath),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8 * pixelMultipler)),
                  ),
                ),
                const HorizontalSpace(width: 12)
              ],
            ),
            const VerticalSpace(height: 7),
            Text(
              truncatedText,
              style: GoogleFonts.poppins(
                color: AppColors.darkGrey,
                fontSize: 12 * textMultiplier,
                fontWeight: FontWeight.w400,
              ),
              softWrap: true,
            )
          ],
        ),
      ),
    );
  }
}
