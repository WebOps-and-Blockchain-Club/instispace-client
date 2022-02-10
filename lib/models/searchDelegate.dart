import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  final Map<String,String> searchTerms;

  CustomSearchDelegate({required this.searchTerms});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear)
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(onPressed: () {
      close(context, query);
    }, icon: Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> matchQuery = searchTerms.values.where(
            (searchTerm) =>
            searchTerm.toLowerCase().contains(query.toLowerCase(),)
    ).toList();
    print('matchQuery:$matchQuery');
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap:(){
            query=result;
            close(context, query);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> matchQuery=searchTerms.values.where(
            (searchTerm) =>
            searchTerm.toLowerCase().contains(query.toLowerCase(),)
    ).toList();
    print(matchQuery);
    // final List<String> matchQuery = searchTerms.where(
    //         (searchTerm) =>
    //         searchTerm.toLowerCase().contains(query.toLowerCase(),)
    // ).toList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
            title: Text(result),
            onTap: (){
              query=result;
              close(context, query);
            }
        );
      },
    );
  }
}