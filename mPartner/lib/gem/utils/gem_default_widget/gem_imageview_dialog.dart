import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class GemImageViewDialog {
  final String imagePath;

  GemImageViewDialog(BuildContext context, {required this.imagePath}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ContentViewDialog(contentPath: imagePath);
      },
    );
  }
}

class ContentViewDialog extends StatelessWidget {
  final String contentPath;

  const ContentViewDialog({Key? key, required this.contentPath}) : super(key: key);

  bool _isURL(String path) {
    Uri uri = Uri.tryParse(path) ?? Uri();
    return uri.isAbsolute && (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'));
  }

  bool _isPDF(String path) {
    return path.toLowerCase().endsWith('.pdf');
  }

  bool _isImage(String path) {
    return path.toLowerCase().endsWith('.jpg') ||
        path.toLowerCase().endsWith('.jpeg') ||
        path.toLowerCase().endsWith('.png') ||
        path.toLowerCase().endsWith('.gif');
  }

  Future<String> _downloadFile(String url, String filename) async {
    final http.Response response = await http.get(Uri.parse(url));
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/$filename');
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.only(left: 20, right: 20, top: 60),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isURL(contentPath))
                    _isPDF(contentPath)
                        ? FutureBuilder<String>(
                      future: _downloadFile(contentPath, 'downloaded.pdf'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return SvgPicture.asset('assets/mpartner/error.svg');
                          } else {
                            return _pdfViewWidget(context, snapshot.data!);
                          }
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    )
                        : _isImage(contentPath)
                        ? _networkImageViewWidget(context, contentPath)
                        : _launchURLWidget(context, contentPath)
                  else if (_isPDF(contentPath))
                    _pdfViewWidget(context, contentPath)
                  else if (_isImage(contentPath))
                      _imageViewWidget(context, contentPath)
                    else
                      SvgPicture.asset('assets/mpartner/error.svg'), // Default error view
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Icon(Icons.close),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

  Widget _launchURLWidget(BuildContext context, String url) {
    return Container(
      padding: EdgeInsets.all(20),
      child: InkWell(
        child: Text(
          url,
          style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
        ),
        onTap: () async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not launch URL')),
            );
          }
        },
      ),
    );
  }

  Widget _pdfViewWidget(BuildContext context, String pdfPath) {
    return Container(
      height: 500, // Set a fixed height for the PDF viewer
      child: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        onRender: (_pages) {
          // Handle render event if needed
        },
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
      ),
    );
  }

  Widget _imageViewWidget(BuildContext context, String imagePath) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: SingleChildScrollView(
        child: Image.file(
          File(imagePath),
          fit: BoxFit.fitWidth,
          errorBuilder: (context, error, stackTrace) =>
              SvgPicture.asset('assets/mpartner/error.svg'),
        ),
      ),
    );
  }

  Widget _networkImageViewWidget(BuildContext context, String imageUrl) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: SingleChildScrollView(
        child: Image.network(
          imageUrl,
          fit: BoxFit.fitWidth,
          errorBuilder: (context, error, stackTrace) =>
              SvgPicture.asset('assets/mpartner/error.svg'),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
