import 'package:intl/intl.dart';

class DateTimeFormatModel {
  final DateTime dateTime;

  DateTimeFormatModel(this.dateTime);

  DateTimeFormatModel.fromString(String _dateTime)
      : dateTime = DateTime.parse(_dateTime).toLocal();

  String toFormat([String? format = "E, MMM dd, yyyy | h:mm a"]) {
    return DateFormat(format).format(dateTime);
  }

  String toISOFormat() {
    return '${dateTime.toIso8601String()}+05:30';
  }

  String dateTimeFormatted() {
    return "${DateTimeFormatModel(dateTime).toFormat("MMM dd, yyyy")} ${DateTimeFormatModel(dateTime).toFormat("h:mm a")}";
  }

  // DateTime addDateTime(DateTime date, DateTime time) {
  //   return DateTimeFormatModel.fromString(
  //           "${date.toString().split(" ").first} ${time.toString().split(" ").last}")
  //       .dateTime;
  // }

  String toDiffString({bool? abs}) {
    DateTime now = DateTime.now();
    DateTime date1 = now;
    DateTime date2 = dateTime;
    if (abs != null && abs == true) {
      date1 = dateTime;
      date2 = now;
    }

    var returnVal = date1.difference(date2).inMinutes;
    var format = 'min';
    if (returnVal < 60) {
      return "$returnVal $format";
    }
    returnVal = date1.difference(date2).inHours;
    format = 'hour';
    if (returnVal < 24) {
      return "$returnVal $format";
    }
    returnVal = date1.difference(date2).inDays;
    format = 'day';
    if (returnVal < 30) {
      return "$returnVal $format";
    }
    returnVal = (date1.difference(date2).inDays) ~/ 30;
    format = 'month';
    if (returnVal < 12) {
      return "$returnVal $format";
    }
    returnVal = (date1.difference(date2).inDays) ~/ (30 * 12);
    format = 'year';

    return "$returnVal $format";
  }

  int toDiffInSeconds() {
    DateTime now = DateTime.now();

    return dateTime.difference(now).inSeconds;
  }
}
