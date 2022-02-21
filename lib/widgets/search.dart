import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Search extends StatefulWidget {
  final TextEditingController searchController;
  late final String search;
  final Future<QueryResult?> Function()? refetch;
  Search({required this.searchController, required this.search, required this.refetch});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  bool display = false;

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if(display)
          SizedBox(
              width: 80,
              height: 40,
              child: TextFormField(
                controller: widget.searchController,
                // onChanged: (String value){
                //   if(value.length>=3){
                //
                //   }
                // },
              )
          ),
        IconButton(onPressed: (){
          setState(() {
            display = !display;
            widget.search = widget.searchController.text;
            // print("search String $search");
          });
          if(!display){
            widget.refetch!();
          }
        }, icon: Icon(Icons.search_outlined)),
      ],
    );
  }
}
