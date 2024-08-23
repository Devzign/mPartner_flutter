import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../widgets/horizontalspace/horizontal_space.dart';
import '../../widgets/verticalspace/vertical_space.dart';
import 'display_ads_template_image_screen.dart';
import 'providers/selected_text_overlay.dart';
import 'providers/text_overlay_provider.dart';
import 'widgets/alignment_tab.dart';
import 'widgets/casing_tab.dart';
import 'widgets/colors_tab.dart';
import 'widgets/discard_edit_alert.dart';
import 'widgets/styling_tab.dart';
import 'widgets/textoverlay_widget.dart';

enum SelectedTab { Colors, Styling, Alignment, Casing }

class AdsEditorScreen extends ConsumerStatefulWidget {
  const AdsEditorScreen({this.imageUrl, this.image, super.key});

  final String? imageUrl;
  final Uint8List? image;

  @override
  ConsumerState<AdsEditorScreen> createState() => _ImageEditScreenState();
}

class _ImageEditScreenState extends ConsumerState<AdsEditorScreen> {
  final globalKey = GlobalKey();
  SelectedTab? selectedTab;
  final screenshotController = ScreenshotController();
  double _height = 0.0;
  double _width = 0.0;
  double finalAngle = 0.0;

  Widget _getSelectedTabContent() {
    var selectedTextProvider = ref.watch(selectedTextOverlayProvider);
    if (selectedTextProvider.id != '') {
      switch (selectedTab) {
        case SelectedTab.Colors:
          return ColorTab();
        case SelectedTab.Styling:
          return StyleTab();
        case SelectedTab.Alignment:
          return AlignmentTab();
        case SelectedTab.Casing:
          return CasingTab();
        default:
          return Container();
      }
    }
    return Container();
  }

