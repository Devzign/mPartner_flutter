import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../data/models/new_warranty_model.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../state/contoller/warranty_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../widgets/common_button.dart';
import '../../widgets/horizontalspace/horizontal_space.dart';
import '../../widgets/verticalspace/vertical_space.dart';

class WarrantyNewUI extends StatefulWidget {
  WarrantyNewUI({Key? key, required this.data});
  NewWarranty data;

  @override
  State<WarrantyNewUI> createState() => _WarrantyNewUIState();
}

class _WarrantyNewUIState extends State<WarrantyNewUI> {
  bool isDownloadable = false;
  bool isDisty = false;
  UserDataController userDataController = Get.find();

  void isUserSellerToTertiaryCustomer() {
    isDownloadable = !widget.data.tertiarySoldTo.contains("*");
  }

  WarrantyController _warrantyController = Get.find();
  @override
  void initState() {
    super.initState();
    isDisty = userDataController.userType == "DISTY";
    _warrantyController.getWarrantyPdfUrl(widget.data.serialNo);
    isUserSellerToTertiaryCustomer();
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  WarrantyProductDetailCard(
                    w: w,
                    h: h,
                    r: r,
                    f: f,
                    modelName: widget.data.modelName,
                    serialNo: widget.data.serialNo,
                    mfgDate: widget.data.mfgDate,
                    imgUrl: widget.data.imgUrl,
                  ),
                  VerticalSpace(height: 16),
                  Text(translation(context).saleJourney,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 14 * f,
                        fontWeight: FontWeight.w700,
                        height: 21 / 14,
                        letterSpacing: 0.10,
                      )),
                  VerticalSpace(height: 12),
                  Visibility(
                    visible: widget.data.primarySoldTo.isNotEmpty,
                    child: SaleCard(
                        r: r,
                        f: f,
                        w: w,
                        h: h,
                        showDottedLine: true,
                        typeOfSale: translation(context).primarySale,
                        dateOfSale: isDisty ? widget.data.primaryDate : "",
                        soldTo: widget.data.primarySoldTo,
                        soldBy: ""),
                  ),
                  Visibility(
                    visible: widget.data.secondarySoldTo.isNotEmpty,
                    child: SaleCard(
                        r: r,
                        f: f,
                        w: w,
                        h: h,
                        showDottedLine: true,
                        typeOfSale: translation(context).secondarySale,
                        dateOfSale: widget.data.secondaryDate,
                        soldTo: widget.data.secondarySoldTo,
                        soldBy: ""),
                  ),
                  Visibility(
                    visible: widget.data.intermediateSoldTo.isNotEmpty,
                    child: SaleCard(
                        r: r,
                        f: f,
                        w: w,
                        h: h,
                        showDottedLine: true,
                        typeOfSale: translation(context).intermediarySale,
                        dateOfSale: widget.data.intermediateDate,
                        soldTo: widget.data.intermediateSoldTo,
                        soldBy: widget.data.intermediateSoldBy),
                  ),
                  Visibility(
                    visible: widget.data.tertiarySoldTo.isNotEmpty,
                    child: SaleCard(
                        r: r,
                        f: f,
                        w: w,
                        h: h,
                        showDottedLine: false,
                        typeOfSale: translation(context).tertiarySale,
                        dateOfSale: widget.data.tertiaryDate,
                        soldTo: widget.data.tertiarySoldTo,
                        soldBy: widget.data.tertiarySoldBy),
                  ),
                  Visibility(
                      visible: !isDownloadable,
                      child: VerticalSpace(height: 20)),
                  Visibility(
                    visible: widget.data.tertiarySoldTo.isNotEmpty &&
                        isDownloadable &&
                        widget.data.finalStatus == "1",
                    child: Obx(
                      () => Visibility(
                        visible: !_warrantyController.isPdfLoading.value,
                        replacement:
                            const Center(child: CircularProgressIndicator()),
                        child: Column(
                          children: [
                            Visibility(
                              visible: _warrantyController.pdfExist.value,
                              child: CommonButton(
                                horizontalPadding: 0,
                                topPadding: 0,
                                bottomPadding: 0,
                                onPressed: () async {
                                  await launchUrlString(
                                      _warrantyController.urlToDownload.value);
                                },
                                backGroundColor: AppColors.lumiBluePrimary,
                                textColor: AppColors.lightWhite,
                                buttonText:
                                    translation(context).downloadWarrantyCard,
                                isEnabled: isDownloadable,
                                containerBackgroundColor: AppColors.lightWhite1,
                              ),
                            ),
                            VerticalSpace(height: 28),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SaleCard extends StatelessWidget {
  SaleCard({
    super.key,
    required this.r,
    required this.f,
    required this.w,
    required this.h,
    required this.showDottedLine,
    required this.typeOfSale,
    required this.dateOfSale,
    required this.soldTo,
    required this.soldBy,
  });

  final double r;
  final double f;
  final double w;
  final double h;
  final bool showDottedLine;
  final String typeOfSale;
  final String dateOfSale;
  final String soldTo;
  final String soldBy;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VerticalSpace(height: 7),
              Icon(
                Icons.circle,
                color: AppColors.lightGreyOval,
                size: 12 * r,
              ),
              VerticalSpace(height: 3),
              Visibility(
                visible: showDottedLine,
                child: CustomPaint(
                  size: Size(1, 1000 * h),
                  painter: DashedLineVerticalPainter(),
                ),
              )
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            HorizontalSpace(width: 24),
            Flexible(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      typeOfSale,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 16 * f,
                        fontWeight: FontWeight.w600,
                        height: 24 / 16,
                        letterSpacing: 0.10,
                      ),
                    ),
                    VerticalSpace(height: 4),
                    Visibility(
                      visible: dateOfSale.isNotEmpty,
                      child: Text(
                        '${translation(context).doneOn} $dateOfSale',
                        style: GoogleFonts.poppins(
                          color: AppColors.grayText,
                          fontSize: 12 * f,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.10,
                        ),
                      ),
                    ),
                    Visibility(
                        visible: dateOfSale.isNotEmpty,
                        child: VerticalSpace(height: 12)),
                    Visibility(
                      visible: soldBy.isNotEmpty,
                      child: SoldBySoldToContainer(
                        w: w,
                        h: h,
                        f: f,
                        r: r,
                        soldTypeText: translation(context).soldBy,
                        userIdText: soldBy,
                      ),
                    ),
                    Visibility(
                        visible: soldBy.isNotEmpty,
                        child: VerticalSpace(height: 12)),
                    SoldBySoldToContainer(
                      w: w,
                      h: h,
                      f: f,
                      r: r,
                      soldTypeText: translation(context).soldTo,
                      userIdText: soldTo,
                    ),
                    VerticalSpace(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SoldBySoldToContainer extends StatelessWidget {
  const SoldBySoldToContainer({
    Key? key,
    required this.w,
    required this.h,
    required this.f,
    required this.r,
    required this.soldTypeText,
    required this.userIdText,
  }) : super(key: key);

  final double w;
  final double h;
  final double f;
  final double r;
  final String soldTypeText;
  final String userIdText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12 * w, vertical: 12 * h),
      decoration: ShapeDecoration(
        color: AppColors.lumiLight5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8 * r)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            soldTypeText,
            style: GoogleFonts.poppins(
              color: AppColors.greyGamma,
              fontSize: 14 * f,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              letterSpacing: 0.10,
            ),
          ),
          Text(
            userIdText,
            style: GoogleFonts.poppins(
              color: AppColors.greyGamma,
              fontSize: 14 * f,
              fontWeight: FontWeight.w600,
              height: 20 / 14,
              letterSpacing: 0.10,
            ),
            // overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class WarrantyProductDetailCard extends StatelessWidget {
  WarrantyProductDetailCard({
    Key? key,
    required this.w,
    required this.h,
    required this.r,
    required this.f,
    required this.modelName,
    required this.serialNo,
    required this.imgUrl,
    required this.mfgDate,
  }) : super(key: key);

  final double w;
  final double h;
  final double r;
  final double f;
  final String modelName;
  final String serialNo;
  final String imgUrl;
  final String mfgDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * w, vertical: 8 * h),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1 * r, color: AppColors.lumiLight4),
          borderRadius: BorderRadius.circular(12 * r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            translation(context).productDetails,
            style: GoogleFonts.poppins(
              color: AppColors.darkGreyText,
              fontSize: 14 * f,
              fontWeight: FontWeight.w700,
              height: 18 / 14,
              letterSpacing: 0.10,
            ),
          ),
          VerticalSpace(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: mfgDate.isNotEmpty ? 3 : 2,
                child: Container(
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.contain,
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
                        'assets/mpartner/warrantyPlaceholder.png',
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
              ),
              HorizontalSpace(width: 8),
              Flexible(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProductDetailColumn(
                      f: f,
                      w: w,
                      titleText: translation(context).serialNo,
                      contentText: serialNo,
                    ),
                    const VerticalSpace(height: 6),
                    ProductDetailColumn(
                      f: f,
                      w: w,
                      titleText: translation(context).modelName,
                      contentText: modelName,
                    ),
                    if (mfgDate.isNotEmpty) ...[
                      const VerticalSpace(height: 6),
                      ProductDetailColumn(
                        f: f,
                        w: w,
                        titleText: translation(context).manufacturedIn,
                        contentText: mfgDate,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class ProductDetailColumn extends StatelessWidget {
  const ProductDetailColumn({
    Key? key,
    required this.f,
    required this.titleText,
    required this.contentText,
    required this.w,
  }) : super(key: key);

  final double f;
  final double w;
  final String titleText, contentText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: GoogleFonts.poppins(
            color: AppColors.grayText,
            fontSize: 12 * f,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
            letterSpacing: 0.10,
          ),
        ),
        const VerticalSpace(
          height: 2,
        ),
        Text(
          contentText,
          softWrap: true,
          style: GoogleFonts.poppins(
            color: AppColors.darkGreyText,
            fontSize: 12 * f,
            fontWeight: FontWeight.w600,
            height: 20 / 12,
            letterSpacing: 0.10,
          ),

        )
      ],
    );
  }
}

class DashedLineVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = AppColors.lightGreyOval
      ..strokeWidth = size.width;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
