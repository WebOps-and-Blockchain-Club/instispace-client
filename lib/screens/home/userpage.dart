// import 'package:client/widgets/tagButtons.dart';
// import 'package:flutter/material.dart';
// import 'package:client/graphQL/home.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import '../../models/tag.dart';
// import '../../widgets/loading screens.dart';
// import '../../widgets/text.dart';
//
//
// class UserPage extends StatelessWidget {
//
//   String getMe = homeQuery().getMe;
//
//   late String name;
//   late String hostelName;
//   late String roll;
//   List<Tag> interests = [];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       print(interests);
//       print(name);
//       print(hostelName);
//       print(roll);
//
//       return Scaffold(
//         //UI
//         body: Column(
//           children: [
//             //Demographics
//             PageTitle('My Profile', context),
//             Center(
//               child: Column(
//                 children: [
//                   //User Name
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
//                     child: Text(
//                       name,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF4151E5),
//                       ),
//                     ),
//                   ),
//
//                   //Roll Number
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
//                     child: Text(
//                       roll,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF4151E5),
//                       ),
//                     ),
//                   ),
//
//                   //Hostel Name
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
//                     child: Text(
//                       "${hostelName} Hostel",
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF4151E5),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             //Tags Box
//             Padding(
//               padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
//               child: ListView(
//                 shrinkWrap: true,
//                   children: interests.map((tag) =>
//                       SizedBox(
//                         child: Padding(
//                             padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
//                             child: TagButtons(tag, context)
//                         ),
//                       )).toList(),
//               ),
//             )
//           ],
//         ),
//       );
//      }
//     );
//   }
// }


import 'package:client/graphQL/home.dart';
import 'package:client/widgets/headings.dart';
import 'package:client/widgets/titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../models/tag.dart';
import '../../widgets/loading screens.dart';
import '../../widgets/tagButtons.dart';
import '../../widgets/text.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  String getMe = homeQuery().getMe;

  late String name;
  late String hostel;
  late String roll;
  List<Tag> interests = [];

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
        document: gql(getMe),),
    builder: (QueryResult result, {fetchMore, refetch}) {
      if (result.hasException) {
        return Text(result.exception.toString());
      }
      if (result.isLoading) {
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                PageTitle('My Profile', context),
                Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) => NewCardSkeleton(),
                        separatorBuilder: (context, index) =>
                        const SizedBox(height: 6,),
                        itemCount: 5)
                )
              ],
            ),
          ),
        );
      }
      name = result.data!["getMe"]["name"];
      hostel = result.data!["getMe"]["hostel"]["name"];
      roll = result.data!["getMe"]["roll"];
      interests.clear();
      for (var i = 0; i < result.data!["getMe"]["interest"].length; i++) {
        interests.add(Tag(
            Tag_name: result.data!["getMe"]["interest"][i]["title"],
            category: result.data!["getMe"]["interest"][i]["category"],
            id: result.data!["getMe"]["interest"][i]["id"]
        ));
      }
      return Scaffold(
        body: Column(
          children: [
            PageTitle('My Profile', context),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png')
                          ),
                        ),
                        Heading(name),
                        Text(
                          roll,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color(0xFF5050ED),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    "$hostel Hostel",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF5050ED),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  //Tags Box
                  Text(
                    "My Interests",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF5050ED),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                      child: Wrap(
                        children:[ ListView(
                          shrinkWrap: true,
                          children: interests.map((tag) =>
                              SizedBox(
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(2.0, 3.0, 2.0, 3.0),
                                    child: TagButtons(tag, context)
                                ),
                              )).toList(),
                        ),
                      ]
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    );
  }
}
