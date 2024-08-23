import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/horizontalspace/horizontal_space.dart';
import '../base_screen.dart';
import 'ads_editor_screen.dart';
import 'widgets/discard_edit_alert.dart';
import '../../widgets/headers/ads_header_widget.dart';

class DisplayAdsImageScreen extends StatefulWidget {
  const DisplayAdsImageScreen({this.url, this.image, super.key});

  final String? url;
  final Uint8List? image;

  @override
  State<DisplayAdsImageScreen> createState() => _DisplayAdsImageScreenState();
}

class _DisplayAdsImageScreenState extends BaseScreenState<DisplayAdsImageScreen> {
  bool showloader = false;
  final GlobalKey<ScaffoldState> displayImageKey = GlobalKey<ScaffoldState>();
  bool errorLoadingImage = false;

  Future<String> saveImage(
      Uint8List? bytes,
      BuildContext context,
      double pixelMultiplier,
      double textMultiplier,
      double variablePixelHeight,
      double variablePixelWidth) async {
    await [Permission.storage].request();

    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = 'mPartner_ad_save_$time';

    bytes ??=
        (await NetworkAssetBundle(Uri.parse(widget.url!)).load(widget.url!))
            .buffer
            .asUint8List();
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          translation(context).imageBeingSavedToGallery,
          style: GoogleFonts.poppins(
            color: AppColors.lumiDarkBlack,
            fontSize: 12 * textMultiplier,
            height: 20 / 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.25,
          ),
        ),
        padding: EdgeInsets.fromLTRB(
            14 * variablePixelWidth,
            8 * variablePixelHeight,
            14 * variablePixelWidth,
            8 * variablePixelHeight),
        elevation: 3,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: AppColors.lightGreen, width: 1 * pixelMultiplier),
          borderRadius: BorderRadius.circular(4 * pixelMultiplier),
        ),
        backgroundColor: AppColors.lightGreen,
        duration: const Duration(seconds: 3),
      ),
    );
    return result['filePath'];
  }

  @override
  Widget baseBody(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double topPadding = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop: () async {
        if (widget.image != null) {
          showDiscardEditsAlert(context, variablePixelHeight,
              variablePixelWidth, pixelMultiplier, textMultiplier);
        } else {
          Navigator.of(context)
              .popUntil(ModalRoute.withName(AppRoutes.createAdvertisement));
        }
        return false;
      },
      child: Scaffold(
        key: displayImageKey,
        backgroundColor: AppColors.white,
        body: SafeArea(
            child: Column(
          children: [
            AdsHeaderWidget(
                heading: translation(context).createAd,
                shareEnabled: true,
                image: widget.image,
                url: widget.url,
                returnFunction: (widget.image != null)
                    ? () {
                        showDiscardEditsAlert(
                            context,
                            variablePixelHeight,
                            variablePixelWidth,
                            pixelMultiplier,
                            textMultiplier);
                      }
                    : null),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: screenHeight - (190) * variablePixelHeight,
                  child: (widget.image != null)
                      ? Image.memory(
                          widget.image!,
                          fit: BoxFit.fitHeight,
                        )
                      : Image.network(
                          widget.url!,
                          fit: BoxFit.fitHeight,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return const Center(child: Icon(Icons.error));
                          },
                        ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              color: AppColors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          24 * variablePixelWidth,
                          5 * variablePixelHeight,
                          8 * variablePixelWidth,
                          8 * variablePixelHeight),
                      child: Button(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.lumiBluePrimary,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => (widget.url != null)
                                  ? AdsEditorScreen(imageUrl: widget.url!)
                                  : AdsEditorScreen(
                                      image: widget.image!,
                                    ),
                            ),
                          );
                        },
                        isEnabled: true,
                        buttonText: translation(context).edit,
                        textColor: AppColors.lumiBluePrimary,
                        backGroundColor: AppColors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          8 * variablePixelWidth,
                          5 * variablePixelHeight,
                          24 * variablePixelWidth,
                          8 * variablePixelHeight),
                      child: Button(
                        image: SvgPicture.asset(
                          'assets/mpartner/download.svg',
                        ),
                        onPressed: () async {
                          setState(() {
                            showloader = true;
                          });
                          Future.delayed(const Duration(seconds: 3), () {
                            setState(() {
                              showloader = false;
                            });
                          });
                          if (widget.image == null && widget.url == null)
                            return;

                          await saveImage(
                              widget.image,
                              context,
                              pixelMultiplier,
                              textMultiplier,
                              variablePixelHeight,
                              variablePixelWidth);
                        },
                        isEnabled: true,
                        showLoader: showloader,
                        buttonText: translation(context).download,
                        textColor: AppColors.lightWhite,
                        backGroundColor: AppColors.lumiBluePrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final String buttonText;
  Color backGroundColor;
  Color textColor;
  Color containerBackgroundColor;
  double containerHeight;
  Icon? icon;
  SvgPicture? image;
  bool showLoader;

  Button({
    super.key,
    required this.onPressed,
    required this.isEnabled,
    required this.buttonText,
    required this.backGroundColor,
    required this.textColor,
    this.containerHeight = 48,
    this.containerBackgroundColor = AppColors.white,
    this.icon,
    this.image,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    return Container(
      color: containerBackgroundColor,
      child: SizedBox(
        height: containerHeight,
        child: ElevatedButton(
          onPressed: isEnabled ? () => onPressed!() : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0 * pixelMultiplier),
                side: BorderSide(
                    width: 1 * pixelMultiplier,
                    color: AppColors.lumiBluePrimary)),
            backgroundColor: backGroundColor,
            disabledBackgroundColor: AppColors.lumiBluePrimary,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: showLoader
              ? const CircularProgressIndicator(
                  color: AppColors.lightWhite,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    image ?? Container(),
                    icon ?? Container(),
                    const HorizontalSpace(width: 8),
                    Text(
                      maxLines: 1,
                      buttonText,
                      // softWrap: true,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14.0 * textMultiplier,
                        letterSpacing: 0.10,
                        height: 0.10,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
