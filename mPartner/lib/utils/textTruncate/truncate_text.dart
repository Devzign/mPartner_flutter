String truncateString(String input) {
  int maxLength = 6;
  if (input.length <= maxLength) {
    return input;
  } else {
    return '${input.substring(0, maxLength-1)}..';
  }
}

