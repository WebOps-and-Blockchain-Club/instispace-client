import 'package:client/graphQL/query.dart';
import 'package:client/models/commentclass.dart';
import 'package:client/models/query.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import '../../../widgets/imageView.dart';

class queryComments extends StatefulWidget {
  final queryClass post;

  queryComments({required this.post});

  @override
  _queryCommentsState createState() => _queryCommentsState();
}

class _queryCommentsState extends State<queryComments> {
  ///GraphQL
  String getComments = Queries().getComments;
  String createComments = Queries().createComment;

  ///Controllers
  TextEditingController commentController = TextEditingController();

  ///variables
  FilePickerResult? Result;
  List byteDataImage = [];
  List multipartfileImage = [];
  List fileNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Comments",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFF2B2E35),
        ),
        body: Query(
          options: QueryOptions(
              document: gql(getComments), variables: {"id": widget.post.id}),
          builder: (QueryResult result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }
            if (result.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Comment> comments = [];
            var data = result.data!["getMyQuery"]["comments"];
            for (var i = 0; i < data.length; i++) {
              List<String> imageUrls=[];
              if(data[i]["images"]!=null && data[i]["images"]!="")
              {imageUrls=data[i]["images"].split(" AND ");}
              comments.add(Comment(
                  id: data[i]["id"],
                  name: (data[i]["createdBy"]["name"] == null)
                      ? ""
                      : data[i]["createdBy"]["name"],
                  message: data[i]["content"],
                imgUrl: imageUrls
              )
              );
            }

            return ListView(
              children: [
                SizedBox(
                  height: Result != null
                      ? MediaQuery.of(context).size.height * 0.65
                      : MediaQuery.of(context).size.height * 0.75,
                  child: ListView(
                    children: [
                      Column(
                        children: comments
                            .map((comment) => Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Card(
                                    color: const Color(0xFFDEDDFF),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 5),
                                          child: Row(
                                            children: [
                                              //PP
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 10, 5, 0),
                                                child: Container(
                                                  height: 30.0,
                                                  width: 30.0,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50.0)),
                                                  ),
                                                ),
                                              ),

                                              ///Name
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 6, 10, 0),
                                                child: Text(
                                                  comment.name,
                                                  style: const TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        ///Comment
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 2, 10, 8),
                                          child: Row(
                                            children: [
                                              Text(
                                                comment.message,
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        ///Image
                                        Wrap(
                                          children: comment.imgUrl.map((image) => Padding(
                                            padding: const EdgeInsets.fromLTRB(3.0, 3.0, 3.0, 0.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width*0.2,
                                              height: MediaQuery.of(context).size.height*0.2,
                                              child: GestureDetector(
                                                child: Center(
                                                  child: Image.network(image,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                onTap: () {
                                                  openImageView(context, comment.imgUrl.indexOf(image), comment.imgUrl);
                                                },
                                              ),
                                            ),
                                          )).toList(),
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),

                ///Selected Images
                if (Result != null)
                  Wrap(
                    children: Result!.files
                        .map((e) => InkWell(
                              onLongPress: () {
                                setState(() {
                                  multipartfileImage
                                      .remove(MultipartFile.fromBytes(
                                    'photo',
                                    e.bytes as List<int>,
                                    filename: e.name,
                                    contentType: MediaType("image", "png"),
                                  ));
                                  byteDataImage.remove(e.bytes);
                                  fileNames.remove(e.name);
                                  Result!.files.remove(e);
                                });
                              },
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.memory(
                                  e.bytes!,
                                ),
                              ),
                            ))
                        .toList(),
                  ),

                ///textfield
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 12.0, 0.0),
                        child: Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                          ),
                          child: const CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextFormField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Write a comment',
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            Result = await FilePicker.platform.pickFiles(
                              type: FileType.image,
                              allowMultiple: true,
                              withData: true,
                            );
                            if (Result != null) {
                              setState(() {
                                fileNames.clear();
                                for (var i = 0; i < Result!.files.length; i++) {
                                  fileNames.add(Result!.files[i].name);
                                  byteDataImage.add(Result!.files[i].bytes);
                                  multipartfileImage
                                      .add(MultipartFile.fromBytes(
                                    'photo',
                                    byteDataImage[i],
                                    filename: fileNames[i],
                                    contentType: MediaType("image", "png"),
                                  ));
                                }
                              });
                            }
                          },
                          icon: Icon(Icons.image_outlined)),
                      Mutation(
                        options: MutationOptions(
                            document: gql(createComments),
                            onCompleted: (dynamic resultData) {
                              refetch!();
                              commentController.clear();
                              Result = null;
                            }),
                        builder: (
                          RunMutation runMutation,
                          QueryResult? result,
                        ) {
                          if (result!.hasException) {
                            return Text(result.exception.toString());
                          }
                          if (result.isLoading) {
                            return Scaffold(
                              appBar: AppBar(
                                title: const Text('Comments'),
                                backgroundColor: const Color(0xFFE6CCA9),
                              ),
                              body: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return IconButton(
                            onPressed: () {
                              runMutation({
                                "content": commentController.text,
                                "id": widget.post.id,
                                "images": multipartfileImage,
                              });
                            },
                            icon: const Icon(Icons.send),
                            iconSize: 24,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }
}
