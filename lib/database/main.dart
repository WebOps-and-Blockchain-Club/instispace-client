// ignore_for_file: prefer_const_constructors

import 'package:client/database/academic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/academic/course.dart';

class AcademicService extends ChangeNotifier {
  List<CourseModel>? _courses;
  List<SlotModel>? _slots;
  String? _day;

  final List<Map<String, dynamic>> _slotsConfig = [
    {
      "slotName": "A/A1/A2",
      "slots": [
        {
          "slotName": "A",
          "day": "Mon",
          "fromTime": "08:00:00 am",
          "toTime": "08:50:00 am",
        },
        {
          "slotName": "A",
          "day": "Tue",
          "fromTime": "01:00 pm",
          "toTime": "01:50 pm",
        },
        {
          "slotName": "A",
          "day": "Thu",
          "fromTime": "11:00 am",
          "toTime": "11:50 am",
        },
        {
          "slotName": "A",
          "day": "Tue",
          "fromTime": "10:00 am",
          "toTime": "10:50 am",
        },
      ],
    },
    {
      "slotName": "B/B1/B2",
      "slots": [
        {
          "slotName": "B",
          "day": "Mon",
          "fromTime": "09:00 am",
          "toTime": "09:50 am",
        },
        {
          "slotName": "B",
          "day": "Tue",
          "fromTime": "10:00 am",
          "toTime": "10:50 am",
        },
      ],
    },
    {
      "slotName": "C/C1/C2",
      "slots": [
        {
          "slotName": "C",
          "day": "Mon",
          "fromTime": "10:00 am",
          "toTime": "10:50 am",
        },
        {
          "slotName": "C",
          "day": "Tue",
          "fromTime": "11:00 am",
          "toTime": "11:50 am",
        },
      ],
    },
    {
      "slotName": "D/D1/D2",
      "slots": [
        {
          "slotName": "D",
          "day": "Mon",
          "fromTime": "11:00 am",
          "toTime": "11:50 am",
        },
        {
          "slotName": "D",
          "day": "Tue",
          "fromTime": "10:00 am",
          "toTime": "10:50 am",
        },
        {
          "slotName": "D",
          "day": "Wed",
          "fromTime": "09:00 am",
          "toTime": "09:50 am",
        },
        {
          "slotName": "D",
          "day": "Thu",
          "fromTime": "01:00 pm",
          "toTime": "01:50 pm",
        },
      ],
    },
    {
      "slotName": "E/E1/E2",
      "slots": [
        {
          "slotName": "E",
          "day": "Tue",
          "fromTime": "11:00 am",
          "toTime": "11:50 am",
        },
        {
          "slotName": "E",
          "day": "Wed",
          "fromTime": "10:00 am",
          "toTime": "10:50 am",
        },
        {
          "slotName": "E",
          "day": "Thu",
          "fromTime": "08:00 am",
          "toTime": "08:50 am",
        },
        {
          "slotName": "E",
          "day": "Fri",
          "fromTime": "05:00 pm",
          "toTime": "05:50 pm",
        },
      ],
    },
    {
      "slotName": "F/F1/F2",
      "slots": [
        {
          "slotName": "F",
          "day": "Tue",
          "fromTime": "05:00 pm",
          "toTime": "05:50 pm",
        },
        {
          "slotName": "F",
          "day": "Wed",
          "fromTime": "11:00 am",
          "toTime": "11:50 am",
        },
        {
          "slotName": "F",
          "day": "Thu",
          "fromTime": "09:00 am",
          "toTime": "09:50 am",
        },
        {
          "slotName": "F",
          "day": "Fri",
          "fromTime": "08:00 am",
          "toTime": "08:50 am",
        },
      ],
    },
    {
      "slotName": "G/G1/G2",
      "slots": [
        {
          "slotName": "G",
          "day": "Mon",
          "fromTime": "01:00 pm",
          "toTime": "01:50 pm",
        },
        {
          "slotName": "G",
          "day": "Wed",
          "fromTime": "05:00 pm",
          "toTime": "05:50 pm",
        },
        {
          "slotName": "G",
          "day": "Thu",
          "fromTime": "10:00 am",
          "toTime": "10:50 am",
        },
        {
          "slotName": "G",
          "day": "Fri",
          "fromTime": "09:00 pm",
          "toTime": "09:50 pm",
        },
      ],
    },
  ];

