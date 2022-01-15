import 'package:client/graphQL/auth.dart';
import 'package:client/screens/home/Announcements/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:getwidget/getwidget.dart';
import 'package:date_time_picker/date_time_picker.dart';


class AddAnnouncements extends StatefulWidget {

  @override
  _AddAnnouncementsState createState() => _AddAnnouncementsState();
}

class _AddAnnouncementsState extends State<AddAnnouncements> {

  final myControllerTitle = TextEditingController();
  final myControllerDescription = TextEditingController();

  String description = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerTitle.dispose();
    myControllerDescription.dispose();
    super.dispose();
  }

  String getHostels = authQuery().getHostels;

  List<String> Hostels = [
    'Select Hostel',
  ];

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
        document: gql(getHostels),),
    builder: (QueryResult result, {fetchMore, refetch}) {
      // print('Hostel:$Hostels');
      Hostels.clear();
      if (result.hasException) {
        return Text(result.exception.toString());
      }
      if (result.isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      for (var i = 0; i < result.data!["getHostels"].length; i++) {
        Hostels.add(result.data!["getHostels"][i]["name"].toString());
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Announcement",
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
                                    ),
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
                            Text(
                              'End Time*',
                              style: TextStyle(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold
                              ),
                            ),
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
                              'Hostel*',
                              style: TextStyle(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            GFMultiSelect(
                              items: Hostels,
                              onSelect: (value) {
                                print('selected $value ');
                              },
                              hideDropdownUnderline: true,
                              dropdownTitleTileText: 'Select Hostel',
                              dropdownTitleTilePadding: EdgeInsets.all(10),
                              dropdownTitleTileColor: Colors.blue[200],
                              dropdownTitleTileTextStyle: TextStyle(color: Colors.black54,fontWeight: FontWeight.w500),
                              dropdownBgColor: Color(0xFF90CAF9),
                              dropdownTitleTileBorderRadius: BorderRadius.circular(30),
                              expandedIcon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black54,
                              ),
                              collapsedIcon: const Icon(
                                Icons.keyboard_arrow_up,
                                color: Colors.black54,
                              ),
                              submitButton: Text('OK'),
                              cancelButton: Text('Cancel'),
                              type: GFCheckboxType.basic,
                              activeBgColor: GFColors.SUCCESS,
                              activeBorderColor: GFColors.SUCCESS,
                              inactiveBorderColor: Colors.grey,
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context)=> Announcements()));
                                      // Navigator.pushNamed(context, '/events');
                                    }
                                  },
                                  child: Text(
                                    "Add Announcement",
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
    );
  }
}
