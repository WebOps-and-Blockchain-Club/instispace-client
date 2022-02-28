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
import 'package:flutter/cupertino.dart';
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
          appBar: AppBar(
            title: const Text('My Profile'),
          ),
          body: Center(
            child: Column(
              children: [
                PageTitle('My Profile', context),
                Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) => const NewCardSkeleton(),
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
        appBar: AppBar(
          title: const Text('Profile'),
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: const Color(0xFF2B2E35),
        ),
        backgroundColor: const Color(0xFFDFDFDF),
        body: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
                        child: CircleAvatar(
                            radius: 65,
                            backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png')
                        ),
                      ),
                      Heading(name),
                      Text(
                        roll,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF222222),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      "$hostel Hostel",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF222222),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),


                //Tags Box
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color: const Color(0xFF222222),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.5)
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
                            child: Row(
                              children: const [
                                Text(
                                  "My Interests",
                                  style: TextStyle(
                                    fontSize: 16.5,
                                    color: Color(0xFF222222),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: interests.map((tag) =>
                                      SizedBox(
                                        child: Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                            child: TagButtons(tag, context)
                                        ),
                                      )).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    );
  }
}
