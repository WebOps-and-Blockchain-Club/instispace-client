import 'package:flutter/material.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {

  final NewPasscontroller = TextEditingController();
  final ConfirmPasscontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String err;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Password",
        style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: Color(0xFFE6CCA9),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Enter New Password',
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0)
                  )
              ),
              controller: NewPasscontroller,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return "This field can't be empty";
                }
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0)
                  )
              ),
              controller: ConfirmPasscontroller,
              validator: (val) {
                if(val == null || val.isEmpty && NewPasscontroller.text.isNotEmpty) {
                  return "Please confirm Password";
                }
                else if (val != NewPasscontroller.text) {
                  return "Passwords don't match";
                }
                return null;
              }
            ),
            // SizedBox(height: 30.0,child: errorMsg("errmsg")),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pushNamed(context, '/');
                }
              },
              child: Text("Submit",style: TextStyle(color: Colors.white),),

            ),
          ],
        ),
      ),
    );
  }
}