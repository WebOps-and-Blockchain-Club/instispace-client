import 'package:client/graphQL/query.dart';
import 'package:client/models/query.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
class EditQuery extends StatefulWidget {
  final Future<QueryResult?> Function()? refetchQuery;
  final queryClass post;
  EditQuery({required this.refetchQuery,required this.post});

  @override
  _EditQueryState createState() => _EditQueryState();
}

class _EditQueryState extends State<EditQuery> {
  String editQuery = Queries().editQuery;
  var byteDataImage;
  var multipartfileImage;
  String selectedImage = "Please select an image";
  PlatformFile? file=null;
  List byteDataAttachment=[];
  List multipartfileAttachment=[];
  List AttachmentNames=[];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    queryClass post = widget.post;
    titleController.text = post.title;
    descriptionController.text = post.content;
    return Scaffold(
      appBar: AppBar(
        title:Text("Edit Query",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
        backgroundColor: Color(0xFF2B2E35),
      ),

      body: SafeArea(
        child: Form(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Column(
                  children: [
                    //Title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                      child: Row(
                        children: [
                          Text("Title",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Item Name Field
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 5),
                      child: SizedBox(
                        height: 40.0,
                        child: TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),

                            hintText: 'Enter Title',
                          ),

                          validator: (value){
                            if (value == null || value.isEmpty) {
                              return 'Item Name cannot be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),

                    //Description
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Row(
                        children: [
                          Text("Description",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Description Field
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 5),
                      child: SizedBox(
                        height: 40.0,
                        child: TextFormField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),

                            hintText: 'Enter description',
                          ),
                        ),
                      ),
                    ),

                    //Images
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Row(
                        children: [
                          Text("Add Images",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Image Selector
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 5, 15, 0),
                      child: SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.65,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.grey,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                            ),
                            onPressed: () async {
                              final FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                                type: FileType.image,
                                allowMultiple: false,
                                withData: true,
                              );
                              if (result != null) {
                                file = result.files.first;
                                setState(() {
                                  selectedImage = file!.name;
                                  // print("selectedImage:$selectedImage");
                                  // print("file:$file");
                                  byteDataImage= file!.bytes;
                                  print("byteData:$byteDataImage");
                                  multipartfileImage=MultipartFile.fromBytes(
                                    'photo',
                                    byteDataImage,
                                    filename: selectedImage,
                                    contentType: MediaType("image","png"),
                                  );
                                  print("multipartfile:$multipartfileImage");
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0.0,7.0,0.0,7.0),
                              child: Text(
                                selectedImage.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )),
                      ),
                    ),
                    if(file!=null)
                      InkWell(
                        onLongPress: (){
                          setState(() {
                            file=null;
                            multipartfileImage=null;
                            byteDataImage=null;
                            selectedImage = "Please select an image";
                          });
                        },
                        child:
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.memory(
                            file!.bytes!,
                          ),
                        ),
                      ),

                    //Attachment
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Row(
                        children: [
                          Text("Add attachments",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Attachment Selector
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 5, 15, 0),
                      child: SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.65,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.grey,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                            ),
                            onPressed: () async {
                              final FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ["pdf"],
                                allowMultiple: true,
                                withData: true,
                              );
                              if (result != null) {
                                setState(() {
                                  AttachmentNames.clear();
                                  for (var i=0;i<result.files.length;i++){
                                    AttachmentNames.add(result.files[i].name);
                                    byteDataAttachment.add(result.files[i].bytes);
                                    multipartfileAttachment.add(MultipartFile.fromBytes(
                                      'file',
                                      byteDataAttachment[i],
                                      filename: AttachmentNames[i],
                                      contentType: MediaType("file","pdf"),
                                    ));
                                  }
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0.0,7.0,0.0,7.0),
                              child: Text(
                                AttachmentNames.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )),
                      ),
                    ),

                    //Submit Button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
                      child: Mutation(
                          options: MutationOptions(
                              document: gql(editQuery),
                              onCompleted: (dynamic resultData){
                                print(resultData);
                                if(resultData["createMyQuery"]==true){
                                  Navigator.pop(context);
                                  widget.refetchQuery!();
                                  print("post created");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Query Created')),
                                  );
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Query Creation Failed')),
                                  );
                                }
                              },
                              onError: (dynamic error){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Query Creation Failed,server error')),
                                );
                              }
                          ),
                          builder: (
                              RunMutation runMutation,
                              QueryResult? result,
                              ){
                            if (result!.hasException){
                              print(result.exception.toString());
                            };
                            return ElevatedButton(
                              onPressed:()
                              {
                                runMutation({
                                  "createQuerysInput": {
                                    "title": titleController.text,
                                    "content": descriptionController.text,
                                  },
                                  "image": multipartfileImage,
                                  "attachments": multipartfileAttachment,
                                });
                              },
                              child: Text("Submit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF42454D),
                                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                minimumSize: Size(80, 35),
                              ),
                            );
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
