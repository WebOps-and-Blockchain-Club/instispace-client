import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

HttpLink httpLink = HttpLink(
  'https://instispace.iitm.ac.in/api/graphql',
  defaultHeaders: {
    "apikey": "",
  },
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
      defaultPolicies: DefaultPolicies(
          query: Policies(
        fetch: FetchPolicy.cacheAndNetwork,
        error: ErrorPolicy.none,
        cacheReread: CacheRereadPolicy.mergeOptimistic,
      ))));
}

GraphQLClient uploadClient() {
  return (GraphQLClient(
    cache: GraphQLCache(store: HiveStore()),
    link: httpLink,
  ));
}
