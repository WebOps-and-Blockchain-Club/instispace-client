

import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/graphQL/LnF.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';


class AddFound extends StatefulWidget {
  final Future<QueryResult?> Function()? refetchPosts;
  AddFound({required this.refetchPosts});
  @override
  _AddFoundState createState() => _AddFoundState();
}

class _AddFoundState extends State<AddFound> {
  String createItem = LnFQuery().createItem;
  var imageResult ;
  TextEditingController nameController =TextEditingController();
  TextEditingController descriptionController =TextEditingController();
  TextEditingController locationController =TextEditingController();
  TextEditingController contactController =TextEditingController();
  var dateTime=DateTime.now().toString();
  List<dynamic> byteData=[];
  List multipartfile=[];
  List fileNames=[];
  FilePickerResult? result=null;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String selectedImage = fileNames.isEmpty? "Please select images": fileNames.toString();
    initializeDateFormatting('az');

    //UI
    return Scaffold(
      appBar: AppBar(
        title:Text('Found Item',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF2B2E35),
      ),

      //Form
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
              child: Column(
                children: [
                  //NOTE
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Row(
                      children: [
                        Text("NOTE:",
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
                    padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
                    child: Row(
                      children: [
                        SizedBox(
                          child: Text("Please add images for better chance of the owner finding it!",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0xFF000000),
                            ),
                            textAlign: TextAlign.left,
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.90,
                        ),
                      ],
                    ),
                  ),

                  //What Question
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                    child: Row(
                      children: [
                        Text("What did you find?",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Object Field
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 5, 15, 5),
                    child: SizedBox(
                      height: 35.0,
                      child: TextFormField(
                        controller: nameController,

                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          hintText: 'Name of the item',
                        ),

                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Item name cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  //When Question
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Row(
                      children: [
                        Text("When?",
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
                    padding: const EdgeInsets.fromLTRB(12, 0, 15, 5),
                    child: DateTimePicker(
                      type: DateTimePickerType.dateTimeSeparate,
                      dateMask: 'd MMM, yyyy',
                      initialValue: DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      icon: Icon(Icons.event),
                      dateLabelText: 'Date',
                      timeLabelText: "Hour",
                      onChanged: (val) => {
                        dateTime= dateTimeString(val),
                      },
                      validator: (val) {
                        print(val);
                        return null;
                      },
                      onSaved: (val) => print(val),
                    ),
                  ),

                  //Location Question
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Row(
                      children: [
                        Text('Where?',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Location Field
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 5, 15, 5),
                    child: SizedBox(
                      height: 35.0,
                      child: TextFormField(
                        controller: locationController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(7.0, 10.0, 5.0, 2.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          hintText: 'Enter Location',
                        ),
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Location cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  //Contact Question
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Row(
                      children: [
                        Text("How to reach you?",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Contact Field
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 5, 15, 0),
                    child: SizedBox(
                      height: 35.0,
                      child: TextFormField(
                        controller: contactController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(7.0, 10.0, 5.0, 2.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          hintText: 'Enter Contact Details',
                        ),
                      ),
                    ),
                  ),

                  //Images Question
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

                  //Select Images
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 5, 15, 0),
                    child: SizedBox(
                      width: 250.0,
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
                              allowMultiple: true,
                              withData: true,
                            );
                            if (result != null) {
                              setState(() {
                                fileNames.clear();
                                for (var i=0;i<result!.files.length;i++){
                                  fileNames.add(result!.files[i].name);
                                  byteData.add(result!.files[i].bytes);
                                  List extention= result!.files[i].name.split(".");
                                  multipartfile.add(MultipartFile.fromBytes(
                                    'photo',
                                    byteData[i],
                                    filename: fileNames[i],
                                    contentType: MediaType("image",extention.last),
                                  ));
                                }
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0.0,7.0,0.0,7.0),
                            child: Text(
                              selectedImage,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                  if(result!=null)
                    Wrap(
                      children: result!.files.map((e) => InkWell(
                        onLongPress: (){
                          setState(() {
                            multipartfile.remove(
                                MultipartFile.fromBytes(
                                  'photo',
                                  e.bytes as List<int>,
                                  filename: e.name,
                                  contentType: MediaType("image","png"),
                                )
                            );
                            byteData.remove(e.bytes);
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

                  SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Discard Button
                        ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text("Discard",
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
                        ),

                        //Post Button
                        Mutation(
                            options:MutationOptions(
                                document: gql(createItem),
                                onCompleted: (dynamic resultData){
                                  print("result:$resultData");
                                  if(resultData["createItem"]==true){
                                    Navigator.pop(context);
                                    widget.refetchPosts!();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Post Created')),
                                    );
                                  }
                                  else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Post Creation Failed')),
                                    );
                                  }
                                },
                                onError: (dynamic error){
                                  print("error:$error");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Post Creation Failed,server Error')),
                                  );
                                }
                            ),
                            builder:(
                                RunMutation runMutation,
                                QueryResult? result,
                                ){
                              if (result!.hasException){
                                print(result.exception.toString());
                              }
                              return ElevatedButton(
                                  onPressed: ()async{
                                    if (_formKey.currentState!.validate()){
                                      await runMutation({
                                        "itemInput": {
                                          "name": nameController.text,
                                          "location":locationController.text,
                                          "time":dateTime,
                                          "category": "FOUND",
                                          "contact":contactController.text,
                                        },
                                        "images": multipartfile.isEmpty ? null : multipartfile,
                                      });
                                    }
                                  },
                                  child: Text("Post",
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
  String dateTimeString(String utcDateTime) {
    if (utcDateTime == "") {
      return "";
    }
    var parseDateTime = DateTime.parse(utcDateTime);
    final localDateTime = parseDateTime.toLocal();

    var dateTimeFormat = DateFormat("yyyy-MM-DDThh:mm:ss");
    return dateTimeFormat.format(localDateTime);
  }
}

