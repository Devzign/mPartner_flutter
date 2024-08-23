import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/routes/app_routes.dart';

class AdsHeaderWidget extends StatefulWidget {
  const AdsHeaderWidget({
    super.key,
    required this.heading,
    required this.shareEnabled,
    this.image,
    this.url,
    this.returnFunction,
  });

  final String heading;
  final bool shareEnabled;
  final String? url;
  final Uint8List? image;
  final Function()? returnFunction;

  @override
  State<AdsHeaderWidget> createState() => _AdsHeaderWidgetState();
}

class _AdsHeaderWidgetState extends State<AdsHeaderWidget> {
  bool _isShareInProgress = false;

  Future saveAndShare(Uint8List? bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/mPartner_ad_share.png');
    if (bytes == null) {
      Uint8List bytes =
          (await NetworkAssetBundle(Uri.parse(widget.url!)).load(widget.url!))
              .buffer
              .asUint8List();
      image.writeAsBytesSync(bytes);
      await Share.shareXFiles([XFile(image.path)]);
      setState(() {
        _isShareInProgress = false;
      });
    } else {
      image.writeAsBytesSync(bytes);
      await Share.shareXFiles([XFile(image.path)]);
      setState(() {
        _isShareInProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return Padding(
      padding: EdgeInsets.fromLTRB(
          14 * variablePixelWidth, 20, 14 * variablePixelWidth, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              icon: const Icon(
                Icons.arrow_back_outlined,
                color: AppColors.iconColor,
              ),
              onPressed: widget.returnFunction ??
                  () => {
                        Navigator.of(context).popUntil(
                            ModalRoute.withName(AppRoutes.createAdvertisement))
                      }),
          Text(
            widget.heading,
            style: GoogleFonts.poppins(
              color: AppColors.iconColor,
              fontSize: AppConstants.FONT_SIZE_LARGE * f,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          (widget.shareEnabled)
              ? _isShareInProgress
                  ? Transform.scale(
                      scale: 0.5, child: const CircularProgressIndicator())
                  : IconButton(
                      onPressed: () async {
                        if (!_isShareInProgress) {
                          setState(() {
                            _isShareInProgress = true;
                          });
                          await saveAndShare(widget.image);
                        }
                      },
                      icon: const Icon(Icons.share_outlined))
              : Container(),
        ],
      ),
    );
  }
}
