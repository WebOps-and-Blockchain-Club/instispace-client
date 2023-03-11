import 'dart:convert';
import 'dart:io' as io;
import 'package:client/graphQL/feed.dart';
import 'package:client/models/category.dart';
import 'package:client/screens/home/new_post/endTime.dart';
import 'package:client/screens/home/new_post/imageService.dart';
import 'package:client/screens/home/new_post/imageView.dart';
import 'package:client/widgets/card/image.dart';

import '../../../models/post/main.dart';
import '../../../services/local_storage.dart';

import 'package:client/graphQL/post.dart';

import 'package:client/screens/home/tag/select_tags.dart';
import 'package:client/screens/home/tag/tags_display.dart';

import 'package:client/themes.dart';
import 'package:client/widgets/buttom_sheet/main.dart';
import 'package:client/widgets/button/elevated_button.dart';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../models/date_time_format.dart';

import '../../../models/post/create_post.dart';
import '../../../models/tag.dart';

import '../../../../widgets/helpers/error.dart';

class NewPostScreen extends StatefulWidget {
  final List<io.File>? images;
  final QueryOptions options;
  final PostModel? post;
  final PostCategoryModel category;
  final CreatePostModel fieldConfiguration;
  const NewPostScreen(
      {Key? key,
      this.images,
      this.post,
      required this.category,
      required this.fieldConfiguration,
      required this.options})
      : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  List<io.File> imgs = [];
  Map<dynamic, String> img_map = {};
  bool isLoading = false;
  bool proceed = false;
  final formKey = GlobalKey<FormState>();

  final TextEditingController title = TextEditingController();
  final TextEditingController desc = TextEditingController();
  final TextEditingController link = TextEditingController();
  final TextEditingController location = TextEditingController();
  final imgService = ImageService();

  late TagsModel selectedTags = TagsModel.fromJson([]);
  late String error;
  String tagError = "";

  final dateTimeFormated = TextEditingController();
  late DateTime? endTime = null;
  late DateTime? date = null;
  late DateTime? time = null;
  late String? endTimeFormated = null;

  final localStorage = LocalStorageService();

  void onDelete(dynamic f) {
    if (widget.post != null) {
      setState(() {
        img_map.remove(f);
      });
    } else {
      setState(() {
        imgs.remove(f);
      });
    }
  }

  void setEndTime(DateTime e) {
    setState(() {
      endTime = e;
    });
  }

  Future getPostData(PostModel? post) async {
    if (widget.post != null) {
      title.text = post!.title ?? '';
      desc.text = post.content!;
      link.text = post.link?.link ?? '';
      location.text = post.location ?? '';
      setState(() {
        date = post.eventTime != null
            ? DateTimeFormatModel.fromString(post.eventTime!).dateTime
            : null;
        time = post.eventTime != null
            ? DateTimeFormatModel.fromString(post.eventTime!).dateTime
            : null;

        dateTimeFormated.text = date != null
            ? DateTimeFormatModel(dateTime: date!).toFormat("MMM dd, yyyy") +
                " " +
                DateTimeFormatModel(dateTime: time!).toFormat("h:mm a")
            : '';
        if (widget.fieldConfiguration.endTime != null) {
          endTime = DateTimeFormatModel.fromString(post.endTime!).dateTime;
        }
        selectedTags = post.tags ?? TagsModel.fromJson([]);
      });
    } else {
      var data = await localStorage.getData(widget.category.name);
      if (data != null) {
        title.text = data["title"];
        desc.text = data["description"];
        dateTimeFormated.text = data['dateTimeFormated'];

        location.text = data["location"];

        link.text = data["link"];
        setState(() {
          selectedTags = TagsModel.fromJson(jsonDecode(data["selectedTags"]));
          endTimeFormated = data['endTimeFormated'];
          date = data['date'];
          time = data['time'];
          endTime = data['endTime'];
        });
      }
    }
  }

  void clearForm() {
    localStorage.clearData("new_post");
    title.clear();
    desc.clear();
    link.clear();
    location.clear();

    dateTimeFormated.clear();

    setState(() {
      selectedTags = TagsModel.fromJson([]);
      date = null;
      time = null;
      endTime = null;
      endTimeFormated = null;
    });
  }

