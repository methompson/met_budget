final List<String> dayOfWeek = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

String getDisplayDayOfWeek(int value) {
  final dow = value % 7;
  return dayOfWeek[dow - 1];
}

String getDisplayDayOfMonth(int value) {
  final int lastDigit = value % 10;

  if (value == 11 || value == 12 || value == 13) {
    return '${value}th';
  } else if (lastDigit == 1) {
    return '${value}st';
  } else if (lastDigit == 2) {
    return '${value}nd';
  } else if (lastDigit == 3) {
    return '${value}rd';
  }

  return '${value}th';
}
