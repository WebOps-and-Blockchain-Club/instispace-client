import 'package:client/graphQL/announcements.dart';
import 'package:client/graphQL/auth.dart';
import 'package:client/screens/home/HostelSection/Announcements/announcements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:client/models/formErrormsgs.dart';
import 'package:client/models/hostelclass.dart';

import '../../../../widgets/formTexts.dart';

class AddAnnouncements extends StatefulWidget {
  final Future<QueryResult?> Function()? refetchAnnouncement;
  AddAnnouncements({required this.refetchAnnouncement});

  @override
  _AddAnnouncementsState createState() => _AddAnnouncementsState();
}

class _AddAnnouncementsState extends State<AddAnnouncements> {

  ///GraphQL
  String createAnnouncements = AnnouncementQM().createAnnouncements;
  String editAnnouncements = AnnouncementQM().editAnnouncements;
  String getHostels = authQuery().getHostels;

  ///Variables
  String description = '';
  List selectedImage = [];
  var values;
  List multipartFile = [];
  List byteData = [];
  var endTime;
  List? images = [];
  String emptyTitleErr = "";
  String emptyDesErr = "";
  String emptyEndTimeErr = "";
  String errorHostel = "";
  FilePickerResult? imageResult;
  Map<Hostel, bool> Hostels = {};
  List<String> selectedHostels = [];
  List<String> hostelIds = [];
  bool isAnnouncementCreated = false;
  bool isHostelSelected = false;
  String endTimeEntered = "No";

  ///Controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  ///Keys
  final _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  ///Dispose Function
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2B2E35),
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
          return Scaffold(
            key: _scaffoldkey,

            appBar: AppBar(
              title: const Text(
                "Add Announcement",
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              elevation: 0,
              backgroundColor: const Color(0xFF2B2E35),
            ),

            ///Background Colour
            backgroundColor: const Color(0xFFDFDFDF),

            body: ListView(
                children: [
              Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ///Title
                    FormText("Title"),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                      child: SizedBox(
                        height: 35,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(8,5,0,8),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              hintText: 'Enter the title',
                            ),
                            controller: titleController,
                            validator: (val) {
                              if(val == null || val.isEmpty) {
                                setState(() {
                                  emptyTitleErr = "Title can't be empty";
                                });
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),

                    ///error in title
                    errorMessages(emptyTitleErr),

                    const SizedBox(height: 10.0),

                    ///End Time
                    Wrap(children: [
                      FormText("EndTime"),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(15,5,15,0),
                        child: Text(
                          '(Post will be displayed till the end time is reached)',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      ),
                    ]),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,0,15,0),
                      child: DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        dateMask: 'd MMM, yyyy',
                        initialValue: DateTime.now().toIso8601String(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        icon: const Icon(Icons.event),
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
                        validator: (val) {
                          if (endTimeEntered == "No") {
                            // setState(() {
                            //   errorEndTime = "Please select an End Time for the announcement";
                            // });
                            return "Please select an End Time for the announcement";
                          }
                        },
                        onSaved: (val) {
                          setState(() {
                            endTime = val;
                          });
                        },
                      ),
                    ),

                    ///error in endtime
                    errorMessages(emptyEndTimeErr),


                    const SizedBox(height: 10.0),


                    ///Select Images
                    FormText("Select Images (if any)"),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                      child: SizedBox(
                        width: 250.0,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: const Color(0xFF42454D),
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0))
                            ),
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
                              padding: const EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 7.0),
                              child: Text(
                                imageName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w300
                                ),
                              ),
                            )),
                      ),
                    ),

                    ///Selected Images
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
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.memory(
                                        e.bytes!,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),

                    const SizedBox(height: 10.0),

                    ///Description
                    FormText('Description'),
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,0,15,0),
                      child: MarkdownTextInput(
                        (String value) => setState(() => description = value),
                        description,
                        label: 'Enter Description',
                        maxLines: 10,
                        actions: MarkdownType.values,
                        controller: descriptionController,
                        validators: (val) {
                          if (descriptionController.text == '' &&
                              imageResult == null) {
                            return "Description and images can't be empty together, Please provide one of them";
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 10.0),

                    ///Select Hostels
                 FormText('Select Hostel'),
                    StatefulBuilder(
                      builder:
                          (BuildContext context, StateSetter setState) {
                        return ExpansionTile(
                          title: const Text("Hostels",style: TextStyle(color: Colors.black),),
                          children: Hostels.keys
                              .map((key) => CheckboxListTile(
                                    checkColor: Color(0xFFFFFFFF),
                                    activeColor: Color(0xFF2B2E35),
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

                    const SizedBox(height: 10.0),

                    ///Discard and Submit Buttons
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          ///Discard Button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const Announcements()));
                            },
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFF2B2E35),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              minimumSize: const Size(80, 35),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(15,5,15,5),
                              child: Text('Discard',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          ///Submit Button
                          Mutation(
                            options: MutationOptions(
                                document: gql(createAnnouncements),
                                onCompleted: (dynamic resultData) {
                                  if (resultData["createAnnouncement"] ==
                                      true) {
                                    Navigator.pop(context);
                                    widget.refetchAnnouncement!();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Announcement Created Successfully')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Announcement Creation Failed')),
                                    );
                                  }
                                },
                                onError: (dynamic error) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text('Announcement Creation Failed, Server Error')
                                  ),
                                  );
                                }),
                            builder: (
                              RunMutation runMutation,
                              QueryResult? result,
                            ) {
                              if (result!.hasException) {
                                return Text(result.exception.toString());
                              }
                              if(result.isLoading){
                                return Center(
                                    child: LoadingAnimationWidget.threeRotatingDots(
                                      color: const Color(0xFF2B2E35),
                                      size: 20,
                                    ));
                              }
                              return ElevatedButton(
                                onPressed: () {
                                  if (_formkey.currentState!.validate()) {
                                    // if(titleController.text.isNotEmpty && endTimeEntered == "Yes") {
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
                                        runMutation({
                                          'announcementInput': {
                                            "title": titleController.text,
                                            "description":
                                            descriptionController.text,
                                            "hostelIds": selectedHostels,
                                            "endTime": "$endTime:00+05:30",
                                          },
                                          "images": multipartFile,
                                        });
                                      }
                                    }
                                  // }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFF2B2E35),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  minimumSize: const Size(80, 35),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(15,5,15,5),
                                  child: Text('Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ]),
          );
        });
  }
}
