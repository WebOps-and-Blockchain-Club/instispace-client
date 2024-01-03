import 'dart:convert';

import 'package:client/screens/mess/main.dart';
import 'package:client/utils/mess.dart';
import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String week;
  final String mess;
  final String meal;
  final String day;

  const MenuCard(
      {Key? key,
      required this.meal,
      required this.day,
      required this.week,
      required this.mess})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = mealMap[meal];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(35),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.15),
                offset: Offset(2, 2),
                blurRadius: 16)
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 25),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35)),
                color: data?.color,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    meal,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    data?.icon,
                    color: Colors.white,
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                    messMap[mess][week][day][meal].length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 25),
                          child: Text(
                            messMap[mess][week][day][meal][index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ))),
          ),
        ],
      ),
    );
  }
}
