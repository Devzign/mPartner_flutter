import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../../utils/localdata/language_constants.dart';
import '../../utils/solar_app_constants.dart';

Tuple2<bool, String> validatePanNo(String panNo, BuildContext context) {
  RegExp regex = SolarAppConstants.PAN_REGEX;
  if (panNo.isEmpty) {
    return const Tuple2(false, "");
  } else if (!regex.hasMatch(panNo)) {
    return Tuple2(false, translation(context).panValidation);
  } else {
    return const Tuple2(true, "");
  }
}

Tuple2<bool, String> validateGstNo(String gstNo, BuildContext context) {
  RegExp regex = SolarAppConstants.GST_REGEX;
  if (gstNo.isEmpty) {
    return const Tuple2(false, "");
  } else if (!regex.hasMatch(gstNo)) {
    return Tuple2(false, translation(context).gstValidation);
  } else {
    return const Tuple2(true, "");
  }
}

Tuple2<bool, String> validatePinCode(String pinCode, BuildContext context) {
  RegExp regex = SolarAppConstants.PINCODE_REGEX;
  if (pinCode.isEmpty) {
    return const Tuple2(false, "");
  } else if (!regex.hasMatch(pinCode)) {
    return Tuple2(false, translation(context).validPostalCodeError);
  } else {
    return const Tuple2(true, "");
  }
}

Tuple2<bool, String> validateEmail(String email, BuildContext context) {
  RegExp regex = SolarAppConstants.EMAIL_REGEX;
  if (email.isEmpty) {
    return const Tuple2(false, "");
  } else if (!regex.hasMatch(email)) {
    return Tuple2(false, translation(context).validEmailError);
  } else {
    return const Tuple2(true, "");
  }
}

Tuple2<bool, String> validateMobileNumber(String mobileNumber, BuildContext context) {
  RegExp regex = SolarAppConstants.MOBILE_NUMBER_REGEX;
  if (mobileNumber.isEmpty) {
    return const Tuple2(false, "");
  } else if (!regex.hasMatch(mobileNumber)) {
    return Tuple2(false, translation(context).validNumberError);
  } else {
    return const Tuple2(true, "");
  }
}

Tuple2<bool, String> validateName(String companyName, BuildContext context) {
  RegExp regex = SolarAppConstants.NAME_REGEX_1;
  if (companyName.isEmpty) {
    return const Tuple2(false, "");
  }
  else if (!regex.hasMatch(companyName)) {
    return Tuple2(false, translation(context).enterMin5Char);
  }
  else {
    return const Tuple2(true, "");
  }
}

Tuple2<bool, String> validateValueAndUnit(String value, String unit, BuildContext context) {
  RegExp regex;
  if (unit.toLowerCase() == "kwh") {
    regex = SolarAppConstants.PROJECT_CAPACITY_REGEX_KWH;
    return validateKwh(value, regex, context);
  } else if (unit.toLowerCase() == "mw") {
    regex = SolarAppConstants.PROJECT_CAPACITY_REGEX_MW;
    return validateMw(value, regex, context);
  } else {
    return const Tuple2(false, "");
  }
}

Tuple2<bool, String> validateKwh(String value, RegExp regex, BuildContext context) {
  if (value.isEmpty) {
    return const Tuple2(false, "");
  } else if (!regex.hasMatch(value)) {
    return Tuple2(false, translation(context).projectCapacityKwValidation);
  } else {
    return const Tuple2(true, "");
  }
}

Tuple2<bool, String> validateMw(String value, RegExp regex, BuildContext context) {
  if (value.isEmpty) {
    return const Tuple2(false, "");
  } else if (!regex.hasMatch(value)) {
    return Tuple2(false, translation(context).projectCapacityMwValidation);
  } else {
    return const Tuple2(true, "");
  }
}

Tuple2<bool, String> validateCost(String input, BuildContext context) {
  if (input.isEmpty) {
    return const Tuple2(false, "");
  }

  double number = double.tryParse(input) ?? 0;

  if (number < 100000 || number > 100000000) {
    return Tuple2(false, translation(context).projectCostValidation);
  } else {
    return const Tuple2(true, "");
  }
}

