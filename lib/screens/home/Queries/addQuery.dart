import 'package:client/graphQL/query.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
class AddQuery extends StatefulWidget {
  final Future<QueryResult?> Function()? refetchQuery;
  AddQuery({required this.refetchQuery});

  @override
  _AddQueryState createState() => _AddQueryState();
}

class _AddQueryState extends State<AddQuery> {
  String createQuery = Queries().createQuery;
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
    return Scaffold(
      appBar: AppBar(
        title:Text("Add Query"),
      ),
      body: SafeArea(
        child: Form(

          child: Column(
            children: [
              Text("Title"),
              TextFormField(
                controller: titleController,
                decoration:InputDecoration(
                  hintText: "Enter Title",
                ),
              ),
              Text("Description"),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "Enter description",
                ),
              ),
              Text("Image"),
              SizedBox(
                width: 450.0,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue[200],
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
                            color: Colors.black87,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                    )),
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
              Text(
                'attachments',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                width: 450.0,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue[200],
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
                            color: Colors.black87,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                    )),
              ),
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
                      print(result.exception.toString());
                    };
                    return ElevatedButton(
                        onPressed:(){
                      runMutation({
                        "createQuerysInput": {
                          "title": titleController.text,
                          "content": descriptionController.text,
                        },
                        "image": multipartfileImage,
                        "attachments": multipartfileAttachment,
                      });
                    }, child: Text("Submit"));
                  }
              ),

            ],
          ),
        ),
      ),
    );
  }
}
