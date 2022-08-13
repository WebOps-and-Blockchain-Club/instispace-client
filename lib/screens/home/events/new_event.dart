import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../widgets/helpers/error.dart';
import '../../../services/image_picker.dart';
import '../../../services/local_storage.dart';
import '../../../graphQL/events.dart';
import '../../../models/event.dart';
import '../../../models/tag.dart';
import '../../../models/date_time_format.dart';
import '../../../screens/home/tag/tags_display.dart';
import '../../../themes.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/text/label.dart';
import '../tag/select_tags.dart';

class NewEvent extends StatefulWidget {
  final QueryOptions options;
  final EditEventModel? event;
  const NewEvent({Key? key, required this.options, this.event})
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
  List<String>? imageUrls;
  late TagsModel selectedTags = TagsModel.fromJson([]);
  String tagError = "";
  bool isLoading = false;

  // Services
  final localStorage = LocalStorageService();

  Future getEventData(EditEventModel? _event) async {
    if (_event != null) {
      DateTimeFormatModel _time = DateTimeFormatModel.fromString(_event.time);
      title.text = _event.title;
      description.text = _event.description;
      date.text = _time.dateTime.toString();
      dateFormated.text = _time.toFormat("MMM dd, yyyy");
      time.text = _time.dateTime.toString();
      timeFormated.text = _time.toFormat("h:mm a");
      location.text = _event.location;
      if (_event.cta?.name != null) ctaName.text = _event.cta!.name;
      if (_event.cta?.link != null) ctaLink.text = _event.cta!.link;
      setState(() {
        imageUrls = _event.imageUrl != null ? [_event.imageUrl!] : null;
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
            update: (cache, result) {
              if (result != null && (!result.hasException)) {
                if (widget.event != null) {
                  cache.writeFragment(
                    Fragment(document: gql(EventGQL.editFragment))
                        .asRequest(idFields: {
                      '__typename': "Event",
                      'id': widget.event!.id,
                    }),
                    data: result.data!["editEvent"],
                    broadcast: false,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Event Edited')),
                  );
                } else {
                  dynamic data = cache.readQuery(widget.options.asRequest);
                  data["getEvents"]["list"] =
                      [result.data!["createEvent"]] + data["getEvents"]["list"];
                  data["getEvents"]["total"] = data["getEvents"]["total"] + 1;
                  cache.writeQuery(widget.options.asRequest, data: data);
                  clearData();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Event Created')),
                  );
                }
              }
            },
            onError: (dynamic error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(formatErrorMessage(error.toString()))),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: title,
                            decoration:
                                const InputDecoration(labelText: "Title"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter the title of the post";
                              }
                              return null;
                            },
                          ),
                        ),
                        // Description
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: description,
                            minLines: 3,
                            maxLines: 8,
                            decoration:
                                const InputDecoration(labelText: "Description"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter the description of the post";
                              }
                              return null;
                            },
                          ),
                        ),

                        // Date Time
                        const LabelText(text: "Time & Location"),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                  controller: dateFormated,
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.calendar_month_outlined,
                                          size: 20),
                                      prefixIconConstraints:
                                          Themes.inputIconConstraints,
                                      labelText: "Event Date"),
                                  readOnly: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter the event date of the post";
                                    }
                                    return null;
                                  },
                                  onTap: () => showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now()
                                                  .add(const Duration(days: 7)),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime.now().add(
                                                  const Duration(days: 30 * 5)))
                                          .then(
                                        (value) {
                                          if (value != null) {
                                            date.text = value.toString();
                                            DateTimeFormatModel _date =
                                                DateTimeFormatModel(
                                                    dateTime: value);
                                            dateFormated.text =
                                                _date.toFormat("MMM dd, yyyy");
                                          }
                                        },
                                      )),
                            )),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                  controller: timeFormated,
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.access_time_outlined,
                                          size: 20),
                                      prefixIconConstraints:
                                          Themes.inputIconConstraints,
                                      labelText: "Event Time"),
                                  readOnly: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter the event time of the post";
                                    }
                                    return null;
                                  },
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
                            )),
                          ],
                        ),

                        // Location
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: location,
                            decoration: InputDecoration(
                              labelText: "Location",
                              prefixIcon: const Icon(Icons.location_on_outlined,
                                  size: 20),
                              prefixIconConstraints:
                                  Themes.inputIconConstraints,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter the location of the post";
                              }
                              return null;
                            },
                          ),
                        ),

                        // Images & Tags
                        const LabelText(
                            text: "Image & Tags (Select maximum of 1 image)"),
                        // Selected Image
                        imagePickerService.previewImages(
                            imageUrls: imageUrls,
                            removeImageUrl: (value) {
                              setState(() {
                                imageUrls!.removeAt(value);
                              });
                            }),
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
                            imagePickerService.pickImageButton(
                              context: context,
                              preSelectedNoOfImages:
                                  imageUrls != null ? imageUrls!.length : 0,
                            ),
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
                                );
                              },
                              text: "Select Tags",
                              color: ColorPalette.palette(context).primary,
                              type: ButtonType.outlined,
                            ),
                          ],
                        ),

                        // CTA (optional)
                        const LabelText(text: "Call To Action(Optional)"),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: ctaName,
                            decoration: InputDecoration(
                              labelText: "Display Text",
                              prefixIcon:
                                  const Icon(Icons.text_fields, size: 20),
                              prefixIconConstraints:
                                  Themes.inputIconConstraints,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: ctaLink,
                            decoration: InputDecoration(
                              labelText: "Link",
                              prefixIcon: const Icon(Icons.link, size: 20),
                              prefixIconConstraints:
                                  Themes.inputIconConstraints,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Expanded(
                                  child: CustomElevatedButton(
                                onPressed: clearData,
                                text: "Clear",
                                color: ColorPalette.palette(context).success,
                                type: ButtonType.outlined,
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
                                      setState(() {
                                        isLoading = true;
                                      });
                                      QueryResult? uploadResult =
                                          await imagePickerService
                                              .uploadImage();
                                      setState(() {
                                        isLoading = false;
                                      });
                                      print(imageUrls);
                                      print(uploadResult?.data?["imageUpload"]
                                          ["imageUrls"]);

                                      runMutation({
                                        "editData": {
                                          "content": description.text,
                                          "title": title.text,
                                          "tagIds": selectedTags.getTagIds(),
                                          "time": _dateTime.toISOFormat(),
                                          "linkName": ctaName.text,
                                          "linkToAction": ctaLink.text,
                                          "location": location.text,
                                          "imageUrls": (imageUrls ?? []) +
                                              (uploadResult
                                                      ?.data!["imageUpload"]
                                                          ["imageUrls"]
                                                      ?.cast<String>() ??
                                                  []),
                                        },
                                        "id": widget.event!.id,
                                        // "image": image,
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
                                isLoading: result!.isLoading || isLoading,
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
