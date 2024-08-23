import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../state/contoller/luminous_videos_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';

class PromotionalVideos extends StatefulWidget {
  PromotionalVideos({super.key, this.videoId = '-1'});

  String videoId;

  @override
  State<PromotionalVideos> createState() => _PromotionalVideos();
}

class _PromotionalVideos extends State<PromotionalVideos> {
  LuminousVideosController luminousVideosController = Get.find();
  YoutubePlayerController? _playerController;
  double variablePixelHeight = 0;
  double variablePixelWidth = 0;
  double textFontMultiplier = 0;
  double pixelMultiplier = 0;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;
  late BuildContext parentContext;

  @override
  void initState() {
    luminousVideosController.fetchLuminousVideos();
    luminousVideosController.fetchChannelIcon();
    _playerController?.addListener(_onPlayerControllerChange);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    if (widget.videoId != "-1") {
      _playVideo(widget.videoId);
    }
    super.initState();
  }

  @override
  void deactivate() {
    _playerController?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _playerController?.dispose();
    super.dispose();
  }

  void _onPlayerControllerChange() {
    if (_isPlayerReady && mounted && !_playerController!.value.isFullScreen) {
      setState(() {
        _playerState = _playerController!.value.playerState;
        _videoMetaData = _playerController!.metadata;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    parentContext = context;
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return Scaffold(
      backgroundColor: AppColors.lightWhite1,
      body: Container(
        child: Column(
          children: [
            Obx(
              () => luminousVideosController.isLoading.value
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                  : Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: luminousVideosController
                              .luminousVideosList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Column(
                                children: [
                                  if (index > 0)
                                    SizedBox(height: 16 * variablePixelHeight),
                                  InkWell(
                                    onTap: () {
                                      _playVideo(luminousVideosController
                                          .luminousVideosList[index].videoId);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return PopScope(
                                            onPopInvoked: (val) {
                                              SystemChrome
                                                  .setEnabledSystemUIMode(
                                                      SystemUiMode.manual,
                                                      overlays: SystemUiOverlay
                                                          .values);
                                            },
                                            child: OrientationBuilder(
                                              builder: (context, orientation) {
                                                return Dialog(
                                                  shadowColor:
                                                      Colors.transparent,
                                                  insetPadding: EdgeInsets.zero,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Padding(
                                                    padding: orientation ==
                                                            Orientation.portrait
                                                        ? EdgeInsets.fromLTRB(
                                                            0,
                                                            270 *
                                                                variablePixelHeight,
                                                            0,
                                                            0)
                                                        : EdgeInsets.zero,
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                            child: _playerController !=
                                                                    null
                                                                ? _buildVideoPlayer()
                                                                : Container()),
                                                        Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          child: Container(
                                                            child: IconButton(
                                                              iconSize: 24,
                                                              color: AppColors
                                                                  .lightWhite1,
                                                              icon: const Icon(
                                                                  Icons.close),
                                                              onPressed: () {
                                                                SystemChrome.setEnabledSystemUIMode(
                                                                    SystemUiMode
                                                                        .manual,
                                                                    overlays:
                                                                        SystemUiOverlay
                                                                            .values);
                                                                SystemChrome
                                                                    .setPreferredOrientations([
                                                                  DeviceOrientation
                                                                      .portraitUp,
                                                                  DeviceOrientation
                                                                      .portraitDown
                                                                ]);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 345 * variablePixelWidth,
                                      height: 140 * variablePixelHeight,
                                      decoration: ShapeDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              luminousVideosController
                                                  .luminousVideosList[index]
                                                  .thumbnail),
                                          fit: BoxFit.cover,
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8 * pixelMultiplier)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16 * variablePixelHeight,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        24 * variablePixelWidth,
                                        0,
                                        24 * variablePixelWidth,
                                        0),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                GetBuilder<
                                                    LuminousVideosController>(
                                                  builder: (_) {
                                                    return CircleAvatar(
                                                      radius:
                                                          16 * pixelMultiplier,
                                                      backgroundColor:
                                                          AppColors.lightWhite1,
                                                      backgroundImage: NetworkImage(
                                                          luminousVideosController
                                                              .youtubeChannelIconUrl
                                                              .value),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 11 * variablePixelWidth,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Wrap(
                                                  children: [
                                                    Container(
                                                      width: 300 *
                                                          variablePixelWidth,
                                                      child: Text(
                                                        luminousVideosController
                                                            .luminousVideosList[
                                                                index]
                                                            .title,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: AppColors
                                                              .darkGreyText,
                                                          fontSize: 14 *
                                                              textFontMultiplier,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8 * variablePixelHeight,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              25 * variablePixelWidth, 0, 0, 0),
                                          child: Container(
                                            width: 302 * variablePixelWidth,
                                            child: Wrap(
                                              spacing: 8,
                                              children: [
                                                ..._buildTagWidgets(
                                                  luminousVideosController
                                                      .luminousVideosList[index]
                                                      .description,
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: 7 *
                                                          variablePixelWidth,
                                                    ),
                                                    Container(
                                                      width: 4 *
                                                          variablePixelWidth,
                                                      height: 4 *
                                                          variablePixelHeight,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration:
                                                          ShapeDecoration(
                                                        color: AppColors
                                                            .lightGreyOval,
                                                        shape: CircleBorder(),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 7 *
                                                          variablePixelWidth,
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        child: Text(
                                                          '${luminousVideosController.luminousVideosList[index].viewCount} views',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: AppColors
                                                                .darkGreyText,
                                                            fontSize: 12 *
                                                                pixelMultiplier,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16 * variablePixelHeight,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        24 * variablePixelWidth,
                                        0,
                                        24 * variablePixelWidth,
                                        0),
                                    child: Divider(
                                      thickness: 1 * variablePixelHeight,
                                      color: AppColors.lightGrey2,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTagWidgets(String description) {
    final RegExp regex = RegExp(r'#(\w+)');
    Iterable<RegExpMatch> matches = regex.allMatches(description);
    List<String?> tags = matches.map((match) => match.group(1)).toList();
    List<Widget> tagWidgets = tags.map((tag) {
      return Text(
        '#$tag',
        style: GoogleFonts.poppins(
          color: AppColors.darkGreyText,
          fontSize: 12 * textFontMultiplier,
          fontWeight: FontWeight.w400,
          height: 0,
        ),
      );
    }).toList();

    return tagWidgets;
  }

  void _playVideo(String videoId) {
    setState(() {
      _playerController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
          showLiveFullscreenButton: false,
        ),
      );
    });
  }

  Widget _buildVideoPlayer() {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller:
            _playerController ?? YoutubePlayerController(initialVideoId: ''),
        // Use null-aware operator
        showVideoProgressIndicator: true,
        onReady: () {
          _playerController?.addListener(_onPlayerControllerChange);
          _isPlayerReady = true;
        },
        onEnded: (value) {
          _playerController?.seekTo(const Duration(seconds: 0));
          _playerController?.pause();
        },
        progressIndicatorColor: Colors.blueAccent,
      ),
      builder: (context, player) {
        return Column(
          children: [
            player,
          ],
        );
      },
    );
  }
}
