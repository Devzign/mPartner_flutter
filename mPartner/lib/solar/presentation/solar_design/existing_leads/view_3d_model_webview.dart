import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../common/heading_solar.dart';

class View3dModelWebView extends StatefulWidget {
  const View3dModelWebView({required this.url, super.key});

  final String url;

  @override
  State<View3dModelWebView> createState() => _View3dModelWebViewState();
}

class _View3dModelWebViewState extends State<View3dModelWebView> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _loadWebView() {
    try {
      _controller.loadRequest(Uri.parse(widget.url));
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
                HeadingSolar(
                  heading: translation(context).view3dModel,
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                const VerticalSpace(height: 24),
                Expanded(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
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
