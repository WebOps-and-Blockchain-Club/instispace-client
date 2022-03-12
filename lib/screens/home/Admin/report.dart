import 'package:client/models/query.dart';
import 'package:client/models/reportNetopPost.dart';
import 'package:client/models/reportQuerypost.dart';
import 'package:client/screens/home/Admin/queryReportCard.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/report.dart';
import '../../../models/tag.dart';
import 'netopReportCard.dart';

class Reported extends StatefulWidget {
  const Reported({Key? key}) : super(key: key);

  @override
  _ReportedState createState() => _ReportedState();
}

class _ReportedState extends State<Reported> {
  String getReports = Report().getReports;
  Map all = {};

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(document: gql(getReports)),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.hasException) {
            print(result.exception.toString());
            return Text(result.exception.toString());
          }
          all.clear();
          print("Report result:${result.data!}");
          for (var i = 0; i < result.data!["getReports"].length; i++) {
            if(result.data!["getReports"][i]["query"]==null){
              List<Tag> tags = [];
              for (var k = 0; k < result.data!["getReports"][i]["netop"]["tags"].length; k++) {
                // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
                tags.add(
                  Tag(
                    Tag_name: result.data!["getReports"][i]["netop"]["tags"][k]["title"],
                    category: result.data!["getReports"][i]["netop"]["tags"][k]["category"],
                    id: result.data!["getReports"][i]["netop"]["tags"][k]["id"],
                  ),
                );
              }
              all.putIfAbsent(
                  NetOpReportPost(
                    title: result.data!["getReports"][i]["netop"]["title"],
                    tags: tags,
                    id: result.data!["getReports"][i]["netop"]["id"],
                    createdByName: result.data!["getReports"][i]["netop"]["createdBy"]["name"],
                    endTime: result.data!["getReports"][i]["netop"]['endTime'],
                    attachment: result.data!["getReports"][i]["netop"]["attachments"],
                    imgUrl: result.data!["getReports"][i]["netop"]["photo"],
                    linkToAction: result.data!["getReports"][i]["netop"]["linkToAction"],
                    linkName: result.data!["getReports"][i]["netop"]["linkName"],
                    description: result.data!["getReports"][i]["netop"]["content"],
                    reportDescription: result.data!["getReports"][i]["description"],
                    reportedByName: result.data!["getReports"][i]["createdBy"]["name"],
                    reportedByRoll: result.data!["getReports"][i]["createdBy"]["roll"],
                  ),
                      () => "netop");
            }
            else{
              all.putIfAbsent(
                  queryReportClass(
                    id: result.data!["getReports"][i]["query"]["id"],
                    title: result.data!["getReports"][i]["query"]["title"],
                    content: result.data!["getReports"][i]["query"]["content"],
                    createdByName: (result.data!["getReports"][i]["query"]["createdBy"]["name"]==null)?"":result.data!["getReports"][i]["query"]["createdBy"]["name"],
                    createdByRoll:result.data!["getReports"][i]["query"]["createdBy"]["roll"],
                    photo: (result.data!["getReports"][i]["query"]["photo"] == null)?"":result.data!["getReports"][i]["query"]["photo"],
                    createdById: result.data!["getReports"][i]["query"]["createdBy"]["id"],
                    reportDescription: result.data!["getReports"][i]["description"],
                    reportedByName: result.data!["getReports"][i]["createdBy"]["name"],
                    reportedByRoll: result.data!["getReports"][i]["createdBy"]["roll"],
                  ),
                      () => "query");
            }
          }

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Reports'),
                backgroundColor: Color(0XFF2B2E35),
              ),
              body: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: ListView(
                      children: all.keys.map(
                              (e) => cardFunction(all[e], e, )
                      ).toList(),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

Widget cardFunction (String category, post){
  if(category == "netop"){
    return NetopReportCard( post: post,);
  }
  else {
    return QueryReportCard(post: post);
  }
}
