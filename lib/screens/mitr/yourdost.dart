import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/card.dart';

class YourDostScreen extends StatelessWidget {
  const YourDostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle styleNormal = Theme.of(context).textTheme.bodyLarge!;
    TextStyle styleBold = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontWeight: FontWeight.bold);
    List<dynamic> contentArr = [
      {
        "content":
            "Your Dost is an external counseling agency, which provides online as well as offline services.\n\n",
        "style": styleNormal
      },
      {"content": "On-line Counseling: ", "style": styleBold},
      {
        "content": "Messaging, Voice call, Video call\n\n",
        "style": styleNormal
      },
      {"content": "Off-line Counseling: ", "style": styleBold},
      {
        "content": "In-person Counseling at Central Library (2nd Floor)",
        "style": styleNormal
      },
    ];
    return Scaffold(
      body: NestedScrollView(
        controller: ScrollController(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[
            // AppBar
            secondaryAppBar(title: 'Your Dost'),
          ];
        },
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: CustomCard(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: RichText(
                    text: TextSpan(
                        children: contentArr
                            .map((_data) => TextSpan(
                                text: _data["content"], style: _data["style"]))
                            .toList()),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: CustomCard(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Booking Service',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () => launchUrlString("https://yourdost.com",
                          mode: LaunchMode.externalApplication),
                      child: const Column(
                        children: [
                          Icon(Icons.language_sharp, size: 30),
                          SizedBox(height: 10),
                          Text("https://yourdost.com"),
                          SizedBox(height: 10),
                          Text("Online"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () => launchUrlString("http://bit.ly/IITMadrasF2F",
                          mode: LaunchMode.externalApplication),
                      child: const Column(
                        children: [
                          Icon(Icons.language_sharp, size: 30),
                          SizedBox(height: 10),
                          Text("http://bit.ly/IITMadrasF2F"),
                          SizedBox(height: 10),
                          Text("Offline"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Login through smail to avail benefits at No Cost, since IITM has subscription for it.",
                      style: styleNormal,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
