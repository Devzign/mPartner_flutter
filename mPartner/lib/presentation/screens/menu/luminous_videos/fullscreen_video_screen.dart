import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';

class FullScreenVideoScreen extends StatefulWidget {
  final String videoId;
  final YoutubePlayerController playerController;

  const FullScreenVideoScreen(
      {super.key, required this.videoId, required this.playerController});

  @override
  State<FullScreenVideoScreen> createState() => _FullScreenVideoScreen();
}

class _FullScreenVideoScreen extends State<FullScreenVideoScreen> {
  final Key myKey = UniqueKey();
  late BuildContext _parentContext;
  bool _isPlayerReady = false;
  late YoutubePlayerController _playerController;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double variablePixelHeight = 0;
  double variablePixelWidth = 0;
  double textFontMultiplier = 0;
  double pixelMultiplier = 0;

  @override
  void initState() {
    _playerController = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
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
    _playerController.addListener(_onPlayerControllerChange);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    super.initState();
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _playerController.pause();
    super.deactivate();
  }

  //
  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  void _onPlayerControllerChange() {
    if (_isPlayerReady && mounted && !_playerController.value.isFullScreen) {
      setState(() {
        _playerState = _playerController.value.playerState;
        _videoMetaData = _playerController.metadata;
      });
    }
  }

  void _enterFullScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _parentContext = context;
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 0,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Container(
                    child: YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: _playerController ??
                            YoutubePlayerController(
                              initialVideoId: '8F4vSXqQnAQ',
                            ),
                        showVideoProgressIndicator: true,
                        onReady: () {
                          _playerController
                              .addListener(_onPlayerControllerChange);
                          _isPlayerReady = true;
                        },
                        onEnded: (value) {
                          _playerController.seekTo(const Duration(seconds: 0));
                          _playerController.pause();
                        },
                        progressIndicatorColor: AppColors.lumiBluePrimary,
                      ),
                      builder: (context, player) {
                        return Column(
                          children: [
                            player,
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: IconButton(
                  iconSize: 35*pixelMultiplier,
                  color: AppColors.lightWhite1,
                  icon: Icon(Icons.fullscreen_exit),
                  onPressed: () {
                    if (_isPlayerReady &&
                        !_playerController.value.isFullScreen) {
                      _enterFullScreen();
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }
}
