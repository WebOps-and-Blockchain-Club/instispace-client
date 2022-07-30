import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

HttpLink httpLink = HttpLink(
  'https://instispace.iitm.ac.in/api/graphql',
);

ValueNotifier<GraphQLClient> client(String? token) {
  Link link;

  if (token != null && token.isNotEmpty) {
    final AuthLink authLink = AuthLink(
      getToken: () => 'Bearer $token',
    );

    link = authLink.concat(httpLink);
  } else {
    link = httpLink;
  }

  return ValueNotifier<GraphQLClient>(GraphQLClient(
    cache: GraphQLCache(store: HiveStore()),
    link: link,
  ));
}
