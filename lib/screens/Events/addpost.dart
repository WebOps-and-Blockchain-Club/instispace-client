import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:client/models/searchDelegate.dart';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';

class AddPostEvents extends StatefulWidget {
  final Future<QueryResult?> Function()? refetchPosts;
  AddPostEvents({required this.refetchPosts});
  @override
  _AddPostEventsState createState() => _AddPostEventsState();
}

class _AddPostEventsState extends State<AddPostEvents> {
  String createEvent = eventsQuery().createEvent;
  List<String>selectedTags=[];
  List<String>selectedIds=[];
  List byteData=[];
  List multipartfile=[];
  List fileNames=[];
  PlatformFile? file=null;
  var key;
  var dateTime=DateTime.now().toString();
  String getTags = authQuery().getTags;
  final myControllerTitle = TextEditingController();
  final myControllerLocation = TextEditingController();
  final myControllerDescription = TextEditingController();
  final myControllerImgUrl = TextEditingController();
  final myControllerFormLink = TextEditingController();
  final formNameController = TextEditingController();
  Map<String,String>tagList={};
  FilePickerResult? Result=null;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerTitle.dispose();
    myControllerLocation.dispose();
    myControllerDescription.dispose();
    myControllerImgUrl.dispose();
    myControllerFormLink.dispose();
    formNameController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String selectedImage = fileNames.isEmpty? "Please select an image": fileNames.toString();
    return Query(
        options: QueryOptions(document: gql(getTags)),
        builder:(QueryResult result, {fetchMore, refetch}){
          tagList.clear();
          if (result.hasException) {
            print(result.exception.toString());
            return Text(result.exception.toString());
          }
          if(result.isLoading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          for (var i = 0; i < result.data!["getTags"].length; i++) {
            tagList.putIfAbsent(result.data!["getTags"][i]["id"].toString(),()=>result.data!["getTags"][i]["title"]);
          }
          // print("TagList:$tagList");
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Add Event",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              backgroundColor: Color(0xFF),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: ()async{
                              final finalResult=await showSearch(
                                context: context,
                                delegate: CustomSearchDelegate(searchTerms:tagList),
                              );
                              setState(() {
                                if(finalResult!=''){
                                  selectedTags.add(finalResult);
                                }
                              });
                              print("finalResult:$finalResult");
                              print("SelectedTags:$selectedTags");
                              },
                            child: Text(
                              "Select Tags",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          selectedTags==[]?Container():
                          Wrap(
                            children:selectedTags.map((e) =>
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: MaterialButton(//shape,color etc...
                                    onPressed: () {
                                      setState(() {
                                        selectedTags.remove(e);
                                      });
                                    },
                                    child: Text(e),
                                    color: Colors.green,
                                  ),
                                ),
                            ).toList(),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter title',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(20.0))),
                            controller: myControllerTitle,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "This field can't be empty";
                              }
                            },
                          ),
                          SizedBox(height: 5.0),
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
                          SizedBox(height: 5.0),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter Location',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(20.0))),
                            controller: myControllerLocation,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "This field can't be empty";
                              }
                            },
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter description',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(20.0))),
                            controller: myControllerDescription,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "This field can't be empty";
                              }
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                          SizedBox(height: 5.0),
                          SizedBox(
                              width: 450.0,
                              child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.blue[200],
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
                                              byteData.add(Result!.files[i].bytes);
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
                          if(Result!=null)
                            Wrap(
                              children: Result!.files.map((e) => InkWell(
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
                          SizedBox(
                            height: 5.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter Form name',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(20.0))),
                            controller: formNameController,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter Form Link',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(20.0))),
                            controller: myControllerFormLink,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "Save",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "Discard Changes",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Mutation(
                                  options: MutationOptions(
                                      document: gql(createEvent),
                                      onCompleted: (dynamic resultData){
                                        print(resultData);
                                        if(resultData["createEvent"]==true){
                                          Navigator.pop(context);
                                          widget.refetchPosts!();
                                          print("post created");
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
                                          const SnackBar(content: Text('Post Creation Failed,server error')),
                                        );
                                      }
                                  ),
                                  builder: (
                                      RunMutation runMutation,
                                      QueryResult? result,
                                      ) {
                                    if (result!.hasException){
                                      print(result.exception.toString());
                                    };

                                    return TextButton(
                                        onPressed: ()async{
                                          if (_formKey.currentState!.validate()) {
                                            for(var i=0;i<selectedTags.length;i++){
                                              key = tagList.keys.firstWhere((k) => tagList[k]==selectedTags[i]);
                                              selectedIds.add(key);
                                            };
                                            print("selectedTagIds:$selectedIds");
                                            await runMutation({
                                              "newEventData":{
                                                "content":myControllerDescription.text,
                                                "title":myControllerTitle.text,
                                                "tagIds":selectedIds,
                                                "time":dateTime,
                                                "linkName":formNameController.text,
                                                "linkToAction":myControllerFormLink.text,
                                                "location":myControllerLocation.text,
                                              },
                                              "image":multipartfile.isEmpty ? null : multipartfile,
                                            });
                                          }
                                        },
                                        child:Text('Submit'));
                                  }
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
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
