import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/services/Auth.dart';


final _auth=AuthService();
// final token = _auth.token;
HttpLink httpLink = HttpLink(
     'https://insti-app.herokuapp.com/graphql',
    // 'http://10.42.167.219:8000/graphql',
);
final AuthLink authLink = AuthLink(
  getToken: () async  {
    await _auth.loadToken();
    // print(_auth.token);
    if(_auth.token!=null)
    {return 'Bearer ${_auth.token}';}
    else{
      return null;
    }
  }
);
final Link link = authLink.concat(httpLink);

// WebSocketLink websocketLink = WebSocketLink('wss://insti-app.herokuapp.com/graphql');
//
// Link lnk = Link.split((request) => request.isSubscription, websocketLink, link);

ValueNotifier<GraphQLClient> client= ValueNotifier<GraphQLClient>(GraphQLClient(
  cache: GraphQLCache(store: InMemoryStore()),
  link: link,
));

