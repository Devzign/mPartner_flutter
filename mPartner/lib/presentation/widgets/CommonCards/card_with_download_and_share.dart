import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import '../../../utils/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/utils.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../horizontalspace/horizontal_space.dart';
import '../verticalspace/vertical_space.dart';

class ProductCardBanner extends StatelessWidget {
  ProductCardBanner(
      {super.key,
        required this.title,
        required this.subtitle,
        required this.pdfURI});
  final String title, subtitle, pdfURI;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      width: 317 * w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 225 * w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkText2,
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.10,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 2 * h,
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 12 * f,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.10,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          DownloadAndShareButton(pdfURI: pdfURI),
        ],
      ),
    );
  }
}

class ContainerWithImageCardAndPDFDownload extends StatelessWidget {
  const ContainerWithImageCardAndPDFDownload(
      {super.key,
        required this.title,
        required this.subtitle,
        required this.Uri,
        this.showCardHeading = false,
        this.pdfUri = "www.google.com",
        this.height = 114});
  final String title;
  final String subtitle;
  final String Uri;
  final String pdfUri;
  final double height;
  final bool showCardHeading;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PDFViewerFromUrl(
                url: pdfUri,
                heading: title,
                subheading1: subtitle,
                subheading2: "",
              )),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: showCardHeading
                ? Container(
              padding: EdgeInsets.only(bottom: 12 * h),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: AppColors.darkText2,
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.10,
                ),
              ),
            )
                : null,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16 * w, 16 * h, 12 * w, 16 * h),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: AppColors.white_234),
                      borderRadius: BorderRadius.circular(12 * r)),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  ProductCardBanner(
                    title: title,
                    subtitle: subtitle,
                    pdfURI: pdfUri,
                  ),
                  SizedBox(
                    height: 16 * h,
                  ),
                  Container(
                    decoration: ShapeDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                        image: NetworkImage(Uri),
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8 * r)),
                    ),
                    height: height * h,
                  ),
                ]),
              ),
            ],
          ),
          SizedBox(
            height: 20 * h,
          ),
        ],
      ),
    );
  }
}

class PDFViewerFromUrl extends StatelessWidget {
  const PDFViewerFromUrl(
      {Key? key,
        required this.url,
        required this.heading,
        required this.subheading1,
        required this.subheading2})
      : super(key: key);

  final String url;
  final String heading, subheading1, subheading2;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24 * w, 24 * h, 24 * w, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      child: SizedBox(
                        height: 24 * r,
                        width: 24 * r,
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.arrow_back_outlined,
                              color: AppColors.iconColor,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                    SizedBox(
                      width: 12 * w,
                    ),
                    Expanded(
                      child: Text(
                        heading,
                        style: GoogleFonts.poppins(
                            color: AppColors.darkText2,
                            fontSize: 22 * f,
                            fontWeight: FontWeight.w600,
                            height: 24 / 22),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
              VerticalSpace(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24 * w),
                child: Text(
                  subheading1,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w500,
                    height: 21 / 14,
                  ),
                ),
              ),
              Visibility(
                visible: subheading2.isNotEmpty,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24 * w),
                  child: Text(
                    subheading2,
                    style: GoogleFonts.poppins(
                      color: AppColors.grayText,
                      fontSize: 14 * f,
                      fontWeight: FontWeight.w500,
                      height: 21 / 14,
                    ),
                  ),
                ),
              ),
              VerticalSpace(height: 16),
              Expanded(
                child: Container(
                  color: AppColors.white,
                  child: PDF(
                      pageFling: false,
                      pageSnap: false,
                      fitPolicy: FitPolicy.WIDTH)
                      .fromUrl(
                    url,
                    placeholder: (double progress) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (dynamic error) =>
                        Center(child: Text(error.toString())),
                  ),
                ),
              ),
              VerticalSpace(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24 * w),
                child: Row(
                  children: [
                    SecondaryButton(
                        showIcon: true,
                        buttonText: "Share",
                        buttonHeight: 48,
                        onPressed: () {
                          showBottomSheetAndShare(context, url);
                        },
                        isEnabled: true),
                    HorizontalSpace(width: 16),
                    PrimaryButton(
                        showIcon: true,
                        buttonText: translation(context).download,
                        buttonHeight: 48,
                        onPressed: () => {_openPdfUrl(url)},
                        isEnabled: true),
                  ],
                ),
              ),
              VerticalSpace(height: 32),
            ]),
      ),
    );
  }
}

class DownloadAndShareButton extends StatelessWidget {
  const DownloadAndShareButton(
      {super.key,
        required this.pdfURI,
        this.rowMainAlignment = MainAxisAlignment.start,
        this.rowCrossAlignment = CrossAxisAlignment.start,
        this.size = 28});
  final String pdfURI;
  final MainAxisAlignment rowMainAlignment;
  final CrossAxisAlignment rowCrossAlignment;
  final double size;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      child: Row(
          mainAxisAlignment: rowMainAlignment,
          crossAxisAlignment: rowCrossAlignment,
          children: [
            SizedBox(
              width: size * r,
              height: size * r,
              child: IconButton(

                //onPressed:,
                  padding: EdgeInsets.all(0),
                  icon: SvgPicture.asset(
                      'assets/mpartner/Products_assets/download.svg'),
                  onPressed: () => {_openPdfUrl(pdfURI)}),
            ),
            SizedBox(
              width: 12 * w,
            ),
            SizedBox(
              width: size * r,
              height: size * r,
              child: IconButton(
                //onPressed
                  padding: EdgeInsets.all(0),
                  icon: SvgPicture.asset(
                    'assets/mpartner/Products_assets/share.svg',
                  ),
                  onPressed: () {
                    showBottomSheetAndShare(context, pdfURI);
                  }
              ),
            )
          ]),
    );
  }
}

void _openPdfUrl(String pdfUrl) async {
  if (await canLaunchUrlString(pdfUrl)) {
    await launchUrlString(pdfUrl);
  } else {
    throw 'Could not launch $pdfUrl';
  }
}

void showBottomSheetAndShare(BuildContext context, String url) {
  showModalBottomSheet(
    context: context,
    builder: (context) => WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SizedBox(
        height: 0.3 * MediaQuery.of(context).size.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
    isDismissible: false,
    enableDrag: false,
  );

  try {
    Future<void> _downloadAndShare() async {
      final tempDir = await getTemporaryDirectory();
      String fileName = url.split('/').last;
      final file = File('${tempDir.path}/$fileName');
      try {
        await file.writeAsBytes(await http.readBytes(Uri.parse(url))).whenComplete(() {
          Navigator.pop(context);
        });
        await Share.shareXFiles([XFile(file.path)]);
      } catch (e) {
        Utils().showToast('Error loading PDF. Please try again later.', context);
        Navigator.pop(context);
      }
    }
    _downloadAndShare().catchError((e) {
      debugPrint('Error: $e');
      Navigator.pop(context);
    });
  } catch (e) {
    debugPrint('Error: $e');
    Navigator.pop(context);
  }
}
