import 'dart:convert';
import 'dart:io' as io;
import 'package:client/screens/home/new_post/endTime.dart';
import 'package:client/screens/home/new_post/imageView.dart';
import 'package:client/widgets/text/label.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validators/validators.dart';

import '../../../services/local_storage.dart';

import 'package:client/graphQL/post.dart';
import 'package:client/screens/home/new_post/main.dart';
import 'package:client/screens/home/tag/select_tags.dart';
import 'package:client/screens/home/tag/tags_display.dart';
import 'package:client/services/client.dart';
import 'package:client/themes.dart';
import 'package:client/widgets/buttom_sheet/main.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:client/widgets/form/image_picker.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import '../../../models/date_time_format.dart';
import '../../../models/post/actions.dart';
import '../../../models/post/create_post.dart';
import '../../../models/tag.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../../widgets/helpers/error.dart';

class NewPostScreen extends StatefulWidget {
  final List<io.File>? images;
  final options;
  final post;
  final PostCategoryModel category;
  final CreatePostModel fieldConfiguration;
  const NewPostScreen(
      {Key? key,
      this.images,
      this.post,
      required this.category,
      required this.fieldConfiguration,
      this.options})
      : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  List<io.File> imgs = [];
  bool isLoading = false;
  bool proceed = false;
  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController title = TextEditingController();
  final TextEditingController desc = TextEditingController();
  final TextEditingController link = TextEditingController();
  final TextEditingController location = TextEditingController();
  // final date = TextEditingController();
  // final dateFormated = TextEditingController();
  // final time = TextEditingController();
  // final timeFormated = TextEditingController();
  final dateTimeFormated = TextEditingController();

  late TagsModel selectedTags = TagsModel.fromJson([]);
  late String error;
  String tagError = "";
  DateTime? endTime = null;
  late DateTime? date = null;
  late DateTime? time = null;

  late String endTimeFormated;

  final localStorage = LocalStorageService();

  void onDelete(io.File f) {
    setState(() {
      imgs.remove(f);
    });
  }

  void setEndTime(DateTime e) {
    setState(() {
      endTime = e;
    });
  }

  Future getPostData() async {
    var data = await localStorage.getData("new_post");
    if (data != null) {
      title.text = data["title"];
      desc.text = data["description"];
      // img
      // date.text = data["date"];
      // dateFormated.text =
      //     DateTimeFormatModel.fromString(data["date"]).toFormat("MMM dd, yyyy");
      // time.text = data["time"];
      // timeFormated.text =
      //     DateTimeFormatModel.fromString(data["time"]).toFormat("h:mm a");

      location.text = data["location"];

      link.text = data["link"];
      setState(() {
        selectedTags = TagsModel.fromJson(jsonDecode(data["selectedTags"]));
      });
    }
  }

  void clearForm() {
    localStorage.clearData("new_post");
    title.clear();
    desc.clear();
    link.clear();
    location.clear();
    // date.clear();
    // dateFormated.clear();
    // time.clear();
    // timeFormated.clear();
    setState(() {
      selectedTags = TagsModel.fromJson([]);
    });
  }

