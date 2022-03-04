import 'package:client/screens/userInit/dropDown.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

typedef void StringCallback (String val);

class Search extends StatefulWidget {

  ///variables
  String search = "";
  final StringCallback callback;
  final Future<QueryResult?> Function()? refetch;
  final GlobalKey<ScaffoldState> ScaffoldKey;
  final String page;
  final Widget widget;
  Search({required this.search, required this.refetch, required this.ScaffoldKey,required this.page,required this.widget,required this.callback});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  ///Variables
  bool display = false;

  ///Controller
  TextEditingController searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22,8,10,0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          ///Search bar
            Expanded(
              flex: 12,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,0),
                child: SizedBox(
                  height: 35,
                  child: TextFormField(
                    controller: searchController,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),

                      hintText: 'Search',
                    ),
                    keyboardType: TextInputType.multiline,
                    // onChanged: (String value){
                    //   if(value.length>=3){
                    //
                    //   }
                    // },
                  ),
                ),
              ),
            ),


          ///Search button
          IconButton(onPressed: (){
            widget.callback(searchController.text);
          },
            icon: const Icon(Icons.search_outlined),
            color: const Color(0xFF42454D),
          ),

          ///Filter button
          if (widget.page != 'queries')
          Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,0),
          child: IconButton(
          onPressed: () {
            // widget.ScaffoldKey.currentState?.openEndDrawer();
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
              return widget.widget;
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10)
                  ),
                ),
            );
          },
          icon: const Icon(Icons.filter_alt_outlined),
            color: const Color(0xFF42454D),),
          ),
        ],
      ),
    );

  }
}
