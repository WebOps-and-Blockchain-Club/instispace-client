import 'package:client/widgets/titles.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Filters extends StatefulWidget {

  final Map filterSettings;
  final Future<QueryResult?> Function()? refetch;
  final List<String> selectedFilterIds;
  final bool isStarred;
  final bool mostLikeValues;
  final String page;
  Filters({required this.filterSettings, required this.refetch,required this.selectedFilterIds,required this.isStarred,required this.mostLikeValues,required this.page});

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  late bool isStared;
  late bool mostLikedValue;
  @override
  Widget build(BuildContext context) {
    isStared = widget.isStarred;
    mostLikedValue = widget.mostLikeValues;
    return SafeArea(
      child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SubHeading('Filter'),
                    Wrap(
                      children: widget.filterSettings.keys.map((key)=>
                      // CheckboxListTile(
                      //   value: widget.filterSettings[key],
                      //   onChanged:(bool? value){
                      //     setState(() {
                      //       widget.filterSettings[key]=value!;
                      //     });
                      //   },
                      //   title: Text(key.Tag_name),
                      // )
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.filterSettings[key] = !widget.filterSettings[key];
                              print(widget.filterSettings[key]);
                            });
                          },
                          child: Text(
                            key.Tag_name,
                            style: TextStyle(
                              color: widget.filterSettings[key]?  Color(0xFF021096):Color(0xFFFFFFFF),
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: widget.filterSettings[key]? Color(0xFFFFFFFF):Color(0xFF021096),
                            padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 6),
                          ),
                        ),
                      ),
                      ).toList(),
                    ),

                    if(widget.page != 'L&F')
                      SubHeading('Sort'),
                    // CheckboxListTile(
                    //     title: Text('most liked'),
                    //     value: mostLikedValue,
                    //     onChanged:(bool? value){
                    //       setState(() {
                    //         mostLikedValue=value!;
                    //       });
                    //     }
                    // ),
                    if(widget.page != 'L&F')
                      Wrap(
                          children : [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    mostLikedValue = !mostLikedValue;
                                  });
                                },
                                child: Text(
                                  'Most Liked',
                                  style: TextStyle(
                                    color: mostLikedValue?  Color(0xFF021096):Color(0xFFFFFFFF),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: mostLikedValue? Color(0xFFFFFFFF):Color(0xFF021096),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 6),
                                ),
                              ),
                            ),
                            // CheckboxListTile(
                            //     title: Text("Starred"),
                            //     value: isStared,
                            //     onChanged:(bool? value){
                            //       setState(() {
                            //         isStared=value!;
                            //       });
                            //     }
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isStared = !isStared;
                                  });
                                },
                                child: Text(
                                  'Starred',
                                  style: TextStyle(
                                    color: isStared?  Color(0xFF021096):Color(0xFFFFFFFF),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: isStared? Color(0xFFFFFFFF):Color(0xFF021096),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 6),
                                ),
                              ),
                            ),
                          ]
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: (){
                        widget.selectedFilterIds.clear();
                        widget.filterSettings.forEach((key, value) {
                          if(value){
                            widget.selectedFilterIds.add(key.id);
                          }
                        });
                        // print("selectedFilterIds:$selectedFilterIds");
                        widget.refetch!();
                      },
                      child: Text('Apply')),
                )
              ],
            ),
          ]
      ),
    );
  }
}
