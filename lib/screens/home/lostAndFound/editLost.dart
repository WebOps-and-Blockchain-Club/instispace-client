import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/graphQL/LnF.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../models/L&Fclass.dart';
import 'package:http_parser/http_parser.dart';

class EditLost extends StatefulWidget {

  final LnF post ;
  final Future<QueryResult?> Function()? refetchPost;
  EditLost({required this.post,required this.refetchPost});

  @override
  _EditLostState createState() => _EditLostState();
}

class _EditLostState extends State<EditLost> {

  ///GrapghQL
  String editItem = LnFQuery().editItem;

  ///Variables
  var dateTime=DateTime.now();
  List byteData=[];
  List multipartfile=[];
  List fileNames=[];
  FilePickerResult? result=null;

  ///Controllers
  TextEditingController nameController =TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController contactController =TextEditingController();

  ///Keys
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var post=widget.post;
    nameController.text=post.what;
    locationController.text=post.location;
    contactController.text=post.contact;
    initializeDateFormatting('az');
  }

  @override
  Widget build(BuildContext context) {

    ///Retrieved data of initial post
    String selectedImage = fileNames.isEmpty? "Please select an image": fileNames.toString();
    return Scaffold(
      appBar: AppBar(
        title:const Text('Lost Item',
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
                    child: Row(
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
                    child: Row(
                      children: [
                        SizedBox(
                          child: const Text("Please add images for better chance of getting back your item!",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0xFF000000),
                            ),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.90,
                        ),
                      ],
                    ),
                  ),

                  ///Item Name Question
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                    child: Row(
                      children: const [
                        Text("What did you lose?",
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
                            return 'Item Name cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  ///When Question
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Row(
                      children: const [
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

                  ///When Field
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
                        dateTime= DateFormat("yyyy-MM-DD hh:mm:ss").parse("$val:00"),
                      },
                      validator: (val) {
                        print(val);
                        return null;
                      },
                      onSaved: (val) => print(val),
                    ),
                  ),

                  ///Location Question
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Row(
                      children: const [
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

                  ///Location Field
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

                  ///Contact Question (optional)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Row(
                      children: const [
                        Text("How to reach you? (optional)",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),
                  ),

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

                  ///Images Question (optional)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Row(
                      children: const [
                        Text("Add Images (if any)",
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
                            multipartfile.remove(
                                MultipartFile.fromBytes(
                                  'photo',
                                  e.bytes as List<int>,
                                  filename: e.name,
                                  contentType: MediaType("image",e.name.split(".").last),
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

                  const SizedBox(
                    height: 20,
                  ),

                  ///Button Row
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

                        ///Post Button
                        Mutation(
                            options:MutationOptions(
                                document: gql(editItem),
                                onCompleted: (dynamic resultData){
                                  if(resultData["editItems"]==true){
                                    Navigator.pop(context);
                                    widget.refetchPost!();
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
                                    await runMutation({
                                      "itemId":widget.post.id,
                                      "editItemInput": {
                                        "name": nameController.text,
                                        "location":locationController.text,
                                        "time":"$dateTime",
                                        "contact":contactController.text,
                                      },
                                      "images": multipartfile.isEmpty ? null : multipartfile,
                                    });
                                  }
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
          ),
        ],
      ),
    );
  }
}

