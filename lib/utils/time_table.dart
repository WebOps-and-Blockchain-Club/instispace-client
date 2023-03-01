import "package:flutter/material.dart";

final Map<String, Map<String, List<int>>> time_table = {
  'monday': {
    'A': [0],
    'B': [1],
    'C': [2],
    'D': [3],
    'G': [4],
    'P': [5, 6],
    'H': [5],
    'H1': [5],
    'M2': [6],
    'M': [6],
    'J': [7],
    'J3': [7],
    'A1': [8],
    'B1': [9],
    'C1': [10],
    'D1': [11],
    'P2': [9, 10, 11],
    'G2': [12],
    'B2': [13],
    'E2': [14],
    'C2': [15],
    'P1': [13, 14, 15],
    'XX': [16],
  },
  'tuesday': {
    'B': [0],
    'C': [1],
    'D': [2],
    'E': [3],
    'A': [4],
    'Q': [5, 6],
    'M': [5],
    'M1': [5],
    'H2': [6],
    'H': [6],
    'F': [7],
    'B1': [8],
    'C1': [9],
    'D1': [10],
    'E1': [11],
    'Q2': [9, 10, 11],
    'A2': [12],
    'C2': [13],
    'D2': [14],
    'E2': [15],
    'Q1': [13, 14, 15],
    'YY': [16],
  },
  'wednesday': {
    'C': [0],
    'D': [1],
    'E': [2],
    'F': [3],
    'B': [4],
    'R': [5, 6],
    'J': [5],
    'J1': [5],
    'K': [6],
    'K2': [6],
    'G': [7],
    'C1': [8],
    'D1': [9],
    'E1': [10],
    'F1': [11],
    'R2': [9, 10, 11],
    'B2': [12],
    'D2': [13],
    'E2': [14],
    'F2': [15],
    'R1': [13, 14, 15],
    'XX': [16],
  },
  'thursday': {
    'E': [0],
    'F': [1],
    'G': [2],
    'A': [3],
    'D': [4],
    'S': [5, 6],
    'L': [5],
    'L1': [5],
    'J': [6],
    'J2': [6],
    'H': [7],
    'H3': [7],
    'E1': [8],
    'F1': [9],
    'G1': [10],
    'A1': [11],
    'S2': [9, 10, 11],
    'D2': [12],
    'F2': [13],
    'G2': [14],
    'A2': [15],
    'S1': [13, 14, 15],
    'YY': [16],
  },
  'friday': {
    'F': [0],
    'G': [1],
    'A': [2],
    'B': [3],
    'C': [4],
    'T': [5, 6],
    'K': [5],
    'K1': [5],
    'L': [6],
    'L2': [6],
    'E': [7],
    'F1': [8],
    'G1': [9],
    'A1': [10],
    'B1': [11],
    'T2': [9, 10, 11],
    'C2': [12],
    'F2': [13],
    'A2': [14],
    'B2': [15],
    'T1': [13, 14, 15],
    'XX': [16],
  }
};

List<String> holiday = [
  "2022-08-09 Muharram",
  "2022-08-15 Independence Day",
  "2022-08-31 Ganesh Chaturthi",
  "2022-09-08 Onam",
  "2022-10-02 Gandhi Jayanthi",
  "2022-10-05 Dussehra",
  "2022-10-24 Deepavali",
  "2022-11-08 Guru Nanak's Birthday",
  "2022-12-25 Christmas"
];

List<String> start_timing = [
  //timings for 2nd year and above
  "08:00 AM",
  "09:00 AM",
  "10:00 AM",
  "11:00 AM",
  "01:00 PM",
  "02:00 PM",
  "03:30 PM",
  "05:00 PM",
  //For 1st year timings
  "08:00 AM",
  "09:00 AM",
  "10:00 AM",
  "11:00 AM",
  "01:00 PM",
  "02:00 PM",
  "03:00 PM",
  "04:00 PM",
  "05:00 PM",
];
List<String> end_timing = [
  //timings for 2nd year and above
  "08:50 AM",
  "09:50 AM",
  "10:50 AM",
  "11:50 AM",
  "01:50 PM",
  "03:15 PM",
  "04:45 PM",
  "05:50 PM",
  //1st year timings
  "08:50 AM",
  "09:50 AM",
  "10:50 AM",
  "11:50 AM",
  "01:50 PM",
  "02:50 PM",
  "03:50 PM",
  "04:50 PM",
  "05:50 PM",
];
Map<String, Color> slot_color = {
  "A": Colors.redAccent,
  "A1": Colors.redAccent,
  "A2": Colors.redAccent,
  "B": Colors.blueAccent,
  "B1": Colors.blueAccent,
  "B2": Colors.blueAccent,
  "C": Colors.greenAccent,
  "C1": Colors.greenAccent,
  "C2": Colors.greenAccent,
  "D": Colors.green,
  "D1": Colors.green,
  "D2": Colors.green,
  "E": Colors.lightGreen,
  "E1": Colors.lightGreen,
  "E2": Colors.lightGreen,
  "F": Colors.brown,
  "F1": Colors.brown,
  "F2": Colors.brown,
  "G": Colors.purpleAccent,
  "G1": Colors.purpleAccent,
  "G2": Colors.purpleAccent,
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
  "P1": Colors.red,
  "P2": Colors.red,
  "Q": Colors.red,
  "Q1": Colors.red,
  "Q2": Colors.red,
  "R": Colors.red,
  "R1": Colors.red,
  "R2": Colors.red,
  "S": Colors.red,
  "S1": Colors.red,
  "S2": Colors.red,
  "T": Colors.red,
  "T1": Colors.red,
  "T2": Colors.red,
  "XX": Colors.purple,
  "YY": Colors.purpleAccent,
};