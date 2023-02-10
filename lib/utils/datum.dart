extension DateString on DateTime {
  String get dateString => "$day. $month. $year";
  String get dateTimeString =>
      "$day. $month. $year $hour:${minute < 10 ? "0$minute" : minute}";
}
