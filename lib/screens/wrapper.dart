import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
    if (auth.token == null) return LogIn(auth: auth);
    if (auth.user == null) return GetMe(auth: auth);
    if (auth.user!.isNewUser != false) return EditProfile(auth: auth);
    if (auth.user!.id == null) return GetMe(auth: auth);
    return HomeWrapper(auth: auth);
  }
}

class GetMe extends StatefulWidget {
  final AuthService auth;
  const GetMe({Key? key, required this.auth}) : super(key: key);

  @override
  State<GetMe> createState() => _GetMeState();
}

class _GetMeState extends State<GetMe> {
  Widget scaffoldBody(
      QueryResult result, Future<QueryResult<Object?>?> Function()? refetch) {
    if (result.hasException) {
      return SelectableText(result.exception.toString());
    }

    if (result.isLoading) {
      return const Text('Loading');
    }

    if (result.data != null) {
      widget.auth.updateUser(result.data!["getMe"]);
    }

    return const Text('Loading');
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(document: gql(UserGQL().getMe)),
        builder: (QueryResult result, {FetchMore? fetchMore, refetch}) {
          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: scaffoldBody(result, refetch),
              ),
            ),
          );
        });
  }
}
