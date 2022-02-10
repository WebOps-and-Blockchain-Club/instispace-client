import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/netops.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'package:client/models/compressFunction.dart';
import 'package:client/models/searchDelegate.dart';
class AddPost extends StatefulWidget {
  final Future<QueryResult?> Function()? refetchPosts;
  AddPost({required this.refetchPosts});
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String createNetop = netopsQuery().createNetop;
  String selectedImage = "Please select an image";
  TextEditingController descriptionController =TextEditingController();
  TextEditingController titleController =TextEditingController();
  TextEditingController endTimeController =TextEditingController();
  TextEditingController urlController= TextEditingController();
  TextEditingController urlNameController= TextEditingController();
  String getTags =authQuery().getTags;
  Map<String,String>tagList={};
  List<String>selectedTags=[];
  List<String>selectedIds=[];
  var dateTime=DateTime.now().toString();
  var key;
  var byteDataImage;
  var multipartfileImage;
  List byteDataAttachment=[];
  List multipartfileAttachment=[];
  List AttachmentNames=[];
  PlatformFile? file=null;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getTags),
      ),
      builder: (QueryResult result, {fetchMore, refetch}){
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
        print("TagList:$tagList");

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Add Post'),
            backgroundColor: Color(0xFFE6CCA9),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: SizedBox(
                height: 750,
                width: 400,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 600.0,
                        width: 400.0,
                        child: SingleChildScrollView(
                          child:
                          Form(
                            key:_formKey,
                            child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton(onPressed: ()async{
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
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          )
                                      ),
                                    ),
                                    child: Text(
                                      'select tags',
                                    )),
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
                                Text(
                                  'Title',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 35.0,
                                  child: TextFormField(
                                    validator: (value){
                                      if (value == null || value.isEmpty) {
                                        return 'Title cannot be empty';
                                      }
                                      return null;
                                      },
                                    controller: titleController,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(7.0, 10.0, 5.0, 2.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100.0),
                                      ),
                                      hintText: 'Enter Title',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                TextFormField(
                                  controller: descriptionController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(7.0, 10.0, 5.0, 2.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100.0),
                                    ),
                                    hintText: 'Enter Description',
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  validator: (value){
                                    if (value == null || value.isEmpty) {
                                      return 'Description cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'image',
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
                                SizedBox(
                                  height: 10.0,
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
                                Text('End Time'),
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
                                Text(
                                  'Url',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 35.0,
                                  child: TextFormField(
                                    controller: urlController,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100.0),
                                      ),
                                    ),
                                    validator: (value){
                                      return null;
                                    },
                                  ),
                                ),
                                Text('what is the url about',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                TextFormField(
                                  controller: urlNameController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100.0),
                                    ),
                                    hintText: 'Eg form link',
                                  ),
                                  validator: (value){
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(onPressed: ()=>{}, child:Text('Delete')),
                          // TextButton(onPressed: ()=>{}, child:Text('Save')),
                          Mutation(
                              options: MutationOptions(
                                document: gql(createNetop),
                                onCompleted: (dynamic resultData){
                                  print(resultData);
                                  if(resultData["createNetop"]==true){
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
                                        print(_formKey.currentState!.validate());
                                        for(var i=0;i<selectedTags.length;i++){
                                          key = tagList.keys.firstWhere((k) => tagList[k]==selectedTags[i]);
                                          selectedIds.add(key);
                                        };
                                        print("selectedTagIds:$selectedIds");
                                        await runMutation({
                                          "newEventData":{
                                            "content":descriptionController.text,
                                            "title":titleController.text,
                                            "tags":selectedIds,
                                            "endTime":dateTime,
                                            "linkName":urlNameController.text,
                                            "linkToAction":urlController.text,
                                          },
                                          "image":multipartfileImage,
                                          "attachments":multipartfileAttachment,
                                        });
                                      }
                                    },
                                    child:Text('Submit'));
                              }
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ),
            ),
          );
      },
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


