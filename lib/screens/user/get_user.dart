import 'package:client/screens/user/profile.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphQL/user.dart';

class GetUser extends StatefulWidget {
  final Map<String, String> userDetails;
  const GetUser({Key? key, required this.userDetails}) : super(key: key);

  @override
  State<GetUser> createState() => _GetUserState();
}

class _GetUserState extends State<GetUser> {
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: gql(UserGQL().getUser),
            variables: {"roll": widget.userDetails["roll"]?.toLowerCase()}),
        builder: (QueryResult result, {FetchMore? fetchMore, refetch}) {
          return Profile(
              result: result,
              userDetails: widget.userDetails,
              refetch: refetch,
              isMyProfile: false);
        });
  }
}
