import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../widgets/button/icon_button.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String email = 'instispace_cfi@smail.iitm.ac.in';
    TextStyle styleNormal = Theme.of(context).textTheme.bodyLarge!;
    TextStyle styleBold = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontWeight: FontWeight.bold);
    List<dynamic> contentArr = [
      {
        "content":
            "InstiSpace from CFI is your go-to place for networking, connecting, updates, announcements and more. This app is for the students of IITM.\n\n",
        "style": styleNormal
      },
      {"content": "Events:\n", "style": styleBold},
      {
        "content":
            "Find all the happenings around the institute. From sports to culture to technicals, you’ll find everything here.\n\n",
        "style": styleNormal
      },
      {"content": "Networking:\n", "style": styleBold},
      {
        "content":
            "Find opportunities and like-minded people to connect with. Everything from club recruitments to intern opportunities can be found here. You might post an opportunity as well!\n\n",
        "style": styleNormal
      },
      {"content": "My Hostel:\n", "style": styleBold},
      {
        "content":
            "Find all updates and announcements in your hostel. You can also find the essential contacts and amenities available in the hostel.\n\n",
        "style": styleNormal
      },
      {"content": "Queries:\n", "style": styleBold},
      {
        "content":
            "Ask about anything from acads to hostel or LitSoc and TechSoc, and let the student community answer your queries.\n\n",
        "style": styleNormal
      },
      {"content": "Lost & Found:\n", "style": styleBold},
      {
        "content":
            "Lost (or found) something? No worries, post it here and update the issue in real-time.\n\n",
        "style": styleNormal
      },
      {
        "content":
            "Your home feed is tailored to your interests. You can also search for other users, know their interests, and connect with them.\n\n",
        "style": styleNormal
      },
      {
        "content":
            "We hope you have a great time using our app. Any feedback is much appreciated.",
        "style": styleNormal
      },
    ];

    return Scaffold(
      appBar: AppBar(
          title: CustomAppBar(
            title: "About InstiSpace",
            leading: CustomIconButton(
              icon: Icons.arrow_back,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 150,
                child: Image(
                    image: AssetImage('assets/logo/primary_with_text.png')),
              ),
              Card(
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
              const SizedBox(
                height: 10,
              ),

              // Contact Us
              Center(
                child: Text(
                  'Contact Us',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => launchUrlString('mailto:$email'),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.forward_to_inbox),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(email),
                      ],
                    ),
                  ),
                ),
              ),

              // Contributor
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Contributor',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Image(
                            image: AssetImage('assets/club_logo.png'),
                            width: 70,
                            height: 70,
                          ),
                          SizedBox(width: 10),
                          Image(
                            image: AssetImage('assets/cfi_logo.png'),
                            width: 100,
                            height: 100,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Center(
                        child: Text(
                          "Team Members:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Center(
                        child: Text(
                          "2021 - 2022:\nJanith M S, Aman Kulwal, Anshul Mehta, Gautam Vaja, Sai Charan, Sneha Reddy, Yatharth, Dhanveerraj J M, Vaidehi Garodia\n\n2022 - 2023:\nGanesh S, Rasagnya, Harsh Trivedi",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          "WebOps and Blockchain Club",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "Centre ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            "For Innovation",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.language_sharp),
                          const SizedBox(
                            width: 5,
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () => launchUrlString(
                                  "https://cfi.iitm.ac.in",
                                  mode: LaunchMode.externalApplication),
                              child: const Text(
                                'cfi.iitm.ac.in',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
