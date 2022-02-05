import 'package:flutter/material.dart';

typedef void StringCallback(String val);
class dropDown extends StatefulWidget {
  final StringCallback callback;
  final List<String> Hostels;
  String dropDownValue;

  dropDown(
      {required this.Hostels,
      required this.dropDownValue,
      required this.callback});
  @override
  _dropDownState createState() => _dropDownState();
}
class _dropDownState extends State<dropDown> {
  @override
  Widget build(BuildContext context) {
    String DropDownValue = widget.Hostels[0];
    return SizedBox(
      width: 400.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[200],
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: DropdownButton<String>(
            underline: Container(
              height: 0.0,
            ),
            dropdownColor: Colors.blue[200],
            hint: Text("Select Hostel"),
            value: widget.dropDownValue,
            onChanged: (String? newValue) {
              setState(() {
                widget.dropDownValue = newValue!;
              });
              widget.callback(newValue!);
            },
            items: widget.Hostels.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
