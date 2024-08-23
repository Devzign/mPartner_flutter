import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../providers/selected_text_overlay.dart';
import '../providers/text_overlay_provider.dart';
import '../widgets/casing_tab.dart';

class TextOverlayWidget extends ConsumerStatefulWidget {
  String id;
  String text;
  Offset offset;
  double fontSize;
  Color color;
  bool bold;
  bool italic;
  bool underline;
  TextAlign alignment;
  TextTransform casing;
  final double screenHeight;
  final double screenWidth;
  bool isSelected;
  double angle;
  double height;
  double width;
  int charMultiplier;

  TextOverlayWidget({
    super.key,
    required this.id,
    required this.text,
    required this.offset,
    required this.fontSize,
    required this.color,
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.alignment = TextAlign.start,
    this.casing= TextTransform.none,
    required this.screenHeight,
    required this.screenWidth,
    required this.isSelected,
    required this.angle,
    required this.height,
    required this.width,
    required this.charMultiplier,
  });

  @override
  ConsumerState<TextOverlayWidget> createState() => _TextOverlayWidgetState();
}

class _TextOverlayWidgetState extends ConsumerState<TextOverlayWidget> {
  late TextEditingController _textEditingController;
  late TextEditingController _textWhileEdit;
  bool isTransforming = false;
  double originalFontSize = 0.0;
  bool textboxActivated = false;
  late FocusNode _focusNode;
  bool keyboardVisible = false;
  int numLines=0;
  int _charMultiplier=1;

