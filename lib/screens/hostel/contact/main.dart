import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../widgets/helpers/loading.dart';
import '../../../widgets/helpers/error.dart';
import 'new_contact.dart';
import '../shared/hostel_dropdown.dart';
import '../../../widgets/card/action_buttons.dart';
import '../../../widgets/utils/main.dart';
import 'actions.dart';
import '../../../graphQL/contacts.dart';
import '../../../models/contacts.dart';
import '../../../models/user.dart';
import '../../../widgets/headers/main.dart';
import '../../../models/post.dart';

class ContactsPage extends StatefulWidget {
  final UserModel user;
  const ContactsPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  //Controllers
  final ScrollController _scrollController = ScrollController();
  String search = "";
  String? selectedHostel;

  Future<void> makePhoneCall(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not perform the phone call'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> variables = {
      "hostelId": widget.user.hostelId ?? (selectedHostel ?? ""),
    };
    final QueryOptions<Object?> options =
        QueryOptions(document: gql(ContactsGQL.getAll), variables: variables);
    return Query(
        options: options,
        builder: (QueryResult result, {FetchMore? fetchMore, refetch}) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: RefreshIndicator(
                  onRefresh: () => refetch!(),
                  child: NestedScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Header(
                                  title: "Contacts",
                                ));
                          }, childCount: 1),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          floating: true,
                          delegate: SearchBarDelegate(
                            additionalHeight: 0,
                            searchUI: SearchBar(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              onSubmitted: (value) {
                                setState(() {
                                  search = value.trim();
                                });
                              },
                            ),
                          ),
                        ),
                        // if (widget.user.permissions
                        //     .contains("GET_ALL_CONTACTS"))
                        //   SliverList(
                        //       delegate: SliverChildBuilderDelegate(
                        //           (BuildContext contaxt, int index) {
                        //     return Padding(
                        //       padding: const EdgeInsets.only(bottom: 10.0),
                        //       child: HostelListDropdown(
                        //           value: selectedHostel,
                        //           onChanged: (val) {
                        //             setState(() {
                        //               selectedHostel = val;
                        //             });
                        //           }),
                        //     );
                        //   }, childCount: 1))
                      ];
                    },
                    body: (() {
                      if (result.hasException) {
                        return Error(error: result.exception.toString());
                      }

                      if (result.isLoading && result.data == null) {
                        return const Loading();
                      }

                      final ContactsModel contacts =
                          ContactsModel.fromJson(result.data!["getContact"]);

                      final List<ContactModel> contactsF =
                          contacts.search(search);

                      if (contactsF.isEmpty) {
                        return const Error(message: "No Contacts", error: "");
                      }

                      return RefreshIndicator(
                        onRefresh: () {
                          return refetch!();
                        },
                        child: ListView.builder(
                            itemCount: contactsF.length,
                            itemBuilder: (context, index) {
                              final PostActions actions = contactsActions(
                                  widget.user, contactsF[index], options);
                              //Show hostels in tag card
                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Name
                                          SelectableText(
                                            contactsF[index].name,
                                            textAlign: TextAlign.justify,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),

                                          // Position
                                          SelectableText(
                                              contactsF[index].type +
                                                  ' (${contactsF[index].hostel.name})',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall),

                                          /*Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Wrap(
                                              spacing: 20,
                                              runSpacing: 20,
                                              children: [
                                                if (contactsF[index]
                                                    .permissions
                                                    .contains("EDIT"))
                                                  EditPostButton(
                                                      edit: actions.edit!),
                                                if (contactsF[index]
                                                    .permissions
                                                    .contains("DELETE"))
                                                  DeletePostButton(
                                                      delete: actions.delete!),
                                              ],
                                            ),
                                          ),*/
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () => makePhoneCall(
                                            'tel:${contactsF[index].number}'),
                                        child: const Icon(Icons.call),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }()),
                  ),
                ),
              ),
            ),
            floatingActionButton:
                widget.user.permissions.contains("CREATE_CONTACT")
                    ? FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => NewContactPage(
                                    user: widget.user,
                                    options: options,
                                  )));
                        },
                        child: const Icon(Icons.add))
                    : null,
          );
        });
  }
}
