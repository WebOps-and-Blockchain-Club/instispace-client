import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  @override
  Widget build(BuildContext context) {
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
            height: 650,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Title',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  ElevatedButton(onPressed: ()=>{},
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
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: 35.0,
                                child: TextFormField(
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
                              TextFormField(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  hintText: 'Attach files',
                                ),
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
                    TextButton(onPressed: ()=>{}, child:Text('Submit')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
