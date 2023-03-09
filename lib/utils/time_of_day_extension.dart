import 'package:flutter/material.dart';

extension TOD on TimeOfDay {
  DateTime toDateTime() {
    return DateTime(1, 1, 1, hour, minute);
  }
}
