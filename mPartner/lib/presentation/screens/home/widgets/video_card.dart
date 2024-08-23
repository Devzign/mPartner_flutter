import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/utils/displaymethods/display_methods.dart';
import 'package:mpartner/presentation/widgets/horizontalspace/horizontal_space.dart';
import 'package:mpartner/presentation/widgets/verticalspace/vertical_space.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/app_colors.dart';
import '../../menu/luminous_videos/luminous_videos.dart';

class VideoCard extends StatefulWidget {
  String imagePath;
  String text;
  String videoId;
  VideoCard(
      {super.key,
      required this.imagePath,
      required this.text,
      required this.videoId});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  Future<void> launchYoutube(String id) async {
    Uri url = Uri.parse("https://www.youtube.com/watch?v=$id");
    try {
      // ignore: deprecated_member_use
      await launch(url.toString(), forceSafariVC: false, forceWebView: false);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultipler = DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    String truncatedText = widget.text.length > 20
        ? widget.text.substring(0, 20) + '...'
        : widget.text;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  //launchYoutube(widget.videoId);
                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LuminousVideos(
                                      videoId: widget.videoId,
                                    ),
                                  ));
                },
                child: Container(
                  height: variablePixelHeight * 95,
                  width: variablePixelWidth * 148,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.imagePath),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8 * pixelMultipler)),
                  ),
                ),
              ),
              HorizontalSpace(width: 12),
            ],
          ),
          VerticalSpace(height: 16),
          Text(
            truncatedText,
            style: GoogleFonts.poppins(
              color: AppColors.darkGreyText,
              fontSize: 12 * textMultiplier,
              fontWeight: FontWeight.w400,
              height: 0.09 * variablePixelHeight,
            ),
          )
        ],
      ),
    );
  }
}
