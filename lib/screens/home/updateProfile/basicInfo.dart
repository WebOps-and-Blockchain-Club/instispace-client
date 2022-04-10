import 'package:client/screens/home/updateProfile/interests.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../graphQL/auth.dart';
import '../../../models/formErrormsgs.dart';
import '../../../widgets/formTexts.dart';
import '../../userInit/dropDown.dart';

class BasicInfo extends StatefulWidget {
  const BasicInfo({Key? key}) : super(key: key);

  @override
  _BasicInfoState createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {

  ///GraphQL
  String getHostels = authQuery().getHostels;

  ///Variables
  List<String> Hostels = [];
  String _DropDownValue = "Select Hostel";
  final _formkey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController PhoneNumberController = TextEditingController();
  String emptyNameErr = "";
  String emptyContactErr = "";
  String emptyHostelErr = '';
  bool validPhone = false;
  String userName ="";
  String hostelName ='';
  String mobile = '';

  @override
  void initState(){
    super.initState();
    _sharedPreference();
  }

  SharedPreferences? prefs;
  void _sharedPreference()async{
    prefs = await SharedPreferences.getInstance();
    print("prefs name");
    setState(() {
      userName = prefs!.getString('name')!;
      hostelName = prefs!.getString('hostelName')!;
      print("hostelName:${prefs!.getString('hostelName')!}");
      if(prefs!.getString('mobile') != null) {
        mobile = prefs!.getString('mobile')!;
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    nameController.text = userName;
    _DropDownValue=hostelName;
    print("Username : $userName");
    print("textController : ${nameController.text}");

    return Query(
        options: QueryOptions(
          document: gql(getHostels),
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          // print('Hostel:$Hostels');
          Hostels.clear();
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          Hostels.add("Select Hostel");
          for (var i = 0; i < result.data!["getHostels"].length; i++) {
            Hostels.add(result.data!["getHostels"][i]["name"].toString());
          }
          // print(Hostels);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Edit Profile",
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

            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FormText('Name'),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
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
                              hintText: 'Enter your name',
                            ),
                            controller: nameController,
                            validator: (val) {
                              if(val == null || val.isEmpty) {
                                setState(() {
                                  emptyNameErr = "Please enter name";
                                });
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),

                    errorMessages(emptyNameErr),

                    const SizedBox(height: 10.0),

                    FormText('Contact number (optional)'),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
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
                              hintText: 'Enter Contact number',
                            ),
                            controller: PhoneNumberController,
                            validator: (val) {
                              if(val != null && val.isNotEmpty) {
                                if (!isValidNumber("+91$val")) {
                                  setState(() {
                                    emptyContactErr = "Please enter a valid number";
                                  });
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),

                    errorMessages(emptyContactErr),

                    dropDown(
                        Hostels: Hostels,
                        dropDownValue: _DropDownValue,
                        callback: (val) => _DropDownValue = val),

                    errorMessages(emptyHostelErr),
                    const SizedBox(height: 10.0),

                    const SizedBox(height: 30.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            if(PhoneNumberController.text.isNotEmpty && isValidNumber("+91${PhoneNumberController.text}")) {
                              setState(() {
                                validPhone = true;
                              });
                            }
                            if(PhoneNumberController.text.isEmpty) {
                              setState(() {
                                validPhone = true;
                              });
                            }
                            if(_DropDownValue == "Select Hostel") {
                              setState(() {
                                emptyHostelErr = "Please select your hostel";
                              });
                            }
                            if(nameController.text.isNotEmpty) {
                              setState(() {
                                emptyNameErr = "";
                              });
                            }
                            if (nameController.text.isNotEmpty && _DropDownValue != "Select Hostel" && validPhone) {
                              setState(() {
                                emptyNameErr = "";
                                emptyContactErr = "";
                              });
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext Context) => EditInterests(
                                    name: nameController.text,
                                    phoneNumber: PhoneNumberController.text,
                                    hostelName: _DropDownValue,
                                  )));
                            }
                          }
                          print("nameController : ${nameController.text}, phoneNumber : ${PhoneNumberController.text}, hostelName: ${_DropDownValue}");
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
                          child: Text('Select Interests',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
  bool isValidNumber (String number) {
    return RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(number);
  }
  void Navigate () {
    Navigator.pop(context);
  }
}

