import 'package:client/graphQL/netops.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../models/post.dart';
import '../../../models/tag.dart';
import 'package:client/screens/home/networking_and _opportunities/comments.dart';
import 'package:url_launcher/url_launcher.dart';

class Single_Post extends StatelessWidget {
  String toggleStar=netopsQuery().toggleStar;
  bool isStarred;
  Future<QueryResult?> Function()? refetch;
  final NetOpPost post;
  Single_Post({required this.post,required this.isStarred,required this.refetch});
  @override
  Widget build(BuildContext context) {

    List<Tag>tags =post.tags;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
              child: Text(post.title,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A47F0)
                ),
              ),
            ),

            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.95,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.72,
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(children:[
                        if(post.imgUrl !=null)
                          SizedBox(
                              width: 400.0,
                              child: Image.network(post.imgUrl!, height: 240.0,width: 400.0,)
                          ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Mutation(
                              options:MutationOptions(
                                  document: gql(toggleStar)
                              ),
                              builder: (
                                  RunMutation runMutation,
                                  QueryResult? result,
                                  ){
                                if (result!.hasException){
                                  print(result.exception.toString());
                                }
                                return IconButton(
                                  onPressed: (){
                                    runMutation({
                                      "toggleStarNetopId":post.id
                                    });
                                    refetch!();
                                  },
                                  icon: isStarred?Icon(Icons.star):Icon(Icons.star_border),
                                  color: isStarred? Colors.amber:Colors.grey,
                                );
                              }
                          ),
                        ),
                      ]),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => {},
                              icon: Icon(Icons.arrow_circle_up_outlined),
                              iconSize: 24,
                              color: Color(0xFF021096),
                            ),
                            IconButton(
                              onPressed: () => {},
                              icon: Icon(Icons.access_alarm),
                              iconSize: 24,
                              color: Color(0xFF021096),
                            ),
                            IconButton(
                              onPressed: () => {},
                              icon: Icon(Icons.share),
                              iconSize: 24,
                              color: Color(0xFF021096),
                            ),


                            IconButton(onPressed: () =>
                            {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Comments(post: post,)),
                            ),
                              print('commented'),
                            }, icon: Icon(Icons.comment),
                              iconSize: 24,
                              color: Color(0xFF021096),),
                          ],
                        ),
                      ),

                      //Tags
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.5,
                              height: 30.0,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Row(
                                      children: tags.map((tag) => SizedBox(
                                        height:25.0,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(2.0,0.0,2.0,0.0),
                                          child: ElevatedButton(onPressed:()=>{},
                                              style: ElevatedButton.styleFrom(
                                                primary: Color(0xFF808CFF),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2,
                                                    horizontal: 6),
                                              ),
                                              child: Text(
                                                tag.Tag_name,
                                                style: TextStyle(
                                                  color: Color(0xFFFFFFFF),
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                        ),
                                      )).toList()
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25.0),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Text("Description",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF021096),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),

                            //Text or Image
                            if(post.imgUrl != null)
                            SizedBox(
                              child: ListView(children:[
                                Text(post.description,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),)
                              ]),
                            ),
                            if(post.imgUrl == null)
                            SizedBox(
                              height: 100,
                              child: ListView(children:[
                                Text(post.description),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
        ),
            // if(post.attachment!=null && post.attachment != "")
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: IconButton(
                  onPressed: (){
                    print("${post.attachment}");
                    launch(post.attachment!);
                  },
                  icon: Icon(Icons.attachment),
                color: Color(0xFF000000),
              ),
            ),
            if(post.linkToAction!=null && post.linkToAction != "")
            Center(
              child: ElevatedButton(onPressed: () => {
                launch(post.linkToAction!)
              },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF6B7AFF),
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  minimumSize: Size(80, 35),
                ),
                child: Text(post.linkName!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),),),
            ),

        ]
    ),
      )
    );
  }
}
