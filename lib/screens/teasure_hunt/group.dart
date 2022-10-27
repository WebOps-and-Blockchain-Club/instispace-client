import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphQL/teasure_hunt.dart';
import '../../widgets/button/elevated_button.dart';
import '../../widgets/button/icon_button.dart';
import '../../widgets/headers/main.dart';
import '../../widgets/helpers/error.dart';
import '../../widgets/text/label.dart';

class GroupPage extends StatefulWidget {
  final Future<QueryResult<Object?>?> Function()? refetch;
  const GroupPage({Key? key, required this.refetch}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              title: CustomAppBar(
                  title: "Teasure Hunt",
                  leading: CustomIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )),
              automaticallyImplyLeading: false),
          body: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 20),
              JoinGroup(refetch: widget.refetch),
              const SizedBox(height: 50),
              Expanded(
                  child: SelectableText(
                "----------- OR -----------",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              )),
              const SizedBox(height: 50),
              CreateGroup(refetch: widget.refetch)
            ],
          )),
    );
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

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: gql(joinGroup),
          onCompleted: (dynamic resultData) {
            widget.refetch!();
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Expanded(
                      child: SelectableText(
                    "Join Group",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  )),
                  const LabelText(text: "Group Code"),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: name,
                      maxLength: 10,
                      minLines: 1,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: "Group Code",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter the group code";
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
                            // TODO: Enter input object
                          });
                        }
                      },
                      text: "Join Group",
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
            widget.refetch!();
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Expanded(
                      child: SelectableText(
                    "Create Group",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  )),
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
                            // TODO: Enter input object
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
