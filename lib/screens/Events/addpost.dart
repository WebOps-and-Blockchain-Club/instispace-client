import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:date_time_picker/date_time_picker.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  final myControllerTitle = TextEditingController();
  final myControllerLocation = TextEditingController();
  final myControllerDescription = TextEditingController();
  final myControllerImgUrl= TextEditingController();
  final myControllerFormLink = TextEditingController();

  @override


  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerTitle.dispose();
    myControllerLocation.dispose();
    myControllerDescription.dispose();
    myControllerImgUrl.dispose();
    myControllerFormLink.dispose();
    super.dispose();
  }
  bool emptyValidation =true;
  bool urlValidation =true;
  void addPostFunc() {
    urlValidation = isURL(myControllerImgUrl.text);
    emptyValidation = myControllerTitle.text.isNotEmpty &&
        myControllerLocation.text.isNotEmpty &&
        myControllerDescription.text.isNotEmpty &&
        myControllerImgUrl.text.isNotEmpty &&
        myControllerFormLink.text.isNotEmpty;
    if ( emptyValidation && urlValidation ) {
      Navigator.pop(context, {
        'title': myControllerTitle.text,
        'location': myControllerLocation.text,
        'description': myControllerDescription.text,
        'imgUrl': myControllerImgUrl.text,
        'formLink': myControllerFormLink.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Event",
          style: TextStyle(
            color: Colors.black,
          ),),
        backgroundColor: Color(0xFFE6CCA9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(200.0, 0.0, 0.0, 0.0),
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text("Select Tags",
                      style: TextStyle(
                        color: Colors.black,
                      ),),
                    color: Color(0xFFE6CCA9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1500.0),
                    ),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter title',
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.circular(20.0)
                      )
                  ),
                  controller: myControllerTitle,
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
                  selectableDayPredicate: (date) {
                    // Disable weekend days to select from the calendar
                    if (date.weekday == 6 || date.weekday == 7) {
                      return false;
                    }

                    return true;
                  },
                  onChanged: (val) => print(val),
                  validator: (val) {
                    print(val);
                    return null;
                  },
                  onSaved: (val) => print(val),
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter Location',
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.circular(20.0)
                      )
                  ),
                  controller: myControllerLocation,
                ),
                SizedBox(height: 5.0,),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter description',
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.circular(20.0)
                      )
                  ),
                  controller: myControllerDescription,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter image Url',
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.circular(20.0)
                      )
                  ),
                  controller: myControllerImgUrl,
                ),
                SizedBox(height: 5.0,),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter Form Link',
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.circular(20.0)
                      )
                  ),
                  controller: myControllerFormLink,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(onPressed: () {},
                  child: Text("Save",
                    style: TextStyle(
                        color: Colors.black
                    ),),
                  color: Color(0xFFE6CCA9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1500.0),
                  ),),
                RaisedButton(onPressed: () {},
                  child: Text("Discard Changes",
                    style: TextStyle(
                        color: Colors.black
                    ),),
                  color: Color(0xFFE6CCA9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1500.0),
                  ),),
                RaisedButton(onPressed: () {
                  addPostFunc();
                  if(urlValidation==false && emptyValidation==true)
                  {
                    showDialog(
                        context: context,
                        builder:(context){
                          return AlertDialog(
                            content: Text('Invalid url'),
                          );
                        }
                    );
                  }
                  if(emptyValidation==false && urlValidation==true){
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text('Field cannot be empty'),
                        );
                      },
                    );
                  }
                  if(emptyValidation==false && urlValidation==false){
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text('Field cannot be empty and invalid url'),
                        );
                      },
                    );
                  }
                },
                  child: Text("Add Event",
                    style: TextStyle(
                        color: Colors.black
                    ),),
                  color: Color(0xFFE6CCA9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1500.0),
                  ),),
              ],
            )
          ],
        ),
      ),
    );
  }
}