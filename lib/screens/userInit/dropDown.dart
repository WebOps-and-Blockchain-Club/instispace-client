import 'package:flutter/material.dart';

typedef void StringCallback(String val);
class dropDown extends StatefulWidget {
  final StringCallback callback;
   final List <String>Hostels;
   String dropDownValue;
  dropDown({required this.Hostels,required this.dropDownValue,required this.callback});

  @override
  _dropDownState createState() => _dropDownState();
}
class _dropDownState extends State<dropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text('Select Hostel'),
      value: widget.dropDownValue,
      onChanged: (String? newValue) {
        setState(() {
          widget.dropDownValue = newValue!;
        });
        widget.callback(newValue!);
        print(widget.dropDownValue);
        print(widget.Hostels);
      },
      items: widget.Hostels.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
