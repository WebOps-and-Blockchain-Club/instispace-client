import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/events.dart';
import 'package:client/models/formErrormsgs.dart';
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
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPostEvents extends StatefulWidget {
  final Future<QueryResult?> Function()? refetchPosts;
  AddPostEvents({required this.refetchPosts});
  @override
  _AddPostEventsState createState() => _AddPostEventsState();
}

class _AddPostEventsState extends State<AddPostEvents> {

  ///GraphQL
  String createEvent = eventsQuery().createEvent;
  String getTags = authQuery().getTags;


  ///Variables
  List<String>selectedTags = [];
  List<String>selectedIds = [];
  List byteDataImage = [];
  List multipartfileImage = [];
  List fileNames = [];
  Map<String,String>tagList = {};
  FilePickerResult? Result;
  PlatformFile? file;
  String emptyTagsError = '';
  String emptyTitleErr = '';
  String emptyDescErr = '';
  String emptyLocationErr = '';
  String emptyFormLinkErr = '';
  String emptyButtonNameErr = '';
  bool showAdditional = false;
  var key;
  var dateTime=DateTime.now().add(const Duration(days: 7));


  ///Controllers
  final myControllerTitle = TextEditingController();
  final myControllerLocation = TextEditingController();
  final myControllerDescription = TextEditingController();
  final myControllerFormLink = TextEditingController();
  final formNameController = TextEditingController();


  ///Keys
  final _formKey = GlobalKey<FormState>();


