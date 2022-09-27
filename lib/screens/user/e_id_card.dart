import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/user.dart';

class EIDCard extends StatefulWidget {
  final UserModel user;

  const EIDCard({Key? key, required this.user}) : super(key: key);

  @override
  State<EIDCard> createState() => _EIDCardState();
}

class _EIDCardState extends State<EIDCard> {
  @override
  void initState() {
    _portraitModeOnly();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'assets/iitm_logo.png',
                    height: 74,
                    width: 74,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      Text(
                        'भारतीय प्रौद्योगिकी संस्थान मद्रास, चेन्नई-600036',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '(एमएचआरडी, जीओआई के तहत एक स्वायत्त संस्थान)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Indian Institute of Technology Madras, Chennai-600036',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '(An Autonomous Institution under MHRD, GOI)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.ldapName!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.user.roll!.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.user.program!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.user.department!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _enableRotation();
    super.dispose();
  }
}

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

void _enableRotation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}
