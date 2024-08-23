import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/scheme_model.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/CommonCards/card_with_download_and_share.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

class LayoutCardScheme extends StatelessWidget {
  LayoutCardScheme({
    Key? key,
    required this.catalogData,
    this.headingforCard = false,
    required this.currMonth,
  }) : super(key: key);

  final List<Scheme> catalogData;
  final bool headingforCard;
  final String currMonth;
  List<Scheme> myList = [];

  List<Scheme> listTobeDisplayed(List<Scheme> catalogData, String currMonth) {
    List<Scheme> result = [];

    if (currMonth != "All") {
      for (Scheme schemeItem in catalogData) {
        DateTime start_date =
            DateTime.parse(schemeItem.startDate ?? "2000-02-01 00:00:00.000");
        DateTime end_date =
            DateTime.parse(schemeItem.endDate ?? "2001-02-01 00:00:00.000");
        DateTime dateTime = DateFormat('MMMM yyyy').parse(currMonth);
        print(start_date);
        if (start_date.compareTo(dateTime) <= 0 &&
            end_date.compareTo(dateTime) >= 0) {
          result.add(schemeItem);
        }
      }
    } else {
      // for (Scheme schemeItem in catalogData) {
      //   DateTime dateTime = DateTime.now().subtract(Duration(days: 180));
      //   DateTime start_date =
      //       DateTime.parse(schemeItem.startDate ?? "2000-02-01 00:00:00.000");

      //   if (start_date.compareTo(dateTime) >= 0) {
      //     result.add(schemeItem);
      //   }
      // }
      result = catalogData;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    myList = listTobeDisplayed(catalogData, currMonth);
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Visibility(
      replacement: Column(children: [
        VerticalSpace(height: 150),
        NoSchemeErrorMessage(w: w, f: f)
      ]),
      visible: myList.isNotEmpty,
      child: GridView.builder(
        // addAutomaticKeepAlives: true,
        // cacheExtent: 10000,
        padding: EdgeInsets.fromLTRB(24 * w, 20 * h, 24 * w, 47 * h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 245 * h + 40 * f,
            crossAxisSpacing: 16 * w,
            mainAxisSpacing: 16 * h),
        itemCount: myList.length,
        itemBuilder: (context, index) {
          return schemeGridContainer(
            pdfUrl: myList[index].cardAction ?? "",
            url: myList[index].mainImage ?? "",
            title: myList[index].title ?? "",
            date_range:
                "${DateFormat('d MMM yyyy').format(DateTime.parse(myList[index].startDate ?? "1600-02-01 00:00:00.000"))} - ${DateFormat('d MMM yyyy').format(DateTime.parse(myList[index].endDate ?? "1600-02-01 00:00:00.000"))}",
            subtitle: myList[index].subTitle ?? "",
          );
        },
      ),
    );
  }
}

class schemeGridContainer extends StatelessWidget {
  schemeGridContainer({
    super.key,
    required this.url,
    required this.pdfUrl,
    required this.title,
    required this.subtitle,
    required this.date_range,
  });
  final String url, title, subtitle, date_range, pdfUrl;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PDFViewerFromUrl(
                      url: pdfUrl,
                      heading: title,
                      subheading1: subtitle,
                      subheading2: date_range,
                    )))
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10.00 * w, 7.51 * h, 6 * w, 7.5 * h),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: AppColors.lightGrey2),
              borderRadius: BorderRadius.circular(12 * r)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                  color: AppColors.darkText2,
                  fontWeight: FontWeight.w600,
                  fontSize: 12 * f,
                  height: 16 / 12),
              overflow: TextOverflow.ellipsis,
            ),
            VerticalSpace(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                  color: AppColors.darkGreyText,
                  fontWeight: FontWeight.w500,
                  fontSize: 10 * f,
                  height: 12 / 10),
              overflow: TextOverflow.ellipsis,
            ),
            VerticalSpace(height: 6),
            Container(
              width: double.infinity,
              height: 190 * h,
              child: Image.network(
                url,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, exception, stackTrace) {
                  return Image.asset(
                    'assets/mpartner/ic_trips_small.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
              // child: CachedNetworkImage(
              //   fit: BoxFit.fitWidth,
              //   imageUrl: url,
              //   placeholder: (context, url) => SvgPicture.asset(
              //       "assets/mpartner/ic_icon_placeholder.svg"),
              //   errorWidget: (context, url, error) => const Icon(Icons.error),
              // )
            ),
            VerticalSpace(
              height: 7.51,
            ),
            Text(
              date_range,
              style: GoogleFonts.poppins(
                  color: AppColors.darkGreyText,
                  fontWeight: FontWeight.w500,
                  fontSize: 10 * f,
                  height: 16 / 12),
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}

class NoSchemeErrorMessage extends StatelessWidget {
  const NoSchemeErrorMessage({
    super.key,
    required this.w,
    required this.f,
  });

  final double w;
  final double f;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 309 * w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            translation(context).noSchemesFound,
            style: GoogleFonts.poppins(
              color: AppColors.blackText,
              fontSize: 18 * f,
              fontWeight: FontWeight.w600,
              height: 20 / 18,
            ),
          ),
          VerticalSpace(height: 12),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  translation(context).noSchemesFoundMsg1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w400,
                    height: 20 / 12,
                  ),
                ),
                Text(
                  translation(context).noSchemesFoundMsg2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w400,
                    height: 20 / 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
