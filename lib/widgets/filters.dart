import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'formTexts.dart';

typedef void StringCallback(bool val);

class Filters extends StatefulWidget {
  ///Variables
  final Map interest;
  final Future<QueryResult?> Function()? refetch;
  final List<String> selectedFilterIds;
  bool isStarred;
  bool mostLikeValues;
  final StringCallback callback;
  final String page;
  Filters(
      {required this.interest,
      required this.refetch,
      required this.selectedFilterIds,
      required this.isStarred,
      required this.mostLikeValues,
      required this.page,
      required this.callback});

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Filter By- heading
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
                          fontSize: 24),
                    ),

                    ///Listing all tags
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.interest.keys.map((key) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormText(key),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Wrap(
                                children: widget.interest[key]!
                                    .map<Widget>((s) => ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            if (widget.selectedFilterIds
                                                .contains(s.id)) {
                                              widget.selectedFilterIds
                                                  .remove(s.id);
                                            } else {
                                              widget.selectedFilterIds
                                                  .add(s.id);
                                            }
                                            print(
                                                "selected IDs : ${widget.selectedFilterIds}");
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 2, 8, 2),
                                          child: Text(
                                            s.Tag_name,
                                            style: const TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          foregroundColor: widget
                                                  .selectedFilterIds
                                                  .contains(s.id)
                                              ? MaterialStateProperty.all(
                                                  Color(0xFFFFFFFF))
                                              : MaterialStateProperty.all(
                                                  Color(0xFF42454D)),
                                          backgroundColor: widget
                                                  .selectedFilterIds
                                                  .contains(s.id)
                                              ? MaterialStateProperty.all(
                                                  Color(0xFF42454D))
                                              : MaterialStateProperty.all(
                                                  Color(0xFFDFDFDF)),
                                          padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 8.0),
                                          ),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                            const Size(50, 35),
                                          ),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                          ),
                                        )))
                                    .toList(),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),

                    ///Sort By
                    if (widget.page != 'L&F')
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sort By',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600),
                            ),
                            Wrap(
                              children: [
                                ///Most Liked Button
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 10, 0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.mostLikeValues =
                                            !widget.mostLikeValues;
                                      });
                                    },
                                    child: Text(
                                      'Most Liked',
                                      style: TextStyle(
                                        color: widget.mostLikeValues
                                            ? Color(0xFFFFFFFF)
                                            : Color(0xFF42454D),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: widget.mostLikeValues
                                          ? const Color(0xFF42454D)
                                          : Color(0xFFDFDFDF),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      minimumSize: Size(50, 35),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                    ),
                                  ),
                                ),

                                ///isStared Button
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 10, 0),
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
                                        color: widget.isStarred
                                            ? Color(0xFFFFFFFF)
                                            : Color(0xFF42454D),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: widget.isStarred
                                          ? const Color(0xFF42454D)
                                          : Color(0xFFDFDFDF),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      minimumSize: Size(50, 35),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
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

              ///Apply Button
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      //ToDo apply settings
                      // print("selectedFilterIds:$selectedFilterIds");
                      Navigator.pop(context);
                      widget.refetch!();
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      minimumSize: Size(50, 35),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
