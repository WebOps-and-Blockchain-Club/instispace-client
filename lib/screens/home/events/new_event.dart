import 'dart:convert';

import 'package:client/graphQL/events.dart';
import 'package:client/models/event.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../services/image_picker.dart';
import '../../../services/local_storage.dart';
import '../../../models/tag.dart';
import '../../../models/date_time_format.dart';
import '../../../screens/home/tag/tags_display.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/form/text_form_field.dart';
import '../../../widgets/text/label.dart';
import '../tag/select_tags.dart';

class NewEvent extends StatefulWidget {
  final Future<QueryResult<Object?>?> Function()? refetch;
  final EditEventModel? event;
  const NewEvent({Key? key, required this.refetch, this.event})
      : super(key: key);

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  //Keys
  final formKey = GlobalKey<FormState>();

  //Controllers
  final title = TextEditingController();
  final description = TextEditingController();
  final date = TextEditingController();
  final dateFormated = TextEditingController();
  final time = TextEditingController();
  final timeFormated = TextEditingController();
  final location = TextEditingController();
  final ctaName = TextEditingController();
  final ctaLink = TextEditingController();

  // Graphql
  String createEvent = EventGQL().create;
  String editEvent = EventGQL().edit;

  // Variables
  late TagsModel selectedTags = TagsModel.fromJson([]);
  String tagError = "";

  // Services
  final localStorage = LocalStorageService();

  Future getEventData(EditEventModel? _event) async {
    if (_event != null) {
      title.text = _event.title;
      description.text = _event.description;
      // img
      date.text = _event.time;
      dateFormated.text =
          DateTimeFormatModel.fromString(_event.time).toFormat("MMM dd, yyyy");
      time.text = _event.time;
      timeFormated.text =
          DateTimeFormatModel.fromString(_event.time).toFormat("h:mm a");
      location.text = _event.location;
      if (_event.cta?.name != null) ctaName.text = _event.cta!.name;
      if (_event.cta?.link != null) ctaLink.text = _event.cta!.link;
      setState(() {
        selectedTags = _event.tags;
      });
    } else {
      var data = await localStorage.getData("new_event");
      if (data != null) {
        title.text = data["title"];
        description.text = data["description"];
        // img
        date.text = data["date"];
        dateFormated.text = DateTimeFormatModel.fromString(data["date"])
            .toFormat("MMM dd, yyyy");
        time.text = data["time"];
        timeFormated.text =
            DateTimeFormatModel.fromString(data["time"]).toFormat("h:mm a");
        location.text = data["location"];
        ctaName.text = data["ctaName"];
        ctaLink.text = data["ctaLink"];
        setState(() {
          selectedTags = TagsModel.fromJson(jsonDecode(data["selectedTags"]));
        });
      }
    }
  }

  void clearData() {
    if (widget.event == null) localStorage.clearData("new_event");
    title.clear();
    description.clear();
    // img
    date.clear();
    dateFormated.clear();
    time.clear();
    timeFormated.clear();
    location.clear();
    ctaName.clear();
    ctaLink.clear();
    setState(() {
      selectedTags = TagsModel.fromJson([]);
    });
  }

