import 'package:client/graphQL/query.dart';
import 'package:client/graphQL/report.dart';
import 'package:client/models/reportQuerypost.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../widgets/expandDescription.dart';
import '../../../widgets/marquee.dart';


class QueryReportCard extends StatefulWidget {
  final queryReportClass post;
  QueryReportCard({required this.post});

  @override
  _QueryReportCardState createState() => _QueryReportCardState();
}
String resolveQuery = Report().resolveReportMyQuery;
String deleteQuery = Queries().deleteQuery;
class _QueryReportCardState extends State<QueryReportCard> {
  @override
  Widget build(BuildContext context) {
    var post = widget.post;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,0,0,10),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.5)
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        color: const Color(0xFFFFFFFF),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Title Container
            Container(
              color: const Color(0xFF42454D),
              child: Padding(
                //Conditional Padding
                padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                child: MarqueeWidget(
                  direction: Axis.horizontal,
                  child: Text(post.title,
                    style: const TextStyle(
                      //Conditional Font Size
                      fontWeight:FontWeight.bold,
                      //Conditional Font Size
                      fontSize:18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            ///Report Description
            Container(
              color: Color(0xFFFFFFFF),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                child: Text(
                  "Reason of Report",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18,15,18,0),
              child: DescriptionTextWidget(text: post.reportDescription ),
            ),
            ///Reported BY
            const Padding(
              padding: EdgeInsets.fromLTRB(18,10,18,0),
              child: Text(
                //ToDo reported by name
                "reported by Anshul",
                // 'reported by ${post.reportedByName},${post.reportedByRoll}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10.0,
                ),
              ),
            ),
            const Divider(),
            //Image
            if(post.photo!='')
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Image.network(post.photo),
              ),

            //Description
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child:
              DescriptionTextWidget(
                text: post.content,
              ),
            ),

            //Creator
            //ToDo change this
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text('Created by ${post.createdByName}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            ///Resolve Button, Delete Button
            Padding(
              padding: const EdgeInsets.fromLTRB(10,0,10,10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ///Resolve Button
                  Mutation(
                      options: MutationOptions(
                        document: gql(resolveQuery),
                      ),
                      builder: (RunMutation runMutation,
                          QueryResult? result){
                        if (result!.hasException){
                          print(result.exception.toString());
                        }
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,14,0),
                          child: Ink(
                            decoration: const ShapeDecoration(
                                color: Colors.white,
                                shape: CircleBorder(
                                  side: BorderSide.none,
                                )
                            ),
                            height: MediaQuery.of(context).size.height*0.05,
                            width: MediaQuery.of(context).size.width*0.1,
                            child: Center(
                              child: IconButton(
                                onPressed: () =>
                                {
                                  runMutation({
                                    "queryId":post.id,
                                  })
                                },
                                icon: const Icon(Icons.check_circle_outline),
                                iconSize: 20,
                                color:Colors.grey,
                                // color: const Color(0xFF021096),
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                  ///Delete Button
                  Mutation(
                      options: MutationOptions(
                        document: gql(deleteQuery),
                      ),
                      builder: (RunMutation runMutation,
                          QueryResult? result){
                        if (result!.hasException){
                          print(result.exception.toString());
                        };
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,14,0),
                          child: Ink(
                            decoration: const ShapeDecoration(
                                color: Colors.white,
                                shape: CircleBorder(
                                  side: BorderSide.none,
                                )
                            ),
                            height: MediaQuery.of(context).size.height*0.05,
                            width: MediaQuery.of(context).size.width*0.1,
                            child: Center(
                              child: IconButton(
                                onPressed: () =>
                                {
                                  runMutation({
                                    "queryId":post.id,
                                  })
                                },
                                icon: const Icon(Icons.delete),
                                iconSize: 20,
                                color:Colors.grey,
                                // color: const Color(0xFF021096),
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
