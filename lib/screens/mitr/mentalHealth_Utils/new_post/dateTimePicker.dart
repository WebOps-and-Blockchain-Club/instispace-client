import 'package:client/models/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerWidget extends StatefulWidget {
  final String? labelText;
  final IconData? icon;
  final Function(DateTime)? onDateTimeChanged;
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const DateTimePickerWidget({
    Key? key,
    this.labelText,
    this.onDateTimeChanged,
    this.icon,
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
  }) : super(key: key);

  @override
  _DateTimePickerWidgetState createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  final TextEditingController formatted = TextEditingController();
  DateTime? _selectedDateTime;

  Future<void> _showDateTimePicker(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = widget.initialDate ?? now;
    final initialTime = TimeOfDay.fromDateTime(initialDate);

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (time == null) return;

    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() => _selectedDateTime = dateTime);

    formatted.text = DateTimeFormatModel(dateTime).dateTimeFormatted();

    widget.onDateTimeChanged?.call(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.labelText != null) {
      return TextFormField(
        controller: formatted,
        onTap: () => _showDateTimePicker(
          context,
        ),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            labelText: widget.labelText),
        readOnly: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter the date & time";
          }
          return null;
        },
      );
    } else {
      return IconButton(
        icon: Icon(widget.icon),
        onPressed: () => _showDateTimePicker(context),
        tooltip: 'Select Date and Time',
      );
    }
  }
}
