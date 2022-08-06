import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../services/image_picker.dart';
import '../../../services/local_storage.dart';
import '../../../graphQL/lost_and_found.dart';
import '../../../models/lost_and_found.dart';
import '../../../models/date_time_format.dart';
import '../../../themes.dart';
import '../../../utils/validation.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/text/label.dart';

class NewItemPage extends StatefulWidget {
  final String category;
  final QueryOptions options;
  final LostAndFoundItemModel? item;
  const NewItemPage(
      {Key? key, required this.category, required this.options, this.item})
      : super(key: key);

  @override
  State<NewItemPage> createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  //Keys
  final formKey = GlobalKey<FormState>();

  //Controllers
  final title = TextEditingController();
  final date = TextEditingController();
  final dateFormated = TextEditingController();
  final time = TextEditingController();
  final timeFormated = TextEditingController();
  final location = TextEditingController();
  final contact = TextEditingController();

  // Services
  final localStorage = LocalStorageService();

  Future getItemData(LostAndFoundItemModel? _item) async {
    if (_item != null) {
      title.text = _item.name;
      // img
      date.text = _item.time;
      dateFormated.text =
          DateTimeFormatModel.fromString(_item.time).toFormat("MMM dd, yyyy");
      time.text = _item.time;
      timeFormated.text =
          DateTimeFormatModel.fromString(_item.time).toFormat("h:mm a");
      location.text = _item.location;
      contact.text = _item.contact ?? "";
    } else {
      var data = await localStorage.getData("new_item");
      if (data != null) {
        title.text = data["title"];
        // img
        date.text = data["date"];
        dateFormated.text = DateTimeFormatModel.fromString(data["date"])
            .toFormat("MMM dd, yyyy");
        time.text = data["time"];
        timeFormated.text =
            DateTimeFormatModel.fromString(data["time"]).toFormat("h:mm a");
        location.text = data["location"];
        contact.text = data["contact"];
      }
    }
  }

  void clearData() {
    if (widget.item == null) localStorage.clearData("new_item");
    title.clear();
    // img
    date.clear();
    dateFormated.clear();
    time.clear();
    timeFormated.clear();
    location.clear();
    contact.clear();
  }

  @override
  void initState() {
    getItemData(widget.item);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
            document: gql(widget.item != null
                ? LostAndFoundGQL.edit
                : LostAndFoundGQL.create),
            update: (cache, result) {
              if (result != null && (!result.hasException)) {
                if (widget.item != null) {
                  // TODO: update the cache value for edit
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edited successfull')),
                  );
                } else {
                  dynamic data = cache.readQuery(widget.options.asRequest);
                  data["getItems"]["itemsList"] = [result.data!["createItem"]] +
                      data["getItems"]["itemsList"];
                  data["getItems"]["total"] = data["getItems"]["total"] + 1;
                  cache.writeQuery(widget.options.asRequest, data: data);
                  clearData();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Created successfully')),
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
                            title: "${widget.category} Item",
                            leading: CustomIconButton(
                              icon: Icons.arrow_back,
                              onPressed: () => Navigator.of(context).pop(),
                            )),

                        /// Info
                        LabelText(
                            text:
                                "What did you ${widget.category.toLowerCase()}?"),
                        // Title
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: title,
                            decoration: const InputDecoration(
                                labelText: "Name of the item"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter the name of the item";
                              }
                              return null;
                            },
                          ),
                        ),

                        // Date Time
                        const LabelText(text: "When?"),
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
                                      labelText: " Time"),
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
                        const LabelText(text: "Where?"),
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
                                return "Enter the location ";
                              }
                              return null;
                            },
                          ),
                        ),

                        // Contact
                        const LabelText(text: "How to reach you? (Optional)"),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: contact,
                            decoration: const InputDecoration(
                                labelText: "Contact number"),
                            validator: (val) {
                              if (val != null &&
                                  val.isNotEmpty &&
                                  (!isValidNumber(val) || val.length != 10)) {
                                return "Please enter a valid number";
                              }
                              return null;
                            },
                          ),
                        ),

                        // Images & Tags
                        LabelText(
                            text:
                                "Add Images (Please add images for better chance of ${widget.category == "Lost" ? "getting back your item" : "the owner finding it"})!"),
                        // Selected Image
                        imagePickerService.previewImages(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            imagePickerService.pickImageButton(context),
                          ],
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
                                  final isValid =
                                      formKey.currentState!.validate();
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
                                    if (widget.item != null) {
                                      runMutation({
                                        "editItemInput": {
                                          "name": title.text,
                                          "time": _dateTime.toISOFormat(),
                                          "location": location.text,
                                          "contact": contact.text,
                                        },
                                        "id": widget.item!.id,
                                        "images": image,
                                      });
                                    } else {
                                      runMutation({
                                        "itemInput": {
                                          "name": title.text,
                                          "location": location.text,
                                          "time": _dateTime.toISOFormat(),
                                          "category":
                                              widget.category.toUpperCase(),
                                          "contact": contact.text,
                                        },
                                        "images": image
                                      });
                                    }
                                  }
                                },
                                text: "Submit",
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
    if (widget.item == null) {
      localStorage.setData("new_item", {
        "title": title.text,
        "date": date.text,
        "time": time.text,
        "location": location.text,
        "contact": contact.text,
      });
    }
    super.dispose();
  }
}