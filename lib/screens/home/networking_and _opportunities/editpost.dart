import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/netops.dart';
import 'package:client/models/post.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:file_picker/file_picker.dart';

class EditPost extends StatefulWidget {
  final Post post;
  EditPost({required this.post});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  String editNetop = netopsQuery().editNetop;
  String? selectedImage = "Please select an image";
  TextEditingController descriptionController =TextEditingController();
  TextEditingController titleController =TextEditingController();

  String getTags =authQuery().getTags;
  var imageResult;
  Map<String,String>tagList={};
  List<String>selectedTags=[];
  List<String>selectedIds=[];
  var dateTime;
  var key;
  late String endTime;

  @override
  Widget build(BuildContext context) {
    var post=widget.post;
    titleController.text=post.title;
    descriptionController.text=post.description;
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
            title: const Text('Edit Post'),
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
                                  )
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
                              Text(
                                'Title',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              SizedBox(
                                height: 35.0,
                                child: TextFormField(
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
                                child: StatefulBuilder(
                                  builder: (BuildContext context,StateSetter setState){
                                    return ElevatedButton(
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
                                          );
                                          if (result != null) {
                                            PlatformFile file = result.files.first;
                                            setState(() {
                                              selectedImage = file.name;
                                            });
                                          }
                                          imageResult=result;
                                          print(result.toString());
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
                                        ));
                                  },
                                )
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
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100.0),
                                    ),
                                  ),
                                ),
                              ),
                              Text('End Time'),
                              DateTimePicker(
                                type: DateTimePickerType.dateTimeSeparate,
                                dateMask: 'd MMM, yyyy',
                                initialValue: post.endTime,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                icon: Icon(Icons.event),
                                dateLabelText: 'Date',
                                timeLabelText: "Hour",
                                onChanged: (val) => {
                                  dateTime=val,
                                  print("$dateTime:00+5:30"),
                                },
                                validator: (val) {
                                  print(val);
                                  return null;
                                },
                                onSaved: (val) => print(val),
                              ),
                              Text('what is the url about',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  hintText: 'Eg form link',
                                ),
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
                        TextButton(onPressed: ()=>{}, child:Text('Save')),
                        Mutation(
                            options: MutationOptions(
                              document: gql(editNetop),
                            ),
                            builder: (
                                RunMutation runMutation,
                                QueryResult? result,
                                ) {
                              if (result!.hasException){
                                print(result.exception.toString());
                              }
                              if(result.isLoading){}
                              return TextButton(
                                  onPressed: ()=>{
                                    endTime="$dateTime"+":00+05:30",
                                    for(var i=0;i<selectedTags.length;i++){
                                      key = tagList.keys.firstWhere((k) => tagList[k]==selectedTags[i],orElse: ()=>""),
                                      selectedIds.add(key),
                                    },
                                    print("selectedTadIds:$selectedIds"),
                                    //ToDo write mutation variables
                                    runMutation({
                                      "editNetopNetopId":post.id,
                                      "editNetopsData":{
                                        "title":titleController.text,
                                        "content":descriptionController.text,
                                        "endtime":"2022-01-31 17:17:00+05:30",
                                      },
                                      "tags":selectedIds,
                                      "editNetopImage":imageResult,
                                    })
                                  },
                                  child:Text('Submit'));
                            }
                        ),
                      ],
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
}

class CustomSearchDelegate extends SearchDelegate {
  final Map<String,String> searchTerms;

  CustomSearchDelegate({required this.searchTerms});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear)
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(onPressed: () {
      close(context, query);
    }, icon: Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> matchQuery = searchTerms.values.where(
            (searchTerm) =>
            searchTerm.toLowerCase().contains(query.toLowerCase(),)
    ).toList();
    print('matchQuery:$matchQuery');
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap:(){
            query=result;
            close(context, query);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> matchQuery=searchTerms.values.where(
            (searchTerm) =>
            searchTerm.toLowerCase().contains(query.toLowerCase(),)
    ).toList();
    print(matchQuery);
    // final List<String> matchQuery = searchTerms.where(
    //         (searchTerm) =>
    //         searchTerm.toLowerCase().contains(query.toLowerCase(),)
    // ).toList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
            title: Text(result),
            onTap: (){
              query=result;
              close(context, query);
            }
        );
      },
    );
  }
}
