import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/casing_tab.dart';
import '../widgets/textoverlay_widget.dart';

final textOverlayListProvider =
    StateNotifierProvider<TextOverlayListNotifier, List<TextOverlayWidget>>(
  (ref) => TextOverlayListNotifier(),
);

class TextOverlayListNotifier extends StateNotifier<List<TextOverlayWidget>> {
  TextOverlayListNotifier() : super([]);

  List<TextOverlayWidget> getList() {
    return state;
  }

  void addText(TextOverlayWidget newText) {
    state = [...state, newText];
  }

  void updateText(int index, String text){
    if (index >= 0 && index < state.length) {
      TextOverlayWidget updatedOverlay = TextOverlayWidget(
          text: text,
          charMultiplier: state[index].charMultiplier,
          height: state[index].height,
          width: state[index].width,
          angle: state[index].angle,
          bold: state[index].bold,
          italic: state[index].italic,
          underline: state[index].underline,
          id: state[index].id,
          offset: state[index].offset,
          fontSize: state[index].fontSize,
          color: state[index].color,
          screenHeight: state[index].screenHeight,
          screenWidth: state[index].screenWidth,
          isSelected: state[index].isSelected,
          casing: state[index].casing,
          alignment: state[index].alignment);
      state = [
        ...state.sublist(0, index),
        updatedOverlay,
        ...state.sublist(index + 1),
      ];
    }
  }

  void deleteAtIndex(int index) {
    if (index >= 0 && index < state.length) {
      state = List.from(state)..removeAt(index);
    }
  }

  int findIndexOfOverlayWithId(String id) {
    return state.indexWhere((overlay) => overlay.id == id);
  }

  void deselectAll() {
    state = state.map((overlay) {
      return TextOverlayWidget(
          charMultiplier: overlay.charMultiplier,
          height: overlay.height,
          width: overlay.width,
          angle: overlay.angle,
          bold: overlay.bold,
          italic: overlay.italic,
          underline: overlay.underline,
          id: overlay.id,
          text: overlay.text,
          offset: overlay.offset,
          fontSize: overlay.fontSize,
          color: overlay.color,
          screenHeight: overlay.screenHeight,
          screenWidth: overlay.screenWidth,
          isSelected: false,
          casing: overlay.casing,
          alignment: overlay.alignment);
    }).toList();
  }

  void resetList() {
    state = [];
  }

  void changeContainerDimensions(int index, double height, double width) {
    if (index >= 0 && index < state.length) {
      TextOverlayWidget updatedOverlay = TextOverlayWidget(
          height: height,
          width: width,
          charMultiplier: state[index].charMultiplier,
          angle: state[index].angle,
          bold: state[index].bold,
          italic: state[index].italic,
          underline: state[index].underline,
          id: state[index].id,
          text: state[index].text,
          offset: state[index].offset,
          fontSize: state[index].fontSize,
          color: state[index].color,
          screenHeight: state[index].screenHeight,
          screenWidth: state[index].screenWidth,
          isSelected: state[index].isSelected,
          casing: state[index].casing,
          alignment: state[index].alignment);
      state = [
        ...state.sublist(0, index),
        updatedOverlay,
        ...state.sublist(index + 1),
      ];
    }
  }

  void changeContainerWidth(int index, double width) {
    if (index >= 0 && index < state.length) {
      TextOverlayWidget updatedOverlay = TextOverlayWidget(
        charMultiplier: state[index].charMultiplier,
          height: state[index].height,
          width: width,
          angle: state[index].angle,
          bold: state[index].bold,
          italic: state[index].italic,
          underline: state[index].underline,
          id: state[index].id,
          text: state[index].text,
          offset: state[index].offset,
          fontSize: state[index].fontSize,
          color: state[index].color,
          screenHeight: state[index].screenHeight,
          screenWidth: state[index].screenWidth,
          isSelected: state[index].isSelected,
          casing: state[index].casing,
          alignment: state[index].alignment);
      state = [
        ...state.sublist(0, index),
        updatedOverlay,
        ...state.sublist(index + 1),
      ];
    }
  }

  void changeSelectstatus(int index, bool isSelected) {
    if (index >= 0 && index < state.length) {
      TextOverlayWidget updatedOverlay = TextOverlayWidget(
        charMultiplier: state[index].charMultiplier,
          height: state[index].height,
          width: state[index].width,
          angle: state[index].angle,
          bold: state[index].bold,
          italic: state[index].italic,
          underline: state[index].underline,
          id: state[index].id,
          text: state[index].text,
          offset: state[index].offset,
          fontSize: state[index].fontSize,
          color: state[index].color,
          screenHeight: state[index].screenHeight,
          screenWidth: state[index].screenWidth,
          isSelected: isSelected,
          casing: state[index].casing,
          alignment: state[index].alignment);
      state = [
        ...state.sublist(0, index),
        updatedOverlay,
        ...state.sublist(index + 1),
      ];
    }
  }

