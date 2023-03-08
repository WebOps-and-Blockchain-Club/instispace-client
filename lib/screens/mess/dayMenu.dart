import 'package:client/screens/mess/menuCard.dart';
import 'package:flutter/material.dart';

class DayMenu extends StatefulWidget {
  final DateTime date;
  const DayMenu({Key? key, required this.date}) : super(key: key);

  @override
  State<DayMenu> createState() => _DayMenuState();
}

class _DayMenuState extends State<DayMenu> {
  final List<String> Meals = ['Breakfast', 'Lunch', 'Dinner'];

  @override
  Widget build(BuildContext context) {
    final String day = weekdayName[widget.date.weekday]!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          day,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        MenuCard(meal: 'Breakfast', day: day),
        MenuCard(meal: 'Lunch', day: day),
        MenuCard(meal: 'Dinner', day: day),
      ],
    );
  }
}
