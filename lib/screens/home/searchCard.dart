import 'package:client/graphQL/home.dart';
import 'package:client/models/tag.dart';
import 'package:client/models/user.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class searchCard extends StatefulWidget {
  final User user;
  searchCard({required this.user});

  @override
  _searchCardState createState() => _searchCardState();
}

class _searchCardState extends State<searchCard> {
  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => singleUser(user: user,)));
      },
      child: Card(
        child: Column(
          children: [
            Text(user.name),
            Text(user.roll),
            Text(user.hostelName),
          ],
        ),
      ),
    );
  }
}

class singleUser extends StatefulWidget {
  final User user;
  singleUser({required this.user});

  @override
  _singleUserState createState() => _singleUserState();
}

class _singleUserState extends State<singleUser> {
  String getUser=homeQuery().getUser;
  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Query(
          options: QueryOptions(
            document: gql(getUser),
            variables: {"getUserInput": {
              "id": user.id
            }}
          ),
          builder:(QueryResult result, {fetchMore, refetch}){
            if (result.hasException) {
              print(result.exception.toString());
            }
            if (result.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue[700],
                ),
              );
            }
            var data = result.data!["getUser"];
            List<Tag> interests=[];
            for(var i=0;i<data["interest"].length;i++){
              interests.add(
                  Tag(
                  Tag_name: data["interest"][i]["title"],
                  category: data["interest"][i]["category"],
                  id: data["interest"][i]["id"]
              )
              );
            }
            return Column(
              children: [
                Text(user.roll),
                Text(user.name),
                Text(user.hostelName),
                Wrap(
                  children: interests.map((e) => Text(e.Tag_name)).toList()
                )
              ],
            );
          }
        )
      ),
    );
  }
}
