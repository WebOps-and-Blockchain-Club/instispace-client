class CalendarsModel {
  final List<CalendarModel> list;
  final int total;

  CalendarsModel({required this.list, required this.total});

  CalendarsModel.fromJson(dynamic data)
      : list = (data["getCalendarEntry"]["list"] as List<dynamic>)
            .map((e) => CalendarModel.fromJson(e))
            .toList(),
        total = data["getCalendarEntry"]['total'];
}

class CalendarModel {
  String id;
  String date;
  String description;
  String type;

  CalendarModel(
      {required this.id,
      required this.date,
      required this.description,
      required this.type});

  CalendarModel.fromJson(dynamic data)
      : id = data['id'],
        date = data['date'],
        description = data['description'] ?? '',
        type = data['type'];
}

class CalendarQueryVariableModel {
  final int take;
  final String lastEntryId;
  final String from;
  final String to;
  final String? type;

  CalendarQueryVariableModel({
    this.take = 20,
    this.lastEntryId = '',
    this.from = '',
    this.to = '',
    this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "take": take,
      "lastEntryId": lastEntryId,
      "calendarFilteringConditions": {
        "from": null,
        "to": null,
        "type": type,
      },
    };
  }
}
