import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../shared/hostels_display.dart';
import '../../../graphQL/announcements.dart';
import '../../../models/date_time_format.dart';
import '../../../services/image_picker.dart';
import '../../../models/announcement.dart';
import '../../../models/user.dart';
import '../../../models/hostel.dart';
import '../../../themes.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/text/label.dart';
import '../shared/select_hostels.dart';

class NewAnnouncementPage extends StatefulWidget {
  final UserModel user;
  final AnnouncementModel? announcement;
  final QueryOptions<Object?> options;

  const NewAnnouncementPage(
      {Key? key, required this.user, this.announcement, required this.options})
      : super(key: key);

  @override
  State<NewAnnouncementPage> createState() => _NewAnnouncementPageState();
}

class _NewAnnouncementPageState extends State<NewAnnouncementPage> {
  HostelsModel? hostels;
  late final List<String> roleList;

  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final date = TextEditingController();
  final dateFormated = TextEditingController();
  final time = TextEditingController();
  final timeFormated = TextEditingController();

  List<String>? imageUrls;
  late HostelsModel selectedHostels = HostelsModel.fromJson([]);
  String hostelError = "";

  @override
  void initState() {
    if (widget.announcement != null) {
      name.text = widget.announcement!.title;
      description.text = widget.announcement!.description;
      DateTimeFormatModel _time =
          DateTimeFormatModel.fromString(widget.announcement!.endTime);
      date.text = _time.dateTime.toString();
      dateFormated.text = _time.toFormat("MMM dd, yyyy");
      time.text = _time.dateTime.toString();
      timeFormated.text = _time.toFormat("h:mm a");
      setState(() {
        imageUrls = widget.announcement!.images;
        selectedHostels = HostelsModel(hostels: widget.announcement!.hostels);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: gql(widget.announcement != null
              ? AnnouncementGQL.edit
              : AnnouncementGQL.create),
          update: (cache, result) {
            if (result != null && (!result.hasException)) {
              if (widget.announcement != null) {
                cache.writeFragment(
                  Fragment(document: gql(AnnouncementGQL.editFragment))
                      .asRequest(idFields: {
                    '__typename': 'Announcement',
                    'id': widget.announcement!.id,
                  }),
                  data: result.data!["editAnnouncement"],
                  broadcast: false,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edited Successfully')),
                );
              } else {
                dynamic data = cache.readQuery(widget.options.asRequest);
                data["getAnnouncements"]["announcementsList"] = [
                      result.data!["createAnnouncement"]
                    ] +
                    data["getAnnouncements"]["announcementsList"];
                data["getAnnouncements"]["total"] =
                    data["getAnnouncements"]["total"] + 1;
                cache.writeQuery(widget.options.asRequest, data: data);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Created Successfully')),
                );
              }
            }
          },
          onError: (dynamic error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Creation Failed, Server Error')),
            );
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return ChangeNotifierProvider(
            create: (_) => ImagePickerService(noOfImages: 4),
            child: Consumer<ImagePickerService>(
                builder: (context, imagePickerService, child) {
              return Scaffold(
                  appBar: AppBar(
                      title: CustomAppBar(
                          title: widget.announcement != null
                              ? "Edit Announcement"
                              : "Create Announcement",
                          leading: CustomIconButton(
                            icon: Icons.arrow_back,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )),
                      automaticallyImplyLeading: false),
                  body: SafeArea(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Form(
                            key: formKey,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                const SizedBox(height: 10),

                                // Name
                                const LabelText(text: "Announcement title"),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: TextFormField(
                                    controller: name,
                                    decoration: const InputDecoration(
                                      labelText: "Title",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter the announcement title";
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                // Description
                                const LabelText(
                                    text: "Announcement Description"),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: TextFormField(
                                    controller: description,
                                    minLines: 3,
                                    maxLines: 8,
                                    decoration: const InputDecoration(
                                      labelText: "Description",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter the announcement description";
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                // Date Time
                                const LabelText(
                                    text:
                                        "How long do you need this announcement to be live?"),
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
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Enter the date";
                                            }
                                            return null;
                                          },
                                          onTap: () => showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now().add(
                                                              const Duration(
                                                                  days: 7)),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime.now()
                                                          .add(const Duration(
                                                              days: 30 * 5)))
                                                  .then(
                                                (value) {
                                                  if (value != null) {
                                                    date.text =
                                                        value.toString();
                                                    DateTimeFormatModel _date =
                                                        DateTimeFormatModel(
                                                            dateTime: value);
                                                    dateFormated.text =
                                                        _date.toFormat(
                                                            "MMM dd, yyyy");
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
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Enter the time";
                                            }
                                            return null;
                                          },
                                          onTap: () => showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              ).then((value) {
                                                if (value != null) {
                                                  DateTime _dateTime = DateTime(
                                                      2021,
                                                      1,
                                                      1,
                                                      value.hour,
                                                      value.minute);
                                                  time.text =
                                                      _dateTime.toString();
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

                                // Attachements & Tags
                                const LabelText(
                                    text:
                                        "Attachements & Hostels (Select maximum of 4 image)"),
                                // Selected Image
                                imagePickerService.previewImages(
                                    imageUrls: imageUrls,
                                    removeImageUrl: (value) {
                                      setState(() {
                                        imageUrls!.removeAt(value);
                                      });
                                    }),
                                // Selected Hostels
                                HostelsDisplay(
                                    hostelsModel: selectedHostels,
                                    onDelete: (value) => setState(() {
                                          selectedHostels = value;
                                        })),
                                if (hostelError.isNotEmpty)
                                  Text(hostelError,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color:
                                                  ColorPalette.palette(context)
                                                      .error)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomElevatedButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              buildSheet(
                                            context,
                                            selectedHostels,
                                            (value) {
                                              setState(() {
                                                selectedHostels = value;
                                              });
                                            },
                                          ),
                                          isScrollControlled: true,
                                        );
                                      },
                                      text: "Select Hostels",
                                      color:
                                          ColorPalette.palette(context).primary,
                                      type: ButtonType.outlined,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    imagePickerService.pickImageButton(
                                      context: context,
                                      preSelectedNoOfImages: imageUrls != null
                                          ? imageUrls!.length
                                          : 0,
                                    ),
                                  ],
                                ),

                                if (result != null && result.hasException)
                                  SelectableText(result.exception.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color:
                                                  ColorPalette.palette(context)
                                                      .error)),

                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: CustomElevatedButton(
                                    onPressed: () async {
                                      var error = (selectedHostels
                                              .hostels.isEmpty)
                                          ? "Select the hostel to create announcement"
                                          : "";
                                      final isValid =
                                          formKey.currentState!.validate() &&
                                              error == "";
                                      setState(() {
                                        hostelError = error;
                                      });
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
                                        if (widget.announcement != null) {
                                          runMutation({
                                            'updateAnnouncementInput': {
                                              "title": name.text,
                                              "description": description.text,
                                              "endTime":
                                                  _dateTime.toISOFormat(),
                                              "imageUrls": imageUrls,
                                              "hostelIds": selectedHostels
                                                  .getHostelIds(),
                                            },
                                            'images': image,
                                            'id': widget.announcement!.id,
                                          });
                                        } else {
                                          runMutation({
                                            'announcementInput': {
                                              "title": name.text,
                                              "description": description.text,
                                              "endTime":
                                                  _dateTime.toISOFormat(),
                                              "hostelIds": selectedHostels
                                                  .getHostelIds(),
                                            },
                                            'images': image,
                                          });
                                        }
                                      }
                                    },
                                    text: widget.announcement != null
                                        ? "Edit Announcement"
                                        : "Create Announcement",
                                    isLoading: result!.isLoading,
                                  ),
                                )
                              ],
                            ),
                          ))));
            }),
          );
        });
  }
}
