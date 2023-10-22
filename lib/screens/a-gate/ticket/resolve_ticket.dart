import 'package:client/graphQL/a-gate/ticket.dart';
import 'package:client/models/ticket.dart';
import 'package:client/screens/a-gate/ticket/main.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../models/date_time_format.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/card.dart';
import '../../../widgets/card/description.dart';
import '../../../widgets/card/image.dart';

final formKey = GlobalKey<FormState>();

class ResolveTicket extends StatefulWidget {
  const ResolveTicket({super.key, required this.ticket});
  final TicketModel ticket;

  @override
  State<ResolveTicket> createState() => _ResolveTicketState();
}

class _ResolveTicketState extends State<ResolveTicket> {
  // final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  // final TextEditingController link = TextEditingController();

  void clearForm() {
    // title.clear();
    description.clear();
    // link.clear();
  }

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;
    return Mutation(
        options: MutationOptions(
          document: gql(TicketGQL.ResolveTicket),
          onError: (error) => {
            print("======================================I AM HERE======"),
            print(error),
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Couldn't raise a ticket")))
          },
          update: (cache, result) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Ticket Resolved")));
            Navigator.of(context).pop();
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Ticket()));
          },
        ),
        builder: (RunMutation runMutation, QueryResult? result) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "Resolve Ticket",
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
                    Container(
                      margin: EdgeInsets.all(15),
                      child: CustomCard(
                        child: Column(
                          children: [
                            //title and status
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ticket.title,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  // Container(
                                  //   // color: const Color.fromARGB(255, 228, 47, 47),
                                  //   padding: EdgeInsets.all(10),
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     // color: Colors.redAccent
                                  //     // color: Colors.greenAccent
                                  //   ),
                                  //   child: Text(
                                  //     "Pending",
                                  //
                                  // ),
                                  // )
                                ],
                              ),
                            ),

                            //createdBy and createdAt
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                "Created by ${ticket.createdBy.name}, ${DateTimeFormatModel.fromString(ticket.createdAt).toDiffString()} ago", // should change it such that when clicked it opens profile page.
                                style: const TextStyle(color: Colors.black45),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            //images
                            if (ticket.photo != null &&
                                ticket.photo!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: ImageCard(
                                  imageUrls: ticket.photo!,
                                ),
                              ),

                            //description
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Description(content: ticket.description),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 42),
                      child: Column(children: [
                        //description
                        TextFormField(
                          maxLength: 160,
                          minLines: 1,
                          maxLines: null,
                          controller: description,
                          decoration: const InputDecoration(
                              label: Text("Resolve Description")),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the title of the post";
                            }
                            return null;
                          },
                        ),

                        Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    runMutation({
                                      "resolveTicketId": ticket.id,
                                      "resolveDescription": description.text,
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
        });
  }
}
