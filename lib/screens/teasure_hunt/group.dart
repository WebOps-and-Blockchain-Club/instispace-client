import 'package:client/screens/badges/scanner.dart';
import 'package:client/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphQL/teasure_hunt.dart';
import '../../widgets/button/elevated_button.dart';
import '../../widgets/button/icon_button.dart';
import '../../widgets/headers/main.dart';
import '../../widgets/helpers/error.dart';
import '../../widgets/text/label.dart';

final localStorage = LocalStorageService();

class GroupPage extends StatefulWidget {
  final Future<QueryResult<Object?>?> Function()? refetch;
  const GroupPage({Key? key, required this.refetch}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: UniqueKey(),
        appBar: AppBar(
            title: CustomAppBar(
                title: "Treasure Hunt",
                leading: CustomIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )),
            automaticallyImplyLeading: false),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              SizedBox(height: 200, child: JoinGroup(refetch: widget.refetch)),
              const SizedBox(height: 50),
            ],
          ),
        ));
  }
}

class JoinGroup extends StatefulWidget {
  final Future<QueryResult<Object?>?> Function()? refetch;

  const JoinGroup({Key? key, required this.refetch}) : super(key: key);

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();

  final joinGroup = TeasureHuntGQL.joinGroup;

  bool scanned = false;

  @override
  void initState() {
    super.initState();
    getScanned();
  }

  getScanned() async {
    var data = await localStorage.getData("treasure_hunt");
    if (data != null) {
      setState(() {
        scanned = data["scanned"];
      });
    } else {
      setState(() {
        scanned = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return scanned
        ? Mutation(
            options: MutationOptions(
                document: gql(joinGroup),
                onCompleted: (dynamic resultData) {
                  print(resultData);
                  if (resultData["group"]["id"] != null) {
                    widget.refetch!();
                  }
                },
                onError: (error) {
                  if (error.toString().contains("user is already in a group")) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("User is already in a group")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              formatErrorMessage(error.toString(), context))),
                    );
                  }
                }),
            builder: (
              RunMutation runMutation,
              QueryResult? result,
            ) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: formKey,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SelectableText(
                        "Join Group",
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      if (result != null && result.hasException)
                        ErrorText(error: result.exception.toString()),
                      if (scanned)
                        Center(
                          child: CustomElevatedButton(
                            onPressed: () {
                              final isValid = formKey.currentState!.validate();
                              FocusScope.of(context).unfocus();

                              if (isValid) {
                                runMutation(
                                    {"maxMembers": 6, "numberOfGroup": 5});
                              }
                            },
                            text: "Join Group",
                            isLoading: result!.isLoading,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            })
        : Center(
            child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text("Please Scan the QR to join a group",
                    style: Theme.of(context).textTheme.headlineMedium),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: CustomElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const ScannerScreen())),
                    text: "Scan The QR",
                  ),
                ),
              ],
            ),
          ));
  }
}

class CreateGroup extends StatefulWidget {
  final Future<QueryResult<Object?>?> Function()? refetch;

  const CreateGroup({Key? key, required this.refetch}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();

  final createGroup = TeasureHuntGQL.createGroup;

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: gql(createGroup),
          onCompleted: (dynamic resultData) {
            if (resultData["createGroup"] != null) {
              widget.refetch!();
            }
          },
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(formatErrorMessage(error.toString(), context))),
            );
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: formKey,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SelectableText(
                    "Create Group",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const LabelText(text: "Group Name"),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: name,
                      maxLength: 10,
                      minLines: 1,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: "Group Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter the group name";
                        }
                        return null;
                      },
                    ),
                  ),
                  if (result != null && result.hasException)
                    ErrorText(error: result.exception.toString()),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CustomElevatedButton(
                      onPressed: () {
                        final isValid = formKey.currentState!.validate();
                        FocusScope.of(context).unfocus();

                        if (isValid) {
                          runMutation({
                            "groupData": {"name": name.text},
                          });
                        }
                      },
                      text: "Create Group",
                      isLoading: result!.isLoading,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class LeaveGroup extends StatefulWidget {
  final Future<QueryResult<Object?>?> Function()? refetch;

  const LeaveGroup({Key? key, required this.refetch}) : super(key: key);

  @override
  State<LeaveGroup> createState() => _LeaveGroupState();
}

class _LeaveGroupState extends State<LeaveGroup> {
  final formKey = GlobalKey<FormState>();

  final leaveGroup = TeasureHuntGQL.leaveGroup;

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: gql(leaveGroup),
          onCompleted: (dynamic resultData) {
            widget.refetch!();
          },
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(formatErrorMessage(error.toString(), context))),
            );
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return CustomIconButton(
              icon: Icons.logout, onPressed: () => {runMutation({})});
        });
  }
}
