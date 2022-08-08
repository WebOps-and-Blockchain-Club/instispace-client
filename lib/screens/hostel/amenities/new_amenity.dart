import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../shared/hostel_dropdown.dart';
import '../../../graphQL/amenities.dart';
import '../../../models/amenities.dart';
import '../../../models/user.dart';
import '../../../models/hostel.dart';
import '../../../themes.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/text/label.dart';

class NewAmenityPage extends StatefulWidget {
  final UserModel user;
  final AmenityEditModel? amenity;
  final QueryOptions<Object?> options;

  const NewAmenityPage(
      {Key? key, required this.user, this.amenity, required this.options})
      : super(key: key);

  @override
  State<NewAmenityPage> createState() => _NewAmenityPageState();
}

class _NewAmenityPageState extends State<NewAmenityPage> {
  HostelsModel? hostels;
  late final List<String> roleList;

  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  String? selectedHostel;

  String hostelError = "";

  @override
  void initState() {
    if (widget.amenity != null) {
      name.text = widget.amenity!.title;
      description.text = widget.amenity!.description;
      setState(() {
        selectedHostel = "null";
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: CustomAppBar(
                title:
                    widget.amenity != null ? "Edit Amenity" : "Create Amenity",
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
                child: Mutation(
                    options: MutationOptions(
                      document: gql(widget.amenity != null
                          ? AmenitiesGQL.edit
                          : AmenitiesGQL.create),
                      update: (cache, result) {
                        if (result != null && (!result.hasException)) {
                          if (widget.amenity != null) {
                            final Map<String, dynamic> updated = {
                              "__typename": "Amenity",
                              "id": widget.amenity!.id,
                              "name": result.data!["updateAmenity"]["name"],
                              "description": result.data!["updateAmenity"]
                                  ["description"],
                              "images": result.data!["updateAmenity"]["images"],
                              "permissions": result.data!["updateAmenity"]
                                  ["permissions"],
                            };
                            cache.writeFragment(
                              Fragment(document: gql(AmenitiesGQL.editFragment))
                                  .asRequest(idFields: {
                                '__typename': updated['__typename'],
                                'id': updated['id'],
                              }),
                              data: updated,
                              broadcast: false,
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Edited Successfully')),
                            );
                          } else {
                            dynamic data =
                                cache.readQuery(widget.options.asRequest);
                            data["getAmenities"] = data["getAmenities"] +
                                [result.data!["createAmenity"]];
                            cache.writeQuery(widget.options.asRequest,
                                data: data);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Created Successfully')),
                            );
                          }
                        }
                      },
                      onError: (dynamic error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Creation Failed, Server Error')),
                        );
                      },
                    ),
                    builder: (
                      RunMutation runMutation,
                      QueryResult? result,
                    ) {
                      return Form(
                        key: formKey,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            const SizedBox(height: 10),

                            // Name
                            const LabelText(text: "Amenity name"),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: name,
                                decoration: InputDecoration(
                                  labelText: "Amenity name",
                                  prefixIcon:
                                      const Icon(Icons.person, size: 20),
                                  prefixIconConstraints:
                                      Themes.inputIconConstraints,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter the amenity name";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            // Description
                            const LabelText(text: "Amenity Description"),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: description,
                                decoration: InputDecoration(
                                  labelText: "Amenity Description",
                                  prefixIcon:
                                      const Icon(Icons.person, size: 20),
                                  prefixIconConstraints:
                                      Themes.inputIconConstraints,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter the amenity description";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            if (!widget.user.role!.contains("HOSTEL_SEC") &&
                                widget.amenity == null)
                              HostelListDropdown(
                                value: selectedHostel,
                                onChanged: (value) {
                                  setState(() {
                                    selectedHostel = value;
                                  });
                                },
                                error: hostelError,
                              ),

                            if (result != null && result.hasException)
                              SelectableText(result.exception.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: ColorPalette.palette(context)
                                              .error)),

                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CustomElevatedButton(
                                onPressed: () async {
                                  var error = ((selectedHostel == null ||
                                              selectedHostel!.isEmpty) &&
                                          widget.user.hostelId == null)
                                      ? "Select the hostel to create amenity"
                                      : "";
                                  final isValid =
                                      formKey.currentState!.validate() &&
                                          error == "";
                                  setState(() {
                                    hostelError = error;
                                  });
                                  FocusScope.of(context).unfocus();
                                  if (isValid) {
                                    if (widget.amenity != null) {
                                      runMutation({
                                        'updateAmenityInput': {
                                          "name": name.text,
                                          "description": description.text,
                                        },
                                        'id': widget.amenity!.id,
                                      });
                                    } else {
                                      runMutation({
                                        'createAmenityInput': {
                                          "name": name.text,
                                          "description": description.text,
                                        },
                                        'hostelId': widget.user.hostelId ??
                                            selectedHostel,
                                      });
                                    }
                                  }
                                },
                                text: widget.amenity != null
                                    ? "Edit Amenity"
                                    : "Create Amenity",
                                isLoading: result!.isLoading,
                              ),
                            )
                          ],
                        ),
                      );
                    }))));
  }
}
