import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/netops.dart';
import 'package:client/models/formErrormsgs.dart';
import 'package:client/widgets/formTexts.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'package:client/models/searchDelegate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class AddPost extends StatefulWidget {
  final Future<QueryResult?> Function()? refetchPosts;
  AddPost({required this.refetchPosts});
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  ///GraphQL
  String createNetop = netopsQuery().createNetop;

  ///Variables
  String selectedImage = "Please select images";
  String getTags =authQuery().getTags;
  Map<String,String>tagList={};
  List<String>selectedTags=[];
  List<String>selectedIds=[];
  String emptyTagsError = '';
  var dateTime=DateTime.now().add(const Duration(days: 7));
  var key;
  var byteDataImage;
  var multipartfileImage;
  bool showAdditional = false;
  List byteDataAttachment=[];
  List multipartfileAttachment=[];
  List AttachmentNames = ['Please select attachments'];
  PlatformFile? file=null;

  ///Controllers
  TextEditingController descriptionController =TextEditingController();
  TextEditingController titleController =TextEditingController();
  TextEditingController endTimeController =TextEditingController();
  TextEditingController urlController= TextEditingController();
  TextEditingController urlNameController= TextEditingController();

  ///Keys
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

          resizeToAvoidBottomInset: false,

          appBar: AppBar(
            title: const Text('Add Post',
              style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),
            backgroundColor: const Color(0xFF2B2E35),
            elevation: 0.0,
          ),

          backgroundColor: const Color(0xFFDFDFDF),

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
              child: ListView(
                children: [
                  SingleChildScrollView(
                    child:
                    Form(
                      key:_formKey,
                      child:
                      ///Input fields
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///Title field
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

                          ///Description field
                          const SizedBox(
                            height: 10,
                          ),
                          FormText('Description'),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 5, 15, 5),
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

                          ///End Time field
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

                          ///Date Time Picker
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
                                print("datetimr:$dateTime+05:30"),
                              },
                              validator: (val) {
                                print(val);
                                return null;
                              },
                              onSaved: (val) => print(val),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          ///Tag Selector
                          FormText('Please Select Tags'),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: SizedBox(
                              width: 250,
                              child: ElevatedButton(
                                  onPressed: ()async{
                                    final finalResult=await showSearch(
                                      context: context,
                                      delegate: CustomSearchDelegate(searchTerms:tagList),
                                    );
                                    setState(() {
                                      if(finalResult!=''){
                                        if(!selectedTags.contains(finalResult))
                                          selectedTags.add(finalResult);
                                      }
                                    });
                                    print("finalResult:$finalResult");
                                    print("SelectedTags:$selectedTags");
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
                                showAdditional? const Icon(Icons.arrow_upward):const Icon(Icons.arrow_downward),
                              ],
                            ),
                            onTap: (){
                              setState(() {
                                showAdditional = !showAdditional;
                              });
                            },
                          ),

                          ///Call to Action Link
                          if(showAdditional)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                    controller: urlController,

                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100.0),
                                      ),

                                      hintText: 'Enter URL',
                                    ),
                                    keyboardType: TextInputType.url,
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
                                  child: ElevatedButton(
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
                                          withData: true,
                                        );
                                        if (result != null) {
                                          file = result.files.first;
                                          setState(() {
                                            selectedImage = file!.name;
                                            byteDataImage= file!.bytes;
                                            multipartfileImage=MultipartFile.fromBytes(
                                              'photo',
                                              byteDataImage,
                                              filename: selectedImage,
                                              contentType: MediaType("image","png"),
                                            );
                                          });
                                        }
                                      },
                                      ///Selected images name
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
                                      )),
                                ),
                              ),

                              ///Selected Images
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

                  ///Discard Button
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Delete Button
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
                              document: gql(createNetop),
                              onCompleted: (dynamic resultData){
                                if(resultData["createNetop"]==true){
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
                                        setState(() {
                                          emptyTagsError =
                                          "Please Select at least one Tag";
                                        });
                                      }
                                      else {
                                        await runMutation({
                                          "newEventData": {
                                            "content": descriptionController
                                                .text,
                                            "title": titleController.text,
                                            "tags": selectedIds,
                                            "endTime": "$dateTime",
                                            "linkName": urlNameController.text,
                                            "linkToAction": urlController.text,
                                          },
                                          "image": multipartfileImage,
                                          "attachments": multipartfileAttachment,
                                        });
                                      }
                                    }
                                  },
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
              )
              ),
            ),
          );
      },
    );
  }
}


