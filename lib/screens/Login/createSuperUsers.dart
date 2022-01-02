import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CreateSuperUsers extends StatefulWidget {

  @override
  _CreateSuperUsersState createState() => _CreateSuperUsersState();
}

class _CreateSuperUsersState extends State<CreateSuperUsers> {
  String DropDownValue = 'Select Hostel';

  static HttpLink httpLink = HttpLink(
    'https://insti-app.herokuapp.com/graphql',
  );

  ValueNotifier<GraphQLClient> client= ValueNotifier<GraphQLClient>(GraphQLClient(
    cache: GraphQLCache(store: InMemoryStore()),
    link: httpLink,
  ));

  String userRole = """
  query Query {
  getMe {
    role
  }
}
  """;

  List<String> ROlES = ['Select Role','Hostel Secretary'];

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Create Superusers",
          style: TextStyle(
            color: Colors.white
          ),),
          backgroundColor: Color(0xFFE6CCA9),
        ),
        body: Query(
          options: QueryOptions(
          document: gql(userRole),
          ),
          builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore }) {
      if (result.hasException) {
        return Text(result.exception.toString());
      }

      if (result.isLoading) {
        return Text('Loading');
      }

      final Role = result.data?['getMe']['role'];
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(
                hintText: 'Enter email ID',
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(20.0)
                )
            ),
          ),
          SizedBox(height: 5.0),
          DropdownButton<String>(
            value: DropDownValue,
            onChanged: (String? newValue) {
              setState(() {
                DropDownValue = newValue!;
              });
            },
            items: ROlES
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      );
    }
        ),
      ),
    );
  }
}
