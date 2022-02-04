
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/graphQL/LnF.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
class AddLost extends StatefulWidget {
  final Future<QueryResult?> Function()? refetchPosts;
  AddLost({required this.refetchPosts});
  @override
  _AddLostState createState() => _AddLostState();
}

class _AddLostState extends State<AddLost> {
  String createItem = LnFQuery().createItem;
  var imageResult ;
  TextEditingController nameController =TextEditingController();
  TextEditingController locationController =TextEditingController();
  TextEditingController contactController =TextEditingController();
  var dateTime=DateTime.now().toString();
  List byteData=[];
  List multipartfile=[];
  List fileNames=[];
  FilePickerResult? result=null;
  @override
  Widget build(BuildContext context) {
    String selectedImage = fileNames.isEmpty? "Please select an image": fileNames.toString();
    initializeDateFormatting('az');
    return Scaffold(
      appBar: AppBar(
        title:Text('Lost Item'),
      ),
      body: Column(
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
            ),
          ),
          Text("When?"),
          DateTimePicker(
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
            child: ElevatedButton(
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
                    withData: true,
                  );
                  if (result != null) {
                    setState(() {
                      fileNames.clear();
                      for (var i=0;i<result!.files.length;i++){
                        fileNames.add(result!.files[i].name);
                        byteData.add(result!.files[i].bytes);
                        multipartfile.add(MultipartFile.fromBytes(
                          'photo',
                          byteData[i],
                          filename: fileNames[i],
                          contentType: MediaType("image","png"),
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
                  document: gql(createItem)
              ),
                builder:(
                    RunMutation runMutation,
                    QueryResult? result,
                ){
                  if (result!.hasException){
                    print(result.exception.toString());
                  }
                  if(result.isLoading){}
                   return ElevatedButton(
                      onPressed: (){
                        runMutation({
                          "itemInput": {
                            "name": nameController.text,
                            "location":locationController.text,
                            "time":dateTime,
                            "category": "LOST",
                            "contact":contactController.text,
                          },
                        "images": multipartfile,
                        });
                        Navigator.pop(context);
                        widget.refetchPosts!();
                      },
                      child: Text("Post")
                  );
                }
              ),
            ],
          )
        ],
      ),
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

