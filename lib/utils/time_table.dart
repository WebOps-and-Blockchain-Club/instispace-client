import "package:flutter/material.dart";

final Map<String, List<List<String>>> time_table = {
  'monday': [
    ['A'],
    ['B'],
    ['C'],
    ['D'],
    ['G'],
    ['P', 'B2', 'H1'],
    ['P', 'E2', 'M2'],
    ['P', 'C2', 'M2'],
    ['J', 'J3']
  ],
  'tuesday': [
    ['B'],
    ['C'],
    ['D'],
    ['E'],
    ['A'],
    ['Q', 'M', 'M1'],
    ['Q', 'H', 'H2'],
    ['F']
  ],
  'wednesday': [
    ['C'],
    ['D'],
    ['E'],
    ['F'],
    ['B'],
    ['R', 'J', 'J1'],
    ['R', 'K', 'K2'],
    ['G']
  ],
  'thursday': [
    ['E'],
    ['F'],
    ['G'],
    ['A'],
    ['D'],
    ['S', 'L', 'L1'],
    ['S', 'J', 'J2'],
    ['H', 'H3']
  ],
  'friday': [
    ['F'],
    ['G'],
    ['A'],
    ['B'],
    ['C'],
    ['T', 'K', 'K1'],
    ['T', 'L', 'L2'],
    ['E']
  ]
};

final holidays = {
  '2022-08-09': 'Muharram',
  '2022-08-15': 'Independence Day',
  '2022-08-31': 'Ganesh Chaturthi',
  '2022-09-08': 'Onam',
  '2022-10-02': 'Gandhi Jayanthi',
  '2022-10-05': 'Dussehra',
  '2022-10-24': 'Deepavali',
  '2022-11-08': "Guru Nanak's Birthday",
  '2022-12-25': 'Christmas'
};
List<String> start_timing = [
  "8:00 AM",
  "9:00 AM",
  "10:00 AM",
  "11:00 AM",
  "1:00 PM",
  "2:00 PM",
  "3:30 PM",
  "5:00 PM"
];
List<String> end_timing = [
  "8:50 AM",
  "9:50 AM",
  "10:50 AM",
  "11:50 AM",
  "1:50 PM",
  "3:15 PM",
  "4:45 PM",
  "5:50 PM"
];
Map<String, Color> slot_color = {
  "A": Colors.redAccent,
  "B": Colors.blueAccent,
  "C": Colors.greenAccent,
  "D": Colors.grey,
  "E": Colors.lightGreen,
  "F": Colors.brown,
  "G": Colors.purpleAccent,
  "H": Colors.amber,
  "H1": Colors.amber,
  "H2": Colors.amber,
  "H3": Colors.amber,
  "J": Colors.deepOrange,
  "J1": Colors.deepOrange,
  "J2": Colors.deepOrange,
  "J3": Colors.deepOrange,
  "K": Colors.blue,
  "K1": Colors.blue,
  "K2": Colors.blue,
  "L": Colors.green,
  "L1": Colors.green,
  "L2": Colors.green,
  "M": Colors.deepPurple,
  "M1": Colors.deepPurple,
  "M2": Colors.deepPurple,
  "P": Colors.red,
  "Q": Colors.red,
  "R": Colors.red,
  "S": Colors.red,
  "T": Colors.red,
};
