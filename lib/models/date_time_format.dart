import 'package:intl/intl.dart';

class DateTimeFormatModel {
  final DateTime dateTime;

  DateTimeFormatModel({required this.dateTime});

  DateTimeFormatModel.fromString(String _dateTime)
      : dateTime = DateTime.parse(_dateTime).toLocal();

  String toFormat([String? format = "E, MMM dd, yyyy | h:mm a"]) {
    return DateFormat(format).format(dateTime);
  }

  String toISOFormat() {
    return dateTime.toIso8601String() + '+05:30';
  }

  String toDiffString() {
    DateTime now = DateTime.now();

    var returnVal = now.difference(dateTime).inMinutes;
    var format = 'min';
    if (returnVal < 60) {
      return "$returnVal $format";
    }
    returnVal = now.difference(dateTime).inHours;
    format = 'hour';
    if (returnVal < 24) {
      return "$returnVal $format";
    }
    returnVal = now.difference(dateTime).inDays;
    format = 'day';
    if (returnVal < 30) {
      return "$returnVal $format";
    }
    returnVal = (now.difference(dateTime).inDays) ~/ 30;
    format = 'month';
    if (returnVal < 12) {
      return "$returnVal $format";
    }
    returnVal = (now.difference(dateTime).inDays) ~/ (30 * 12);
    format = 'year';

    return "$returnVal $format";
  }
}
