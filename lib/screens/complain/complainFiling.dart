import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'submitComplain.dart';

class ComplaintPortal extends StatefulWidget {
  const ComplaintPortal({super.key});

  @override
  State<ComplaintPortal> createState() => _ComplaintPortalState();
}

class _ComplaintPortalState extends State<ComplaintPortal> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Complaint",
            style: TextStyle(
                letterSpacing: 1,
                color: Color(0xFF262626),
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Greetings from Student Ethics & Constitutional Commission, the quasi-judicial body of the '
                  'Students’ Government at IIT Madras. The Students’ Constitution of IIT Madras provides the '
                  'students with a grievance redressal mechanism where they can launch a complaint and get'
                  'their grievance addressed by SECC if their grievance comes under any of the following categories - ',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                UnorderedList(const [
                  "• Interpretation of the Constitution.",
                  "• Interpretation of the constitutional amendments.",
                  "• Interpretation of all legislation passed into law.",
                ]),
                const SizedBox(height: 8.0),
                const Text(
                  "Disputes and controversies: ",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                UnorderedList(const [
                  "1. Student(s) against an organization or vice versa",
                  "2. An organization against an organization. ",
                  "3. Student(s) against student(s). ",
                  "4. Student(s) against faculty members and staff (only if the Fundamental Right has been suspected to be violated) ",
                  "5. Charges of violations of the constitution, constitutional amendments, or other legislation passed by Student Legislative Council and signed into law.",
                ]),
                const SizedBox(height: 16.0),
                const Text(
                  "[The student has to select one of the options to launch a complaint, otherwise the complaint will not be launched.]  ",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Guidelines to be taken into note -",
                    style: TextStyle(
                      fontSize: 16.0,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: UnorderedList(const [
                    "1. Once the complainant files a complaint with SECC, the complaint cannot be withdrawn. The complainant’s identity and complaint remains confidential with SECC.",
                    "2. Once the complainant submits the complaint, a mail would be launched from your smail Id to the mail Id of SECC.",
                    "3. SECC would respond to your complaint within 48 hours via its official mail ID to your smail. This mail would mention that your complaint has been taken up or not.",
                    "4. SECC would conduct hearings to know more about the case and the complainant has to cooperate with SECC.",
                    "5. SECC has constitutionally guaranteed rights to impose sanctions (punish) against whom the complaint has been launched, if the case proves so.",
                    "6. SECC is the ex-officio member of any committee formed in the institute that discusses or acts on disciplinary matters concerning students, including the Students Disciplinary Committee, and Discipline & Welfare Committee.",
                    "7. The members of SECC are Faculty Advisor, Chief Commissioner and 2 Commissioners.",
                  ]),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Checkbox(
                        value: checked,
                        onChanged: (value) {
                          setState(() {
                            checked = value!;
                            if (kDebugMode) {
                              print(checked);
                            }
                          });
                        }),
                    const SizedBox(
                      width: 2.0,
                    ),
                    const Flexible(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "By ticking this box I agree I have read all the guidelines and I am ready to file a complaint with the SECC. ",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: const Text("Proceed"),
                    onTap: () {
                      if (checked) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const SubmitComplain()));
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text('Please Confirm'),
                              content: Text(
                                  'Please click on the checkbox to proceed.'),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class UnorderedList extends StatelessWidget {
  UnorderedList(this.texts);
  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      // Add list item
      widgetList.add(UnorderedListItem(text));
      // Add space between items
      widgetList.add(SizedBox(height: 5.0));
    }

    return Column(children: widgetList);
  }
}

class UnorderedListItem extends StatelessWidget {
  UnorderedListItem(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Text("• "),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16.0,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
