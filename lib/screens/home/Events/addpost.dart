import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:validators/validators.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

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

  String description = '';

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
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              0.1,
              0.3,
              0.4,
              0.6,
              0.9
            ],
            colors: [
              Colors.deepPurpleAccent,
              Colors.blue,
              Colors.lightBlueAccent,
              Colors.lightBlueAccent,
              Colors.blueAccent
            ]
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(children: [
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Title*',
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 5.0),
                          SizedBox(
                            width: 450.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue[200],
                                borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10.0,0.0,0.0,0.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
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
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
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
                          SizedBox(height: 10.0),
                          Text(
                            'Location*',
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 5.0),
                          SizedBox(
                            width: 450.0,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue[200],
                                  borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10.0,0.0,0.0,0.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
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
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Description*',
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 5.0),
                          MarkdownTextInput(
                                (String value) => setState(() => description = value),
                            description,
                            label: 'Enter Description',
                            maxLines: 10,
                            actions: MarkdownType.values,
                            controller: myControllerDescription,
                            validators: (val) {
                              if (val == '') {
                                return "This field can't be empty";
                              }
                            },
                          ),
                          MarkdownBody(
                            data: description,
                            shrinkWrap: true,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Call-to-Action Link*',
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 5.0),
                          SizedBox(
                            width: 450.0,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue[200],
                                  borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10.0,0.0,0.0,0.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
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
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Tags*',
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 5.0),
                          SizedBox(
                            width: 450.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue[200],
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                elevation: 0.0
                              ),
                              onPressed: () {},
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0.0,7.0,0.0,7.0),
                                child: Text(
                                  "Select Tags",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w300
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Image*',
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 5.0),
                          SizedBox(
                            width: 450.0,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[200],
                                    elevation: 0.0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                                ),
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
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0,7.0,0.0,7.0),
                                  child: Text(
                                      selectedImage.toString(),
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w300
                                    ),
                                  ),
                                )),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[700],
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[700],
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Discard Changes",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[700],
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                                ),
                                onPressed: () {
                                  if (_formkey.currentState!.validate()) {
                                    print(description);
                                    Navigator.pushNamed(context, '/events');
                                  }
                                },
                                child: Text(
                                  "Add Event",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  // Markdown(
                  //   data: description,
                  //   styleSheet: MarkdownStyleSheet(
                  //     h1: TextStyle(color: Colors.blue)
                  //   ),
                  // ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
