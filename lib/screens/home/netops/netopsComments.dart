import 'package:client/graphQL/netops.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import '../../../models/formErrormsgs.dart';
import '../../../models/netopsClass.dart';
import 'package:client/models/commentclass.dart';
import 'package:http_parser/http_parser.dart';

class Comments extends StatefulWidget {
  final NetOpPost post;
  Comments({required this.post});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {

  ///GraphQL
  String getComments= netopsQuery().getComments;

  ///Controllers
  TextEditingController commentController = TextEditingController();

  ///Dispose function
  @override
  void dispose(){
    commentController.dispose();
    super.dispose();
  }
  ///variables
  FilePickerResult? Result;
  List byteDataImage = [];
  List multipartfileImage = [];
  List fileNames = [];
  String emptyCommentErr = '';

  ///Keys
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List<Comment> comments = [];
    String createComments =netopsQuery().createComment;
    return Scaffold(

      backgroundColor: const Color(0xFFDFDFDF),

      appBar: AppBar(
        title: const Text('Comments',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
        backgroundColor: const Color(0xFF2B2E35),
        elevation: 0.0,
      ),

      body: Query(
        options:QueryOptions(
          document: gql(getComments),
          variables: {"getNetopNetopId":widget.post.id}
        ),
        builder: (QueryResult result, {fetchMore, refetch}){
          comments.clear();
          if (result.hasException) {
            print(result.exception.toString());
            return Text(result.exception.toString());
          }
          if(result.isLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          for(var j=0;j<result.data!["getNetop"]["comments"].length;j++){
            List<String> imageUrls=[];
            if(result.data!["getNetop"]["comments"][j]["images"]!=null && result.data!["getNetop"]["comments"][j]["images"]!="")
            {imageUrls=result.data!["getNetop"]["comments"][j]["images"].split(" AND ");}
            comments.add(
                Comment(
                  message: result.data!["getNetop"]["comments"][j]["content"],
                  id: result.data!["getNetop"]["comments"][j]["id"],
                  name: result.data!["getNetop"]["comments"][j]["createdBy"]["name"], imgUrl: imageUrls,
                )
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: Result != null
                      ? MediaQuery.of(context).size.height * 0.65
                      : MediaQuery.of(context).size.height * 0.75,
                  child: RefreshIndicator(
                    onRefresh: () {
                      return refetch!();
                    },
                    child: ListView(
                      children: [
                        Column(
                          children : comments.map((comment) => Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Card(
                              color: const Color(0xFFDEDDFF),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    child: Row(
                                      children: [
                                        //PP
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                                          child: Container(
                                            height:30.0,
                                            width: 30.0,
                                            decoration: const BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                            ),
                                          ),
                                        ),

                                        ///Name
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(5, 6, 10, 0),
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
                                    padding: const EdgeInsets.fromLTRB(12, 5, 10, 8),
                                    child: Row(
                                      children: [
                                        Text(
                                          comment.message,
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )).toList(),
                        )
                      ],
                    ),
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
                            borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          ),
                          child: const CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),
                          ),
                        ),
                      ),
                      Column(
                        children: [
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
                                validator: (value){
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      emptyCommentErr =
                                      "Comment can't be empty";
                                    });
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          errorMessages(emptyCommentErr),
                        ],
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
                          icon: const Icon(Icons.image_outlined)),
                      Mutation(
                        options: MutationOptions(
                            document: gql(createComments),
                            onCompleted: (dynamic resultData){
                              // print("comment result data: $resultData");
                              if(resultData["createCommentNetop"]){
                                refetch!();
                                commentController.clear();
                                Result = null;
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Comment not created')),
                                );
                              }
                            }
                        ),
                        builder: (
                            RunMutation runMutation,
                            QueryResult? result,
                            ){
                          if (result!.hasException){
                            print(result.exception.toString());
                          }
                          if(result.isLoading){
                            return Scaffold(
                              appBar:AppBar(
                                title: const Text('Comments'),
                                backgroundColor:const Color(0xFDFDFDF),
                              ),
                              body: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return IconButton(
                            onPressed: () {
                              if(_formKey.currentState!
                                  .validate()){
                                if(commentController.text.isNotEmpty){
                                  runMutation(
                                      {
                                        "content":commentController.text,
                                        "netopId":widget.post.id,
                                        "images":multipartfileImage,
                                      }
                                  );
                                }
                              }
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
            ),
          );
        },
      )
    );
  }
}
