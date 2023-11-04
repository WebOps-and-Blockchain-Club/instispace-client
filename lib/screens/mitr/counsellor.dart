import 'dart:io';

import 'package:client/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/custom_icons.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/profile_icon.dart';
import 'data.dart';

class CounsellorScreen extends StatelessWidget {
  const CounsellorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = mitrMembers;
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          controller: ScrollController(),
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            return <Widget>[
              // AppBar
              secondaryAppBar(title: 'Wellness Centre of IITM',context: context),
            ];
          },
          body: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final i = data[index];
              return Padding(
                padding: EdgeInsets.only(
                    top: 20.0,
                    left: 20,
                    right: 20,
                    bottom: index + 1 == data.length ? 20 : 0),
                child: CustomCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfileIconWidget(
                        photo: i.photo,
                        size: 100,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              i.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            Text("Designation: ${i.designation}"),
                            const SizedBox(height: 8),
                            Text(
                              'Experience: ${i.experience}',
                            ),
                            const SizedBox(height: 8),
                            Text('Languages: ${i.languages.join(", ")}'),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () =>
                                      launchUrlString('mailto:${i.email}'),
                                  child: const Icon(Icons.forward_to_inbox),
                                ),
                                const SizedBox(width: 20),
                                InkWell(
                                  onTap: () => launchUrlString((Platform.isIOS
                                          ? "https://wa.me/"
                                          : "whatsapp://send?phone=") +
                                      i.whatsapp),
                                  child: const Icon(CustomIcons.whatsapp),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