  ///dispose function
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerTitle.dispose();
    myControllerLocation.dispose();
    myControllerDescription.dispose();
    myControllerFormLink.dispose();
    formNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _sharedPreference();
  }
  void _sharedPreference() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if(prefs?.getString("titleControllerEvent")!=null){
        myControllerTitle.text = prefs!.getString("titleControllerEvent")!;
      }
      if(prefs?.getString("descriptionControllerEvent")!=null){
        myControllerDescription.text = prefs!.getString("descriptionControllerEvent")!;
      }
      if(prefs?.getString("formLinkControllerEvent")!=null){
        myControllerFormLink.text = prefs!.getString("formLinkControllerEvent")!;
      }
      if(prefs?.getString("formNameControllerEvent")!=null){
        formNameController.text = prefs!.getString("formNameControllerEvent")!;
      }
      if(prefs?.getStringList('addEventTags') != null ){
        var _interests = prefs!.getStringList('addEventTags')!;
        for(var i=0;i<_interests.length;i++){
          selectedTags.add(_interests[i]);
        }
      }
      showAdditional = (formNameController.text.isNotEmpty || myControllerFormLink.text.isNotEmpty);
    });
  }
  SharedPreferences? prefs;


  @override
  Widget build(BuildContext context) {
    String selectedImage = fileNames.isEmpty? "Please select image(s)": fileNames.toString();
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
            resizeToAvoidBottomInset: true,

            appBar: AppBar(
              title: const Text(
                "Add Event",
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              elevation: 0,
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

                          /// Input fields
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///Title
                                  FormText('Title'),
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
                                            hintText: 'Enter Title',
                                          ),
                                          controller: myControllerTitle,
                                          validator: (val) {
                                            if(val == null || val.isEmpty) {
                                              setState(() {
                                              emptyTitleErr = "Title can't be empty";
                                            });
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),

                                  errorMessages(emptyTitleErr),


                                  ///Image Selector
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      FormText('Please Select Images'),
                                      const Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0, 10, 15, 0),
                                        child: Text(
                                          '(if any)',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 5, 15, 0),
                                    child: SizedBox(
                                      width: 250.0,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary:
                                              const Color(0xFF42454D),
                                              elevation: 0.0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      24.0))),
                                          onPressed: () async {
                                            Result = await FilePicker
                                                .platform
                                                .pickFiles(
                                              type: FileType.image,
                                              allowMultiple: true,
                                              withData: true,
                                            );
                                            if (Result != null) {
                                              setState(() {
                                                fileNames.clear();
                                                for (var i = 0;i < Result!.files.length; i++) {
                                                  fileNames.add(Result!.files[i].name);
                                                  byteDataImage.add(Result!.files[i].bytes);
                                                }
                                              });
                                            }
                                          },

                                          ///Selected images name
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(
                                                0.0, 7.0, 0.0, 7.0),
                                            child: Text(
                                              selectedImage.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17.0,
                                                  fontWeight:
                                                  FontWeight.w300),
                                            ),
                                          )),
                                    ),
                                  ),

                                  ///Selected Images
                                  if (Result != null)
                                    Wrap(
                                      children: Result!.files
                                          .map((e) => InkWell(
                                        onLongPress: () {
                                          setState(() {
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
                                      ))
                                          .toList(),
                                    ),
                                  if (Result != null)
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("long press to delete"),
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
                                            setState(() {
                                              emptyDescErr = "Description can't be empty";
                                            });
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                      ),
                                    ),
                                  ),

                                  errorMessages(emptyDescErr),

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
                                            setState(() {
                                              emptyLocationErr = "Location can't be empty";
                                            });
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),

                                  errorMessages(emptyLocationErr),

                                  ///Date-Time Field
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
                                        dateTime = DateFormat("yyyy-MM-DD hh:mm:ss").parse("$val:00"),
                                  },
                                      validator: (val) {
                                        return null;
                                      },
                                      // onSaved: (val) => print(val),
                                    ),
                                  ),

                                  ///Select Tags
                                  FormText('Please Select Tags'),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: SizedBox(
                                      width: 250,
                                      child: ElevatedButton(
                                        onPressed: ()async{
                                          final finalResult = await showSearch(
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
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
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
                                  errorMessages(emptyTagsError),

                                  ///Selected tags
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
                                      ///Call to Action Link
                                      Row(
                                        children: [
                                          FormText('Call To Action Link'),
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(0,10,15,0),
                                            child: Text(
                                              '(if any)',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      ///Button name
                                      const Padding(
                                        padding: EdgeInsets.fromLTRB(24,7,15,0),
                                        child: Text(
                                          'Button name',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                        child: SizedBox(
                                          height: 35.0,
                                          child: TextFormField(
                                            controller: formNameController,
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(100.0),
                                              ),
                                              hintText: 'Enter a name',
                                            ),
                                            keyboardType: TextInputType.multiline,
                                            validator: (val) {
                                              if(val!.isEmpty && myControllerFormLink.text.isNotEmpty) {
                                                setState(() {
                                                  emptyButtonNameErr = "Please provide button name too if you are giving link";
                                                });
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),

                                      errorMessages(emptyButtonNameErr),

                                      ///Link Field
                                      const Padding(
                                        padding: EdgeInsets.fromLTRB(24,7,15,0),
                                        child: Text(
                                          'Link',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                        child: SizedBox(
                                          height: 35.0,
                                          child: TextFormField(
                                            controller: myControllerFormLink,

                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(100.0),
                                              ),

                                              hintText: 'Enter URL',
                                            ),
                                            keyboardType: TextInputType.url,
                                            validator: (val) {
                                              if(val!.isEmpty && formNameController.text.isNotEmpty) {
                                                setState(() {
                                                  emptyFormLinkErr = 'Please provide link too if you are giving button name';
                                                });
                                              }
                                              if (val.isNotEmpty && !Uri.parse(val).isAbsolute)
                                              {
                                               setState(() {
                                                 emptyFormLinkErr = 'Please enter a valid link';
                                               });
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),

                                      errorMessages(emptyFormLinkErr),
                                    ],
                                  )
                                ],
                              ),

                          ///Discard and Submit Button
                          Padding(
                                padding: const EdgeInsets.fromLTRB(10, 15, 10, 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [

                                    ///Discard Button
                                    ElevatedButton(
                                      onPressed: () =>{
                                        myControllerTitle.clear(),
                                        myControllerDescription.clear(),
                                        myControllerFormLink.clear(),
                                        formNameController.clear(),
                                        selectedTags.clear(),
                                        prefs!.remove("titleControllerEvent"),
                                        prefs!.remove("descriptionControllerEvent"),
                                        prefs!.remove("formLinkControllerEvent"),
                                        prefs!.remove("formNameControllerEvent"),
                                        prefs!.remove("addEventTags"),
                                        Navigator.pop(context),
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.fromLTRB(15,5,15,5),
                                        child: Text(
                                          "Discard",
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
                                    ///Save Button
                                    ElevatedButton(
                                      onPressed: ()=>{
                                        prefs!.setString("titleControllerEvent", myControllerTitle.text),
                                        prefs!.setString("descriptionControllerNetop",myControllerDescription.text),
                                        prefs!.setString("formLinkControllerEvent",myControllerFormLink.text),
                                        prefs!.setString("formNameControllerEvent",formNameController.text),
                                        prefs!.setStringList("addEventTags", selectedTags),
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.fromLTRB(15,5,15,5),
                                        child: Text('Save',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),),
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
                                            document: gql(createEvent),
                                            onCompleted: (dynamic resultData){
                                              if(resultData["createEvent"]==true){
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

                                                if(myControllerTitle.text.isNotEmpty && myControllerDescription.text.isNotEmpty && myControllerLocation.text.isNotEmpty) {
                                                  for (var i = 0; i <
                                                      selectedTags
                                                          .length; i++) {
                                                    key =
                                                        tagList.keys
                                                            .firstWhere((k) =>
                                                        tagList[k] ==
                                                            selectedTags[i]);
                                                    selectedIds.add(key);
                                                  }
                                                  if (selectedIds.isEmpty) {
                                                    setState(() {
                                                      emptyTagsError =
                                                      "Please select at least one tag";
                                                    });
                                                  }
                                                  else {
                                                    for(var i=0;i<byteDataImage.length;i++) {
                                                      multipartfileImage.add(
                                                          MultipartFile.fromBytes(
                                                            'photo',
                                                            byteDataImage[i],
                                                            filename: fileNames[i],
                                                            contentType: MediaType(
                                                                "image", fileNames[i].split(".").last),
                                                          ));
                                                    }
                                                    runMutation({
                                                      "newEventData": {
                                                        "content": myControllerDescription
                                                            .text,
                                                        "title": myControllerTitle
                                                            .text,
                                                        "tagIds": selectedIds,
                                                        "time": "$dateTime",
                                                        "linkName": formNameController
                                                            .text,
                                                        "linkToAction": myControllerFormLink
                                                            .text,
                                                        "location": myControllerLocation
                                                            .text,
                                                      },
                                                      "image": multipartfileImage.isEmpty
                                                          ? null
                                                          : multipartfileImage,
                                                    });
                                                  }
                                                }
                                                }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: const Color(0xFF2B2E35),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(24)
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                              minimumSize: const Size(80, 35),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.fromLTRB(15,5,15,5),
                                              child: Text('Submit',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
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