  void addText() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    _height = 50.0 * variablePixelHeight;
    _width = 130.0 * variablePixelWidth;
    TextOverlayWidget newText = TextOverlayWidget(
      charMultiplier: translation(context).addText.length,
      id: const Uuid().v4(),
      height: _height,
      width: _width,
      angle: 0,
      text: translation(context).addText,
      offset: Offset(screenWidth / 4, screenHeight / 1.6),
      color: AppColors.white,
      alignment: TextAlign.left,
      fontSize: 20 * textMultiplier,
      screenHeight: screenHeight,
      screenWidth: screenWidth,
      isSelected: true,
    );
    setState(() {
      var textListProvider = ref.watch(textOverlayListProvider.notifier);
      textListProvider.deselectAll();
      ref.read(selectedTextOverlayProvider.notifier).state = newText;
      ref.read(textOverlayListProvider.notifier).addText(newText);
    });
  }

  void _duplicateWidget() {
    var textListProvider = ref.watch(textOverlayListProvider.notifier);
    var selectedTextProvider = ref.watch(selectedTextOverlayProvider);

    if (selectedTextProvider.id == '') return;
    TextOverlayWidget duplicatedWidget = TextOverlayWidget(
        charMultiplier: selectedTextProvider.charMultiplier,
        id: const Uuid().v4(),
        text: selectedTextProvider.text,
        offset: Offset(MediaQuery.of(context).size.width / 4,
            MediaQuery.of(context).size.height / 1.6),
        bold: selectedTextProvider.bold,
        italic: selectedTextProvider.italic,
        underline: selectedTextProvider.underline,
        alignment: selectedTextProvider.alignment,
        fontSize: selectedTextProvider.fontSize,
        color: selectedTextProvider.color,
        casing: selectedTextProvider.casing,
        screenHeight: selectedTextProvider.screenHeight,
        screenWidth: selectedTextProvider.screenWidth,
        isSelected: selectedTextProvider.isSelected,
        angle: selectedTextProvider.angle,
        height: selectedTextProvider.height,
        width: selectedTextProvider.width);

    setState(() {
      textListProvider.addText(duplicatedWidget);
      textListProvider.deselectAll();
      ref.watch(selectedTextOverlayProvider.notifier).state = duplicatedWidget;
    });
  }

  @override
  void initState() {
    Future.microtask(() {
      ref.read(selectedTextOverlayProvider.notifier).state = TextOverlayWidget(
          charMultiplier: 1,
          height: 0,
          width: 0,
          angle: 0,
          id: '',
          text: '',
          offset: const Offset(0, 0),
          fontSize: 0,
          color: AppColors.white,
          screenHeight: 0,
          screenWidth: 0,
          isSelected: false);
      var textListProvider = ref.watch(textOverlayListProvider.notifier);
      textListProvider.resetList();
    });
    super.initState();
  }

  void _deleteWidget(TextOverlayWidget overlay) {
    var textListProvider = ref.watch(textOverlayListProvider.notifier);
    int idx = textListProvider.findIndexOfOverlayWithId(overlay.id);
    setState(
      () {
        textListProvider.deleteAtIndex(idx);

        ref.read(selectedTextOverlayProvider.notifier).state =
            TextOverlayWidget(
                charMultiplier: 1,
                height: 0,
                width: 0,
                angle: 0,
                id: '',
                text: '',
                offset: const Offset(0, 0),
                fontSize: 0,
                color: AppColors.white,
                screenHeight: 0,
                screenWidth: 0,
                isSelected: false);
        selectedTab = null;
      },
    );
  }

  void _rotateAngle(BoxConstraints constraints, DragUpdateDetails details) {
    var textListProvider = ref.watch(textOverlayListProvider.notifier);
    var selectedTextProvider = ref.watch(selectedTextOverlayProvider);
    int idx =
        textListProvider.findIndexOfOverlayWithId(selectedTextProvider.id);
    Offset centerOfGestureDetector =
        Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
    final touchPositionFromCenter =
        details.localPosition - centerOfGestureDetector;
    double angleInDegrees = touchPositionFromCenter.direction * 180 / pi;
    const double sensitivity = 15.0;
    double quantizedAngle =
        (angleInDegrees / sensitivity).round() * sensitivity;
    setState(
      () {
        finalAngle = quantizedAngle * pi / 180;
        textListProvider.changeAngle(idx, finalAngle);
      },
    );
  }

  void dragWidget(DraggableDetails details, BoxConstraints constraints,
      TextOverlayWidget overlay) {
    var textListProvider = ref.watch(textOverlayListProvider.notifier);
    var selectedTextProvider = ref.watch(selectedTextOverlayProvider);
    int idx =
        textListProvider.findIndexOfOverlayWithId(selectedTextProvider.id);
    Offset newOffset = Offset(
        details.offset.dx,
        details.offset.dy -
            MediaQuery.of(context).padding.top -
            80 * DisplayMethods(context: context).getTextFontMultiplier());
    setState(() {
      textListProvider.updateOffset(idx, newOffset);
      overlay.offset = newOffset;
    });
  }

  void resizeTextBox(TextOverlayWidget overlay, DragUpdateDetails details) {
    var textListProvider = ref.watch(textOverlayListProvider.notifier);
    var selectedTextProvider = ref.watch(selectedTextOverlayProvider);
    int idx =
        textListProvider.findIndexOfOverlayWithId(selectedTextProvider.id);

    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    _height = selectedTextProvider.height;
    _width = selectedTextProvider.width;
    setState(() {
      _width += details.delta.dx * variablePixelWidth;
      _height += details.delta.dy * variablePixelHeight;

      double fontSizeChange = details.delta.dy * 1;

      double newFontSize = overlay.fontSize + fontSizeChange;
      if (newFontSize < 15 * textMultiplier) {
        newFontSize = 15 * textMultiplier;
      }

      if (newFontSize > 60 * textMultiplier) {
        newFontSize = 60 * textMultiplier;
      }

      if (_width < 100 * variablePixelWidth) {
        _width = 100 * variablePixelWidth;
      }

      if (_height < 50 * variablePixelHeight) {
        _height = 50 * variablePixelHeight;
      }

      textListProvider.changeFontSize(idx, newFontSize);
      ref.read(selectedTextOverlayProvider.notifier).state =
          textListProvider.getList()[idx];
    });
  }

  @override
  Widget build(BuildContext context) {
    var selectedTextProvider = ref.watch(selectedTextOverlayProvider);
    var textListProvider = ref.watch(textOverlayListProvider.notifier);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    return WillPopScope(
      onWillPop: () async {
        if (textListProvider.getList().isNotEmpty) {
          showDiscardEditsAlert(context, variablePixelHeight,
              variablePixelWidth, pixelMultiplier, textMultiplier);
        } else {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    width: screenWidth,
                    padding: EdgeInsets.symmetric(
                        horizontal: 24 * variablePixelWidth,
                        vertical: 8 * variablePixelHeight),
                    decoration:
                        const BoxDecoration(color: AppColors.lumiDarkBlack),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            var textListProvider =
                                ref.watch(textOverlayListProvider.notifier);
                            if (textListProvider.getList().isNotEmpty) {
                              showDiscardEditsAlert(
                                  context,
                                  variablePixelHeight,
                                  variablePixelWidth,
                                  pixelMultiplier,
                                  textMultiplier);
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: SizedBox(
                            width: 32 * variablePixelWidth,
                            height: 32 * variablePixelHeight,
                            child: const Icon(Icons.close,
                                color: AppColors.lightWhite),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _duplicateWidget();
                          },
                          child: SizedBox(
                            width: 28 * variablePixelWidth,
                            height: 28 * variablePixelHeight,
                            child: const Icon(
                              Icons.content_copy,
                              color: AppColors.lightWhite,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            var textListProvider =
                                ref.watch(textOverlayListProvider.notifier);
                            setState(() {
                              textListProvider.deselectAll();
                            });
                            await screenshotController.capture().then(
                                  (image) =>
                                      Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => DisplayAdsImageScreen(
                                        image: image,
                                      ),
                                    ),
                                  ),
                                );
                          },
                          child: SizedBox(
                            width: 32 * variablePixelWidth,
                            height: 32 * variablePixelHeight,
                            child: const Icon(Icons.check,
                                color: AppColors.lightWhite),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top:
                  MediaQuery.of(context).padding.top + 48 * variablePixelHeight,
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 5,
                panEnabled: false,
                child: Screenshot(
                  controller: screenshotController,
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  var textListProvider = ref
                                      .watch(textOverlayListProvider.notifier);
                                  var selectedTextProvider =
                                      ref.watch(selectedTextOverlayProvider);
                                  int idx =
                                      textListProvider.findIndexOfOverlayWithId(
                                          selectedTextProvider.id);
                                  setState(() {
                                    textListProvider.changeSelectstatus(
                                        idx, false);
                                  });
                                  textListProvider.deselectAll();
                                  ref
                                          .read(selectedTextOverlayProvider
                                              .notifier)
                                          .state =
                                      TextOverlayWidget(
                                          charMultiplier: 1,
                                          height: 0,
                                          width: 0,
                                          angle: 0,
                                          id: '',
                                          text: '',
                                          offset: const Offset(0, 0),
                                          alignment: TextAlign.left,
                                          fontSize: 0,
                                          color: AppColors.white,
                                          screenHeight: 0,
                                          screenWidth: 0,
                                          isSelected: false);
                                  selectedTab = null;
                                },
                                child: SizedBox(
                                    width: screenWidth,
                                    height: screenHeight -
                                        (180) * variablePixelHeight,
                                    child: (widget.image != null)
                                        ? Image.memory(
                                            widget.image!,
                                            fit: BoxFit.contain,
                                          )
                                        : Image.network(widget.imageUrl!,
                                            fit: BoxFit.contain))),
                            for (var overlay in textListProvider.getList())
                              Positioned(
                                left: overlay.offset.dx,
                                top: overlay.offset.dy,
                                child: Transform.rotate(
                                  angle: overlay.angle,
                                  child: GestureDetector(
                                    onTap: () {
                                      var textListProvider = ref.watch(
                                          textOverlayListProvider.notifier);

                                      ref
                                          .read(selectedTextOverlayProvider
                                              .notifier)
                                          .state = overlay;
                                      var selectedTextProvider = ref
                                          .watch(selectedTextOverlayProvider);
                                      int idx = textListProvider
                                          .findIndexOfOverlayWithId(
                                              selectedTextProvider.id);
                                      setState(() {
                                        textListProvider.changeSelectstatus(
                                            idx, true);
                                      });
                                      ref
                                              .read(selectedTextOverlayProvider
                                                  .notifier)
                                              .state =
                                          textListProvider.getList()[idx];
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Flex(
                                          clipBehavior: Clip.antiAlias,
                                          direction: Axis.horizontal,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            (overlay.isSelected)
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors.white,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            AppColors.grayText,
                                                        width: 0.3,
                                                      ),
                                                    ),
                                                    width:
                                                        24 * variablePixelWidth,
                                                    height: 24 *
                                                        variablePixelHeight,
                                                    child: LayoutBuilder(
                                                      builder: (context,
                                                          constraints) {
                                                        return GestureDetector(
                                                          behavior:
                                                              HitTestBehavior
                                                                  .translucent,
                                                          onTap: () =>
                                                              _deleteWidget(
                                                                  overlay),
                                                          child: Icon(
                                                            Icons.close,
                                                            color: AppColors
                                                                .grayText,
                                                            size: 12 *
                                                                pixelMultiplier,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Container(),
                                            HorizontalSpace(
                                                width: (overlay.fontSize / 20) *
                                                    overlay.charMultiplier *
                                                    5),
                                            (overlay.isSelected)
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors.white,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: AppColors
                                                              .grayText,
                                                          width: 0.3),
                                                    ),
                                                    width:
                                                        24 * variablePixelWidth,
                                                    height: 24 *
                                                        variablePixelHeight,
                                                    child: LayoutBuilder(
                                                      builder: (context,
                                                          constraints) {
                                                        return GestureDetector(
                                                          behavior:
                                                              HitTestBehavior
                                                                  .translucent,
                                                          onPanUpdate:
                                                              (details) =>
                                                                  _rotateAngle(
                                                                      constraints,
                                                                      details),
                                                          child: Icon(
                                                            Icons
                                                                .rotate_right_outlined,
                                                            color: AppColors
                                                                .grayText,
                                                            size: 12 *
                                                                pixelMultiplier,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Container(),
                                            Container(),
                                          ],
                                        ),
                                        Container(
                                          constraints: BoxConstraints(
                                              minHeight:
                                                  50 * variablePixelHeight,
                                              minWidth:
                                                  100 * variablePixelWidth,
                                              maxWidth: screenWidth * 0.9,
                                              maxHeight: screenHeight * 0.9),
                                          // height: overlay.height,
                                          // width: overlay.width,
                                          padding: EdgeInsets.fromLTRB(
                                              4 * variablePixelWidth,
                                              4 * variablePixelHeight,
                                              4 * variablePixelWidth,
                                              4 * variablePixelHeight),
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return Draggable(
                                                feedback: overlay,
                                                childWhenDragging: overlay,
                                                onDragEnd: (details) =>
                                                    dragWidget(details,
                                                        constraints, overlay),
                                                child: overlay,
                                              );
                                            },
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            (overlay.isSelected)
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors.white,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            AppColors.grayText,
                                                        width: 0.3 *
                                                            pixelMultiplier,
                                                      ),
                                                    ),
                                                    width:
                                                        24 * variablePixelWidth,
                                                    height: 24 *
                                                        variablePixelHeight,
                                                    child: LayoutBuilder(
                                                      builder: (context,
                                                          constraints) {
                                                        return GestureDetector(
                                                            behavior:
                                                                HitTestBehavior
                                                                    .translucent,
                                                            onPanUpdate:
                                                                (details) =>
                                                                    resizeTextBox(
                                                                        overlay,
                                                                        details),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .all(6.0 *
                                                                      pixelMultiplier),
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/mpartner/open_in_full.svg',
                                                                color: AppColors
                                                                    .grayText,
                                                              ),
                                                            ));
                                                      },
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 100 * variablePixelHeight,
              child: _getSelectedTabContent(),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: AppColors.white,
                alignment: Alignment.center,
                width: screenWidth,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12 * variablePixelWidth,
                          vertical: 20 * variablePixelHeight),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              addText();
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2 * variablePixelHeight,
                                      vertical: 2 * variablePixelWidth),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: AppColors.darkGreyText,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          100 * variablePixelWidth),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 24 * variablePixelWidth,
                                        height: 24 * variablePixelHeight,
                                        child: const Icon(
                                          Icons.add_rounded,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const VerticalSpace(height: 4),
                                Text(
                                  translation(context).addText,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkGreyText,
                                    fontSize: 10 * textMultiplier,
                                    fontWeight: FontWeight.w500,
                                    height: 14 / 10,
                                    letterSpacing: 0.10 * variablePixelWidth,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const HorizontalSpace(width: 12),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4 * variablePixelWidth,
                                vertical: 4 * variablePixelHeight),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1 * pixelMultiplier,
                                    color: AppColors.lumiLight4),
                                borderRadius:
                                    BorderRadius.circular(12 * pixelMultiplier),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                EditFeature(
                                  title: translation(context).colors,
                                  icon: Icon(
                                    Icons.format_color_fill,
                                    color: (selectedTab == SelectedTab.Colors &&
                                                selectedTextProvider.id !=
                                                    '') ==
                                            true
                                        ? AppColors.lumiBluePrimary
                                        : AppColors.grayText,
                                  ),
                                  isSelected:
                                      (selectedTab == SelectedTab.Colors &&
                                          selectedTextProvider.id != ''),
                                  onPressed: () {
                                    setState(() {
                                      if (selectedTab == SelectedTab.Colors) {
                                        selectedTab = null;
                                      } else {
                                        selectedTab = SelectedTab.Colors;
                                      }
                                    });
                                  },
                                ),
                                const HorizontalSpace(width: 16),
                                EditFeature(
                                  title: translation(context).styling,
                                  icon: SvgPicture.asset(
                                    'assets/mpartner/B.svg',
                                    color:
                                        (selectedTab == SelectedTab.Styling &&
                                                    selectedTextProvider.id !=
                                                        '') ==
                                                true
                                            ? AppColors.lumiBluePrimary
                                            : AppColors.grayText,
                                  ),
                                  isSelected:
                                      (selectedTab == SelectedTab.Styling &&
                                          selectedTextProvider.id != ''),
                                  onPressed: () {
                                    setState(() {
                                      if (selectedTab == SelectedTab.Styling) {
                                        selectedTab = null;
                                      } else
                                        selectedTab = SelectedTab.Styling;
                                    });
                                  },
                                ),
                                const HorizontalSpace(width: 16),
                                EditFeature(
                                    title: translation(context).alignment,
                                    icon: Icon(Icons.format_align_left,
                                        color: (selectedTab ==
                                                        SelectedTab.Alignment &&
                                                    selectedTextProvider.id !=
                                                        '') ==
                                                true
                                            ? AppColors.lumiBluePrimary
                                            : AppColors.grayText),
                                    isSelected:
                                        (selectedTab == SelectedTab.Alignment &&
                                            selectedTextProvider.id != ''),
                                    onPressed: () {
                                      setState(() {
                                        if (selectedTab ==
                                            SelectedTab.Alignment) {
                                          selectedTab = null;
                                        } else {
                                          selectedTab = SelectedTab.Alignment;
                                        }
                                      });
                                    }),
                                const HorizontalSpace(width: 16),
                                EditFeature(
                                    title: translation(context).casing,
                                    icon: SvgPicture.asset(
                                      'assets/mpartner/Aj.svg',
                                      color:
                                          (selectedTab == SelectedTab.Casing &&
                                                      selectedTextProvider.id !=
                                                          '') ==
                                                  true
                                              ? AppColors.lumiBluePrimary
                                              : AppColors.grayText,
                                    ),
                                    isSelected:
                                        (selectedTab == SelectedTab.Casing &&
                                            selectedTextProvider.id != ''),
                                    onPressed: () {
                                      setState(() {
                                        if (selectedTab == SelectedTab.Casing) {
                                          selectedTab = null;
                                        } else {
                                          selectedTab = SelectedTab.Casing;
                                        }
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditFeature extends StatelessWidget {
  EditFeature(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.isSelected,
      required this.icon});

  final String title;
  final dynamic icon;
  final Function() onPressed;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 12 * variablePixelWidth,
          vertical: 4 * variablePixelHeight),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4 * pixelMultiplier)),
        color: (isSelected) == true ? AppColors.lumiLight5 : Colors.transparent,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 24 * variablePixelHeight,
              width: 24 * variablePixelWidth,
              child: icon,
            ),
            const VerticalSpace(height: 3),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: isSelected == true
                    ? AppColors.lumiBluePrimary
                    : AppColors.grayText,
                fontSize: 10 * textMultiplier,
                fontWeight: FontWeight.w500,
                height: 14 / 10,
                letterSpacing: 0.10 * variablePixelWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
