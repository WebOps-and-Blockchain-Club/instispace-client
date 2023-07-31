import 'package:client/widgets/form/dropdown_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:client/models/user.dart';

final formKey = GlobalKey<FormState>();

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
  String? category;
  String? catError;

  final List<String> categories = [
    'Interpretation of the Constitution',
    'Interpretation of the constitutional amendments',
    'Interpretation of all legislation passed into law',
    'Disputes and controversies - Student(s) against an organization or vice versa',
    'Disputes and controversies - An organization against an organization',
    'Disputes and controversies - Student(s) against student(s)',
    'Disputes and controversies - Student(s) against faculty members and staff (only if the Fundamental Right has been suspected to be violated)',
    'Charges of violations of the constitution, constitutional amendments, or otherlegislation passed by Student Legislative Council and signed into law',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _studentName.text = widget.user.ldapName.toString();
    studentName = widget.user.ldapName.toString();
    studentRollno = widget.user.roll.toString();
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
      'subject': '[Complaint] $category',
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
      appBar: AppBar(title: const Text("Submit Complaint")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Student Details",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
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
                        "Grievance Category",
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
                CustomDropdownButton(
                  // add both the conditions so that category being empty initially is ignored
                  isError: category == null && catError != null,
                  padding: const EdgeInsets.all(0),
                  value: category,
                  items: categories,
                  onChanged: (p0) {
                    if (p0 != null) {
                      setState(() {
                        category = p0;
                        catError = null;
                      });
                    }
                  },
                ),
                if (catError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(catError!,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                const SizedBox(height: 25),
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
                TextFormField(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "PLease enter the description";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Attachment Link:",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
                      //validate the form accoring to the mandatory fields
                      bool isValid =
                          formKey.currentState!.validate() && category != null;

                      if (isValid) {
                        try {
                          _submitComplain(studentRollno, studentName,
                              description, attachmentLink);
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      } else {
                        if (category == null) {
                          setState(() {
                            catError =
                                'Please select a grievance category to launch your complaint';
                          });
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