  @override
  void initState() {
    getPostData(widget.post);
    if (widget.images != null) {
      setState(() {
        imgs = widget.images!;
      });
    }
    if (widget.fieldConfiguration.postTime == null &&
        widget.fieldConfiguration.endTime != null) {
      setState(() {
        endTime = DateTime.now().add(widget.fieldConfiguration.endTime!.time);
      });
    }
    if (widget.post != null && widget.post!.attachement != null) {
      for (var img in widget.post!.attachement!) {
        setState(() {
          img_map[img] = 'link';
        });
      }
    }
    if (widget.post != null && widget.post!.photo != null) {
      for (var img in widget.post!.photo!) {
        setState(() {
          img_map[img] = 'link';
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mutation =
        widget.post == null ? PostGQl().createPost : PostGQl().editPost;
    return Mutation(
        options: MutationOptions(
          document: gql(mutation),
          update: ((cache, result) {
            if (result != null && (!result.hasException)) {
              if (widget.post != null) {
                cache.writeFragment(
                  Fragment(document: gql(FeedGQL().editFragment))
                      .asRequest(idFields: {
                    '__typename': "Post",
                    'id': widget.post!.id,
                  }),
                  data: result.data!["updatePost"],
                  broadcast: false,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post Edited')),
                );
              } else {
                dynamic data = cache.readQuery(widget.options.asRequest);
                data["findPosts"]["list"] =
                    [result.data!["createPost"]] + data["findPosts"]["list"];
                data["findPosts"]["total"] = data["findPosts"]["total"] + 1;

                cache.writeQuery(widget.options.asRequest, data: data);
                clearForm();
                if (widget.fieldConfiguration.imageSecondary != null) {
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
            }
          }),
          onError: (dynamic error) {
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
              title: Text(
                "${widget.post == null ? 'NEW' : 'EDIT'} ${widget.category.name.toUpperCase()}",
                style: const TextStyle(
                    letterSpacing: 1,
                    color: Color(0xFF3C3C3C),
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
            body: SafeArea(
              child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 10),

                      // images
                      if (imgs.isNotEmpty)
                        ImageView(
                          images: imgs,
                          onDelete: onDelete,
                        ),
                      if (img_map.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: ImageCard(
                              dynamic_images:
                                  (img_map.isNotEmpty) ? img_map : null,
                              onDelete: onDelete),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 42),
                        child: Column(
                          children: [
                            //title
                            if (widget.fieldConfiguration.title != null)
                              TextFormField(
                                maxLength: 40,
                                minLines: 1,
                                maxLines: null,
                                controller: title,
                                decoration:
                                    const InputDecoration(label: Text("Title")),
                                validator: (value) {
                                  if (widget
                                          .fieldConfiguration.title!.required &&
                                      (value == null || value.isEmpty)) {
                                    return "Enter the title of the post";
                                  }
                                  return null;
                                },
                              ),

                            //description
                            TextFormField(
                              controller: desc,
                              maxLength: 3000,
                              maxLines: null,
                              decoration: InputDecoration(
                                  label: Text(widget.category.name == "Lost" ||
                                          widget.category.name == "Found"
                                      ? "Item description, Contact info"
                                      : "Description")),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter the description of the post";
                                }
                                return null;
                              },
                            ),

                            //date and time
                            if (widget.fieldConfiguration.postTime != null)
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
                                                        firstDate: widget
                                                                        .category
                                                                        .name ==
                                                                    'Lost' ||
                                                                widget.category
                                                                        .name ==
                                                                    'Found'
                                                            ? DateTime.now().subtract(
                                                                const Duration(
                                                                    days: 30))
                                                            : DateTime.now(),
                                                        lastDate: DateTime.now()
                                                            .add(const Duration(days: 30 * 5)))
                                                    .then(
                                                  (value) {
                                                    if (value != null) {
                                                      setState(() {
                                                        date = value;
                                                      });
                                                    }
                                                  },
                                                ).then((value) => showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                              TimeOfDay.now(),
                                                        ).then((value) {
                                                          if (value != null) {
                                                            DateTime _dateTime =
                                                                DateTime(
                                                                    2021,
                                                                    1,
                                                                    1,
                                                                    value.hour,
                                                                    value
                                                                        .minute);
                                                            setState(() {
                                                              time = _dateTime;
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
                                                              endTime = DateTimeFormatModel.fromString(date
                                                                          .toString()
                                                                          .split(
                                                                              " ")
                                                                          .first +
                                                                      " " +
                                                                      time
                                                                          .toString()
                                                                          .split(
                                                                              " ")
                                                                          .last)
                                                                  .dateTime
                                                                  .add(widget
                                                                      .fieldConfiguration
                                                                      .endTime!
                                                                      .time);
                                                            });
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

                            //location
                            if (widget.fieldConfiguration.location != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  validator: (value) {
                                    if (widget.fieldConfiguration.location!
                                            .required &&
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

                            //link
                            if (widget.fieldConfiguration.link != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: TextFormField(
                                  controller: link,
                                  decoration: const InputDecoration(
                                      label: Text("link (optional)")),
                                ),
                              ),

                            //display chosen tags
                            if (selectedTags.getTagIds().isNotEmpty)
                              TagsDisplay(
                                  tagsModel: selectedTags,
                                  onDelete: (value) => setState(() {
                                        selectedTags = value;
                                      })),

                            // pick images (if imageSecondary or edit post)
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15),
                                child: Text(((widget.fieldConfiguration
                                                .imageSecondary !=
                                            null ||
                                        widget.fieldConfiguration.tag != null))
                                    ? "Choose a maximum of " +
                                        ((widget.fieldConfiguration
                                                    .imageSecondary !=
                                                null)
                                            ? "${widget.fieldConfiguration.imageSecondary!.maxImgs} images "
                                            : '') +
                                        ((widget.fieldConfiguration
                                                        .imageSecondary !=
                                                    null &&
                                                widget.fieldConfiguration.tag !=
                                                    null)
                                            ? "and "
                                            : '') +
                                        ((widget.fieldConfiguration.tag != null)
                                            ? "7 tags"
                                            : '')
                                    : '')),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (widget.fieldConfiguration.imageSecondary !=
                                        null ||
                                    widget.post != null)
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
                                                          final io.File? photo =
                                                              await imgService
                                                                  .pickCamera();

                                                          if (photo != null) {
                                                            if (widget.post !=
                                                                null) {
                                                              setState(() {
                                                                img_map[photo] =
                                                                    'file';
                                                              });
                                                            } else {
                                                              setState(() {
                                                                imgs.add(photo);
                                                              });
                                                            }

                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        },
                                                        child: const Text(
                                                            'Camera')),
                                                    TextButton(
                                                        onPressed: () async {
                                                          final List<io.File>
                                                              photos =
                                                              await imgService
                                                                  .pickGalley();

                                                          if (photos
                                                              .isNotEmpty) {
                                                            if (widget.post !=
                                                                null) {
                                                              for (var photo
                                                                  in photos) {
                                                                setState(() {
                                                                  img_map[photo] =
                                                                      'file';
                                                                });
                                                              }
                                                            } else {
                                                              setState(() {
                                                                imgs.addAll(
                                                                    photos);
                                                              });
                                                            }

                                                            Navigator.pop(
                                                                context);
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

                                // select tags
                                if (widget.fieldConfiguration.tag != null)
                                  CustomElevatedButton(
                                      leading: Icons.tag,
                                      padding: const [0, 2],
                                      onPressed: () => selectTags(),
                                      text: 'Tags'),
                              ],
                            ),

                            //tag error
                            if (tagError.isNotEmpty)
                              Text(tagError,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12)),
                            const SizedBox(height: 10),

                            //end time of the post
                            if ((endTime != null ||
                                    widget.fieldConfiguration.postTime ==
                                        null) &&
                                widget.fieldConfiguration.endTime != null)
                              EndTime(
                                endTime: (widget
                                        .fieldConfiguration.endTime!.enableEdit)
                                    ? endTime
                                    : DateTime.now()
                                        .add(const Duration(days: 30)),
                                setEndtime: setEndTime,
                                edit: widget
                                    .fieldConfiguration.endTime!.enableEdit,
                              ),

                            //clear and post buttons
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
                                      if ((widget.fieldConfiguration.tag !=
                                                  null &&
                                              widget.fieldConfiguration.tag!
                                                  .required) &&
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
                                          (widget.fieldConfiguration.tag !=
                                                      null &&
                                                  selectedTags
                                                      .tags.isNotEmpty &&
                                                  selectedTags.tags.length <=
                                                      7 ||
                                              widget.fieldConfiguration.tag ==
                                                  null);

                                      FocusScope.of(context).unfocus();

                                      if (isValid) {
                                        String mut_inp = widget.post == null
                                            ? "postInput"
                                            : "updatePostInput";

                                        List<String>? uploadResult;

                                        if (imgs.isNotEmpty) {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          try {
                                            uploadResult =
                                                await imgService.upload(imgs);
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                    'Image Upload Failed'),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .errorColor,
                                              ),
                                            );
                                            setState(() {
                                              isLoading = false;
                                            });
                                            return;
                                          }

                                          setState(() {
                                            isLoading = false;
                                          });
                                        } else if (img_map.isNotEmpty) {
                                          uploadResult = [];
                                          setState(() {
                                            isLoading = true;
                                          });

                                          List<io.File> files = [];

                                          for (var img in img_map.keys) {
                                            if (img_map[img] == 'file') {
                                              files.add(img);
                                            } else {
                                              uploadResult.add(img);
                                            }
                                          }

                                          try {
                                            var res =
                                                await imgService.upload(files);
                                            uploadResult.addAll(res);
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                    'Image Upload Failed'),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .errorColor,
                                              ),
                                            );
                                            setState(() {
                                              isLoading = false;
                                            });
                                            return;
                                          }

                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                        final List<String> tags = selectedTags
                                            .getTagIds()
                                            .cast<String>();
                                        print('upload result : ');
                                        print(
                                          widget.fieldConfiguration.postTime !=
                                                  null
                                              ? date
                                                      .toString()
                                                      .split(" ")
                                                      .first +
                                                  " " +
                                                  time
                                                      .toString()
                                                      .split(" ")
                                                      .last
                                              : null,
                                        );
                                        runMutation({
                                          "updatePostId":
                                              widget.post?.id.toString(),
                                          mut_inp: {
                                            "category": widget.category.name,
                                            "title": title.text,
                                            "content": desc.text,
                                            "location": location.text,
                                            "link": link.text,
                                            "tagIds": tags,
                                            "postTime": widget
                                                        .fieldConfiguration
                                                        .postTime !=
                                                    null
                                                ? date
                                                        .toString()
                                                        .split(" ")
                                                        .first +
                                                    " " +
                                                    time
                                                        .toString()
                                                        .split(" ")
                                                        .last
                                                : null,
                                            "endTime":
                                                endTime?.toIso8601String(),
                                            "photoList":
                                                uploadResult?.join(" AND ") ??
                                                    ''
                                          },
                                        });
                                      }
                                    },
                                    text: 'Post',
                                    isLoading: isLoading ||
                                        (result != null
                                            ? result.isLoading
                                            : false),
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

  void selectTags() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => buildSheet(
          context,
          (controller) => SelectTags(
              selectedTags: selectedTags,
              controller: controller,
              callback: (val) {
                setState(() {
                  selectedTags = val;
                });
              })),
      isScrollControlled: true,
    );
  }

  @override
  void dispose() {
    if (widget.post == null) {
      localStorage.setData(widget.category.name, {
        "title": title.text,
        "description": desc.text,
        "selectedTags": jsonEncode(selectedTags.toJson()),
        "date": date,
        "time": time,
        "endTime": endTime,
        "endTimeFormated": endTimeFormated,
        "dateTimeFormated": dateTimeFormated.text,
        "location": location.text,
        "link": link.text,
      });
    }

    super.dispose();
  }
}
