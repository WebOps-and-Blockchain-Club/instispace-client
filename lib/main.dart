import 'package:client/screens/userInit/signUp.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/wrapper.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/services/Client.dart';
import 'package:client/screens/userInit/signUp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Hostel App',
        theme: ThemeData(
          // This is the theme of application.

          primarySwatch: Colors.green,
        ),
        home: Wrapper(),
      ),
    );
  }
}
