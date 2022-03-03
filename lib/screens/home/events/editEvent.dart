import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/events.dart';
import 'package:client/models/formErrormsgs.dart';
import 'package:client/models/eventsClass.dart';
import 'package:client/widgets/formTexts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:client/models/searchDelegate.dart';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';

class EditPostEvents extends StatefulWidget {
  final Future<QueryResult?> Function()? refetchPosts;
  final eventsPost post;
  EditPostEvents({required this.refetchPosts,required this.post});
  @override
  _EditPostEventsState createState() => _EditPostEventsState();
}

class _EditPostEventsState extends State<EditPostEvents> {

  ///GraphQL
  String editEvent = eventsQuery().editEvent;
  String getTags = authQuery().getTags;

  ///Variables
  List<String>selectedTags=[];
  List<String>selectedIds=[];
  List byteData=[];
  List multipartfile=[];
  List fileNames=[];
  Map<String,String>tagList={};
  String? selectedImage = "Please select an image";
  String emptyTagsError = '';
  FilePickerResult? Result;
  PlatformFile? file;
  var key;
  var dateTime=DateTime.now().toString();
  bool showAdditional = false;

  ///Controllers
  final myControllerTitle = TextEditingController();
  final myControllerLocation = TextEditingController();
  final myControllerDescription = TextEditingController();
  final myControllerFormLink = TextEditingController();
  final formNameController = TextEditingController();

