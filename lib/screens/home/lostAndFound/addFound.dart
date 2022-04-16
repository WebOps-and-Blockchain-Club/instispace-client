import 'dart:io';

import 'package:client/widgets/formTexts.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/graphQL/LnF.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/formErrormsgs.dart';

class AddFound extends StatefulWidget {
  final Future<QueryResult?> Function()? refetchPosts;
  AddFound({required this.refetchPosts});
  @override
  _AddFoundState createState() => _AddFoundState();
}

class _AddFoundState extends State<AddFound> {

  ///GraphQL
  String createItem = LnFQuery().createItem;

  ///Variables
  var imageResult ;
  var dateTime=DateTime.now();
  List<dynamic> byteData=[];
  List multipartfile=[];
  List fileNames=[];
  FilePickerResult? result=null;
  String emptyNameErr = "";
  String emptyLocationErr = "";

  ///Controllers
  TextEditingController nameController =TextEditingController();
  TextEditingController descriptionController =TextEditingController();
  TextEditingController locationController =TextEditingController();
  TextEditingController contactController =TextEditingController();

  ///Keys
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String selectedImage = fileNames.isEmpty? "Please select images": fileNames.toString();
    initializeDateFormatting('az');

    return Scaffold(

      appBar: AppBar(
       title:const Text('Found Item',
         style: TextStyle(
           color: Colors.white,
           fontSize: 20,
           fontWeight: FontWeight.bold,
         ),
       ),
       backgroundColor: const Color(0xFF2B2E35),
      ),

      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
              child: Column(
                children: [
                  ///NOTE
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Wrap(
                      children: const [
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
                    child: Wrap(
                      children: [
                        SizedBox(
                          child: const Text("Please add images for better chance of the owner finding it!",
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

                  ///Found what
                  FormText('What did you find?'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 5, 15, 5),
                    child: SizedBox(
                      height: 35,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,0,0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(8,5,0,8),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            hintText: 'Name of the item',
                          ),
                          controller: nameController,
                          validator: (val) {
                            if(val == null || val.isEmpty) {
                              setState(() {
                                emptyNameErr = "Name cannot be empty";
                              });
                            }
                            else {
                              emptyNameErr = "";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  errorMessages(emptyNameErr),

                  ///Found when
                  FormText("When?"),

                  ///DateTime Picker
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 15, 5),
                    child: DateTimePicker(
                      type: DateTimePickerType.dateTimeSeparate,
                      dateMask: 'd MMM, yyyy',
                      initialValue: DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      icon: const Icon(Icons.event),
                      dateLabelText: 'Date',
                      timeLabelText: "Hour",
                      onChanged: (val) => {
                        // dateTime= dateTimeString(val),
                        dateTime = DateFormat("yyyy-MM-DD hh:mm:ss").parse("$val:00"),

                      },
                      validator: (val) {
                        return null;
                      },
                      // onSaved: (val) => print(val),
                    ),
                  ),

                  ///Location
                  FormText('Where?'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 5, 15, 5),
                    child: SizedBox(
                      height: 35,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,0,0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(8,5,0,8),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            hintText: 'Enter Location',
                          ),
                          controller: locationController,
                          validator: (val) {
                            if(val == null || val.isEmpty) {
                              setState(() {
                                emptyLocationErr = "Location cannot be empty";
                              });
                            }
                            else{
                              emptyLocationErr = "";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  errorMessages(emptyLocationErr),

                  ///Contact Question (optional)
                  FormText("How to reach you? (optional)"),

                  ///Contact Field (optional)
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

                  ///Images (optional)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Row(
                      children: const [
                        Text("Add Images  (if any)",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///Select Images (optional)
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
                                  print("byteData in picker: ${byteData.length}");
                                }
                              });
                            }

                          },
                          ///Selected images name
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0.0,7.0,0.0,7.0),
                            child: Text(
                              selectedImage,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                      ),
                    ),
                  ),

                  ///Selected Images
                  if(result!=null)
                    Wrap(
                      children: result!.files.map((e) => InkWell(
                        onLongPress: (){
                          setState(() {
                            byteData.remove(e.bytes);
                            print("byteData : ${byteData.length}");
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

                  const SizedBox(
                    height: 20,
                  ),

                  ///Discard Button
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ///Discard Button
                        ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(15,5,15,5),
                              child: Text("Discard",
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
                        ),

                        ///Submit Button
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
                                // return Text(result.exception.toString());
                                print(result.exception.toString());
                              }
                              if(result.isLoading){
                                return Center(
                                    child: LoadingAnimationWidget.threeRotatingDots(
                                      color: Color(0xFF2B2E35),
                                      size: 20,
                                    ));
                              }
                              return ElevatedButton(
                                  onPressed: ()async{
                                    if (_formKey.currentState!.validate()){
                                      if(nameController.text.isNotEmpty && locationController.text.isNotEmpty) {
                                        for(var i=0;i<byteData.length;i++) {
                                          multipartfile.add(MultipartFile.fromBytes(
                                            'photo',
                                            byteData[i],
                                            filename: fileNames[i],
                                            contentType: MediaType("image",fileNames[i].split(".").last),
                                          ));
                                        }
                                        await runMutation({
                                          "itemInput": {
                                            "name": nameController.text,
                                            "location":locationController.text,
                                            "time":"$dateTime",
                                            "category": "FOUND",
                                            "contact":contactController.text,
                                          },
                                          "images": multipartfile.isEmpty ? null : multipartfile,
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

  ///Function to format date
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

