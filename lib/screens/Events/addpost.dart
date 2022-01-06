import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';

class AddPostEvents extends StatefulWidget {
  @override
  _AddPostEventsState createState() => _AddPostEventsState();
}

class _AddPostEventsState extends State<AddPostEvents> {
  final myControllerTitle = TextEditingController();
  final myControllerLocation = TextEditingController();
  final myControllerDescription = TextEditingController();
  final myControllerImgUrl = TextEditingController();
  final myControllerFormLink = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerTitle.dispose();
    myControllerLocation.dispose();
    myControllerDescription.dispose();
    myControllerImgUrl.dispose();
    myControllerFormLink.dispose();
    super.dispose();
  }

  final _formkey = GlobalKey<FormState>();
  String? selectedImage = "Please select an image";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Event",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Color(0xFF),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Select Tags",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Enter title',
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(20.0))),
                      controller: myControllerTitle,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "This field can't be empty";
                        }
                      },
                    ),
                    SizedBox(height: 5.0),
                    DateTimePicker(
                      type: DateTimePickerType.dateTimeSeparate,
                      dateMask: 'd MMM, yyyy',
                      initialValue: DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      icon: Icon(Icons.event),
                      dateLabelText: 'Date',
                      timeLabelText: "Hour",
                      selectableDayPredicate: (date) {
                        // Disable weekend days to select from the calendar
                        if (date.weekday == 6 || date.weekday == 7) {
                          return false;
                        }

                        return true;
                      },
                      onChanged: (val) => print(val),
                      validator: (val) {
                        print(val);
                        return null;
                      },
                      onSaved: (val) => print(val),
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Enter Location',
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(20.0))),
                      controller: myControllerLocation,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "This field can't be empty";
                        }
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Enter description',
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(20.0))),
                      controller: myControllerDescription,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "This field can't be empty";
                        }
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              final FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.image,
                                allowMultiple: false,
                              );
                              if (result != null) {
                                PlatformFile file = result.files.first;
                                setState(() {
                                  selectedImage = file.name;
                                });
                              }
                            },
                            child: Text("Select an image")),
                        Text(selectedImage.toString()),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Enter Form Link',
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(20.0))),
                      controller: myControllerFormLink,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "This field can't be empty";
                        } else if (isURL(val) == false) {
                          return "Please enter a valid url";
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "Discard Changes",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              Navigator.pushNamed(context, '/events');
                            }
                          },
                          child: Text(
                            "Add Event",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
