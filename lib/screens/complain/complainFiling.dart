import 'package:client/graphQL/badge.dart';
import 'package:client/graphQL/feed.dart';
import 'package:client/utils/custom_icons.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:client/widgets/helpers/loading.dart';
import 'package:flutter/src/foundation/key.dart';
import 'dart:io';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../themes.dart';

class ComplaintPortal extends StatefulWidget {
  const ComplaintPortal({super.key});

  @override
  State<ComplaintPortal> createState() => _ComplaintPortalState();
}

class _ComplaintPortalState extends State<ComplaintPortal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Complain",
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
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      TextSpan(text: 'First point'),
                      TextSpan(text: 'Second point'),
                      TextSpan(text: 'Third point'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class BulletSpan extends StatelessWidget {
  // const BulletSpan({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      child: const Text('\u2022', style: TextStyle(fontSize: 20.0)),
    );
  }
}
