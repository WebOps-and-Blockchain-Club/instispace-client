import 'dart:html';
import 'dart:typed_data';
import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/home.dart';
import 'package:client/screens/home/Announcements/home.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:getwidget/getwidget.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';



class AddAnnouncements extends StatefulWidget {
final Future<QueryResult?> Function()? refetchAnnouncement;
AddAnnouncements({required this.refetchAnnouncement});

@override
  _AddAnnouncementsState createState() => _AddAnnouncementsState();
}

class _AddAnnouncementsState extends State<AddAnnouncements> {

  String createAnnouncements = homeQuery().createAnnouncements;
  String editAnnouncements = homeQuery().editAnnouncements;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String description = '';
  List selectedImage = ["Please select an image"];
  var values;
  List multipartFile = [];
  List byteData = [];
  var endTime;


  @override

  String getHostels = authQuery().getHostels;

  Map <String,String> Hostels = {};
  List<String> hostelIds = [];

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
        document: gql(getHostels),),
    builder: (QueryResult result, {fetchMore, refetch}) {
      Hostels.clear();
      if (result.hasException) {
        return Text(result.exception.toString());
      }
      if (result.isLoading) {
        return Center(
          child: CircularProgressIndicator(color: Colors.blue[700],),
        );
      }
      for (var i = 0; i < result.data!["getHostels"].length; i++) {
        Hostels.putIfAbsent(result.data!["getHostels"][i]["id"].toString(),() => "");
        Hostels[result.data!["getHostels"][i]["id"]] = result.data!["getHostels"][i]["name"];
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
                                    cursorColor: Colors.blue[700],
                                    controller: titleController,
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
                              initialValue: DateTime.now().toIso8601String(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              icon: Icon(Icons.event),
                              dateLabelText: 'Date',
                              timeLabelText: "Hour",
                              initialTime: TimeOfDay.now(),
                              use24HourFormat: true,
                              selectableDayPredicate: (date) {
                                return true;
                              },
                              onChanged: (val) {
                                setState(() {
                                  endTime = val;
                                });
                              },
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "This field can't be empty";
                                }
                              },
                              onSaved: (val) {
                                setState(() {
                                  endTime = val;
                                  print(endTime);
                                });
                              }
                              ,
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
                              controller: descriptionController,
                              validators: (val) {
                                if (val == '') {
                                  return "This field can't be empty";
                                }
                              },
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
                              items: Hostels.values.toList(),
                              onSelect: (value) {
                                values = value;
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
                                    final FilePickerResult? result = await FilePicker.platform.pickFiles(
                                      type: FileType.image,
                                      allowMultiple: true,
                                    );
                                    if (result != null) {
                                      setState(() {
                                        selectedImage.clear();
                                        for(var i = 0; i < result.files.length; i++) {
                                          selectedImage.add(result.files[i].name);
                                          byteData.add(result.files[i].bytes);
                                          multipartFile.add(MultipartFile.fromBytes(
                                            'photo',
                                            byteData[i],
                                            filename: selectedImage[i],
                                            contentType: MediaType("image", "png"),
                                          ));
                                        }
                                      });
                                      print(multipartFile);
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
                                Mutation(
                                    options: MutationOptions(
                                      document: gql(editAnnouncements),
                                    ),
                                    builder: (
                                        RunMutation runMutation,
                                        QueryResult? result,
                                        ) {
                                      if (result!.hasException) {
                                        print(result.exception.toString());
                                      }
                                      if (result.isLoading) {
                                        return Center(
                                          child: CircularProgressIndicator(color: Colors.blue[700],),
                                        );
                                      }
                                      return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.blue[700],
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30.0))
                                        ),
                                        onPressed: () {
                                          runMutation({
                                            'announcementInput': {
                                              "title": titleController.text,
                                              "description": descriptionController.text,
                                              "hostelIds": hostelIds,
                                              "endTime": "$endTime:00+05:30",
                                            },
                                            "images": multipartFile
                                          });
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext context) => Announcements()
                                            )
                                          );
                                        },
                                        child: Text(
                                          "Save Changes",
                                          style: TextStyle(color: Colors.white,fontSize: 7.0),
                                        ),
                                      );
                                    }
                                    ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blue[700],
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context)=> Announcements()
                                        )
                                    );
                                  },
                                  child: Text(
                                    "Discard Changes",
                                    style: TextStyle(color: Colors.white,fontSize: 7.0),
                                  ),
                                ),
                                Mutation(
                                  options: MutationOptions(
                                    document: gql(createAnnouncements),
                                  ),
                                  builder: (
                                      RunMutation runMutation,
                                      QueryResult? result,
                                  ) {
                                    if (result!.hasException){
                                      print(result.exception.toString());
                                      print(result.data);
                                    }
                                    if(result.isLoading){
                                      return Center(
                                        child: CircularProgressIndicator(color: Colors.blue[700],),
                                      );
                                    }
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.blue[700],
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                                      ),
                                      onPressed: () {
                                        List Hostl = [];
                                        Hostels.forEach((k, v) => Hostl.add(k));
                                        for (var i = 0; i < values.length; i++) {
                                          hostelIds.add(Hostl[values[i]]);
                                        }
                                        if (_formkey.currentState!.validate()) {
                                          runMutation({
                                            'announcementInput': {
                                              "title": titleController.text,
                                              "description": descriptionController.text,
                                              "hostelIds": hostelIds,
                                              "endTime": "$endTime:00+05:30",
                                            },
                                            "images": multipartFile,
                                          });
                                          Navigator.pop(context);
                                          widget.refetchAnnouncement!();
                                        }
                                      },
                                      child: Text(
                                        "Add Announcement",
                                        style: TextStyle(color: Colors.white,fontSize: 7.0),
                                      ),
                                    );
                                  },
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


