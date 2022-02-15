import 'package:client/graphQL/announcement_mutations.dart';
import 'package:client/graphQL/auth.dart';
import 'package:client/screens/home/Announcements/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:client/models/formErrormsgs.dart';
import 'package:client/screens/home/Announcements/Announcement.dart';
import 'package:client/models/hostelclass.dart';

class EditAnnouncements extends StatefulWidget {
  final Announcement announcement;
  final Future<QueryResult?> Function()? refetchAnnouncement;
  EditAnnouncements(
      {required this.announcement, required this.refetchAnnouncement});

  @override
  _EditAnnouncementsState createState() => _EditAnnouncementsState();
}

class _EditAnnouncementsState extends State<EditAnnouncements> {
  String editAnnouncements = AnnouncementMutations().editAnnouncements;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String description = '';
  List selectedImage = [];
  var values;
  List multipartFile = [];
  List byteData = [];
  List? images = [];
  var endTime;
  var endDate;
  late String endtime;
  String errorTitle = "";
  String errorDes = "";
  String errorEndTime = "";
  String errorHostel = "";
  FilePickerResult? imageResult = null;

  @override
  String getHostels = authQuery().getHostels;

  Map<Hostel, bool> Hostels = {};
  List<String> selectedHostels = [];
  List<String> hostelIds = [];

  bool isAnnouncementCreated = false;
  bool isHostelSelected = false;
  String endTimeEntered = "No";

  final _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.announcement.title;
    description = widget.announcement.description;
    endDate = widget.announcement.endTime.toString().substring(0,10);
    endtime = widget.announcement.endTime.toString().substring(11,16);
    selectedHostels = widget.announcement.hostelIds;
    endTime = "${endDate} ${endtime}";

    print(endTime);

