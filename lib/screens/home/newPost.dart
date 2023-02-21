import 'package:client/graphQL/post.dart';
import 'package:client/screens/home/tag/select_tags.dart';
import 'package:client/screens/home/tag/tags_display.dart';
import 'package:client/themes.dart';
import 'package:client/widgets/buttom_sheet/main.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../models/date_time_format.dart';
import '../../models/post/actions.dart';
import '../../models/post/create_post.dart';
import '../../models/tag.dart';
import '../../widgets/button/icon_button.dart';
import '../../../widgets/helpers/error.dart';

class NewPostScreen extends StatefulWidget {
  final List<dynamic>? images;
  final post;
  final PostCategoryModel category;
  final CreatePostModel fieldConfiguration;
  const NewPostScreen(
      {Key? key,
      this.images,
      this.post,
      required this.category,
      required this.fieldConfiguration})
      : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();
  final TextEditingController desc = TextEditingController();
  final TextEditingController link = TextEditingController();
  final TextEditingController location = TextEditingController();
  late String? dateFormated = null;
  late String? time = null;
  String? timeFormatted;
  late TagsModel selectedTags = TagsModel.fromJson([]);
  late String error;
  String tagError = "";
  String? date;

  void clearForm() {
    title.clear();
    desc.clear();
    link.clear();
    location.clear();
    setState(() {
      selectedTags = TagsModel.fromJson([]);
      dateFormated = null;
      time = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: gql(PostGQl().createPost),
          onCompleted: (data) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Posted Successfully!')),
            );
          },
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
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                      //   child: CustomAppBar(
                      //       title: "NEW POST",
                      //       leading: CustomIconButton(
                      //         icon: Icons.arrow_back,
                      //         onPressed: () => Navigator.of(context).pop(),
                      //       )),
                      // ),
                      const SizedBox(height: 10),
                      if (widget.images != null)
                        SizedBox(
                          height: 310,
                          child: PageView.builder(
                              itemCount: widget.images!.length,
                              itemBuilder: ((context, index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 30),
                                  height: 280,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      image: DecorationImage(
                                        image: FileImage(widget.images![index]),
                                        fit: BoxFit.cover,
                                      )),
                                );
                              })),
                        ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 42),
                        child: Column(
                          children: [
                            TextFormField(
                              maxLength: 40,
                              minLines: 1,
                              maxLines: null,
                              controller: title,
                              decoration:
                                  const InputDecoration(label: Text("Title")),
                              validator: (value) {
                                if ((widget.category == "Lost" ||
                                        widget.category == "Found") &&
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
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomElevatedButton(
                                    onPressed: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime.now().add(
                                                  const Duration(days: 30 * 5)))
                                          .then(
                                        (value) {
                                          setState(() {
                                            date = value.toString();
                                          });
                                          if (value != null) {
                                            DateTimeFormatModel _date =
                                                DateTimeFormatModel(
                                                    dateTime: value);
                                            setState(() {
                                              dateFormated = _date
                                                  .toFormat("MMM dd, yyyy");
                                            });
                                          }
                                        },
                                      ).then((value) {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          if (value != null) {
                                            DateTime _dateTime = DateTime(2023,
                                                1, 1, value.hour, value.minute);

                                            setState(() {
                                              time = _dateTime.toString();
                                            }); //2021-01-01 14:11:00.000
                                            DateTimeFormatModel _time =
                                                DateTimeFormatModel(
                                                    dateTime: _dateTime);
                                            setState(() {
                                              timeFormatted =
                                                  _time.toFormat("h:mm a");
                                            });
                                          }
                                        });
                                      });
                                    },
                                    text: "Select Date and Time",
                                    padding: const [27, 16],
                                    textColor: Colors.white,
                                    color:
                                        ColorPalette.palette(context).secondary)
                              ],
                            ),
                            if (dateFormated != null && time != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 17),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(dateFormated!,
                                        style: const TextStyle(fontSize: 18)),
                                    const SizedBox(width: 13),
                                    Text(timeFormatted!,
                                        style: const TextStyle(fontSize: 18))
                                  ],
                                ),
                              ),
                            if (['Lost', 'Found', 'Events']
                                .contains(widget.category))
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  controller: location,
                                  decoration: InputDecoration(
                                      label: Text(widget.category == "Events"
                                          ? "Location"
                                          : "Where?")),
                                ),
                              ),
                            if ([
                              'Events',
                              'Competitions,' 'Recruitment',
                              'Announcement',
                              'Opportunity',
                              'Reviews'
                            ].contains(widget.category))
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: TextFormField(
                                  controller: link,
                                  decoration: const InputDecoration(
                                      label: Text("link (optional)")),
                                ),
                              ),
                            TagsDisplay(
                                tagsModel: selectedTags,
                                onDelete: (value) => setState(() {
                                      selectedTags = value;
                                    })),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomElevatedButton(
                                    padding: const [10, 3],
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            buildSheet(
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
                                    },
                                    text: 'Tags'),
                              ],
                            ),
                            if (tagError.isNotEmpty)
                              Text(tagError,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomElevatedButton(
                                    onPressed: () => clearForm(),
                                    text: "Clear",
                                    padding: const [27, 16],
                                    textColor: Colors.black,
                                    color: Colors.white),
                                CustomElevatedButton(
                                  onPressed: () {
                                    if (selectedTags.tags.isEmpty) {
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
                                    final isValid =
                                        formKey.currentState!.validate() &&
                                            selectedTags.tags.isNotEmpty &&
                                            selectedTags.tags.length <= 7;
                                    FocusScope.of(context).unfocus();
                                    if (dateFormated == null ||
                                        time == null && !isValid) {
                                      setState(() {
                                        error = 'Enter Date and Time';
                                      });
                                    } else {
                                      DateTimeFormatModel _dateTime =
                                          DateTimeFormatModel.fromString(
                                              date!.split(" ").first +
                                                  " " +
                                                  time!.split(" ").last);

                                      runMutation({
                                        "postInput": {
                                          "category": widget.category,
                                          "title": title.text,
                                          "content": desc.text,
                                          "location": location.text,
                                          "tagIds": selectedTags.getTagIds(),
                                          "link": link.text,
                                          "endTime": _dateTime.toISOFormat(),
                                          "Photo": widget.images?.join(" AND ")
                                        },
                                      });
                                    }
                                  },
                                  text: 'Post',
                                  padding: const [27, 16],
                                  color:
                                      ColorPalette.palette(context).secondary,
                                ),
                              ],
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
}