  List<CourseModel>? get courses => _courses;
  List<SlotModel>? get slots => _slots;
  List<Map<String, dynamic>> get slotsConfig => _slotsConfig;
  String? get day => _day;

  AcademicDatabaseService acadDb = AcademicDatabaseService.instance;
  AcademicService() {
    notifyListeners();
    _courses = null;
    _slots = null;
    _day = DateFormat('E').format(DateTime.now());
    if (_day == 'Sat' || _day == 'Sun') {
      _day == 'Mon';
    }
    _initFetch();
  }

  _initFetch() async {
    // var fromTime = TimeOfDay(hour: 8, minute: 50);
    // var toTime = TimeOfDay(hour: 14, minute: 50);
    // print('==============required string format');
    // print(fromTime.toString().substring(10, 15) +
    //     ' ' +
    //     fromTime.period.toString().split('.').last);
    // print(toTime.toString().substring(10, 15) +
    //     ' ' +
    //     toTime.period.toString().split('.').last);
    if (_day == 'Sat' || _day == 'Sun') {
      setDay('Mon');
    }
    await getSlots();
    await getCourses();
  }

  // getSlotOptions(String slotName) {
  //   var slotOptions = <SlotModel>[];
  //   // for (var i = 0; i < _slotsConfig.length; i++) {
  //   //   var e = _slotsConfig[i];
  //   //   var _slotName = e["slotName"];
  //   //   var _slots = <SlotModel>[];
  //   //   for (var j = 0; j < e["slots"].length; j++) {
  //   //     var f = e["slots"][j];
  //   //     _slots.add(SlotModel.fromJson({
  //   //       "slotName": _slotName,
  //   //       "fromTime": f["fromTime"],
  //   //       "toTime": f["toTime"],
  //   //       "day": f['day']
  //   //     }));
  //   //   }
  //   //   slotOptions.add({"slotName": _slotName, "slots": _slots});
  //   // }
  //   var _slotName = slotName.toUpperCase().trim();
  //   for (var i = 0; i < _slotsConfig1.length; i++) {
  //     var e = _slotsConfig1[i];
  //     if (e["slots"].contains(_slotName)) {
  //       slotOptions.add(SlotModel.fromJson({
  //         "slotName": _slotName,
  //         "fromTime": e["fromTime"],
  //         "toTime": e["toTime"],
  //         "day": e['day']
  //       }));
  //     }
  //   }
  //   return slotOptions;
  // }

  getSlotOptions2() {
    var slotOptions = <Map<String, dynamic>>[];
    for (var i = 0; i < _slotsConfig.length; i++) {
      var e = _slotsConfig[i];
      var _slotName = e["slotName"];
      var _slots = <SlotModel>[];
      for (var j = 0; j < e["slots"].length; j++) {
        var f = e["slots"][j];
        _slots.add(SlotModel.fromJson({
          "slotName": _slotName,
          "fromTime": f["fromTime"],
          "toTime": f["toTime"],
          "day": f['day']
        }));
      }
      slotOptions.add({"slotName": _slotName, "slots": _slots});
    }
    return slotOptions;
  }

  setDay(String day) {
    _day = day;
    _initFetch();
  }

  getSlots() async {
    _slots = await acadDb.fetchSlotsByDay(_day ?? "Mon");
    notifyListeners();
  }

  getUpcomingSlots() async {}

  getCourses() async {
    _courses = await acadDb.fetchCoursesWithSlots();
    notifyListeners();
  }

  createCourse(CourseModel course) async {
    await acadDb.insertCourseWithSlots(course);
    _initFetch();
    return true;
  }

  updateCourse(String courseId, CourseModel course) async {
    await acadDb.updateCourseWithSlots(int.parse(courseId), course);
    _initFetch();
    return true;
  }

  deleteCourse(String courseId) async {
    await acadDb.deleteCourseWithSlots(int.parse(courseId));
    _initFetch();
    return true;
  }
}
