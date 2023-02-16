import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../shared/hostel_dropdown.dart';
import '../../../graphQL/contacts.dart';
import '../../../models/contacts.dart';
import '../../../models/user.dart';
import '../../../models/hostel.dart';
import '../../../themes.dart';
import '../../../utils/validation.dart';
import '../../../widgets/helpers/error.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/text/label.dart';

class NewContactPage extends StatefulWidget {
  final UserModel user;
  final ContactModel? contact;
  final QueryOptions<Object?> options;

  const NewContactPage(
      {Key? key, required this.user, this.contact, required this.options})
      : super(key: key);

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  HostelsModel? hostels;
  late final List<String> roleList;

  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController role = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  String? selectedHostel;

  String hostelError = "";

  @override
  void initState() {
    if (widget.contact != null) {
      name.text = widget.contact!.name;
      role.text = widget.contact!.type;
      mobile.text = widget.contact!.number;
      setState(() {
        selectedHostel = widget.contact!.hostel.id;
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
                    widget.contact != null ? "Edit Contact" : "Create Contact",
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
                      document: gql(widget.contact != null
                          ? ContactsGQL.edit
                          : ContactsGQL.create),
                      update: (cache, result) {
                        if (result != null && (!result.hasException)) {
                          if (widget.contact != null) {
                            final Map<String, dynamic> updated = {
                              "__typename": "Contact",
                              "id": widget.contact!.id,
                              "name": result.data!["updateHostelContact"]
                                  ["name"],
                              "type": result.data!["updateHostelContact"]
                                  ["type"],
                              "contact": result.data!["updateHostelContact"]
                                  ["contact"],
                              "permissions": result.data!["updateHostelContact"]
                                  ["permissions"],
                            };
                            cache.writeFragment(
                              Fragment(document: gql(ContactsGQL.editFragment))
                                  .asRequest(idFields: {
                                '__typename': updated['__typename'],
                                'id': updated['id'],
                              }),
                              data: updated,
                              broadcast: false,
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Contact Edited')),
                            );
                          } else {
                            dynamic data =
                                cache.readQuery(widget.options.asRequest);
                            data["getContact"] = data["getContact"] +
                                [result.data!["createHostelContact"]];
                            cache.writeQuery(widget.options.asRequest,
                                data: data);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Contact Created')),
                            );
                          }
                        }
                      },
                      onError: (dynamic error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text(formatErrorMessage(error.toString()))),
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
                            const LabelText(
                                text: "Enter the contact person name"),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: name,
                                maxLength: 40,
                                minLines: 1,
                                maxLines: null,
                                decoration: InputDecoration(
                                  labelText: "Contact person name",
                                  prefixIcon:
                                      const Icon(Icons.person, size: 20),
                                  prefixIconConstraints:
                                      Themes.inputIconConstraints,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter the contact person name";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            // Role
                            const LabelText(
                                text: "Enter the contact person role"),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: role,
                                maxLength: 40,
                                minLines: 1,
                                maxLines: null,
                                decoration: InputDecoration(
                                  labelText: "Contact person role",
                                  prefixIcon:
                                      const Icon(Icons.person, size: 20),
                                  prefixIconConstraints:
                                      Themes.inputIconConstraints,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter the contact person role";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            // Mobile Number
                            const LabelText(
                                text: "Enter the contact person number"),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: mobile,
                                maxLength: 10,
                                minLines: 1,
                                maxLines: null,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: "Contact person number",
                                  prefixIcon: const Icon(Icons.call, size: 20),
                                  prefixIconConstraints:
                                      Themes.inputIconConstraints,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter the contact person number";
                                  } else if (!isValidNumber(value) ||
                                      value.length != 10) {
                                    return "Enter a valid mobile number";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            // if (!widget.user.role!.contains("HOSTEL_SEC") &&
                            //     widget.contact == null)
                            //   HostelListDropdown(
                            //     value: selectedHostel,
                            //     onChanged: (value) {
                            //       setState(() {
                            //         selectedHostel = value;
                            //       });
                            //     },
                            //     error: hostelError,
                            //   ),

                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CustomElevatedButton(
                                onPressed: () async {
                                  var error = ((selectedHostel == null ||
                                              selectedHostel!.isEmpty) &&
                                          widget.user.hostelId == null)
                                      ? "Select the hostel to create contact"
                                      : "";
                                  final isValid =
                                      formKey.currentState!.validate() &&
                                          error == "";
                                  setState(() {
                                    hostelError = error;
                                  });
                                  FocusScope.of(context).unfocus();
                                  if (isValid) {
                                    if (widget.contact != null) {
                                      runMutation({
                                        'updateContactInput': {
                                          "name": name.text,
                                          "type": role.text,
                                          "contact": mobile.text
                                        },
                                        'id': widget.contact!.id,
                                      });
                                    } else {
                                      runMutation({
                                        'createContactInput': {
                                          "name": name.text,
                                          "type": role.text,
                                          "contact": mobile.text
                                        },
                                        'hostelId': widget.user.hostelId ??
                                            selectedHostel,
                                      });
                                    }
                                  }
                                },
                                text: widget.contact != null
                                    ? "Edit Contact"
                                    : "Create Contact",
                                isLoading: result!.isLoading,
                              ),
                            )
                          ],
                        ),
                      );
                    }))));
  }
}
