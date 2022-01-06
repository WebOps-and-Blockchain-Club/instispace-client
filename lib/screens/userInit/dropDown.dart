import 'package:flutter/material.dart';

class dropDown extends StatefulWidget {

   final List <String>Hostels;
  dropDown({required this.Hostels});
  @override
  _dropDownState createState() => _dropDownState();
}

class _dropDownState extends State<dropDown> {

  @override
  Widget build(BuildContext context) {
    String DropDownValue = widget.Hostels[0];
    return DropdownButton<String>(
      value: DropDownValue,
      onChanged: (String? newValue) {
        setState(() {
          DropDownValue = newValue!;
        });
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
