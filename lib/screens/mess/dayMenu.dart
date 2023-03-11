import 'package:client/screens/mess/main.dart';
import 'package:client/screens/mess/menuCard.dart';
import 'package:flutter/material.dart';

class DayMenu extends StatefulWidget {
  final String week;
  final String mess;
  final DateTime date;
  const DayMenu(
      {Key? key, required this.date, required this.week, required this.mess})
      : super(key: key);

  @override
  State<DayMenu> createState() => _DayMenuState();
}

class _DayMenuState extends State<DayMenu> {
  final List<String> Meals = ['Breakfast', 'Lunch', 'Dinner'];

  @override
  Widget build(BuildContext context) {
    final String day = weekDays[widget.date.weekday - 1];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          day,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        MenuCard(
          meal: 'Breakfast',
          day: day,
          week: widget.week,
          mess: widget.mess,
        ),
        MenuCard(
          meal: 'Lunch',
          day: day,
          week: widget.week,
          mess: widget.mess,
        ),
        MenuCard(
          meal: 'Dinner',
          day: day,
          week: widget.week,
          mess: widget.mess,
        ),
      ],
    );
  }
}
