import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../services/image_picker.dart';
import '../../../services/local_storage.dart';
import '../../../graphQL/netops.dart';
import '../../../models/netop.dart';
import '../../../models/tag.dart';
import '../../../models/date_time_format.dart';
import '../../../screens/home/tag/tags_display.dart';
import '../../../themes.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/text/label.dart';
import '../tag/select_tags.dart';

class NewNetopPage extends StatefulWidget {
  final QueryOptions options;
  final EditNetopModel? netop;
  const NewNetopPage({Key? key, required this.options, this.netop})
      : super(key: key);

  @override
  State<NewNetopPage> createState() => _NewNetopPageState();
}

class _NewNetopPageState extends State<NewNetopPage> {
  //Keys
  final formKey = GlobalKey<FormState>();

  //Controllers
  final title = TextEditingController();
  final description = TextEditingController();
  final date = TextEditingController();
  final dateFormated = TextEditingController();
  final endTime = TextEditingController();
  final timeFormated = TextEditingController();
  final ctaName = TextEditingController();
  final ctaLink = TextEditingController();

  // Graphql
  String create = NetopGQL.create;
  String edit = NetopGQL.edit;

  // Variables
  late TagsModel selectedTags = TagsModel.fromJson([]);
  String tagError = "";

  // Services
  List<String>? imageUrls;
  final localStorage = LocalStorageService();

  Future getNetopData(EditNetopModel? _netop) async {
    if (_netop != null) {
      title.text = _netop.title;
      description.text = _netop.description;
      DateTimeFormatModel _time =
          DateTimeFormatModel.fromString(_netop.endTime);
      date.text = _time.dateTime.toString();
      dateFormated.text = _time.toFormat("MMM dd, yyyy");
      endTime.text = _time.dateTime.toString();
      timeFormated.text = _time.toFormat("h:mm a");
      if (_netop.cta?.name != null) ctaName.text = _netop.cta!.name;
      if (_netop.cta?.link != null) ctaLink.text = _netop.cta!.link;
      setState(() {
        imageUrls = _netop.imageUrls;
        selectedTags = _netop.tags;
      });
    } else {
      var data = await localStorage.getData("new_netop");
      if (data != null) {
        title.text = data["title"];
        description.text = data["description"];
        // img
        date.text = data["date"];
        dateFormated.text = DateTimeFormatModel.fromString(data["date"])
            .toFormat("MMM dd, yyyy");
        endTime.text = data["endTime"];
        timeFormated.text =
            DateTimeFormatModel.fromString(data["endTime"]).toFormat("h:mm a");
        ctaName.text = data["ctaName"];
        ctaLink.text = data["ctaLink"];
        setState(() {
          selectedTags = TagsModel.fromJson(jsonDecode(data["selectedTags"]));
        });
      }
    }
  }

  void clearData() {
    if (widget.netop == null) localStorage.clearData("new_netop");
    title.clear();
    description.clear();
    // img
    date.clear();
    dateFormated.clear();
    endTime.clear();
    timeFormated.clear();
    ctaName.clear();
    ctaLink.clear();
    setState(() {
      selectedTags = TagsModel.fromJson([]);
    });
  }

  @override
  void initState() {
    getNetopData(widget.netop);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
            document: gql(widget.netop != null ? edit : create),
            update: (cache, result) {
              if (result != null && (!result.hasException)) {
                if (widget.netop != null) {
                  cache.writeFragment(
                    Fragment(document: gql(NetopGQL.editFragment))
                        .asRequest(idFields: {
                      '__typename': "Netop",
                      'id': widget.netop!.id,
                    }),
                    data: result.data!["editNetop"],
                    broadcast: false,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post Edited')),
                  );
                } else {
                  dynamic data = cache.readQuery(widget.options.asRequest);
                  data["getNetops"]["netopList"] = [
                        result.data!["createNetop"]
                      ] +
                      data["getNetops"]["netopList"];
                  data["getNetops"]["total"] = data["getNetops"]["total"] + 1;
                  cache.writeQuery(widget.options.asRequest, data: data);
                  clearData();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post Created')),
                  );
                }
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
            create: (_) => ImagePickerService(noOfImages: 4),
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
                            title: "New Post",
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
                        const LabelText(
                            text: "How long do you need this post to be live?"),
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
                                      labelText: "Date"),
                                  readOnly: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter the date";
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
                                      labelText: "Time"),
                                  readOnly: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter the time";
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
                                          endTime.text = _dateTime.toString();
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

                        // Images & Tags
                        const LabelText(
                            text: "Image & Tags (Select maximum of 4 image)"),
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
                                              endTime.text.split(" ").last);

                                  if (isValid) {
                                    List<MultipartFile>? image =
                                        await imagePickerService
                                            .getMultipartFiles();
                                    if (widget.netop != null) {
                                      runMutation({
                                        "editData": {
                                          "title": title.text,
                                          "content": description.text,
                                          "tagIds": selectedTags.getTagIds(),
                                          "endTime": _dateTime.toISOFormat(),
                                          "imageUrls": imageUrls,
                                          "linkName": ctaName.text,
                                          "linkToAction": ctaLink.text,
                                        },
                                        "id": widget.netop!.id,
                                        "images": image,
                                      });
                                    } else {
                                      runMutation({
                                        "newData": {
                                          "title": title.text,
                                          "content": description.text,
                                          "tags": selectedTags.getTagIds(),
                                          "endTime": _dateTime.toISOFormat(),
                                          "linkName": ctaName.text,
                                          "linkToAction": ctaLink.text,
                                        },
                                        "images": image
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
  }

  @override
  void dispose() {
    if (widget.netop == null) {
      localStorage.setData("new_netop", {
        "title": title.text,
        "description": description.text,
        "selectedTags": jsonEncode(selectedTags.toJson()),
        "date": date.text,
        "endTime": endTime.text,
        "ctaName": ctaName.text,
        "ctaLink": ctaLink.text
      });
    }
    super.dispose();
  }
}
