import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/widgets/app_bar.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/user.dart';
import '../../widgets/button/icon_button.dart';

class EIDCard extends StatefulWidget {
  final UserModel user;

  const EIDCard({Key? key, required this.user}) : super(key: key);

  @override
  State<EIDCard> createState() => _EIDCardState();
}

class _EIDCardState extends State<EIDCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          controller: ScrollController(),
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            return <Widget>[
              // AppBar
              secondaryAppBar(title: 'E-ID Card'),
            ];
          },
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Color.fromRGBO(165, 202, 114, 1),
                          Color.fromRGBO(154, 169, 101, 1),
                          Color.fromRGBO(149, 171, 96, 1),
                        ]),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/iitm_logo.png',
                      height: 74,
                      width: 74,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'भारतीय प्रौद्योगिकी संस्थान मद्रास, चेन्नई-600036',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '(एमएचआरडी, जीओआई के तहत एक स्वायत्त संस्थान)',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Indian Institute of Technology Madras, Chennai-600036',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '(An Autonomous Institution under MHRD, GOI)',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ConstrainedBox(
                        constraints: const BoxConstraints(
                            maxWidth: 160,
                            minWidth: 160,
                            maxHeight: 160,
                            minHeight: 160),
                        child: CachedNetworkImage(
                          imageUrl: widget.user.photo,
                          placeholder: (_, __) =>
                              const CircularProgressIndicator(),
                          errorWidget: (_, __, ___) =>
                              const Icon(Icons.account_circle_rounded),
                        )),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: " + (widget.user.ldapName ?? ""),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Roll Number: " +
                              (widget.user.roll?.toUpperCase() ?? ""),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Program: " + (widget.user.program ?? ''),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Department: " + (widget.user.department ?? ""),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
