class Holidayinfo {
  String? date;
  String? title;
  Holidayinfo({this.date, this.title});
}

class HolidayModel {
  String? month;
  List<Holidayinfo?> info = [];
  HolidayModel({this.month, required this.info});
}