  void changeFontSize(int index, double fontSize) {
    if (index >= 0 && index < state.length) {
      TextOverlayWidget updatedOverlay = TextOverlayWidget(
        charMultiplier: state[index].charMultiplier,
          height: state[index].height,
          width: state[index].width,
          angle: state[index].angle,
          bold: state[index].bold,
          italic: state[index].italic,
          underline: state[index].underline,
          id: state[index].id,
          text: state[index].text,
          offset: state[index].offset,
          fontSize: fontSize,
          color: state[index].color,
          screenHeight: state[index].screenHeight,
          screenWidth: state[index].screenWidth,
          isSelected: state[index].isSelected,
          casing: state[index].casing,
          alignment: state[index].alignment);
      state = [
        ...state.sublist(0, index),
        updatedOverlay,
        ...state.sublist(index + 1),
      ];
    }
  }

  void updateOffset(int index, Offset offset) {
    if (index >= 0 && index < state.length) {
      TextOverlayWidget updatedOverlay = TextOverlayWidget(
        charMultiplier: state[index].charMultiplier,
          height: state[index].height,
          width: state[index].width,
          angle: state[index].angle,
          bold: state[index].bold,
          italic: state[index].italic,
          underline: state[index].underline,
          id: state[index].id,
          text: state[index].text,
          offset: offset,
          fontSize: state[index].fontSize,
          color: state[index].color,
          screenHeight: state[index].screenHeight,
          screenWidth: state[index].screenWidth,
          isSelected: state[index].isSelected,
          casing: state[index].casing,
          alignment: state[index].alignment);
      state = [
        ...state.sublist(0, index),
        updatedOverlay,
        ...state.sublist(index + 1),
      ];
    }
  }

  void changeColorAtIndex(int index, Color newColor) {
    if (index >= 0 && index < state.length) {
      TextOverlayWidget updatedOverlay = TextOverlayWidget(
        charMultiplier: state[index].charMultiplier,
          height: state[index].height,
          width: state[index].width,
          angle: state[index].angle,
          bold: state[index].bold,
          italic: state[index].italic,
          underline: state[index].underline,
          id: state[index].id,
          text: state[index].text,
          offset: state[index].offset,
          fontSize: state[index].fontSize,
          color: newColor,
          screenHeight: state[index].screenHeight,
          screenWidth: state[index].screenWidth,
          isSelected: state[index].isSelected,
          casing: state[index].casing,
          alignment: state[index].alignment);
      state = [
        ...state.sublist(0, index),
        updatedOverlay,
        ...state.sublist(index + 1),
      ];
    }
  }

  void updateBold(int index, bool isBold) {
    if (index >= 0 && index < state.length) {
      TextOverlayWidget updatedOverlay = TextOverlayWidget(
        charMultiplier: state[index].charMultiplier,
          height: state[index].height,
          width: state[index].width,
          angle: state[index].angle,
          bold: isBold,
          italic: state[index].italic,
          underline: state[index].underline,
          id: state[index].id,
          text: state[index].text,
          offset: state[index].offset,
          fontSize: state[index].fontSize,
          color: state[index].color,
          screenHeight: state[index].screenHeight,
          screenWidth: state[index].screenWidth,
          isSelected: state[index].isSelected,
          casing: state[index].casing,
          alignment: state[index].alignment);
      state = [
        ...state.sublist(0, index),
        updatedOverlay,
        ...state.sublist(index + 1),
      ];
    }
  }

  void updateItalic(int index, bool isItalic) {
    if (index >= 0 && index < state.length) {
      TextOverlayWidget updatedOverlay = TextOverlayWidget(
        charMultiplier: state[index].charMultiplier,
          height: state[index].height,
          width: state[index].width,
          angle: state[index].angle,
          italic: isItalic,
          bold: state[index].bold,
          underline: state[index].underline,
          id: state[index].id,
          text: state[index].text,
          offset: state[index].offset,
          fontSize: state[index].fontSize,
          color: state[index].color,
          screenHeight: state[index].screenHeight,
          screenWidth: state[index].screenWidth,
          isSelected: state[index].isSelected,
          casing: state[index].casing,
          alignment: state[index].alignment);
      state = [
        ...state.sublist(0, index),
        updatedOverlay,
        ...state.sublist(index + 1),
      ];
    }
  }

