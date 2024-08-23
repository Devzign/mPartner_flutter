import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/utils.dart';
import '../../widgets/common_divider.dart';
import '../../widgets/verticalspace/vertical_space.dart';

showUploadBottomSheet(
  BuildContext context,
  String title,
  Function(String imagePath) onImageSelected, {
  bool? isAllowedPDFAndImage,
}) {
  String cameraPermission = translation(context).cameraPermission;
  String grantCameraAccess = translation(context).grantCameraAccess;
  String goTosettings = translation(context).goTosettings;
  String cancel = translation(context).cancel;
  String storagePermission = translation(context).storagePermission;
  String grantStorageAccess = translation(context).grantStorageAccess;

  double variablePixelHeight =
      DisplayMethods(context: context).getVariablePixelHeight();
  double variablePixelWidth =
      DisplayMethods(context: context).getVariablePixelWidth();
  double pixelMultiplier =
      DisplayMethods(context: context).getPixelMultiplier();
  double textMultiplier =
      DisplayMethods(context: context).getTextFontMultiplier();

  void callSettingDialogStorage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.lightWhite1,
          title: Text(
            storagePermission,
            style: GoogleFonts.poppins(
              color: AppColors.titleColor,
              fontSize: 20 * textMultiplier,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.50 * variablePixelWidth,
            ),
          ),
          content: Text(grantStorageAccess,
              style: GoogleFonts.poppins(
                fontSize: 14 * textMultiplier,
              )),
          actions: <Widget>[
            ElevatedButton(
              child: Text(goTosettings,
                  style: GoogleFonts.poppins(color: AppColors.lumiBluePrimary)),
              onPressed: () async {
                Navigator.of(context).pop();
                bool isPermissionGranted = await openAppSettings();
              },
            ),
            ElevatedButton(
              child: Text(cancel,
                  style: GoogleFonts.poppins(color: AppColors.errorRed)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void callSettingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.lightWhite1,
          title: Text(
            cameraPermission,
            style: GoogleFonts.poppins(
              color: AppColors.titleColor,
              fontSize: 20 * textMultiplier,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.50 * variablePixelWidth,
            ),
          ),
          content: Text(grantCameraAccess,
              style: GoogleFonts.poppins(
                fontSize: 14 * textMultiplier,
              )),
          actions: <Widget>[
            ElevatedButton(
              child: Text(goTosettings,
                  style: GoogleFonts.poppins(color: AppColors.lumiBluePrimary)),
              onPressed: () async {
                Navigator.of(context).pop();
                bool isPermissionGranted = await openAppSettings();
              },
            ),
            ElevatedButton(
              child: Text(cancel,
                  style: GoogleFonts.poppins(color: AppColors.errorRed)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<XFile?> _takePhoto() async {
    final picker = ImagePicker();
    try {
      // Pick image from the camera
      final XFile? image = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: AppConstants.imageCompressPercentage,
          maxHeight: AppConstants.imageMaxHeight,
          maxWidth: AppConstants.imageMaxWidth);
      return image;
    } catch (e) {
      print("Error taking photo: $e");
      return null;
    }
  }

  void fetchImage(BuildContext context) async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isGranted) {
      Navigator.of(context).pop();
      XFile? image = await _takePhoto();
      if (image != null) {
        onImageSelected(image.path);
      }
    } else if (status.isDenied) {
      Navigator.of(context).pop();
      await Permission.camera.request();
      PermissionStatus status = await Permission.camera.status;
      if (status.isGranted) {
        XFile? image = await _takePhoto();
        if (image != null) {
          onImageSelected(image.path);
        }
      }
    } else if (status.isPermanentlyDenied) {
      Navigator.of(context).pop();
      callSettingDialog(context);
    }
  }

  bool isImageMimeTypeAllowed(String filePath) {
    final allowedMimeTypes = ['image/jpeg', 'image/png', 'image/jpg'];
    final mimeType = lookupMimeType(filePath);

    return mimeType != null && allowedMimeTypes.contains(mimeType);
  }

  bool isFileMimeTypeAllowed(String filePath) {
    final allowedMimeTypes = ['jpeg', 'png', 'jpg', 'pdf'];
    final mimeType = filePath.split(".").last;
    return mimeType != null && allowedMimeTypes.contains(mimeType);
  }

  bool? checkFileSize(FilePickerResult? result) {
    var length = result?.files.first.size;
    var extention = result?.files.first.extension;
    if (length != null && extention != null) {
      var lengthInMB = length / (1024 * 1024);
      if (extention == 'pdf' && lengthInMB <= AppConstants.maxUploadFileSize) {
        return false;
      } else {
        if (lengthInMB > AppConstants.maxUploadFileSize) {
          Utils().showToast(translation(context).fileSizeError, context);
          return true;
        } else {
          return false;
        }
      }
    }
    return true;
  }

  Future<XFile?> pickImageFromGallery() async {
    if (isAllowedPDFAndImage ?? false) {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
          allowCompression: false,
        );
        if (result != null) {
          String filePath = result.files.single.path ?? "";
          bool? isShowError = checkFileSize(result);
          XFile? file = XFile(filePath);
          if (!isShowError!) {
            if (isFileMimeTypeAllowed(filePath)) {
              return file;
            } else {
              Utils().showToast(translation(context).invalidFileType, context);
              return null;
            }
          }
        }
        return null;
      } catch (error) {
        print("Error picking file : $error");
        callSettingDialogStorage(context);
      }
    } else {
      final picker = ImagePicker();
      try {
        final XFile? image = await picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: AppConstants.imageCompressPercentage,
            maxHeight: AppConstants.imageMaxHeight,
            maxWidth: AppConstants.imageMaxWidth);

        if (image != null) {
          // Check if the selected file type is allowed (JPEG, PNG, or JPG) based on MIME type
          if (isImageMimeTypeAllowed(image.path)) {
            return image;
          } else {
            Utils().showToast(translation(context).invalidFileType, context);
            return null;
          }
        }
        return null;
      } catch (e) {
        print("Error picking image from gallery: $e");
        callSettingDialogStorage(context);
        return null;
      }
    }
    return null;
  }

  void fetchImageFromGallery(BuildContext context) async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    PermissionStatus status = android.version.sdkInt < 33
        ? await Permission.storage.status
        : await Permission.photos.status;

    if (status.isGranted) {
      Navigator.of(context).pop();
      XFile? image = await pickImageFromGallery();
      if (image != null) {
        onImageSelected(image.path);
      }
    } else if (status.isDenied) {
      Navigator.of(context).pop();
      android.version.sdkInt < 33
          ? await Permission.storage.request()
          : await Permission.photos.request();
      PermissionStatus status = android.version.sdkInt < 33
          ? await Permission.storage.status
          : await Permission.photos.status;
      if (status.isGranted) {
        XFile? image = await pickImageFromGallery();
        if (image != null) {
          onImageSelected(image.path);
        }
      }
    } else if (status.isPermanentlyDenied) {
      Navigator.of(context).pop();
      callSettingDialogStorage(context);
    }
  }

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VerticalSpace(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Center(
              child: Container(
                height: 5 * variablePixelHeight,
                width: 50 * variablePixelWidth,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12 * pixelMultiplier),
                ),
              ),
            ),
          ),
          const VerticalSpace(height: 16),
          Container(
            margin: EdgeInsets.only(
                left: 10.0 * variablePixelWidth,
                right: 24 * variablePixelWidth),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 28 * pixelMultiplier,
              ),
            ),
          ),
          const VerticalSpace(height: 12),
          Container(
            margin: EdgeInsets.only(
                left: 24.0 * variablePixelWidth,
                right: 24 * variablePixelWidth),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: AppColors.titleColor,
                fontSize: 20 * textMultiplier,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.50 * variablePixelWidth,
              ),
            ),
          ),
          const VerticalSpace(height: 16),
          Container(
            margin: EdgeInsets.only(
                left: 24.0 * variablePixelWidth,
                right: 24 * variablePixelWidth),
            child: const CustomDivider(color: AppColors.dividerColor),
          ),
          Container(
            margin: EdgeInsets.only(
                left: 10.0 * variablePixelWidth,
                right: 24 * variablePixelWidth),
            child: ListTile(
              title: Text(
                translation(context).camera,
                style: GoogleFonts.poppins(
                  color: AppColors.titleColor,
                  fontSize: 16 * textMultiplier,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.50 * variablePixelWidth,
                ),
              ),
              onTap: () async {
                fetchImage(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: 10.0 * variablePixelWidth,
                right: 24 * variablePixelWidth),
            child: ListTile(
              title: Text(
                translation(context).chooseFiles,
                style: GoogleFonts.poppins(
                  color: AppColors.titleColor,
                  fontSize: 16 * textMultiplier,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.50 * variablePixelWidth,
                ),
              ),
              onTap: () async {
                if (Platform.isIOS) {
                  Navigator.pop(context);
                  // Open gallery to pick an image
                  XFile? image = await pickImageFromGallery();
                  if (image != null) {
                    onImageSelected(image.path);
                  }
                } else {
                  fetchImageFromGallery(context);
                }
              },
            ),
          ),
          const VerticalSpace(height: 24),
        ],
      );
    },
  );
}
