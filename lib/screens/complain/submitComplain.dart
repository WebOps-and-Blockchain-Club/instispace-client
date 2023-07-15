import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:client/models/user.dart';

class SubmitComplain extends StatefulWidget {
  final UserModel user;
  const SubmitComplain({super.key, required this.user});

  @override
  State<SubmitComplain> createState() => _SubmitComplainState();
}

class _SubmitComplainState extends State<SubmitComplain> {
  final TextEditingController _studentRollno = TextEditingController();
  final TextEditingController _studentName = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _attachmentLink = TextEditingController();
  String studentRollno = '';
  String studentName = '';
  String description = '';
  String attachmentLink = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _studentName.text = widget.user.ldapName.toString();
    _studentRollno.text = widget.user.roll.toString();
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  _submitComplain(
      String rollno, String name, String description, attachmentLink) async {
    final Map<String, String> queryParameters = {
      'subject': 'Complaint from $name RollNumber: $rollno',
      if (attachmentLink.isEmpty) 'body': description,
      if (!attachmentLink.isEmpty)
        'body': '$description \n\n\nAttachedLink: $attachmentLink',
    };
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'secc@smail.iitm.ac.in',
      query: encodeQueryParameters(queryParameters),
    );
    await launchUrlString(_emailLaunchUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SubmitComplaint")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Student Details",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      "Student Id:",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "*",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              CustomTextField(
                controller: _studentRollno,
                onChanged: (value) {
                  setState(() {
                    studentRollno = value;
                  });
                },
                readOnly: true,
              ),
              const SizedBox(height: 16.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      "Student Name:",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "*",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              CustomTextField(
                controller: _studentName,
                onChanged: (value) {
                  setState(() {
                    studentName = value;
                  });
                },
                readOnly: true,
              ),
              const SizedBox(height: 16.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      "Description:",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "*",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              TextField(
                controller: _description,
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
                maxLength: 1000,
                minLines: 6,
                maxLines: 10,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Attachment Link:",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              TextField(
                controller: _attachmentLink,
                onChanged: (value) {
                  setState(() {
                    attachmentLink = value;
                  });
                },
                maxLength: 100,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              const Text(
                "Upload all the proof/s to the drive and put the link here, Please attach proof if there are any, attaching proof makes your complain more credible.",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Divider(
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Note",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                "This Portal is for filling the complaint or reporting the violation of Model Code of Conduct. Add a proper description and attach drive link to the proof to make your complain more credible. Student Election Commission does not divulge the details of the complaints to anyone without thier consent.",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  tileColor: Colors.green,
                  title: const Center(
                    child: Text(
                      "Send",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
                    if (studentRollno.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            title: Text('Please Enter StudentID'),
                            content: Text('Please Enter StudentID to proceed.'),
                          );
                        },
                      );
                    } else if (studentName.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            title: Text('Please Enter Student Name'),
                            content:
                                Text('Please Enter Student Name to proceed.'),
                          );
                        },
                      );
                    } else if (description.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            title: Text('Please write Description'),
                            content:
                                Text('Please write Description to proceed.'),
                          );
                        },
                      );
                    } else {
                      try {
                        _submitComplain(studentRollno, studentName, description,
                            attachmentLink);
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool readOnly;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      readOnly: readOnly,
      maxLength: 50,
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        filled: true,
        fillColor: Colors.grey[300],
      ),
    );
  }
}
