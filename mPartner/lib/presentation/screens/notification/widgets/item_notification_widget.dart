import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../state/contoller/notification_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import 'notification_icon_widget.dart';

class NotificationItemViewWidget extends StatefulWidget {
  final bool isMessageRead;
  final String notificationTime;
  final String notificationPreview;
  final VoidCallback onPressed;
  final String imgUrl;

  const NotificationItemViewWidget({
    super.key,
    required this.isMessageRead,
    required this.notificationTime,
    required this.notificationPreview,
    required this.imgUrl,
    required this.onPressed,
  });

  @override
  State<NotificationItemViewWidget> createState() => _NotificationItemViewWidgetState();
}

class _NotificationItemViewWidgetState extends State<NotificationItemViewWidget> {
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          22.0 * variablePixelWidth,
          16.0 * variablePixelHeight,
          20.0 * variablePixelWidth,
          16.0 * variablePixelHeight,
        ),
        color: widget.isMessageRead ? AppColors.white : AppColors.lumiLight5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(right: 12.0 * variablePixelWidth),
                child: Column(
                  children: [
                    ListIconWidget(isMessageRead: widget.isMessageRead),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HtmlWidget(widget.notificationPreview),
                  SizedBox(height: 5 * variablePixelHeight),
                  Text(
                    NotificationController.parseNotificationDate(
                        widget.notificationTime),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.poppins(
                        color: AppColors.hintColor,
                        fontSize: 12 * textFontMultiplier,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.10 * variablePixelWidth),
                  ),
                  if (widget.imgUrl != '')
                    Container(
                      padding: EdgeInsets.only(top: 12.0 * variablePixelHeight),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width * variablePixelWidth,
                        //width: 40 * variablePixelWidth,
                        height: 140 * variablePixelHeight,
                        imageUrl: widget.imgUrl,
                        fit: BoxFit.fitWidth,
                        placeholder: (context, url) => SvgPicture.asset(
                            "assets/mpartner/ic_icon_placeholder.svg"),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
