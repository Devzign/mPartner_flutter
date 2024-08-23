import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../data/models/get_alert_notification_model.dart';
import '../../state/contoller/alert_notification_controller.dart';
import '../../utils/displaymethods/display_methods.dart';
import '../../utils/app_colors.dart';
import '../../state/contoller/read_check_alert_notification_controller.dart';
import '../../state/contoller/survey_question_controller.dart';
import '../../state/contoller/user_data_controller.dart';

class PopUp extends StatefulWidget {
  final int id;
  final String text;
  final bool isread;
  final String imagename;
  final String imagepath;
  final String date;
  final ImageType type;
  final int show_flag;
  final bool isLastPopUp;
  final void Function() checkToShowSurveyForm;
  String filePathAndName;

  PopUp({
    required this.id,
    required this.text,
    required this.isread,
    required this.imagename,
    required this.imagepath,
    required this.date,
    required this.type,
    required this.show_flag,
    required this.isLastPopUp,
    required this.checkToShowSurveyForm,
    required this.filePathAndName
  });

  @override
  State<PopUp> createState() =>
      _PopUpState();
}

class _PopUpState extends State<PopUp> {
  UserDataController controller = Get.find();
  ReadCheckAlertNotificationController readCheckAlertNotificationController = Get.find();
  SurveyQuestionsController surveyQuestionsController = Get.find();
  AlertNotificationController _alertNotificationController = Get.find();
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    if (widget.type == ImageType.video) {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(
          widget.imagepath,
        ),
      );
      _initializeVideoPlayerFuture = _videoController.initialize();
      _videoController.setLooping(true);
      _videoController.play();
    }
  }

  @override
  void dispose() {
    if (widget.type == ImageType.video) {
      _videoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Dialog(
      backgroundColor: AppColors.transparent,
      insetPadding: EdgeInsets.symmetric(
          horizontal: 24 * w,
          vertical: 24 * h
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  readCheckAlertNotificationController.fetchReadCheckAlertNotification(widget.id.toString());
                  Navigator.of(context).pop();
                  if (widget.isLastPopUp == true ) {
                    if (controller.isSurveyFormAppeared != true && surveyQuestionsController.showSurveyForm == true) {
                      widget.checkToShowSurveyForm();
                    }
                  }
                  if (widget.type == ImageType.image && widget.filePathAndName.isNotEmpty) {
                    File(widget.filePathAndName).delete();
                    _alertNotificationController.removeFilePath(widget.filePathAndName);
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 12 * w,
                      vertical: 10 * h
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 1 * w,
                      vertical: 1 * h
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreyOval,
                    borderRadius: BorderRadius.circular(4.0 * r),
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColors.darkGreyText,
                    size: 28 * r,
                  ),
                ),
              ),
            ),
          ),
          AlertDialog(
            backgroundColor: AppColors.white,
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12 * r),
            ),
            content: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topRight,
              children: [
                if (widget.type == ImageType.image)
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.85,
                      maxWidth: MediaQuery.of(context).size.width * 0.95,
                      minWidth: MediaQuery.of(context).size.width * 0.85,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12 * r),
                      child: widget.filePathAndName != ""
                          ? FutureBuilder<bool>(
                        future: File(widget.filePathAndName).exists(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.data == true) {
                              return Image.file(
                                File(widget.filePathAndName),
                                fit: BoxFit.fill,
                              );
                            } else {
                              return Image.network(
                                fit: BoxFit.fill,
                                widget.imagepath,
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Container(
                                      height: 193 * h,
                                      width: MediaQuery.of(context).size.width * 0.95,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                              : null,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            }
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      )
                          : Image.network(
                        fit: BoxFit.fill,
                        widget.imagepath,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Container(
                              height: 193 * h,
                              width: MediaQuery.of(context).size.width * 0.95,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                if (widget.type == ImageType.video)
                  FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.85,
                            maxWidth: MediaQuery.of(context).size.width * 0.95,
                            minWidth: MediaQuery.of(context).size.width * 0.85,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12 * r),
                            child: AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          height: 193 * h,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Center(
                              child: CircularProgressIndicator()
                          ),
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


