import 'package:client/screens/userInit/dropDown.dart';
import 'package:client/widgets/titles.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

typedef void StringCallback (bool val);

class Filters extends StatefulWidget {

  final Map filterSettings;
  final Future<QueryResult?> Function()? refetch;
  final List<String> selectedFilterIds;
   bool isStarred;
   bool mostLikeValues;
   final StringCallback callback;
  final String page;
  Filters({required this.filterSettings, required this.refetch,required this.selectedFilterIds,required this.isStarred,required this.mostLikeValues,required this.page,required this.callback});

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15,0,15,0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Filter By',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 24
                          ),
                        ),
                        Wrap(
                          children: widget.filterSettings.keys.map((key)=>
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,10,10,0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  widget.filterSettings[key] = !widget.filterSettings[key];
                                  print(widget.filterSettings[key]);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8,2,8,2),
                                child: Text(
                                  key.Tag_name,
                                  style: TextStyle(
                                    color: widget.filterSettings[key]?  Color(0xFFFFFFFF):Color(0xFF42454D),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: widget.filterSettings[key]? const Color(0xFF42454D):Color(0xFFDFDFDF),
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                minimumSize: Size(50, 35),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)
                                ),
                              ),
                            ),
                          ),
                          ).toList(),
                        ),


                        if(widget.page != 'L&F')
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,20,0,0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  const Text(
                                    'Sort By',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                // CheckboxListTile(
                                //     title: Text('most liked'),
                                //     value: mostLikedValue,
                                //     onChanged:(bool? value){
                                //       setState(() {
                                //         mostLikedValue=value!;
                                //       });
                                //     }
                                // ),
                                Wrap(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0,10,10,0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.mostLikeValues = !widget.mostLikeValues;
                                            print(widget.mostLikeValues);
                                          });
                                        },
                                        child: Text(
                                          'Most Liked',
                                          style: TextStyle(
                                            color: widget.mostLikeValues?  Color(0xFFFFFFFF):Color(0xFF42454D),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: widget.mostLikeValues? const Color(0xFF42454D):Color(0xFFDFDFDF),
                                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                          minimumSize: Size(50, 35),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0)
                                          ),
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
                                      padding: const EdgeInsets.fromLTRB(0,10,10,0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.isStarred = !widget.isStarred;
                                            widget.callback(widget.isStarred);
                                          });
                                        },
                                        child: Text(
                                          'Starred',
                                          style: TextStyle(
                                            color: widget.isStarred?  Color(0xFFFFFFFF):Color(0xFF42454D),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: widget.isStarred? const Color(0xFF42454D):Color(0xFFDFDFDF),
                                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                          minimumSize: Size(50, 35),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,20,0,0),
                      child: ElevatedButton(
                          onPressed: (){
                            widget.selectedFilterIds.clear();
                            widget.filterSettings.forEach((key, value) {
                              if(value){
                                widget.selectedFilterIds.add(key.id);
                              }
                            });
                            // print("selectedFilterIds:$selectedFilterIds");
                            Navigator.pop(context);
                            widget.refetch!();
                          },
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(15,5,15,5),
                            child: Text(
                                'Apply',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF2B2E35),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          minimumSize: Size(50, 35),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]
      ),
    );
  }
}
