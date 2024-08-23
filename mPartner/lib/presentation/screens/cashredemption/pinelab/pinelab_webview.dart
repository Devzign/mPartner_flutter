import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../widgets/headers/back_button_header_widget.dart';
import '../../../widgets/verticalspace/vertical_space.dart';


class PinelabWebview extends StatefulWidget {
  const PinelabWebview({super.key});

  @override
  State<PinelabWebview> createState() => _PinelabWebviewState();
}

class _PinelabWebviewState extends State<PinelabWebview> {
  final UserDataController udc = Get.find();
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _loadWebView() {
    String userId = udc.sapId;
    try {
      _controller.loadRequest(Uri.parse('https://luminous.woohoo.in/login?email=$userId&token=${AppConstants.pinlabToken}'));
    } catch (e) {
      logger.e("Error loading URL: ${e.toString()}");
    }
  }

  void _navigateToBrowser(String weblink) async {
    if (await canLaunchUrlString(weblink)) {
      await launchUrl(Uri.parse(weblink), mode: LaunchMode.externalApplication);
    } else {
      logger.e("weblink is invalid");
    }
  }

  void _initWebView() {
    _controller = WebViewController();

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
          },
          onWebResourceError: (WebResourceError error) {
              setState(() {
                _isLoading = false;
              });
          },
        ),
      );
    _loadWebView();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidgetWithBackButton(
                  heading: 'Pine Labs Microsite',
                  leftPadding: 14,
                  topPadding: 24,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const VerticalSpace(height: 24),
                Expanded(
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return WebViewWidget(controller: _controller);
                    },
                  ),
                ),
              ],
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