  @override
  void initState() {
    String text=widget.text;
    if (widget.casing == TextTransform.lowercase) {
      text = widget.text.toLowerCase();
    } else if (widget.casing == TextTransform.uppercase) {
      text = widget.text.toUpperCase();
    } else if (widget.casing == TextTransform.title) {
      text = toTitleCase(widget.text);
    } else {
      text = widget.text;
    }

    _textEditingController = TextEditingController(text: text);
    _textWhileEdit = TextEditingController(text: text);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        keyboardVisible = _focusNode.hasFocus;
      });
      if (!keyboardVisible) {
        _finishEditing();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textWhileEdit.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String toTitleCase(String text) {
  List<String> lines = text.split('\n');
  List<String> capitalizedLines = [];
  for (String line in lines) {
    capitalizedLines.add(_capitalizeLine(line));
  }
  return capitalizedLines.join('\n');
}

String _capitalizeLine(String line) {
  return line.split(RegExp(r'\s+')).map((word) => _capitalizeWord(word)).join(' ');
}

String _capitalizeWord(String word) {
  if (word.isEmpty) {
    return '';
  }
  return '${word[0].toUpperCase()}${word.substring(1)}';
}


  String returnText(String text) {
    if (widget.casing == TextTransform.lowercase) {
      return text.toLowerCase();
    } else if (widget.casing == TextTransform.uppercase) {
      return text.toUpperCase();
    } else if (widget.casing == TextTransform.title) {
      return toTitleCase(text);
    }

    return text;
  }

  void __activateTextBox() {
    var textListProvider = ref.watch(textOverlayListProvider.notifier);
    ref.read(selectedTextOverlayProvider.notifier).state = widget;
    var selectedTextProvider = ref.watch(selectedTextOverlayProvider);
    int idx =
        textListProvider.findIndexOfOverlayWithId(selectedTextProvider.id);
    print(idx);
    setState(() {
      String text=widget.text;
    if (widget.casing == TextTransform.lowercase) {
      text = widget.text.toLowerCase();
    } else if (widget.casing == TextTransform.uppercase) {
      text = widget.text.toUpperCase();
    } else if (widget.casing == TextTransform.title) {
      text = toTitleCase(widget.text);
    }

    _textEditingController = TextEditingController(text: text);
    _textWhileEdit = TextEditingController(text: text);
      textListProvider.changeSelectstatus(idx, true);
      textboxActivated = true;
      _textWhileEdit.text=returnText(_textEditingController.text);
    });
    ref.read(selectedTextOverlayProvider.notifier).state =
        ref.watch(textOverlayListProvider)[idx];
  }

  void _startEditing(double screenHeight, double screenWidth,
      double variablePixelHeight, double variablePixelWidth) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.8),
      barrierDismissible: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.transparent,
            body: Column(
              children: [
                Column(
                  children: [
                    Container(
                      width: screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24 * variablePixelWidth,
                          vertical: 8 * variablePixelHeight),
                      decoration: const BoxDecoration(color: AppColors.lumiDarkBlack),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _textWhileEdit.text=returnText(_textEditingController.text);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 32 * variablePixelWidth,
                              height: 32 * variablePixelHeight,
                              child: const Icon(Icons.close,
                                  color: AppColors.lightWhite),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _finishEditing();
                              Navigator.of(context).pop();
                            },
                            child: Container(
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
                Expanded(
                  child: Center(
                    child: SizedBox(
                      height: screenHeight / 2,
                      child: TextField(
                        keyboardType:  TextInputType.multiline,
                        maxLines: 10,
                        focusNode: _focusNode,
                        controller: _textWhileEdit,
                        autofocus: true,
                        textAlign: TextAlign.center,
                        maxLength: AppConstants.advertisementTextMaxLength,
                        onSubmitted: (_) {
                          _finishEditing();
                          Navigator.of(context).pop();
                        },
                        onChanged: (String e){
                          setState((){
                            final lineLengths = _textWhileEdit.text.split('\n').map((line) => line.length).toList();
                              _charMultiplier = lineLengths.reduce((value, element) => value > element ? value : element);
                              numLines = '\n'.allMatches(e).length + 1;
                          });
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.poppins(                          
                          color: widget.color,
                          fontSize: widget.fontSize,
                          letterSpacing: 0.1,
                          decoration: widget.underline
                              ? TextDecoration.underline
                              : TextDecoration.none,
                          fontStyle: widget.italic
                              ? FontStyle.italic
                              : FontStyle.normal,
                          fontWeight:
                              widget.bold ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) => _focusNode.requestFocus());
  }

  void _finishEditing() {
    var textListProvider = ref.watch(textOverlayListProvider.notifier);
    var selectedTextProvider = ref.watch(selectedTextOverlayProvider);
    int idx =
        textListProvider.findIndexOfOverlayWithId(selectedTextProvider.id);
    print(idx);
    String updatedText = _textWhileEdit.text;
    // double newTextBoxHeight = widget.height;
    // double newTextBoxWidth = widget.fontSize / 1.5 * updatedText.length;
        
    // if (newTextBoxWidth > (300 * variablePixelWidth)) {
    //   newTextBoxHeight = (newTextBoxWidth/(300 * variablePixelWidth)) * widget.fontSize + (22 * variablePixelHeight);
    //   newTextBoxWidth = 300 * variablePixelWidth;
    // }

    setState(() {
      widget.text = updatedText;
      _textEditingController.text = updatedText;
      textListProvider.changeSelectstatus(idx, false);
      textboxActivated = false;
      // if(newTextBoxWidth < 50 * variablePixelWidth) {
      //   newTextBoxWidth=50 * variablePixelWidth;
      // }
      if(_charMultiplier==0) {
        _charMultiplier=1;
      } else if (_charMultiplier>9){
        _charMultiplier=9;
      }
      textListProvider.updatecharMultiplier(idx,_charMultiplier);
      textListProvider.updateText(idx, returnText(updatedText));
      // textListProvider.changeContainerDimensions(idx, newTextBoxHeight, newTextBoxWidth);
      // textListProvider.changeContainerWidth(idx,  newTextBoxWidth);
    });
    textListProvider.deselectAll();
    ref.read(selectedTextOverlayProvider.notifier).state = TextOverlayWidget(
      charMultiplier: 1,
      id: '',
      text: '',
      offset: const Offset(0, 0),
      fontSize: 0,
      color: AppColors.white,
      screenHeight: 0,
      screenWidth: 0,
      isSelected: false,
      angle: 0,
      height: 0,
      width: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    return TapRegion(
      onTapInside: (tap) {
        __activateTextBox();
      },
      onTapOutside: (tap) {
        setState(() {
          textboxActivated = false;
        });
      },
      child: Container(
        // height: widget.height, width: widget.width,
        decoration: (widget.isSelected)
            ? BoxDecoration(
                border: Border.all(
                  color: AppColors.lightGrey2,
                  width: 0.59 * pixelMultiplier,
                ),
              )
            : const BoxDecoration(),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (widget.isSelected)
              ? () => _startEditing(screenHeight, screenWidth,
                  variablePixelHeight, variablePixelWidth)
              : null,
          child:  
            Transform.translate(
              offset:(!widget.isSelected)? const Offset(0, 0): Offset(0, -22 * textMultiplier),
              child: Padding(
                padding: EdgeInsets.only(top: 22 * textMultiplier),
                child: Text(
                  returnText(widget.text),
                  textAlign: widget.alignment,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                  style: GoogleFonts.poppins(
                    color: widget.color,
                    fontSize: widget.fontSize,
                    decoration: widget.underline
                    ? TextDecoration.underline
                    : TextDecoration.none,
                    decorationColor: widget.color,
                    fontStyle: widget.italic ? FontStyle.italic : FontStyle.normal,
                    fontWeight: widget.bold ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}
