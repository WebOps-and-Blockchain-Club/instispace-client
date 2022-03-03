import 'package:client/graphQL/createHostelSec_mutation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/graphQL/createHostelSec_mutation.dart';

class CreateHostelSec extends StatefulWidget {
  const CreateHostelSec({Key? key}) : super(key: key);

  @override
  _CreateHostelSecState createState() => _CreateHostelSecState();
}
String createSec = createHostelSec().createSec;

class _CreateHostelSecState extends State<CreateHostelSec> {

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
