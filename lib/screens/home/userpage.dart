import 'package:flutter/material.dart';


class UserPage extends StatelessWidget {

  List<String> interest = [
    'Webops Club',
    'Programming Club',
    'iBot Club',
    'Music',
    'Dance',
    'Singing',
    'Hockey',
    'Movies and Web-Series',
    'Competitive programming',
    'Hackathons'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile",
        style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: Color(0xFFE6CCA9),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Anshul Mehta"),
          Text("CH20B014"),
          Text("Sindhu Hostel"),
          SizedBox(
            height: 100.0,
            width: 80.0,
            child: ListView(
                children:interest.map((s)=>
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: MaterialButton(
                        //shape,color etc...
                        onPressed:() {},
                        child:Text(s),
                        color: Colors.grey,
                      ),
                    )).toList()
            ),
          )
        ],
      ),
    );
  }
}
