extension DateString on DateTime {
  String get dateString => "$day. $month. $year";
  String get dateTimeString =>
      "$day. $month. $year $hour:${minute < 10 ? "0$minute" : minute}";
  String get rawDateString => "$day-$month-$year";
}

extension TextDuration on Duration {
  String get durationText =>
      "$inHours hodin${(inHours < 5 && inHours > 1) ? "y" : (inHours == 1) ? "a" : ""} ${inMinutes - inHours * 60} minut${(inMinutes - inHours * 60) < 5 && (inMinutes - inHours * 60) > 1 ? "y" : (inMinutes - inHours * 60) == 1 ? "a" : ""}";
}
