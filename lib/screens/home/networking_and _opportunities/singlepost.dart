import 'package:client/graphQL/netops.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../models/post.dart';
import '../../../models/tag.dart';
import 'package:client/screens/home/networking_and _opportunities/comments.dart';

class Single_Post extends StatelessWidget {
  String toggleStar=netopsQuery().toggleStar;
  bool isStarred;
  Future<QueryResult?> Function()? refetch;
  final Post post;
  Single_Post({required this.post,required this.isStarred,required this.refetch});
  @override
  Widget build(BuildContext context) {
    List<Tag>tags =post.tags;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
            child: Text(post.title,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(
            width: 400.0,
            height: 580.0,
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
                          IconButton(onPressed: ()=>{}, icon: Icon(Icons.share)),
                          IconButton(onPressed: () =>
                          {
                            print('remainder added')
                          }, icon: Icon(Icons.access_alarm)),
                          IconButton(onPressed: () =>
                          {
                            print('liked')
                          }, icon: Icon(Icons.arrow_circle_up_outlined)),
                          IconButton(onPressed: () =>
                          {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Comments(post: post,)),
                          ),
                            print('commented'),
                          }, icon: Icon(Icons.comment)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 200.0,
                      height: 30.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Row(
                              children: tags.map((tag) => SizedBox(
                                height:25.0,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(4.0,0.0,0.0,0.0),
                                  child: ElevatedButton(onPressed:()=>{},
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.grey),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ))
                                      ),
                                      child: Text(
                                        tag.Tag_name,
                                      )),
                                ),
                              )).toList()
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          if(post.imgUrl != null)
                          SizedBox(
                            height: 200.0,
                            child: ListView(children:[
                              Text(post.description)
                            ]),
                          ),
                          if(post.imgUrl == null)
                            SizedBox(
                              height: 400.0,
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
          Center(
            child: ElevatedButton(onPressed: ()=>{},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0x70533535)),
              ),
              child: Text('Know More'),),
          ),
          
      ]
    )
    );
  }
}
