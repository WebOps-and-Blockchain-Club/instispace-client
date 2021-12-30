import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';



HttpLink httpLink = HttpLink('https://insti-app.herokuapp.com/graphql');

ValueNotifier<GraphQLClient> client= ValueNotifier<GraphQLClient>(GraphQLClient(
  cache: GraphQLCache(store: InMemoryStore()),
  link: httpLink,
));