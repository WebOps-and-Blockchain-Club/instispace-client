import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/netops.dart';
import 'package:client/models/formErrormsgs.dart';
import 'package:client/models/netopsClass.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:client/models/searchDelegate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../widgets/formTexts.dart';
class EditPost extends StatefulWidget {
  final NetOpPost post;
  final Future<QueryResult?> Function()? refetchNetops;
  EditPost({required this.post,required this.refetchNetops});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {

  ///GraphQL
  String editNetop = netopsQuery().editNetop;
  String getTags =authQuery().getTags;

  ///Variables
  List<String>selectedTags=[];
  List<String>selectedIds=[];
  List byteDataAttachment=[];
  List multipartfileAttachment=[];
  List AttachmentNames=['Please select attachments'];
  Map<String,String>tagList={};
  String? selectedImage = "Please select an image";
  String emptyTagsError = '';
  bool showAdditional = false;
  var key;
  var imageResult;

  ///Controllers
  TextEditingController descriptionController =TextEditingController();
  TextEditingController titleController =TextEditingController();
  TextEditingController urlController= TextEditingController();
  TextEditingController urlNameController= TextEditingController();


  @override
  Widget build(BuildContext context) {

    ///Retrieving data of initial netops post
    var post=widget.post;
    var dateTime=post.endTime;
    titleController.text=post.title;
    descriptionController.text=post.description;
    if(post.linkToAction!=null && post.linkToAction!=""){
      urlController.text=post.linkToAction!;
    }
    if(post.linkName!=null && post.linkName!=""){
      urlNameController.text=post.linkName!;
    }
    return Query(
      options: QueryOptions(
        document: gql(getTags),
      ),
      builder: (QueryResult result, {fetchMore, refetch}){
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
            title: const Text('Edit Post',
              style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),
            backgroundColor: const Color(0xFF2B2E35),
          ),

          backgroundColor: const Color(0xFFDFDFDF),

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
              child: SizedBox(
                child: ListView(
                  children: [
                    SingleChildScrollView(
                      child:
                      Form(
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///Title
                            FormText('Title'),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 5, 15, 5),
                              child: SizedBox(
                                height: 35.0,
                                child: TextFormField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100.0),
                                    ),

                                    hintText: 'Enter title',
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

                            ///Description
                            const SizedBox(
                              height: 10,
                            ),
                            FormText('Description'),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 7, 15, 5),
                              child: SizedBox(
                                height: 35.0,
                                child: TextFormField(
                                  controller: descriptionController,

                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100.0),
                                    ),

                                    hintText: 'Enter description',
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  validator: (value){
                                    if (value == null || value.isEmpty) {
                                      return 'Item Name cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            ///End Time
                            const SizedBox(
                              height: 10,
                            ),
                            Wrap(
                              children: [
                                FormText('End Time'),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(15,5,15,0),
                                  child: Text(
                                    '(Post will be displayed till the end time is reached)',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            ///Date Time Picker for endTime
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 15, 5),
                              child: DateTimePicker(
                                type: DateTimePickerType.dateTimeSeparate,
                                dateMask: 'd MMM, yyyy',
                                initialValue: post.endTime,
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


                            ///Tag Selector
                            const SizedBox(
                              height: 10,
                            ),
                            FormText('Please Select Tags'),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                              child: SizedBox(
                                  width: 250,
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,StateSetter setState) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            width:250,
                                            child: ElevatedButton(
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
                                                style: ElevatedButton.styleFrom(
                                                    primary: const Color(0xFF42454D),
                                                    elevation: 0.0,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0))
                                                ),
                                                child: const Text('Select tags',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17.0,
                                                      fontWeight: FontWeight.w300
                                                  ),)),
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
                                        ],
                                      );
                                    },
                                  )
                              ),
                            ),


                            ///Additional fields
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
                                 const SizedBox(
                                   height: 10,
                                 ),
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

                                 ///Link Name
                                 const Padding(
                                   padding: EdgeInsets.fromLTRB(21,7,15,0),
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
                                   padding: const EdgeInsets.fromLTRB(18, 5, 15, 5),
                                   child: SizedBox(
                                     height: 35.0,
                                     child: TextFormField(
                                       controller: urlNameController,

                                       decoration: InputDecoration(
                                         contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                         border: OutlineInputBorder(
                                           borderRadius: BorderRadius.circular(100.0),
                                         ),

                                         hintText: 'Enter a name',
                                       ),
                                       keyboardType: TextInputType.multiline,
                                       validator: (val) {
                                         if(val!.isEmpty && urlController.text.isNotEmpty) {
                                           return "Please provide button name too if you are giving link";
                                         }
                                         return null;
                                       },
                                     ),
                                   ),
                                 ),

                                 ///Link Field
                                 const Padding(
                                   padding: EdgeInsets.fromLTRB(21,7,15,0),
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
                                   padding: const EdgeInsets.fromLTRB(18, 5, 15, 5),
                                   child: SizedBox(
                                     height: 35.0,
                                     child: TextFormField(
                                       controller: urlController,

                                       decoration: InputDecoration(
                                         contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                         border: OutlineInputBorder(
                                           borderRadius: BorderRadius.circular(100.0),
                                         ),

                                         hintText: 'Enter URL',
                                       ),
                                       keyboardType: TextInputType.multiline,
                                       validator: (val) {
                                         if(val!.isEmpty && urlNameController.text.isNotEmpty) {
                                           return 'Please provide link too if you are giving button name';
                                         }
                                         if (val!.isNotEmpty && !Uri.parse(val).isAbsolute)
                                         {
                                           return 'Please provide a valid link';
                                         }
                                         return null;
                                       },
                                     ),
                                   ),
                                 ),

                                 ///Image Selector
                                 const SizedBox(
                                   height: 10,
                                 ),
                                 Row(
                                   children: [
                                     FormText('Please Select Images'),
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
                                 Padding(
                                   padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                   child: SizedBox(
                                       width: 250.0,
                                       child: StatefulBuilder(
                                         builder: (BuildContext context,StateSetter setState){
                                           return ElevatedButton(
                                               style: ElevatedButton.styleFrom(
                                                   primary: const Color(0xFF42454D),
                                                   elevation: 0.0,
                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0))
                                               ),
                                               onPressed: () async {
                                                 final FilePickerResult? result =
                                                 await FilePicker.platform.pickFiles(
                                                   type: FileType.image,
                                                   allowMultiple: false,
                                                 );
                                                 if (result != null) {
                                                   PlatformFile file = result.files.first;
                                                   setState(() {
                                                     selectedImage = file.name;
                                                   });
                                                 }
                                                 imageResult=result;
                                               },

                                               ///Image name
                                               child: Padding(
                                                 padding: const EdgeInsets.fromLTRB(0.0,7.0,0.0,7.0),
                                                 child: Text(
                                                   selectedImage.toString(),
                                                   style: const TextStyle(
                                                       color: Colors.white,
                                                       fontSize: 17.0,
                                                       fontWeight: FontWeight.w300
                                                   ),
                                                 ),
                                               ));
                                         },
                                       )
                                   ),
                                 ),


                                 ///Attachment Selector
                                 const SizedBox(
                                   height: 10,
                                 ),
                                 Row(
                                   children: [
                                     FormText('Please Select Attachments'),
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
                                 Padding(
                                   padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                   child: SizedBox(
                                     width: 250.0,
                                     child: ElevatedButton(
                                         style: ElevatedButton.styleFrom(
                                             primary: const Color(0xFF42454D),
                                             elevation: 0.0,
                                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0))
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

                                         ///Attachments Name
                                         child: Padding(
                                           padding: const EdgeInsets.fromLTRB(0.0,7.0,0.0,7.0),
                                           child: Text(
                                             AttachmentNames.toString(),
                                             style: const TextStyle(
                                                 color: Colors.white,
                                                 fontSize: 17.0,
                                                 fontWeight: FontWeight.w300
                                             ),
                                           ),
                                         )),
                                   ),
                                 ),
                               ],
                             )
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    ///Discard and Submit Buttons
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ///Discard Button
                          ElevatedButton(
                            onPressed: ()=>{
                              Navigator.pop(context)
                            },
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(15,5,15,5),
                              child: Text('Discard',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),),
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

                          ///Edit Button
                          Mutation(
                              options: MutationOptions(
                                document: gql(editNetop),
                                  onCompleted: (dynamic resultData){
                                    if(resultData["editNetop"]==true){
                                      Navigator.pop(context);
                                      widget.refetchNetops!();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Post Edited')),
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
                                    onPressed: ()=>{
                                      for(var i=0;i<selectedTags.length;i++){
                                        key = tagList.keys.firstWhere((k) => tagList[k]==selectedTags[i],orElse: ()=>""),
                                        selectedIds.add(key),
                                      },
                                      if (selectedIds.isEmpty) {
                                        emptyTagsError = 'Please select at least one tag'
                                      }
                                      else{
                                    runMutation({
                                      "netopId":post.id,
                                      "editNetopsData":{
                                      "title":titleController.text,
                                      "content":descriptionController.text,
                                      "endTime":dateTime,
                                      "tagIds":selectedIds,
                                      "linkName":urlNameController.text,
                                      "linkToAction":urlController.text,
                                      },
                                      "image":imageResult,
                                      "attachments":multipartfileAttachment,
                                    })
                                    }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.fromLTRB(15,5,15,5),
                                      child: Text('Submit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),),
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

