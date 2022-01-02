import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  List<String> Hostels = ['Select Hostel', 'Alakananda', 'Bhadra', 'Brahmaputra', 'Cauvery','Ganga','Godavari','Jamuna','Krishna','Mahanadhi','Narmada','Pampa','Sabarmati','Saraswathi','Sarayu','Sharavathi','Sindhu','Tamiraparani','Tapti','Tunga'];

  List<String> interest = [
    'Webops Club',
    'Programming Club',
    'iBot Club',
    'Electronics Club',
    'Cricket',
    'Football',
    'Table Tennis',
    'Badminton',
    'Basket Ball',
    'Nirman Club',
    'E-cell',
    'Music',
    'Dance',
    'Singing',
    'Hockey',
    'Movies and Web-Series',
    'Competitive programming',
    'Hackathons'
  ];

  List<String> selectedInterest = [];

  String DropDownValue = 'Select Hostel';

  static HttpLink httpLink = HttpLink(
    'https://insti-app.herokuapp.com/graphql',
  );

  ValueNotifier<GraphQLClient> client= ValueNotifier<GraphQLClient>(GraphQLClient(
    cache: GraphQLCache(store: InMemoryStore()),
    link: httpLink,
  ));

  String hostelName = """
  
  """;

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "SignUp Journey",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xFFE6CCA9),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Enter Your Name',
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.circular(20.0)
                      )
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return "This fiels can't be empty";
                    }
                  },
                ),
                SizedBox(height: 5.0),
                DropdownButton<String>(
                  value: DropDownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      DropDownValue = newValue!;
                    });
                  },
                  items: Hostels
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10.0),
                Text("Please choose your interests"),
                SizedBox(height: 15.0),
                Wrap(
                    children:selectedInterest.map((s)=>
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: MaterialButton(
                            //shape,color etc...
                            onPressed:(){
                              setState(() {
                                interest.add(s);
                                selectedInterest.remove(s);
                              });
                            },
                            child:Text(s),
                            color: Colors.green,
                          ),
                        )).toList()
                ),
                SizedBox(height: 10.0),
                Wrap(
                    children:interest.map((s)=>
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: MaterialButton(
                            //shape,color etc...
                            onPressed:(){
                              setState(() {
                                selectedInterest.add(s);
                                interest.remove(s);
                              });
                            },
                            child:Text(s),
                            color: Colors.grey,
                          ),
                        )).toList()
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
