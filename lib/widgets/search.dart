import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Search extends StatefulWidget {
  String search = "";
  final Future<QueryResult?> Function()? refetch;
  final GlobalKey<ScaffoldState> ScaffoldKey;
  final String page;
  final Widget widget;
  Search({required this.search, required this.refetch, required this.ScaffoldKey,required this.page,required this.widget});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController searchController = TextEditingController();
  bool display = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22,8,10,0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
            Expanded(
              flex: 12,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,0),
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                          color: Color(0xFF5451FD),
                          width: 1,
                        )
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15,0,15,10),
                    child: TextFormField(
                      controller: searchController,
                      cursorColor: Color(0xFF5451FD),
                      decoration: InputDecoration(
                        border: InputBorder.none
                      ),
                      // onChanged: (String value){
                      //   if(value.length>=3){
                      //
                      //   }
                      // },
                    ),
                  ),
                ),
              ),
            ),

          IconButton(onPressed: (){
            setState(() {
              display = !display;
              widget.search=searchController.text;
              // print("search String $search");
            });
            if(!display){
              widget.refetch!();
            }
          }, icon: Icon(Icons.search_outlined),color: Color(0xFF5451FD),
          ),

          if (widget.page != 'Queries')
          Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,0),
          child: IconButton(
          onPressed: () {
            // widget.ScaffoldKey.currentState?.openEndDrawer();
            showModalBottomSheet(context: context, builder: (BuildContext context) {
              return widget.widget;
            }   );
          },
          icon: Icon(Icons.filter_alt_outlined),color: Color(0xFF5451FD),),
          ),
        ],
      ),
    );

  }
}
