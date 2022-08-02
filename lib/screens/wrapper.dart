import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/user.dart';
import '../services/auth.dart';
import '../../graphQL/user.dart';
import 'auth/login.dart';
import 'home/main.dart';
import 'user/edit_profile.dart';

class Wrapper extends StatefulWidget {
  final AuthService auth;
  const Wrapper({Key? key, required this.auth}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = widget.auth;
    if (auth.token == null) {
      return const Scaffold(body: Text('Loading'));
    } else if (auth.token == "") {
      return LogIn(auth: auth);
    } else {
      return Query(
          options: QueryOptions(document: gql(UserGQL().getMe)),
          builder: (QueryResult result, {FetchMore? fetchMore, refetch}) {
            return Scaffold(
              body: (() {
                if (result.hasException) {
                  return SelectableText(result.exception.toString());
                }

                if (result.isLoading) {
                  return const Text('Loading');
                }

                final UserModel user =
                    UserModel.fromJson(result.data!["getMe"]);

                if (user.isNewUser == true) {
                  return EditProfile(
                    auth: auth,
                    user: user,
                    refetch: refetch,
                  );
                } else if (user.isNewUser == false) {
                  return HomeWrapper(
                    auth: auth,
                    user: user,
                    refetch: refetch,
                  );
                }

                return SelectableText(
                    "Some error occured ${result.data.toString()}");
              }()),
            );
          });
    }
  }
}
