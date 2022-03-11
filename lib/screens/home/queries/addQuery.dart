import 'package:client/graphQL/query.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class AddQuery extends StatefulWidget {
  final Future<QueryResult?> Function()? refetchQuery;
  AddQuery({required this.refetchQuery});

  @override
  _AddQueryState createState() => _AddQueryState();
}

class _AddQueryState extends State<AddQuery> {

  ///GraphQL
  String createQuery = Queries().createQuery;

  ///Variables
  List byteDataImage = [];
  List multipartfileImage = [];
  List fileNames = [];
  String selectedImage = "Please select images";
  FilePickerResult? Result;

  ///Controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String selectedImage = fileNames.isEmpty? "Please select image(s)": fileNames.toString();
    return Scaffold(

      appBar: AppBar(
        title:const Text("Add Query",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
        backgroundColor: const Color(0xFF2B2E35),
      ),

      body: SafeArea(
        child: Form(
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
                              return 'Item Name cannot be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),

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
                        ),
                      ),
                    ),

                    ///Images (optional)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Row(
                        children: const [
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
                              Result =
                              await FilePicker.platform.pickFiles(
                                type: FileType.image,
                                allowMultiple: true,
                                withData: true,
                              );
                              if (Result != null) {
                                setState(() {
                                  fileNames.clear();
                                  for (var i=0;i<Result!.files.length;i++){
                                    fileNames.add(Result!.files[i].name);
                                    byteDataImage.add(Result!.files[i].bytes);
                                    multipartfileImage.add(MultipartFile.fromBytes(
                                      'photo',
                                      byteDataImage[i],
                                      filename: fileNames[i],
                                      contentType: MediaType("image","png"),
                                    ));
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
                    if(Result!=null)
                      Wrap(
                        children: Result!.files.map((e) => InkWell(
                          onLongPress: (){
                            setState(() {
                              multipartfileImage.remove(
                                  MultipartFile.fromBytes(
                                    'photo',
                                    e.bytes as List<int>,
                                    filename: e.name,
                                    contentType: MediaType("image","png"),
                                  )
                              );
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
                        )).toList(),
                      ),
                    if(Result!=null)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("long press to delete"),
                      ),

                    ///Buttons Row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ///Discard Button
                          ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: const Text("Discard",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: const Color(0xFF2B2E35),
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                minimumSize: const Size(80, 35),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)
                                )
                            ),
                          ),

                          ///Submit Button
                          Mutation(
                              options: MutationOptions(
                                document: gql(createQuery),
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
                                  return Text(result.exception.toString());
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
                                          runMutation({
                                          "createQuerysInput": {
                                          "title": titleController.text,
                                          "content": descriptionController.text,
                                          },
                                          "images": multipartfileImage,
                                          // "attachments": multipartfileAttachment,
                                          });
                                        },
                                    child: const Text("Submit",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color(0xFF2B2E35),
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                      minimumSize: const Size(80, 35),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24)
                                      )
                                  ),
                                );
                              }
                          ),
                        ],
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
