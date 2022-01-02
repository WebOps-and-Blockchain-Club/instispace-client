import 'package:flutter/material.dart';

class CreateHostel extends StatelessWidget {

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Hostel",style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFFE6CCA9),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  hintText: "Hostel Name",
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0)
                  )
              ),
              validator: (val) {
                if(val == null || val.isEmpty) {
                  return "This field can't be empty";
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      Navigator.pushNamed(context, '/');
                    }
                  },
                  child: Text("Submit",style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