  ///Keys
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    ///Retrieved values of inital post
    var post=widget.post;
    myControllerTitle.text=post.title;
    myControllerLocation.text=post.location;
    if(post.linkToAction!=null && post.linkToAction!=""){
      myControllerFormLink.text=post.linkToAction!;
    }
    myControllerDescription.text=post.description;
    formNameController.text=post.linkName;
    return Query(
        options: QueryOptions(document: gql(getTags)),
        builder:(QueryResult result, {fetchMore, refetch}){
          tagList.clear();
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if(result.isLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          for (var i = 0; i < result.data!["getTags"].length; i++) {
            tagList.putIfAbsent(result.data!["getTags"][i]["id"].toString(),()=>result.data!["getTags"][i]["title"]);
          }

          return Scaffold(

            appBar: AppBar(
              title: const Text(
                "Edit Event",
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              backgroundColor: const Color(0xFF5451FD),
            ),


            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    ///Input fields
                    Column(
                      children: [
                        ///Title Field
                        FormText('Title'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter title',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(50.0))),
                            controller: myControllerTitle,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "This field can't be empty";
                              }
                              return null;
                            },
                          ),
                        ),

                        ///Description Field
                        FormText('Description'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter description',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(50.0))),
                            controller: myControllerDescription,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "This field can't be empty";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                        ),

                        ///Location Field
                        FormText('Location'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter location',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(50.0))),
                            controller: myControllerLocation,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "This field can't be empty";
                              }
                              return null;
                            },
                          ),
                        ),


                        ///Date-Time Field
                        FormText('Date and Time of Event'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: DateTimePicker(
                            type: DateTimePickerType.dateTimeSeparate,
                            dateMask: 'd MMM, yyyy',
                            initialValue: post.time,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            icon: const Icon(Icons.event),
                            dateLabelText: 'Date',
                            timeLabelText: "Hour",
                            onChanged: (val) => {
                              dateTime= dateTimeString(val),
                            },
                            validator: (val) {
                              return null;
                            },
                            // onSaved: (val) => print(val),
                          ),
                        ),

                        ///Additional Fields
                        ListTile(
                          title: Row(
                            children: [
                              const Text('Additional Fields',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                              showAdditional? const Icon(Icons.arrow_upward): const Icon(Icons.arrow_downward),
                            ],
                          ),
                          onTap: (){
                            setState(() {
                              showAdditional = !showAdditional;
                            });
                          },
                        ),

                        if(showAdditional)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            ///CTA Button Name
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: 'Enter name for CTA Button',
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black, width: 1.0),
                                        borderRadius: BorderRadius.circular(50.0))),
                                controller: formNameController,
                              ),
                            ),

                            ///CTA Link Field
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: 'Enter Call-to-Action Link',
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey,
                                            width: 1.0),
                                        borderRadius: BorderRadius.circular(50.0))),
                                controller: myControllerFormLink,
                              ),
                            ),

                            ///Select Tags
                            FormText('Please Select Tags'),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState){
                                      return Column(
                                        children: [
                                          ElevatedButton(
                                            onPressed: ()async{
                                              final finalResult=await showSearch(
                                                context: context,
                                                delegate: CustomSearchDelegate(searchTerms:tagList),
                                              );
                                              setState(() {
                                                if(finalResult!=''){
                                                  if(!selectedTags.contains(finalResult)) {
                                                    selectedTags.add(finalResult);
                                                  }
                                                }
                                              });
                                            },
                                            child: const Text(
                                              "Select tags",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: const Color(0x554A47F0),
                                              elevation: 0.0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30.0)
                                              ),
                                              side: const BorderSide(
                                                width: 1.0,
                                                color: Color(0x664A47F0),
                                              ),
                                            ),
                                          ),
                                          errorMessages(emptyTagsError),

                                          ///Selected Tags
                                          selectedTags==[]?Container():
                                          Wrap(
                                            children:selectedTags.map((e) =>
                                                Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: ElevatedButton(//shape,color etc...
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedTags.remove(e);
                                                      });
                                                    },
                                                    child: Text(
                                                      e,
                                                      style: const TextStyle(
                                                        color: Color(0xFF2B2E35),
                                                        fontSize: 12.5,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      primary: const Color(0xFFFFFFFF),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15)
                                                      ),
                                                      // side: BorderSide(color: Color(0xFF2B2E35)),
                                                      padding: const EdgeInsets.symmetric(
                                                          vertical: 2,
                                                          horizontal: 6),
                                                    ),
                                                  ),
                                                ),
                                            ).toList(),
                                          ),


                                          ///Select Image Button
                                            FormText('Please Select Image'),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                                            child: SizedBox(
                                              width: 250.0,
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    primary: const Color(0x554A47F0),
                                                    elevation: 0.0,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(30.0)
                                                    ),
                                                    side: const BorderSide(
                                                      width: 1.0,
                                                      color: Color(0x664A47F0),
                                                    ),
                                                  ),

                                                  onPressed: () async
                                                  {
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

                                                  ///Name of selected image
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(0.0,7.0,0.0,7.0),
                                                    child: Text(
                                                      selectedImage!,
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 17.0,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  )
                                              ),
                                            ),
                                          ),


                                          ///Selected Images
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


                                        ],
                                      );
                                    }
                                )
                            ),
                          ],
                        ),
                      ],
                    ),

                    ///Discard and Delete Buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ///Discard Button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Discard",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFF6B7AFF),
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              minimumSize: const Size(50, 35),
                            ),
                          ),

                          ///Submit Button
                          Mutation(
                              options: MutationOptions(
                                  document: gql(editEvent),
                                  onCompleted: (dynamic resultData){
                                    if(resultData["editEvent"]==true){
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
                                  onPressed: ()async{
                                    if (_formKey.currentState!.validate()) {
                                      for (var i = 0; i <
                                          selectedTags.length; i++) {
                                        key = tagList.keys.firstWhere((k) =>
                                        tagList[k] == selectedTags[i]);
                                        selectedIds.add(key);
                                      }
                                      if (selectedIds.isEmpty) {
                                        emptyTagsError =
                                        "Please select at least one tag";
                                      }
                                      else {
                                        await runMutation({
                                          "editEventData": {
                                            "content": myControllerDescription
                                                .text,
                                            "title": myControllerTitle.text,
                                            "tagIds": selectedIds,
                                            "time": dateTime,
                                            "linkName": formNameController.text,
                                            "linkToAction": myControllerFormLink
                                                .text,
                                            "location": myControllerLocation
                                                .text,
                                          },
                                          "eventId": post.id,
                                          "image": multipartfile.isEmpty
                                              ? null
                                              : multipartfile,
                                        });
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFF6B7AFF),
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    minimumSize: const Size(50, 35),
                                  ),
                                  child: const Text('Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  ///Function to format date time
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
