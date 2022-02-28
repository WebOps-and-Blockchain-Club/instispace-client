import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/events.dart';
import 'package:client/widgets/formTexts.dart';
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
  var dateTime=DateTime.now().add(const Duration(days: 7));
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
    String selectedImage = fileNames.isEmpty? "Please select image(s)": fileNames.toString();
    return Query(
        options: QueryOptions(document: gql(getTags)),
        builder:(QueryResult result, {fetchMore, refetch}){
          tagList.clear();
          if (result.hasException) {
            print(result.exception.toString());
            return Text(result.exception.toString());
          }
          if(result.isLoading){
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }
          for (var i = 0; i < result.data!["getTags"].length; i++) {
            tagList.putIfAbsent(result.data!["getTags"][i]["id"].toString(),()=>result.data!["getTags"][i]["title"]);
          }
          // print("TagList:$tagList");
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text(
                "Add Event",
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              backgroundColor: const Color(0xFF2B2E35),
            ),
            backgroundColor: const Color(0xFFDFDFDF),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,10,10,0),
                child: ListView(
                  children: [
                    SingleChildScrollView(
                      child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///Title Field
                                  FormText('Title'),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(12, 5, 15, 5),
                                    child: SizedBox(
                                      height: 35,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100.0),
                                          ),

                                          hintText: 'Enter title',
                                        ),
                                        controller: myControllerTitle,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return "This field can't be empty";
                                          }
                                        },
                                      ),
                                    ),
                                  ),


                                  ///Description Field
                                  FormText('Description'),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(12, 5, 15, 5),
                                    child: SizedBox(
                                      height: 35,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100.0),
                                          ),

                                          hintText: 'Enter description',
                                        ),
                                        controller: myControllerDescription,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return "This field can't be empty";
                                          }
                                        },
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                      ),
                                    ),
                                  ),


                                  ///Select Image Button
                                  FormText('Please Select Images'),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                    child: SizedBox(
                                      width: 250.0,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: const Color(0xFF42454D),
                                              elevation: 0.0,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0))
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
                                              selectedImage,
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

                                  ///Location Field
                                  FormText('Location'),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    child: SizedBox(
                                      height: 35,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100.0),
                                          ),

                                          hintText: 'Enter Location',
                                        ),
                                        controller: myControllerLocation,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return "This field can't be empty";
                                          }
                                        },
                                      ),
                                    ),
                                  ),

                                  //Date-Time Field
                                  FormText('Date and Time of Event'),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(12, 0, 15, 5),
                                    child: DateTimePicker(
                                      type: DateTimePickerType.dateTimeSeparate,
                                      dateMask: 'd MMM, yyyy',
                                      initialValue: DateTime.now().add(const Duration(days: 7)).toString(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                      icon: const Icon(Icons.event),
                                      dateLabelText: 'Date',
                                      timeLabelText: "Hour",
                                       onChanged: (val) => {
                                    print("value:$val"),
                                        dateTime = DateFormat("yyyy-MM-DD hh:mm:ss").parse("$val:00"),
                                          print("datetimr:$dateTime+05:30"),
                                  },
                                      validator: (val) {
                                        print(val);
                                        return null;
                                      },
                                      onSaved: (val) => print(val),
                                    ),
                                  ),

                                  ///Select Tags
                                  FormText('Please Select Tags'),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: SizedBox(
                                      height: 250,
                                      child: ElevatedButton(
                                        onPressed: ()async{
                                          final finalResult = await showSearch(
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
                                        child: const Text(
                                          "Select tags",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: const Color(0xFF42454D),
                                            elevation: 0.0,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0))
                                        ),
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

                                  ///CTA Button Name
                                  FormText('CTA Button Name'),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(12,5,15,5),
                                    child: SizedBox(
                                      height: 35,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100.0),
                                          ),

                                          hintText: 'Enter a name',
                                        ),
                                        keyboardType: TextInputType.multiline,
                                        controller: formNameController,
                                      ),
                                    ),
                                  ),

                                  ///CTA Link Field
                                  FormText('CTA Link'),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(12,5,15,5),
                                    child: SizedBox(
                                      height: 35,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100.0),
                                          ),

                                          hintText: 'Enter CTA Link'
                                        ),
                                        controller: myControllerFormLink,
                                        keyboardType: TextInputType.multiline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                          //Action Buttons
                          Padding(
                                padding: const EdgeInsets.fromLTRB(10, 15, 10, 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //Save Button
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: const Text(
                                        "Save",
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

                                    //Discard Button
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: const Text(
                                        "Discard",
                                        style: const TextStyle(
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

                                    //Submit Button
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

                                          return ElevatedButton(
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
                                                    "time":"$dateTime",
                                                    "linkName":formNameController.text,
                                                    "linkToAction":myControllerFormLink.text,
                                                    "location":myControllerLocation.text,
                                                  },
                                                  "image":multipartfile.isEmpty ? null : multipartfile,
                                                });
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: const Color(0xFF6B7AFF),
                                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                              minimumSize: const Size(50, 35),
                                            ),
                                            child:const Text('Submit',
                                              style: const TextStyle(
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
                ]
                ),
              ),
            ),
          );
        }
    );
  }
}
