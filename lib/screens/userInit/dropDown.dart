import 'package:flutter/material.dart';

typedef void StringCallback (String val);
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
    // String DropDownValue = widget.Hostels[0];
    return Padding(
      padding: const EdgeInsets.fromLTRB(15,15,15,0),
      child: Container(
        width: MediaQuery.of(context).size.width*1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: DropdownButtonHideUnderline(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10,0,10,0),
            child: DropdownButton<String>(
              dropdownColor: Colors.white,
              hint: const Padding(
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                child: Text("Select Hostel"),
              ),
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
      ),
    );
  }
}
