import 'dart:io';

import 'package:client/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/custom_icons.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/profile_icon.dart';
import 'data.dart';

class InstiHospitalScreen extends StatelessWidget {
  const InstiHospitalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = counselors;
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          controller: ScrollController(),
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            return <Widget>[
              // AppBar
              secondaryAppBar(title: 'Institute Hospital', context: context),
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
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              i.nameOfTheCounselor,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            Text("Designation: ${i.designation}"),
                            const SizedBox(height: 8),
                            Text(
                              'Gender: ${i.gender}',
                            ),
                            const SizedBox(height: 8),
                            Text('Mobile Number: ${i.mobileNumber}'),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Duty Timing: ${i.dutyTiming}"),
                                const SizedBox(width: 20),
                                InkWell(
                                  onTap: () => launchUrlString((Platform.isIOS
                                          ? "https://wa.me/"
                                          : "whatsapp://send?phone=") +
                                      i.mobileNumber),
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
