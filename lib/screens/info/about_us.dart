import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/card.dart';

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
            "InstiSpace from CFI is your go-to place for everything insti, from events, networking, discussions in public forums, start-up opportunities and many more! This is a one-place solution for your needs in insti.\n\n",
        "style": styleNormal
      },
      {"content": "Home:\n", "style": styleBold},
      {
        "content":
            "Choose what you wish to see by following the tags. Get your personalised updates on happenings on the campus across various spheres, from cultural and co-curricular to sports and acads.\n\n",
        "style": styleNormal
      },
      {"content": "Feed:\n", "style": styleBold},
      {
        "content":
            "Deep dive into various happenings in the insti. Get a taste of a plethora of events, recruitments into various clubs and teams, competitions and many more.\n\n",
        "style": styleNormal
      },
      {"content": "Forum::\n", "style": styleBold},
      {
        "content":
            "Looking for a like-minded junta to get a taste of your entrepreneurial drive or to connect with like-minded people? The Forum is the solution. You can post various opportunities and queries, connect with people, request immediate help, conduct surveys or share thoughts.\n\n",
        "style": styleNormal
      },
      {"content": "Academics:\n", "style": styleBold},
      {
        "content":
            "Worried about missing classes. We have got you covered. Personalise your timetable and get reminders for every class.\n\n",
        "style": styleNormal
      },
      {"content": "Lost and Found:\n", "style": styleBold},
      {
        "content":
            "Lost your values? Fret not! Post it here with images and get updates in real time when someone finds it for you\n\n",
        "style": styleNormal
      },
      {
        "content":
            "We hope you have a great time using our app. Any feedback is much appreciated.",
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
            secondaryAppBar(title: 'About Us'),
          ];
        },
        body: ListView(
          children: [
            const SizedBox(
              height: 150,
              child:
                  Image(image: AssetImage('assets/logo/primary_with_text.png')),
            ),
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

            // Contact Us
            GestureDetector(
              onTap: () => launchUrlString('mailto:$email'),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: CustomCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                            'Contact Us',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
            ),

            // Contributor
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: CustomCard(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Contributor',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
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
                          "Project Head:\nYatharth, Janith M S\n\nMembers:\nAman Kulwal, Anshul Mehta, Gautam Vaja, Sai Charan, Ganesh S, Rasagnya, Harsh Trivedi\n\nSpecial Thanks:\nDhanveerraj J M, Abhigyan Chattopadhyay, Vaidehi Garodia, Abhiram V M, Nancy, Yashwanth, Faiza Nazrien",
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
            ),
          ],
        ),
      ),
    );
  }
}
