import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({Key? key}) : super(key: key);

  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  //rating
  bool rating = false;
  bool rat_is1 = false;
  bool rat_is2 = false;
  bool rat_is3 = false;
  bool rat_is4 = false;
  bool rat_is5 = false;

  //recommend
  bool reco = false;
  bool rec_is1 = false;
  bool rec_is2 = false;
  bool rec_is3 = false;
  bool rec_is4 = false;
  bool rec_is5 = false;

  //easy
  bool easy = false;
  bool eas_is1 = false;
  bool eas_is2 = false;
  bool eas_is3 = false;
  bool eas_is4 = false;
  bool eas_is5 = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Feedback",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2B2E35),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFDFDFDF),
      body: ListView(
        children: [
          Form(
            // key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Rating Question
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                    child: Wrap(
                      children: const [
                        Text("How would you rate our app?",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Rating Selector
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //1  Star
                        IconButton(
                          onPressed: (){
                            setState(() {
                              rating = true;
                              rat_is1 = true;
                              rat_is2 = false;
                              rat_is3 = false;
                              rat_is4 = false;
                              rat_is5 = false;
                            });
                          },
                          icon: (rat_is1 || rat_is2 || rat_is3 || rat_is4 || rat_is5)
                              ? const Icon(Icons.star): const Icon(Icons.star_border),
                          color: const Color(0xFF222222),
                        ),

                        //2  Star
                        IconButton(
                          onPressed: (){
                            setState(() {
                              rat_is1 = true;
                              rat_is2 = true;
                              rat_is3 = false;
                              rat_is4 = false;
                              rat_is5 = false;
                            });
                          },
                          icon: (rat_is2)
                              ? const Icon(Icons.star): const Icon(Icons.star_border),
                          color: const Color(0xFF222222),
                        ),

                        //3  Star
                        IconButton(
                          onPressed: (){
                            setState(() {
                              rat_is1 = true;
                              rat_is2 = true;
                              rat_is3 = true;
                              rat_is4 = false;
                              rat_is5 = false;
                            });
                          },
                          icon: (rat_is3)
                              ? const Icon(Icons.star): const Icon(Icons.star_border),
                          color: const Color(0xFF222222),
                        ),

                        //4  Star
                        IconButton(
                          onPressed: (){
                            setState(() {
                              rat_is1 = true;
                              rat_is2 = true;
                              rat_is3 = true;
                              rat_is4 = true;
                              rat_is5 = false;
                            });
                          },
                          icon: (rat_is4)
                              ? const Icon(Icons.star): const Icon(Icons.star_border),
                          color: const Color(0xFF222222),
                        ),

                        //5  Star
                        IconButton(
                          onPressed: (){
                            setState(() {
                              rat_is1 = true;
                              rat_is2 = true;
                              rat_is3 = true;
                              rat_is4 = true;
                              rat_is5 = true;
                            });
                          },
                          icon: (rat_is5)
                              ? const Icon(Icons.star): const Icon(Icons.star_border),
                          color: const Color(0xFF222222),
                        ),
                      ],
                    ),
                  ),

                  //Easy Question
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 5),
                    child: Wrap(
                      children: const [
                        Text("How easy was it to use our app?",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Easy Selector
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //1  Star
                        IconButton(
                          onPressed: (){
                            setState(() {
                              easy = true;
                              eas_is1 = true;
                              eas_is2 = false;
                              eas_is3 = false;
                              eas_is4 = false;
                              eas_is5 = false;
                            });
                          },
                          icon: (eas_is1)
                              ? const Icon(Icons.star): const Icon(Icons.star_border),
                          color: const Color(0xFF222222),
                        ),

                        //2  Star
                        IconButton(
                          onPressed: (){
                            setState(() {
                              easy = true;
                              eas_is1 = true;
                              eas_is2 = true;
                              eas_is3 = false;
                              eas_is4 = false;
                              eas_is5 = false;
                            });
                          },
                          icon: (eas_is2)
                              ? const Icon(Icons.star): const Icon(Icons.star_border),
                          color: const Color(0xFF222222),
                        ),

                        //3  Star
                        IconButton(
                          onPressed: (){
                            setState(() {
                              easy = true;
                              eas_is1 = true;
                              eas_is2 = true;
                              eas_is3 = true;
                              eas_is4 = false;
                              eas_is5 = false;
                            });
                          },
                          icon: (eas_is3)
                              ? const Icon(Icons.star): const Icon(Icons.star_border),
                          color: const Color(0xFF222222),
                        ),

                        //4  Star
                        IconButton(
                          onPressed: (){
                            setState(() {
                              easy = true;
                              eas_is1 = true;
                              eas_is2 = true;
                              eas_is3 = true;
                              eas_is4 = true;
                              eas_is5 = false;
                            });
                          },
                          icon: (eas_is4)
                              ? const Icon(Icons.star): const Icon(Icons.star_border),
                          color: const Color(0xFF222222),
                        ),

                        //5  Star
                        IconButton(
                          onPressed: (){
                            setState(() {
                              easy = true;
                              eas_is1 = true;
                              eas_is2 = true;
                              eas_is3 = true;
                              eas_is4 = true;
                              eas_is5 = true;
                            });
                          },
                          icon: (eas_is5)
                              ? const Icon(Icons.star): const Icon(Icons.star_border),
                          color: const Color(0xFF222222),
                        ),
                      ],
                    ),
                  ),

                  //Recommend Question
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                    child: Wrap(
                      children: const [
                        Text("How likely is that would you recommend the app your friends?",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Recommend Selector
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //1  Star
                        IconButton(
                          onPressed: (){
                            setState(() {
                              reco = true;
                              rec_is1 = true;
                              rec_is2 = false;
                              rec_is3 = false;
                              rec_is4 = false;
                              rec_is5 = false;
                            });
                          },
                          icon: (rec_is1)
                              ? const Icon(Icons.star): const Icon(Icons.star_border),
                          color: const Color(0xFF222222),
                        ),

                        //2  Star
                        IconButton(
                          onPressed: (){
                            setState(() {
                              reco = true;
                              rec_is1 = true;
                              rec_is2 = true;
                              rec_is3 = false;
                              rec_is4 = false;
                              rec_is5 = false;
                            });
                          },
                          icon: (rec_is2)
                              ? const Icon(Icons.star): const Icon(Icons.star_border),
                          color: const Color(0xFF222222),
                        ),

                        //3  Star
                        IconButton(
                          onPressed: (){
                            setState(() {
                              reco = true;
                              rec_is1 = true;
                              rec_is2 = true;
                              rec_is3 = true;
                              rec_is4 = false;
                              rec_is5 = false;
                            });
                          },
                          icon: (rec_is3)
                              ? const Icon(Icons.star): const Icon(Icons.star_border),
                          color: const Color(0xFF222222),
                        ),

                        //4  Star
                        IconButton(
                          onPressed: (){
                            setState(() {
                              reco = true;
                              rec_is1 = true;
                              rec_is2 = true;
                              rec_is3 = true;
                              rec_is4 = true;
                              rec_is5 = false;
                            });
                          },
                          icon: (rec_is4)
                              ? const Icon(Icons.star): const Icon(Icons.star_border),
                          color: const Color(0xFF222222),
                        ),

                        //5  Star
                        IconButton(
                          onPressed: (){
                            setState(() {
                              setState(() {
                                reco = true;
                                rec_is1 = true;
                                rec_is2 = true;
                                rec_is3 = true;
                                rec_is4 = true;
                                rec_is5 = true;
                              });
                            });
                          },
                          icon: (rec_is5)
                              ? const Icon(Icons.star): const Icon(Icons.star_border),
                          color: const Color(0xFF222222),
                        ),
                      ],
                    ),
                  ),
                  
                  //Expander
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
                    child: ExpandablePanel(
                        controller: ExpandableController(

                        ),
                        header: const Center(
                          child: Text('Additional Feedback',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ),
                        collapsed: Column(),
                        expanded: Column(
                          children: [
                            //Like Question
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                              child: Wrap(
                                children: const [
                                  Text("What did you like the most about the app & why?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Color(0xFF222222),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //Like Field
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 10, 15, 5),
                              child: SizedBox(
                                height: 35.0,
                                child: TextFormField(
                                  // controller: nameController,

                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100.0),
                                    ),

                                    hintText: 'Enter text',
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

                            //Not like Question
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: Wrap(
                                children: const [
                                  Text('What did you not like about the app & why?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Color(0xFF222222),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //Not like Field
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 10, 15, 5),
                              child: SizedBox(
                                height: 35.0,
                                child: TextFormField(
                                  // controller: locationController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(7.0, 10.0, 5.0, 2.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100.0),
                                    ),
                                    hintText: 'Enter text',
                                  ),
                                  validator: (value){
                                    if (value == null || value.isEmpty) {
                                      return 'Location cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            //Suggestions Question
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: Wrap(
                                children: const [
                                  Text("Do you have any suggestions?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Color(0xFF222222),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //Suggestions Field
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 10, 15, 0),
                              child: SizedBox(
                                height: 35.0,
                                child: TextFormField(
                                  // controller: contactController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(7.0, 10.0, 5.0, 2.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100.0),
                                    ),
                                    hintText: 'Enter text',
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                    ),
                  ),

                  //Button
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Submit Button
                        ElevatedButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: const Text("Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF42454D),
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            minimumSize: const Size(80, 35),
                          ),
                        ),

                        //Post Button
                        // Mutation(
                        //     options:MutationOptions(
                        //         document: gql(createItem),
                        //         onCompleted: (dynamic resultData){
                        //           print("result:$resultData");
                        //           if(resultData["createItem"]==true){
                        //             Navigator.pop(context);
                        //             widget.refetchPosts!();
                        //             ScaffoldMessenger.of(context).showSnackBar(
                        //               const SnackBar(content: Text('Post Created')),
                        //             );
                        //           }
                        //           else{
                        //             ScaffoldMessenger.of(context).showSnackBar(
                        //               const SnackBar(content: Text('Post Creation Failed')),
                        //             );
                        //           }
                        //         },
                        //         onError: (dynamic error){
                        //           print("error:$error");
                        //           ScaffoldMessenger.of(context).showSnackBar(
                        //             const SnackBar(content: Text('Post Creation Failed,server Error')),
                        //           );
                        //         }
                        //     ),
                        //     builder:(
                        //         RunMutation runMutation,
                        //         QueryResult? result,
                        //         ){
                        //       if (result!.hasException){
                        //         print(result.exception.toString());
                        //       }
                        //       return ElevatedButton(
                        //         onPressed: ()async{
                        //           print("${multipartfile.isEmpty ? null : multipartfile}");
                        //           print("result:$multipartfile");
                        //           // print("contact:${contactController.text}");
                        //           if (_formKey.currentState!.validate()){
                        //             await runMutation({
                        //               "itemInput": {
                        //                 "name": nameController.text,
                        //                 "location":locationController.text,
                        //                 "time":dateTime,
                        //                 "category": "LOST",
                        //                 "contact":contactController.text,
                        //               },
                        //               "images": multipartfile.isEmpty ? null : multipartfile,
                        //             });
                        //           }
                        //         },
                        //         child: Text("Post",
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 16,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //         style: ElevatedButton.styleFrom(
                        //           primary: Color(0xFF42454D),
                        //           padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        //           minimumSize: Size(80, 35),
                        //         ),
                        //       );
                        //     }
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
