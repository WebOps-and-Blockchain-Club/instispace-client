import 'package:client/graphQL/netops.dart';
import 'package:client/graphQL/report.dart';
import 'package:client/models/reportNetopPost.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../widgets/expandDescription.dart';
import '../../../widgets/marquee.dart';
import '../../../widgets/tagButtons.dart';


class NetopReportCard extends StatefulWidget {
  final NetOpReportPost post;

  NetopReportCard({required this.post});
  @override
  _NetopReportCardState createState() => _NetopReportCardState();
}
String deleteNetop = netopsQuery().deleteNetop;
class _NetopReportCardState extends State<NetopReportCard> {
  String resolveNetop = Report().resolveReportNetop;
  @override
  Widget build(BuildContext context) {
    var post= widget.post;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.5)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ///Title Container
          Container(
            color: const Color(0xFF42454D),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15,0,0,0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///Title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: SizedBox(
                      width:MediaQuery.of(context).size.width*0.68,
                      child: MarqueeWidget(
                        direction: Axis.horizontal,
                        child: Text(post.title,
                          style: const TextStyle(
                            //Conditional Font Size
                            fontWeight:FontWeight.bold,
                            //Conditional Font Size
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ///Report Description
          const Padding(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
            child: Text(
              "Reason of Report",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18,15,18,0),
            child: DescriptionTextWidget(text: post.reportDescription ),
          ),
          ///ReportedBy
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
          ///Image
          if(post.imgUrl != null)
            Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Container(
                width: MediaQuery.of(context).size.width*0.6,
                child: Center(
                  child: Image.network(post.imgUrl!,fit: BoxFit.contain,width: 400,),
                ),
              ),
            ),

          ///Description
          Padding(
            padding: const EdgeInsets.fromLTRB(18,15,18,0),
            child: DescriptionTextWidget(text: post.description),
          ),

          ///Tags Row
          if(post.tags.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 8, 0),
              child: Wrap(
                children: post.tags.map((tag) =>
                    SizedBox(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,2,0),
                          child: TagButtons(tag, context)
                      ),
                    )).toList(),
              ),
            ),

          ///Attachments Wrap
          if(post.attachment != null && post.attachment != '')
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 8, 0),
              child: Row(
                children: [
                  const Icon(Icons.attachment),
                  Wrap(
                    children: post.tags.map((tag) =>
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.5,
                          height: 20,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                            child: ElevatedButton(
                              onPressed: () => {
                                launch('${post.attachment}')
                              },
                              child: Padding(
                                padding: EdgeInsets.all(3),
                                child: Text(
                                  post.attachment!.split("/").last,
                                  style: const TextStyle(
                                    color: Color(0xFF2B2E35),
                                    fontSize: 12.5, fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                // primary: const Color(0xFFDFDFDF),
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                // side: BorderSide(color: Color(0xFF2B2E35)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 6),
                              ),
                            ),
                          ),
                        )).toList(),
                  ),
                ],
              ),
            ),

          ///Call to Action Button
          if(post.linkName != null && post.linkToAction != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(15,10,15,0),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.9,
                  height: 24,
                  child: ElevatedButton(
                    onPressed: () {
                      launch('${post.linkToAction}');
                    },
                    child: Text(
                      post.linkName!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF42454D),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ///Posted by
                //ToDo change this line
          const Padding(
            padding: EdgeInsets.fromLTRB(18,10,18,0),
            child: Text(
              'Posted by Anshul, ago',
              // ${post.createdByName}
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10.0,
              ),
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
                      document: gql(resolveNetop),
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
                              //ToDo apply resolve mutation
                              onPressed: () =>
                              {
                                runMutation({
                                  "netopId":post.id,
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
                      document: gql(deleteNetop),
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
                                  "netopId":post.id,
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
    );
  }
}