  @override
  void initState() {
    getEventData(widget.event);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
            document: gql(widget.event != null ? editEvent : createEvent),
            onCompleted: (dynamic resultData) {
              if (resultData["createEvent"] == true) {
                widget.refetch!();
                clearData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post Created')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post Creation Failed')),
                );
              }
            },
            onError: (dynamic error) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Post Creation Failed, Server Error')),
              );
            }),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return ChangeNotifierProvider(
            create: (_) => ImagePickerService(),
            child: Consumer<ImagePickerService>(
                builder: (context, imagePickerService, child) {
              return Scaffold(
                body: SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: formKey,
                    child: ListView(
                      children: [
                        CustomAppBar(
                            title: "New Event",
                            leading: CustomIconButton(
                              icon: Icons.arrow_back,
                              onPressed: () => Navigator.of(context).pop(),
                            )),

                        /// Info
                        const LabelText(text: "Info"),
                        // Title
                        CustomTextFormField(
                          controller: title,
                          labelText: "Title",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the title of the post";
                            }
                            return null;
                          },
                        ),
                        // Description
                        CustomTextFormField(
                          controller: description,
                          labelText: "Description",
                          minLines: 3,
                          maxLines: 8,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the description of the post";
                            }
                            return null;
                          },
                        ),

                        // Date Time
                        const LabelText(text: "Time & Location"),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: CustomTextFormField(
                                    controller: dateFormated,
                                    labelText: "Event Date",
                                    prefixIcon: Icons.calendar_month_outlined,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter the event date of the post";
                                      }
                                      return null;
                                    },
                                    readOnly: true,
                                    onTap: () => showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now().add(
                                                    const Duration(days: 7)),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.now().add(
                                                    const Duration(
                                                        days: 30 * 5)))
                                            .then((value) {
                                          if (value != null) {
                                            date.text = value.toString();
                                            DateTimeFormatModel _date =
                                                DateTimeFormatModel(
                                                    dateTime: value);
                                            dateFormated.text =
                                                _date.toFormat("MMM dd, yyyy");
                                          }
                                        }))),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: CustomTextFormField(
                                  controller: timeFormated,
                                  labelText: "Event Time",
                                  prefixIcon: Icons.access_time_outlined,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter the event time of the post";
                                    }
                                    return null;
                                  },
                                  readOnly: true,
                                  onTap: () => showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        if (value != null) {
                                          DateTime _dateTime = DateTime(2021, 1,
                                              1, value.hour, value.minute);
                                          time.text = _dateTime.toString();
                                          DateTimeFormatModel _time =
                                              DateTimeFormatModel(
                                                  dateTime: _dateTime);
                                          timeFormated.text =
                                              _time.toFormat("h:mm a");
                                        }
                                      })),
                            ),
                          ],
                        ),

                        // Location
                        CustomTextFormField(
                          controller: location,
                          labelText: "Location",
                          prefixIcon: Icons.location_on_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the location of the post";
                            }
                            return null;
                          },
                        ),

                        // Images & Tags
                        const LabelText(text: "Image & Tags"),
                        // Selected Image
                        imagePickerService.previewImages(),
                        // Selected Tags
                        TagsDisplay(
                            tagsModel: selectedTags,
                            onDelete: (value) => setState(() {
                                  selectedTags = value;
                                })),
                        if (tagError.isNotEmpty)
                          Text(tagError,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            imagePickerService.pickImageButton(context),
                            const SizedBox(
                              width: 20,
                            ),
                            CustomElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) => buildSheet(
                                    context,
                                    selectedTags,
                                    (value) {
                                      setState(() {
                                        selectedTags = value;
                                      });
                                    },
                                    null,
                                  ),
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10)),
                                  ),
                                );
                              },
                              text: "Select Tags",
                              backgroundColor: Colors.white,
                              borderColor: const Color(0xFF2f247b),
                              textColor: const Color(0xFF2f247b),
                            ),
                          ],
                        ),

                        // CTA (optional)
                        const LabelText(text: "Call To Action(Optional)"),
                        CustomTextFormField(
                          controller: ctaName,
                          labelText: "Display Text",
                          prefixIcon: Icons.text_fields,
                        ),
                        CustomTextFormField(
                          controller: ctaLink,
                          labelText: "Link",
                          prefixIcon: Icons.link,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Expanded(
                                  child: CustomElevatedButton(
                                onPressed: clearData,
                                text: "Clear",
                                backgroundColor: Colors.green[50] as Color,
                                textColor: Colors.green,
                              )),
                              const SizedBox(width: 20),
                              Expanded(
                                  child: CustomElevatedButton(
                                onPressed: () async {
                                  if (selectedTags.tags.isEmpty) {
                                    setState(() {
                                      tagError = "Tags not selected";
                                    });
                                  } else if (tagError.isNotEmpty &&
                                      selectedTags.tags.isNotEmpty) {
                                    setState(() {
                                      tagError = "";
                                    });
                                  }
                                  final isValid =
                                      formKey.currentState!.validate() &&
                                          selectedTags.tags.isNotEmpty;
                                  FocusScope.of(context).unfocus();

                                  DateTimeFormatModel _dateTime =
                                      DateTimeFormatModel.fromString(
                                          date.text.split(" ").first +
                                              " " +
                                              time.text.split(" ").last);

                                  if (isValid) {
                                    List<MultipartFile>? image =
                                        await imagePickerService
                                            .getMultipartFiles();
                                    if (widget.event != null) {
                                      runMutation({
                                        "editData": {
                                          "content": description.text,
                                          "title": title.text,
                                          "tagIds": selectedTags.getTagIds(),
                                          "time": _dateTime.toISOFormat(),
                                          "linkName": ctaName.text,
                                          "linkToAction": ctaLink.text,
                                          "location": location.text,
                                        },
                                        "id": widget.event!.id,
                                        "image": image,
                                      });
                                    } else {
                                      runMutation({
                                        "newData": {
                                          "title": title.text,
                                          "content": description.text,
                                          "location": location.text,
                                          "tagIds": selectedTags.getTagIds(),
                                          "time": _dateTime.toISOFormat(),
                                          "linkName": ctaName.text,
                                          "linkToAction": ctaLink.text,
                                        },
                                        "image": image
                                      });
                                    }
                                  }
                                },
                                text: "Save",
                                isLoading: result!.isLoading,
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
              );
            }),
          );
        });
    // return
  }

  @override
  void dispose() {
    if (widget.event == null) {
      localStorage.setData("new_event", {
        "title": title.text,
        "description": description.text,
        "selectedTags": jsonEncode(selectedTags.toJson()),
        "date": date.text,
        "time": time.text,
        "location": location.text,
        "ctaName": ctaName.text,
        "ctaLink": ctaLink.text
      });
    }
    super.dispose();
  }
}