  void changeAngle(int index, double angle) {
    if (index >= 0 && index < state.length) {
      TextOverlayWidget updatedOverlay = TextOverlayWidget(
        charMultiplier: state[index].charMultiplier,
          height: state[index].height,
          width: state[index].width,
          angle: angle,
          underline: state[index].underline,
          bold: state[index].bold,
          italic: state[index].italic,
          id: state[index].id,
          text: state[index].text,
          offset: state[index].offset,
          fontSize: state[index].fontSize,
          color: state[index].color,
          screenHeight: state[index].screenHeight,
          screenWidth: state[index].screenWidth,
          isSelected: state[index].isSelected,
          casing: state[index].casing,
          alignment: state[index].alignment);
      state = [
        ...state.sublist(0, index),
        updatedOverlay,
        ...state.sublist(index + 1),
      ];
    }
  }

  void updateUnderline(int index, bool isUnderlined) {
    if (index >= 0 && index < state.length) {
      TextOverlayWidget updatedOverlay = TextOverlayWidget(
        charMultiplier: state[index].charMultiplier,
          height: state[index].height,
          width: state[index].width,
          angle: state[index].angle,
          underline: isUnderlined,
          bold: state[index].bold,
          italic: state[index].italic,
          id: state[index].id,
          text: state[index].text,
          offset: state[index].offset,
          fontSize: state[index].fontSize,
          color: state[index].color,
          screenHeight: state[index].screenHeight,
          screenWidth: state[index].screenWidth,
          isSelected: state[index].isSelected,
          casing: state[index].casing,
          alignment: state[index].alignment);
      state = [
        ...state.sublist(0, index),
        updatedOverlay,
        ...state.sublist(index + 1),
      ];
    }
  }

  void changeCase(int index, TextTransform textTransform) {
    if (index >= 0 && index < state.length) {
      TextOverlayWidget updatedOverlay = TextOverlayWidget(
        charMultiplier: state[index].charMultiplier,
          height: state[index].height,
          width: state[index].width,
          angle: state[index].angle,
          underline: state[index].underline,
          bold: state[index].bold,
          italic: state[index].italic,
          id: state[index].id,
          text: state[index].text,
          offset: state[index].offset,
          fontSize: state[index].fontSize,
          color: state[index].color,
          screenHeight: state[index].screenHeight,
          screenWidth: state[index].screenWidth,
          isSelected: state[index].isSelected,
          casing: textTransform,
          alignment: state[index].alignment);
      state = [
        ...state.sublist(0, index),
        updatedOverlay,
        ...state.sublist(index + 1),
      ];
    }
  }

  void changeAlignment(int index, TextAlign alignment) {
    if (index >= 0 && index < state.length) {
      TextOverlayWidget updatedOverlay = TextOverlayWidget(
        charMultiplier: state[index].charMultiplier,
        height: state[index].height,
        width: state[index].width,
        angle: state[index].angle,
        underline: state[index].underline,
        bold: state[index].bold,
        italic: state[index].italic,
        id: state[index].id,
        text: state[index].text,
        offset: state[index].offset,
        fontSize: state[index].fontSize,
        color: state[index].color,
        screenHeight: state[index].screenHeight,
        screenWidth: state[index].screenWidth,
        isSelected: state[index].isSelected,
        casing: state[index].casing,
        alignment: alignment,
      );
      state = [
        ...state.sublist(0, index),
        updatedOverlay,
        ...state.sublist(index + 1),
      ];
    }
  }

    void updatecharMultiplier(int index, int charMultiplier) {
    if (index >= 0 && index < state.length) {
      TextOverlayWidget updatedOverlay = TextOverlayWidget(
        charMultiplier: charMultiplier,
        height: state[index].height,
        width: state[index].width,
        angle: state[index].angle,
        underline: state[index].underline,
        bold: state[index].bold,
        italic: state[index].italic,
        id: state[index].id,
        text: state[index].text,
        offset: state[index].offset,
        fontSize: state[index].fontSize,
        color: state[index].color,
        screenHeight: state[index].screenHeight,
        screenWidth: state[index].screenWidth,
        isSelected: state[index].isSelected,
        casing: state[index].casing,
        alignment: state[index].alignment,
      );
      state = [
        ...state.sublist(0, index),
        updatedOverlay,
        ...state.sublist(index + 1),
      ];
    }
    }
}
