import 'package:client/graphQL/query.dart';
import 'package:client/models/query.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../models/formErrormsgs.dart';
class EditQuery extends StatefulWidget {
  final Future<QueryResult?> Function()? refetchQuery;
  final queryClass post;
  EditQuery({required this.refetchQuery,required this.post});

  @override
  _EditQueryState createState() => _EditQueryState();
}

class _EditQueryState extends State<EditQuery> {

  ///GraphQL
  String editQuery = Queries().editQuery;

  ///Variables
  List byteDataImage = [];
  List multipartfileImage = [];
  String selectedImage = "Please select an image";
  String emptyTitleErr = '';
  String emptyDescErr = '';
  FilePickerResult? result;
  List fileNames = [];

  ///Controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  ///Keys
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ///Retrieved data of initial post
    queryClass post = widget.post;
    titleController.text = post.title;
    descriptionController.text = post.content;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:const Text("Edit Query",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
        backgroundColor: const Color(0xFF2B2E35),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Column(
                  children: [
                    ///Title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                      child: Row(
                        children: const [
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

                    ///Item Name Field
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
                              setState(() {
                                emptyTitleErr =
                                "Title can't be empty";
                              });
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    errorMessages(emptyTitleErr),
                    ///Description field
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Row(
                        children: const [
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
                          validator: (value){
                            if (value == null || value.isEmpty) {
                              setState(() {
                                emptyDescErr =
                                "Description can't be empty";
                              });
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    errorMessages(emptyDescErr),
                    ///Images (optional)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Row(
                        children: const[
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

                    ///Image Selector (optional)
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
                              result =
                              await FilePicker.platform.pickFiles(
                                type: FileType.image,
                                allowMultiple: false,
                                withData: true,
                              );
                              if (result != null) {
                                setState(() {
                                  fileNames.clear();
                                  for (var i=0;i<result!.files.length;i++){
                                    fileNames.add(result!.files[i].name);
                                    byteDataImage.add(result!.files[i].bytes);
                                  }
                                });
                              }
                            },
                            ///Selected images name
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0.0,7.0,0.0,7.0),
                              child: Text(
                                selectedImage.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )),
                      ),
                    ),

                    ///Selected Images
                    if(result!=null)
                      Wrap(
                        children: result!.files.map((e) => InkWell(
                          onLongPress: (){
                            setState(() {
                              byteDataImage.remove(e.bytes);
                              fileNames.remove(e.name);
                              result!.files.remove(e);
                            });
                          },
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.memory(
                              e.bytes!,
                            ),
                          ),
                        )).toList(),
                      ),
                    if(result!=null)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("long press to delete"),
                      ),

                    ///Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ///Discard Button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15,25,15,0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(15,5,15,5),
                              child: Text(
                                'Discard',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFF2B2E35),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              minimumSize: const Size(80, 35),
                            ),
                          ),
                        ),

                        ///Submit Button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
                          child: Mutation(
                              options: MutationOptions(
                                  document: gql(editQuery),
                                  onCompleted: (dynamic resultData){
                                    print("resultData:$resultData");
                                    if(resultData["editMyQuery"]==true){
                                      Navigator.pop(context);
                                      widget.refetchQuery!();
                                      print("post edited");
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Query Edited')),
                                      );
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Query Edit Failed')),
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
                                  print("exception : ${result.exception.toString()}");
                                }
                                if(result.isLoading){
                                  return Center(
                                      child: LoadingAnimationWidget.threeRotatingDots(
                                        color: const Color(0xFF2B2E35),
                                        size: 20,
                                      ));
                                }
                                return ElevatedButton(
                                  onPressed:()
                                  {
                                    //ToDo Check functionality
                                    if(_formKey.currentState!.validate()){
                                      if(titleController
                                          .text.isNotEmpty &&
                                          descriptionController
                                              .text.isNotEmpty){
                                        for(var i=0;i<byteDataImage.length;i++){
                                          multipartfileImage.add(MultipartFile.fromBytes(
                                            'photo',
                                            byteDataImage[i],
                                            filename: fileNames[i],
                                            contentType: MediaType("image","png"),
                                          ));
                                        }
                                        runMutation({
                                          "id":widget.post.id,
                                          "editMyQuerysData": {
                                            "title": titleController.text,
                                            "content": descriptionController.text,
                                          },
                                          "image": multipartfileImage,
                                        });
                                      }
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.fromLTRB(15,5,15,5),
                                    child: Text("Submit",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFF2B2E35),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24)
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    minimumSize: const Size(80, 35),
                                  ),
                                );
                              }
                          ),
                        ),
                      ],
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
