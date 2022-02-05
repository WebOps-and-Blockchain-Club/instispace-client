import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/graphQL/LnF.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'LFclass.dart';
import 'package:http_parser/http_parser.dart';
import 'package:client/models/compressFunction.dart';

class EditFound extends StatefulWidget {

  final LnF post ;
  final Future<QueryResult?> Function()? refetchPost;
  EditFound({required this.post,required this.refetchPost});

  @override
  _EditFoundState createState() => _EditFoundState();
}

class _EditFoundState extends State<EditFound> {
  String editItem = LnFQuery().editItem;
  TextEditingController nameController =TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController contactController =TextEditingController();
  var dateTime=DateTime.now().toString();
  List byteData=[];
  List multipartfile=[];
  List fileNames=[];
  FilePickerResult? result=null;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String selectedImage = fileNames.isEmpty? "Please select an image": fileNames.toString();
    var post=widget.post;
    nameController.text=post.what;
    locationController.text=post.location;
    contactController.text=post.contact;
    initializeDateFormatting('az');
    return Scaffold(
      appBar: AppBar(
        title:Text('Found Item'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
        children: [
          Text("What did you lose?"),
          SizedBox(
            height: 35.0,
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(7.0, 10.0, 5.0, 2.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                hintText: 'Short Word',
              ),
              validator: (value){
                if (value == null || value.isEmpty) {
                  return 'Item name cannot be empty';
                }
                return null;
              },
            ),
          ),
          Text("When?"),
          DateTimePicker(
            type: DateTimePickerType.dateTimeSeparate,
            dateMask: 'd MMM, yyyy',
            initialValue: post.time,
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
          Text('Location'),
          SizedBox(
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
          Text("Contact Details"),
          SizedBox(
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
          Text("Images"),
          SizedBox(
              width: 450.0,
              child: StatefulBuilder(
                builder: (BuildContext context,StateSetter setState){
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue[200],
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                      ),
                      onPressed: () async {
                        result =
                        await FilePicker.platform.pickFiles(
                          type: FileType.image,
                          allowMultiple: true,
                        );
                        if (result != null) {
                          setState(() {
                            fileNames.clear();
                            for (var i=0;i<result!.files.length;i++){
                              fileNames.add(result!.files[i].name);
                              byteData.add(result!.files[i].bytes);
                              multipartfile.add(MultipartFile.fromBytes(
                                'file',
                                byteData[i],
                                filename: fileNames[i],
                                contentType: MediaType("file","pdf"),
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
                              color: Colors.black87,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      )
                  );
                },
              )
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Discard")
              ),
              Mutation(
                  options:MutationOptions(
                      document: gql(editItem),
                      onCompleted: (dynamic resultData){
                        print("result:$resultData");
                        if(resultData["editItems"]==true){
                          Navigator.pop(context);
                          widget.refetchPost!();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Post Edited')),
                          );
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Post Creation Failed')),
                          );
                        }
                      },
                      onError: (dynamic error){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Post Creation Failed,Server Error')),
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
                      return Text("loading");
                    }
                    return ElevatedButton(
                        onPressed: ()async{
                          if (_formKey.currentState!.validate()){
                            // print("run mutation");
                            print("${contactController.text}");
                            await runMutation({
                              "editItemsItemId": post.id,
                              "editItemsEditItemInput": {
                                "name": nameController.text,
                                "location":locationController.text,
                                "time":dateTime,
                                "contact":contactController.text,
                              },
                              "editItemsImages": multipartfile,
                            });
                          }
                        },
                        child: Text("Post")
                    );
                  }
              ),
            ],
          )
        ],
      ),)
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