  @override
  void initState() {
    getPostData();
    if (widget.images != null) {
      setState(() {
        imgs = widget.images!;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fieldConfiguration = getCreatePostFields[widget.category.name] ??
        getCreatePostFields["Events"]!;
    return Mutation(
        options: MutationOptions(
          document: gql(PostGQl().createPost),
          update: ((cache, result) {
            if (result != null && (!result.hasException)) {
              dynamic data = cache.readQuery(widget.options.asRequest);
              data["findPosts"]["list"] =
                  [result.data!["createPost"]] + data["findPosts"]["list"];
              data["findPosts"]["total"] = data["findPosts"]["total"] + 1;

              cache.writeQuery(widget.options.asRequest, data: data);
              clearForm();
              if (fieldConfiguration.imageSecondary != null) {
                Navigator.pop(context);
              } else {
                Navigator.of(context)
                  ..pop()
                  ..pop();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Posted')),
              );
            }
          }),
          onError: (dynamic error) {
            print(error.toString());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(formatErrorMessage(error.toString()))),
            );
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "NEW POST",
                style: TextStyle(
                    letterSpacing: 2.64,
                    color: Color(0xFF3C3C3C),
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ),
            body: SafeArea(
              child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 10),
                      if (imgs.isNotEmpty)
                        ImageView(
                          images: imgs,
                          onDelete: onDelete,
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 42),
                        child: Column(
                          children: [
                            if (fieldConfiguration.title != null)
                              TextFormField(
                                maxLength: 40,
                                minLines: 1,
                                maxLines: null,
                                controller: title,
                                decoration:
                                    const InputDecoration(label: Text("Title")),
                                validator: (value) {
                                  if (fieldConfiguration.title!.required &&
                                      (value == null || value.isEmpty)) {
                                    return "Enter the title of the post";
                                  }
                                  return null;
                                },
                              ),
                            TextFormField(
                              controller: desc,
                              maxLength: 3000,
                              maxLines: null,
                              decoration: const InputDecoration(
                                  label: Text("Description")),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter the description of the post";
                                }
                              },
                            ),
                            if (fieldConfiguration.postTime != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('When?'),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                            controller: dateTimeFormated,
                                            decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10),
                                                labelText: "Date & Time"),
                                            readOnly: true,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Enter the date & time";
                                              }
                                              return null;
                                            },
                                            onTap: () => showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime.now(),
                                                        lastDate: DateTime.now()
                                                            .add(const Duration(
                                                                days: 30 * 5)))
                                                    .then(
                                                  (value) {
                                                    if (value != null) {
                                                      setState(() {
                                                        date = value;
                                                      });

                                                      print("date : $date");
                                                    }
                                                  },
                                                ).then(
                                                        (value) =>
                                                            showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  TimeOfDay
                                                                      .now(),
                                                            ).then((value) {
                                                              if (value !=
                                                                  null) {
                                                                DateTime
                                                                    _dateTime =
                                                                    DateTime(
                                                                        2021,
                                                                        1,
                                                                        1,
                                                                        value
                                                                            .hour,
                                                                        value
                                                                            .minute);
                                                                setState(() {
                                                                  time =
                                                                      _dateTime;
                                                                });

                                                                dateTimeFormated
                                                                    .text = DateTimeFormatModel(
                                                                            dateTime:
                                                                                date!)
                                                                        .toFormat(
                                                                            "MMM dd, yyyy") +
                                                                    " " +
                                                                    DateTimeFormatModel(
                                                                            dateTime:
                                                                                time!)
                                                                        .toFormat(
                                                                            "h:mm a");

                                                                setState(() {
                                                                  endTime = fieldConfiguration
                                                                          .endTime!
                                                                          .enableEdit
                                                                      ? DateTimeFormatModel.fromString(date.toString().split(" ").first + " " + time.toString().split(" ").last)
                                                                          .dateTime
                                                                          .add(const Duration(
                                                                              hours:
                                                                                  2))
                                                                      : DateTime
                                                                              .now()
                                                                          .add(const Duration(
                                                                              days: 30));
                                                                });

                                                                print(
                                                                    "time : $time");
                                                              }
                                                            }))),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            if (fieldConfiguration.location != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  validator: (value) {
                                    if (fieldConfiguration.location!.required &&
                                        (value == null || value.isEmpty)) {
                                      return "Location is a mandatory field";
                                    }
                                    return null;
                                  },
                                  controller: location,
                                  decoration: const InputDecoration(
                                      label: Text("Where?")),
                                ),
                              ),
                            if (fieldConfiguration.link != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: TextFormField(
                                  controller: link,
                                  decoration: const InputDecoration(
                                      label: Text("link (optional)")),
                                ),
                              ),
                            if (selectedTags.getTagIds().isNotEmpty)
                              TagsDisplay(
                                  tagsModel: selectedTags,
                                  onDelete: (value) => setState(() {
                                        selectedTags = value;
                                      })),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Text(((fieldConfiguration
                                                .imageSecondary !=
                                            null ||
                                        fieldConfiguration.tag != null))
                                    ? "Choose a maximum of " +
                                        ((fieldConfiguration.imageSecondary !=
                                                null)
                                            ? "${fieldConfiguration.imageSecondary!.maxImgs} images "
                                            : '') +
                                        ((fieldConfiguration.imageSecondary !=
                                                    null &&
                                                fieldConfiguration.tag != null)
                                            ? "and "
                                            : "") +
                                        ((fieldConfiguration.tag != null)
                                            ? "7 tags"
                                            : '')
                                    : '')),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (fieldConfiguration.imageSecondary != null)
                                  CustomElevatedButton(
                                      color: Colors.white,
                                      leading: Icons.camera_alt,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                title:
                                                    const Text('Choose Images'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          final XFile? photo =
                                                              await _picker.pickImage(
                                                                  source:
                                                                      ImageSource
                                                                          .camera);
                                                          setState(() {
                                                            if (photo != null) {
                                                              imgs.add(io.File(
                                                                  photo.path));
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          });
                                                        },
                                                        child: const Text(
                                                            'Camera')),
                                                    TextButton(
                                                        onPressed: () async {
                                                          final List<XFile>?
                                                              photos =
                                                              await _picker
                                                                  .pickMultiImage();
                                                          if (photos != null &&
                                                              photos
                                                                  .isNotEmpty) {
                                                            List<io.File>
                                                                files = [];
                                                            for (XFile photo
                                                                in photos) {
                                                              files.add(io.File(
                                                                  photo.path));
                                                            }
                                                            setState(() {
                                                              imgs.addAll(
                                                                  files);
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          }
                                                        },
                                                        child: const Text(
                                                            'Gallegy')),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: const Text(
                                                                "Cancel"))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      textColor: Colors.black,
                                      text: 'Images'),
                                if (fieldConfiguration.tag != null)
                                  CustomElevatedButton(
                                      leading: Icons.tag,
                                      padding: const [0, 2],
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              buildSheet(
                                                  context,
                                                  (controller) => SelectTags(
                                                      selectedTags:
                                                          selectedTags,
                                                      controller: controller,
                                                      callback: (val) {
                                                        setState(() {
                                                          selectedTags = val;
                                                        });
                                                      })),
                                          isScrollControlled: true,
                                        );
                                      },
                                      text: 'Tags'),
                              ],
                            ),
                            if (tagError.isNotEmpty)
                              Text(tagError,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12)),
                            const SizedBox(height: 10),
                            if ((fieldConfiguration.postTime != null &&
                                    endTime != null) ||
                                fieldConfiguration.postTime == null)
                              EndTime(
                                endTime: endTime,
                                setEndtime: setEndTime,
                                edit: fieldConfiguration.endTime!.enableEdit,
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomElevatedButton(
                                      onPressed: () => clearForm(),
                                      text: "Clear",
                                      textSize: 18,
                                      padding: const [25, 15],
                                      textColor: Colors.black,
                                      color: Colors.white),
                                  CustomElevatedButton(
                                    padding: const [25, 15],
                                    textSize: 18,
                                    onPressed: () async {
                                      if ((fieldConfiguration.tag != null &&
                                              fieldConfiguration
                                                  .tag!.required) &&
                                          selectedTags.tags.isEmpty) {
                                        setState(() {
                                          tagError = "Tags not selected";
                                        });
                                      } else if (selectedTags.tags.length > 7) {
                                        setState(() {
                                          tagError =
                                              "Not allowed to select more than 7 tags";
                                        });
                                      } else if (tagError.isNotEmpty &&
                                          selectedTags.tags.isNotEmpty) {
                                        setState(() {
                                          tagError = "";
                                        });
                                      }
                                      final isValid = formKey.currentState!
                                              .validate() &&
                                          (fieldConfiguration.tag != null &&
                                                  selectedTags
                                                      .tags.isNotEmpty &&
                                                  selectedTags.tags.length <=
                                                      7 ||
                                              fieldConfiguration.tag == null);

                                      FocusScope.of(context).unfocus();

                                      if (isValid) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25)),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                          "Think before you post"),
                                                      TextButton(
                                                          onPressed: () async {
                                                            List<String>?
                                                                uploadResult;
                                                            if (imgs
                                                                .isNotEmpty) {
                                                              setState(() {
                                                                isLoading =
                                                                    true;
                                                              });

                                                              try {
                                                                uploadResult =
                                                                    await upload(
                                                                        imgs);
                                                              } catch (e) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content:
                                                                        const Text(
                                                                            'Image Upload Failed'),
                                                                    backgroundColor:
                                                                        Theme.of(context)
                                                                            .errorColor,
                                                                  ),
                                                                );
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
                                                                });
                                                                return;
                                                              }

                                                              setState(() {
                                                                isLoading =
                                                                    false;
                                                              });
                                                            }
                                                            runMutation({
                                                              "postInput": {
                                                                "category":
                                                                    widget
                                                                        .category
                                                                        .name,
                                                                "title":
                                                                    title.text,
                                                                "content":
                                                                    desc.text,
                                                                "location":
                                                                    location
                                                                        .text,
                                                                "tagIds":
                                                                    selectedTags
                                                                        .getTagIds(),
                                                                "link":
                                                                    link.text,
                                                                "postTime": fieldConfiguration
                                                                            .postTime !=
                                                                        null
                                                                    ? date
                                                                            .toString()
                                                                            .split(
                                                                                " ")
                                                                            .first +
                                                                        " " +
                                                                        time
                                                                            .toString()
                                                                            .split(" ")
                                                                            .last
                                                                    : null,
                                                                "endTime": endTime !=
                                                                        null
                                                                    ? endTime!
                                                                        .toIso8601String()
                                                                    : DateTime
                                                                            .now()
                                                                        .add(const Duration(
                                                                            days:
                                                                                5))
                                                                        .toIso8601String(),
                                                                "photoList":
                                                                    uploadResult
                                                                        ?.join(
                                                                            " AND ")
                                                              },
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              'proceed'))
                                                    ],
                                                  ));
                                            });
                                      }
                                    },
                                    text: 'Post',
                                    color:
                                        ColorPalette.palette(context).primary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30)
                    ],
                  )),
            ),
          );
        });
  }

  Future<List<MultipartFile>?> getMultipartFiles(List<dynamic> files) async {
    List<MultipartFile> multipart_files = [];
    if (files.isNotEmpty) {
      for (var item in files) {
        var byteData = await item.readAsBytes();

        var multipartFile = MultipartFile.fromBytes(
          'images',
          byteData,
          filename: '${DateTime.now().second}.jpg',
          contentType: MediaType("image", "jpg"),
        );

        multipart_files.add(multipartFile);
      }
      print("mulipart done");
      return multipart_files;
    } else {
      return null;
    }
  }

  Future<List<String>> upload(List<dynamic> files) async {
    List<MultipartFile>? images = await getMultipartFiles(files);
    if (images == null || images.isEmpty) return [];
    var request = uploadClient();
    request.files.addAll(images);
    try {
      StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        dynamic res = await response.stream.bytesToString();
        print("upload done");
        return jsonDecode(res)["urls"].cast<String>();
      } else {
        throw (await response.stream.bytesToString());
      }
    } on io.SocketException {
      throw ('server error');
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    localStorage.setData("new_post", {
      "title": title.text,
      "description": desc.text,
      "selectedTags": jsonEncode(selectedTags.toJson()),
      // "date": date.text,
      // "time": time.text,
      "location": location.text,
      "link": link.text,
    });

    super.dispose();
  }
}
