import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../solar/utils/solar_app_constants.dart';

class HandlePlaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String sanitizedText = '';
    if(newValue.text.isNotEmpty) {
      if (newValue.text.length == 1 && newValue.text == " ") {
        sanitizedText = newValue.text.replaceAll(" ", "");
      } else if (newValue.text.length == 1 && newValue.text == ".") {
        sanitizedText = newValue.text.replaceAll(".", "");
      } else if (newValue.text.length == 1 && newValue.text == ",") {
        sanitizedText = newValue.text.replaceAll(",", "");
      } else if (newValue.text.length == 1 && newValue.text == "/") {
        sanitizedText = newValue.text.replaceAll("/", "");
      } else if (newValue.text.length == 1 && newValue.text == "\\") {
        sanitizedText = newValue.text.replaceAll("\\", "");
      } else if (newValue.text.length == 1 && newValue.text == "-") {
        sanitizedText = newValue.text.replaceAll("-", "");
      }
      else {
        sanitizedText = newValue.text.replaceAll(RegExp(r"\s+"), " ");
      }
    }
    return TextEditingValue(
      text: sanitizedText,
      selection: TextSelection.collapsed(offset: sanitizedText.length),
    );
  }
}


class HandleFirstSpaceAndDotInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String sanitizedText = newValue.text;

    if (sanitizedText.isNotEmpty && (sanitizedText[0] == ' ' || sanitizedText[0] == '.')) {
      sanitizedText = sanitizedText.substring(1);
    }

    sanitizedText = sanitizedText.replaceAll(RegExp(r'\s+'), ' ');

    int lenRemoved = newValue.text.length - sanitizedText.length;
    int newOffset = newValue.selection.baseOffset - lenRemoved;
    if (newOffset < 0) {
      newOffset = 0;
    }

    return TextEditingValue(
      text: sanitizedText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}

class HandleFirstSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String sanitizedText = newValue.text;

    if (sanitizedText.isNotEmpty && sanitizedText[0] == ' ') {
      sanitizedText = sanitizedText.substring(1);
    }

    sanitizedText = sanitizedText.replaceAll(RegExp(r'\s+'), ' ');

    int lenRemoved = newValue.text.length - sanitizedText.length;
    int newOffset = newValue.selection.baseOffset - lenRemoved;
    if (newOffset < 0) {
      newOffset = 0;
    }
    return TextEditingValue(
      text: sanitizedText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}


class HandleFirstDigitInMobileTextFieldFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String sanitizedText = '';

    if (newValue.text.isNotEmpty) {
      // Check if the first digit is 0, 1, 2, 3, 4, or 5
      if (RegExp(r"[0-5]").hasMatch(newValue.text[0])) {
        // If the first digit is not allowed, do not update the text
        return oldValue;
      } else {
        sanitizedText = newValue.text;
      }
    }
    int lenRemoved = newValue.text.length-sanitizedText.length;
    return TextEditingValue(
      text: sanitizedText,
      selection: TextSelection.collapsed(offset: newValue.selection.baseOffset-lenRemoved),
    );
  }
}

class HandleMultipleDotsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String sanitizedText = '';
    if(newValue.text.isNotEmpty){
        sanitizedText = newValue.text.replaceAll(RegExp(r"\.+"), ".");
    }
    int lenRemoved = newValue.text.length-sanitizedText.length;
    return TextEditingValue(
      text: sanitizedText,
      selection: TextSelection.collapsed(offset: newValue.selection.baseOffset-lenRemoved),
    );
  }
}

class HandleBeginningInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String sanitizedText = newValue.text;
    if (sanitizedText.isNotEmpty &&
        (sanitizedText[0] == ' ' || sanitizedText[0] == '.'
            || sanitizedText[0] == ',' || sanitizedText[0] == '-')) {
      sanitizedText = sanitizedText.substring(1);
    }
    sanitizedText = sanitizedText.replaceAll(RegExp(r'\s+'), ' ');

    int lenRemoved = newValue.text.length - sanitizedText.length;
    int newOffset = newValue.selection.baseOffset - lenRemoved;
    if (newOffset < 0) {
      newOffset = 0;
    }
    return TextEditingValue(
      text: sanitizedText,
      selection: TextSelection.collapsed(
          offset: newOffset),
    );
  }
}

class HandleMultipleCommasInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String sanitizedText = '';
    if (newValue.text.isNotEmpty) {
      sanitizedText = newValue.text.replaceAll(RegExp(r"\,+"), ",");
    }
    int lenRemoved = newValue.text.length - sanitizedText.length;
    return TextEditingValue(
      text: sanitizedText,
      selection: TextSelection.collapsed(
          offset: newValue.selection.baseOffset - lenRemoved),
    );
  }
}

class HandleMultipleHyphensInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String sanitizedText = '';
    if (newValue.text.isNotEmpty) {
      sanitizedText = newValue.text.replaceAll(RegExp(r"\-+"), "-");
    }
    int lenRemoved = newValue.text.length - sanitizedText.length;
    return TextEditingValue(
      text: sanitizedText,
      selection: TextSelection.collapsed(
          offset: newValue.selection.baseOffset - lenRemoved),
    );
  }
}

class HandleFirstCharacterEmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String sanitizedText = newValue.text;

    if (sanitizedText.isNotEmpty && (sanitizedText[0] == '.' || sanitizedText[0] == ',' || sanitizedText[0] == '\$' || sanitizedText[0] == '@')) {
      sanitizedText = sanitizedText.substring(1);
    }

    sanitizedText = sanitizedText.replaceAll(RegExp(r'\s+'), ' ');

    int lenRemoved = newValue.text.length - sanitizedText.length;
    int newOffset = newValue.selection.baseOffset - lenRemoved;
    if (newOffset < 0) {
      newOffset = 0;
    }

    return TextEditingValue(
      text: sanitizedText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}

class HandleMultipleAtTheRateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String sanitizedText = '';
    if (newValue.text.isNotEmpty) {
      sanitizedText = newValue.text.replaceAll(RegExp(r"@+"), "@");
    }
    int lenRemoved = newValue.text.length - sanitizedText.length;
    return TextEditingValue(
      text: sanitizedText,
      selection: TextSelection.collapsed(
          offset: newValue.selection.baseOffset - lenRemoved),
    );
  }
}

class HandleMultipleDollarInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String sanitizedText = '';
    if (newValue.text.isNotEmpty) {
      sanitizedText = newValue.text.replaceAll(RegExp(r"\$+"), "\$");
    }
    int lenRemoved = newValue.text.length - sanitizedText.length;
    return TextEditingValue(
      text: sanitizedText,
      selection: TextSelection.collapsed(
          offset: newValue.selection.baseOffset - lenRemoved),
    );
  }
}
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final int newValueInt =
        int.tryParse(newValue.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

    final formatter = NumberFormat.currency(
        locale: "HI", symbol: "", decimalDigits: 0);

    String newText = formatter.format(newValueInt);

    int lenRemoved = newText.length - newValue.text.length;

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newValue.selection.end + lenRemoved));
  }
}

class LatLngTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final RegExp regex = SolarAppConstants.GEOCODE_ALLOW_REGEX;

    if (newValue.text.isEmpty) {
      return newValue;
    }

    if (!regex.hasMatch(newValue.text)) {
      return oldValue;
    }
    List<String> parts = newValue.text.split(',');
    for (String part in parts) {
      if(part.contains('.')){
        List<String> coordinate = part.split('.');
        if (coordinate.length > 2 || coordinate[1].length > 6) {
          return oldValue;
        }
      }
    }
    
    return newValue;
  }
}
class HandleLatLngBeginningInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String sanitizedText = newValue.text;
    if (sanitizedText.isNotEmpty &&
        (sanitizedText[0] == ' ' || sanitizedText[0] == '.'
            || sanitizedText[0] == ',')) {
      sanitizedText = sanitizedText.substring(1);
    }
    sanitizedText = sanitizedText.replaceAll(RegExp(r'\s+'), ' ');

    int lenRemoved = newValue.text.length - sanitizedText.length;
    int newOffset = newValue.selection.baseOffset - lenRemoved;
    if (newOffset < 0) {
      newOffset = 0;
    }
    return TextEditingValue(
      text: sanitizedText,
      selection: TextSelection.collapsed(
          offset: newOffset),
    );
  }
}