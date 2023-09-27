import 'package:client/graphQL/a-gate/ticket.dart';
import 'package:client/graphQL/user.dart';
import 'package:client/widgets/helpers/navigate.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../services/image_picker.dart';
import '../../widgets/button/elevated_button.dart';

final formKey = GlobalKey<FormState>();

class TicketForm extends StatefulWidget {
  const TicketForm({super.key});

  @override
  State<TicketForm> createState() => _TicketFormState();
}
// feild in ticketing form
// title
// description
// images

class _TicketFormState extends State<TicketForm> {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController link = TextEditingController();

  void clearForm() {
    title.clear();
    description.clear();
    link.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: gql(TicketGQL.createTicket),
          onError: (error) => {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Couldn't raise a ticket")))
          },
          update: (cache, result) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Ticket Raised")));
            Navigator.pop(context);
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
                    centerTitle: true,
                    title: const Text(
                      "Raise Ticket",
                      style: TextStyle(
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
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 42),
                            child: Column(children: [
                              //title
                              TextFormField(
                                maxLength: 40,
                                minLines: 1,
                                maxLines: null,
                                controller: title,
                                decoration:
                                    const InputDecoration(label: Text("Title")),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter the title of the post";
                                  }
                                  return null;
                                },
                              ),

                              //description
                              TextFormField(
                                maxLength: 160,
                                minLines: 1,
                                maxLines: null,
                                controller: description,
                                decoration: const InputDecoration(
                                    label: Text("Description")),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter the title of the post";
                                  }
                                  return null;
                                },
                              ),

                              //link
                              TextFormField(
                                maxLength: 160,
                                minLines: 1,
                                maxLines: null,
                                controller: link,
                                decoration:
                                    const InputDecoration(label: Text("Link")),
                              ),

                              //images
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Text("Choose a maximum of 4 images")),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  imagePickerService.pickImageButton(
                                      context: context),
                                ],
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
                                        text: "Submit",
                                        isLoading: result!.isLoading,
                                        //function starts here
                                        onPressed: () async {
                                          List<String>? uploadResult;
                                          bool isvalid =
                                              formKey.currentState!.validate();
                                          if (isvalid) {
                                            if (imagePickerService
                                                    .imageFileList !=
                                                null) {
                                              uploadResult =
                                                  await imagePickerService
                                                      .uploadImage();
                                            }
                                          }
                                          runMutation({
                                            "createTicketInput": {
                                              "title": title.text,
                                              "description": description.text,
                                              "link": link.text,
                                              "imageUrls":
                                                  uploadResult?.join(" AND ")
                                            }
                                          });
                                        },
                                      )
                                    ],
                                  ))
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }));
        });
  }
}
