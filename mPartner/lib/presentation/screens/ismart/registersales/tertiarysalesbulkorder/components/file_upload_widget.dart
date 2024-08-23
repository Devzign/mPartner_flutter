import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

import '../../../../../../network/api_constants.dart';
import '../../../../../../state/contoller/auth_contoller.dart';
import '../../../../../../state/contoller/user_data_controller.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_constants.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../../../utils/requests.dart';
import '../../../../../../utils/utils.dart';

class FileUploadWidget extends StatefulWidget {
  final Function(bool, String) onFileUpload;
  final String title; final String fileType;
  const FileUploadWidget({super.key, required this.onFileUpload, required this.title, required this.fileType});

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  bool showError = false;
  String? _filePath;
  bool _isLoading = false;
  late Widget _pdfPreviewWidget;

  void checkFileTypeAndSize(FilePickerResult? result){
    var length = result?.files.first.size;
    var extention = result?.files.first.extension;
    if(length!=null && extention!= null){
      var lengthInMB = length / (1024 * 1024);
      if(extention == 'pdf' && lengthInMB <= AppConstants.maxUploadFileSize){
        setState(() {
          showError=false;
        });
      } else{
        setState(() {
          showError=true;
        });
        if(extention!='pdf' && lengthInMB > AppConstants.maxUploadFileSize){
          Utils().showToast('File extension must be .pdf and size must not exceed 5 MB.', context);
        }
        else if(extention!='pdf'){
          Utils().showToast('File extension must be .pdf.', context);
        }
        else if(lengthInMB > AppConstants.maxUploadFileSize) {
          Utils().showToast(translation(context).fileSizeError, context);
        }
      }
      if(lengthInMB < AppConstants.maxUploadFileSize && extention == 'pdf'){
        widget.onFileUpload(true, _filePath!);
      }else{
        widget.onFileUpload(false, _filePath!);
      }
    }
  }

  Future<Widget> getPdfPreview(String filePath) async {
    if(filePath.isPDFFileName){
    return PDFView(
      filePath: filePath,
      enableSwipe: false,
      swipeHorizontal: false,
      autoSpacing: false,
      pageFling: true,
      pageSnap: true,
      defaultPage: 0,
      fitPolicy: FitPolicy.WIDTH,
      onError: (error) {
        print("Error loading PDF: $error");
      },
      onPageError: (page, error) {
        print("$page: $error");
      },
    );
    }
    else {
      return const Center(child: Icon(Icons.error));
    }
  }

  Future<void> _uploadPDF(filePath) async {
    AuthController controller = Get.find();
    UserDataController userDataController = Get.find();
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.postTertiarySaleBulkPDFUploadEndPoint),
      );

      request.headers.addAll({
        "Authorization": "Bearer ${controller.accessToken}",
      });

      request.fields['FileName'] = "File1";
      request.fields['Channel'] = AppConstants.channel;
      request.fields['Device_Id'] = deviceId;
      request.fields['SapCode'] = userDataController.sapId;
      request.fields['User_Id'] = userDataController.sapId;
      request.fields['Os_Type'] = osType;
      request.fields['App_Version'] = AppConstants.appVersionName;
      request.fields['FileType'] = widget.fileType;
      request.files.add(
        await http.MultipartFile.fromPath(
          'File',
          filePath,
          contentType: MediaType('application', 'pdf'),
        ),
      );
      print('Request Body: ${request.fields}');

      final response = await request.send();
      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
       // _pdfPreviewWidget = await getPdfPreview(_filePath!);
      } else if (response.statusCode == 401 || response.statusCode == 406) {
        Requests.showLogoutBottomSheet();
      } else if (response.statusCode == 402) {
        Requests.showUpdateAlertDialog();
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<void> _selectAndUploadFile() async {
    setState(() {
      _isLoading = true;
    });

    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowCompression: false,
      );
      if (result != null) {
        _filePath = result.files.single.path;
        checkFileTypeAndSize(result);
        _uploadPDF(_filePath);
        
        _pdfPreviewWidget = await getPdfPreview(_filePath!);
        setState(() {
        _isLoading = false;
      });
    }
    else{
      setState(() {
        _isLoading=false;
      });
    }
    }catch(error){
      print('Error is $error');
    }

  }



  Widget _buildFilePreviewOrLoader(double variablePixelHeight, double variablePixelWidth,) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_filePath != null) {
      return Stack(
        children: [
          Container(height: 300 * variablePixelHeight,
            child:_pdfPreviewWidget,),
          Positioned(
                right: 24 * variablePixelWidth,
                top:24 * variablePixelHeight,
                child:  InkWell(
                    onTap: _selectAndUploadFile,
                    child:SvgPicture.asset('assets/mpartner/ismart/ic_edit_upload.svg',
                    width: 36 * variablePixelWidth,
                    fit: BoxFit.contain)),
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/mpartner/ismart/ic_cloud_upload.svg',
              color: AppColors.grayText,
              width: 56 * variablePixelWidth,
              fit: BoxFit.contain),
          SizedBox(height: 20*variablePixelHeight,),
          Text(
            widget.title,
            style: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.50),
          )
        ],
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    double variableTextFontMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();
    return
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 24 * variablePixelWidth,
                    right: 24 * variablePixelWidth,
                    bottom: 16 * variablePixelHeight),
                child: GestureDetector(
                  onTap: _selectAndUploadFile,
                  child: Container(
                    height: 160 * variablePixelHeight,
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: (showError)? 3 * variablePixelWidth : 1 * variablePixelWidth,
                            color: (showError)? AppColors.errorRed:AppColors.lightGrey1),
                        borderRadius: BorderRadius.circular(8*variablePixelMultiplier),
                      ),
                    ),
                    child:_buildFilePreviewOrLoader(variablePixelHeight, variablePixelWidth),
                  ),
                ),
              ),
            ],
          );
  }
}
