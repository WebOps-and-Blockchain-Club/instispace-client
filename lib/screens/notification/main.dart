import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphQL/notification.dart';
import '../../themes.dart';
import '../../widgets/helpers/error.dart';
import '../../widgets/helpers/loading.dart';
import '../../widgets/button/elevated_button.dart';
import '../../widgets/button/icon_button.dart';
import '../../widgets/form/dropdown_button.dart';
import '../../widgets/headers/main.dart';
import '../../widgets/text/label.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: gql(NotificationGQL.get),
            fetchPolicy: FetchPolicy.networkOnly),
        builder: (QueryResult result, {FetchMore? fetchMore, refetch}) {
          return Scaffold(
            appBar: AppBar(
                title: CustomAppBar(
                    title: "Notifications Settings",
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
                child: RefreshIndicator(
                    onRefresh: () => refetch!(),
                    child: (() {
                      if (result.isLoading && result.data == null) {
                        return const Loading();
                      }

                      return EditNotification(result: result);
                    }())),
              ),
            ),
          );
        });
  }
}

class EditNotification extends StatefulWidget {
  final QueryResult result;
  const EditNotification({Key? key, required this.result}) : super(key: key);

  @override
  State<EditNotification> createState() => _EditNotificationState();
}

class _EditNotificationState extends State<EditNotification> {
  String? netop = "Notify only Followed Tags";
  String? event = "Notify only Followed Tags";
  String? lnf = "Don't Notify Me";
  String? query = "Don't Notify Me";
  Map<String, String> prefsType1 = {
    "Notify All": "FORALL",
    "Notify only Followed Tags": "FOLLOWED_TAGS",
    "Don't Notify Me": "NONE",
  };
  Map<String, bool> prefsType2 = {
    "Notify Me": true,
    "Don't Notify Me": false,
  };
  @override
  void initState() {
    netop = prefsType1.keys.firstWhere(
        (k) => prefsType1[k] == widget.result.data!['getMe']['notifyNetop']);
    event = prefsType1.keys.firstWhere(
        (k) => prefsType1[k] == widget.result.data!['getMe']['notifyEvent']);
    query = prefsType2.keys.firstWhere(
        (k) => prefsType2[k] == widget.result.data!['getMe']['notifyMyQuery']);
    lnf = prefsType2.keys.firstWhere(
        (k) => prefsType2[k] == widget.result.data!['getMe']['notifyFound']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: gql(NotificationGQL.edit),
          onCompleted: (dynamic resultData) {
            if (resultData["changeNotificationSettings"] == true) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications setting saved')),
              );
            }
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult? mutationResult,
        ) {
          return ListView(
            shrinkWrap: true,
            children: [
              // Netops
              const LabelText(text: "Configure for Netops notifications"),
              CustomDropdownButton(
                value: netop,
                items: prefsType1.keys.toList(),
                onChanged: (value) {
                  setState(() {
                    netop = value!;
                  });
                },
              ),
              // Events
              const LabelText(text: "Configure for Events notifications"),
              CustomDropdownButton(
                value: event,
                items: prefsType1.keys.toList(),
                onChanged: (value) {
                  setState(() {
                    event = value!;
                  });
                },
              ),
              //
              const LabelText(
                  text: "Configure for Lost and Found notifications"),
              CustomDropdownButton(
                value: lnf,
                items: prefsType2.keys.toList(),
                onChanged: (value) {
                  setState(() {
                    lnf = value!;
                  });
                },
              ),
              const LabelText(text: "Configure for Queries notifications"),
              CustomDropdownButton(
                value: query,
                items: prefsType2.keys.toList(),
                onChanged: (value) {
                  setState(() {
                    query = value!;
                  });
                },
              ),
              if (mutationResult != null && mutationResult.hasException)
                ErrorText(error: mutationResult.exception.toString()),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: CustomElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    runMutation({
                      "notifyNetop": prefsType1[netop],
                      "notifyEvent": prefsType1[event],
                      "toggleNotifyMyQuery": prefsType2[query],
                      "toggleNotifyFound": prefsType2[lnf],
                    });
                  },
                  text: "Save",
                  isLoading: mutationResult!.isLoading,
                ),
              )
            ],
          );
        });
  }
}