    String imageName = selectedImage.isEmpty
        ? "Please select image"
        : selectedImage.toString();
    return Query(
        options: QueryOptions(
          document: gql(getHostels),
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          Hostels.clear();
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue[700],
              ),
            );
          }
          for (var i = 0; i < result.data!["getHostels"].length; i++) {
            Hostels.putIfAbsent(
                Hostel(
                    Hostel_id: result.data!["getHostels"][i]["id"],
                    Hostel_name: result.data!["getHostels"][i]["name"] =
                        result.data!["getHostels"][i]["name"]),
                () => false);
          }
          List HostelIds = widget.announcement.hostelIds;
          print(HostelIds);
          for(var i =0;i<HostelIds.length;i++){
            print("Hostels:$Hostels");
            var key = Hostels.keys.firstWhere((element)=>
              HostelIds[i] == (element.Hostel_name));
            Hostels[key] = true;
            print("Hostels after done: $Hostels");
          };
          return Scaffold(
            key: _scaffoldkey,
            appBar: AppBar(
              title: Text(
                "Edit Announcement",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              backgroundColor: Colors.deepPurpleAccent,
              elevation: 0.0,
            ),
            body: Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(children: [
                  Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Title*',
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        SizedBox(
                          width: 450.0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue[200],
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 0.0, 0.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter title',
                                ),
                                cursorColor: Colors.blue[700],
                                controller: titleController,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    // setState(() {
                                    //   errorTitle = "Title can't be empty, Please give some title to the announcement";
                                    // });
                                    return "Title can't be empty";
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        // errorMessages(errorTitle),
                        SizedBox(height: 10.0),
                        Text(
                          'End Time*',
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold),
                        ),
                        DateTimePicker(
                          type: DateTimePickerType.dateTimeSeparate,
                          dateMask: 'd MMM, yyyy',
                          initialValue: widget.announcement.endTime,
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
                              endTimeEntered = "Yes";
                              endTime = val;
                            });
                          },
                          // validator: (val) {
                          //   if (endTimeEntered == "No") {
                          //     // setState(() {
                          //     //   errorEndTime = "Please select an End Time for the announcement";
                          //     // });
                          //     return "Please select an End Time for the announcement";
                          //   }
                          // },
                          onSaved: (val) {
                            setState(() {
                              endTime = val;
                            });
                          },
                        ),
                        // errorMessages(errorEndTime),
                        SizedBox(height: 10.0),
                        Text(
                          'Image*',
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        SizedBox(
                          width: 450.0,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue[200],
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30.0))),
                              onPressed: () async {
                                imageResult =
                                await FilePicker.platform.pickFiles(
                                  type: FileType.image,
                                  allowMultiple: true,
                                  withData: true,
                                );
                                if (imageResult != null) {
                                  setState(() {
                                    selectedImage.clear();
                                    for (var i = 0;
                                    i < imageResult!.files.length;
                                    i++) {
                                      selectedImage
                                          .add(imageResult!.files[i].name);
                                      byteData.add(imageResult!.files[i].bytes);
                                      multipartFile.add(MultipartFile.fromBytes(
                                        'photo',
                                        byteData[i],
                                        filename: selectedImage[i],
                                        contentType: MediaType("image",
                                            selectedImage[i].split(".").last),
                                      ));
                                    }
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 7.0, 0.0, 7.0),
                                child: Text(
                                  imageName,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w300),
                                ),
                              )),
                        ),
                        if (imageResult != null)
                          Wrap(
                            children: imageResult!.files
                                .map((e) => InkWell(
                              onLongPress: () {
                                setState(() {
                                  multipartFile
                                      .remove(MultipartFile.fromBytes(
                                    'photo',
                                    e.bytes as List<int>,
                                    filename: e.name,
                                    contentType:
                                    MediaType("image", "png"),
                                  ));
                                  byteData.remove(e.bytes);
                                  selectedImage.remove(e.name);
                                  imageResult!.files.remove(e);
                                });
                              },
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.memory(
                                  e.bytes!,
                                ),
                              ),
                            ))
                                .toList(),
                          ),
                        SizedBox(height: 10.0),
                        Text(
                          'Description*',
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold),
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
                            if (descriptionController.text == '' &&
                                imageResult == null) {
                              // setState(() {
                              //   errorDes = "Description and images can't be empty together, Please provide one of them";
                              // });
                              return "Description and images can't be empty together, Please provide one of them";
                            }
                          },
                        ),
                        errorMessages(errorDes),
                        SizedBox(height: 10.0),
                        Text(
                          'Hostel*',
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold),
                        ),
                        StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return ExpansionTile(
                              title: Text("Hostels"),
                              children: Hostels.keys
                                  .map((key) => CheckboxListTile(
                                value: Hostels[key],
                                onChanged: (bool? value) {
                                  setState(() {
                                    Hostels[key] = value!;
                                  });
                                },
                                title: Text(key.Hostel_name),
                              ))
                                  .toList(),
                            );
                          },
                        ),
                        errorMessages(errorHostel),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue[700],
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30.0))),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Announcements()));
                              },
                              child: Text(
                                "Discard Changes",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.0),
                              ),
                            ),
                            Mutation(
                              options: MutationOptions(
                                  document: gql(editAnnouncements),
                                  onCompleted: (dynamic resultData) {
                                    if (resultData["editAnnouncement"] ==
                                        true) {
                                      Navigator.pop(context);
                                      widget.refetchAnnouncement!();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Announcement Edited Successfully')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Announcement Edition Failed')),
                                      );
                                    }
                                  },
                                  onError: (dynamic error) {
                                    return ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Announcement Edition Failed, Server Error')),
                                    );
                                  }),
                              builder: (
                                  RunMutation runMutation,
                                  QueryResult? result,
                                  ) {
                                if (result!.hasException) {
                                  print(result.exception.toString());
                                }
                                if (result.isLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blue[700],
                                    ),
                                  );
                                }
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blue[700],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(30.0))),
                                  onPressed: () {
                                    if (_formkey.currentState!.validate()) {
                                      selectedHostels.clear();
                                      Hostels.forEach((key, value) {
                                        if (value) {
                                          selectedHostels.add(key.Hostel_id);
                                        }
                                      });
                                      if (selectedHostels.isEmpty) {
                                        setState(() {
                                          errorHostel =
                                          "Please select at least one hostel";
                                        });
                                      } else {
                                        print(
                                            "selectedHostels:$selectedHostels");
                                        print(
                                            "textController: ${titleController.text}");
                                      runMutation({
                                        'announcementId':
                                        widget.announcement.id,
                                        'updateAnnouncementInput': {
                                          "title": titleController.text,
                                          "description":
                                          descriptionController.text,
                                          "endTime": "$endTime:00+05:30",
                                          "hostelIds": selectedHostels,
                                        },
                                        "images": multipartFile,
                                      });

                                    }
                                    }
                                  },
                                  child: Text(
                                    "Edit Announcement",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.0),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          );
        });
  }
}
