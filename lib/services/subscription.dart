import 'package:client/graphQL/netops.dart';
import 'package:client/services/notification.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Subscriptions extends StatefulWidget {
  const Subscriptions({Key? key}) : super(key: key);

  @override
  _SubscriptionsState createState() => _SubscriptionsState();
}
List notifications= [];
class _SubscriptionsState extends State<Subscriptions> {
  String netopSub = netopsQuery().netopSubscription;
  int id=0;
  @override
  Widget build(BuildContext context) {
    return Subscription(
        options: SubscriptionOptions(
          document: gql(netopSub),
        ),
        builder: (result) {
          if (result.hasException) {
            print(result.exception.toString());
          }
          if (result.isLoading) {
            print("subscription loading");
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
          print("subscription");
          print("subscription $result");
          var data =result.data!["createNetop2"];
          print("data:${data}");
          NotificationService().showNotification(id, data["title"], data["content"], 2);
          id++;
          notifications.add({
            "title":data["title"],
            "content":data["content"],
          });
          // ResultAccumulator is a provided helper widget for collating subscription results.
          // careful though! It is stateful and will discard your results if the state is disposed
          return ResultAccumulator.appendUniqueEntries(
              latest: result.data,
              builder: (context, {results}) => Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(notifications[index]["title"]),
                        subtitle: Text(notifications[index]["content"]),
                      ),
                    );
                  },
                ),
              ),
          );
        }
    );
  }
}
