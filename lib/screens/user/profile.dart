import 'package:client/models/user.dart';
import 'package:flutter/material.dart';

import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/text/label.dart';

class Profile extends StatelessWidget {
  final UserModel user;
  const Profile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(children: [
            CustomAppBar(
                title: user.name == null ? user.ldapName! : user.name!,
                leading: CustomIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () => Navigator.of(context).pop(),
                )),
            const SizedBox(height: 20),
            CircleAvatar(
                radius: 65,
                backgroundImage: NetworkImage(
                    'https://photos.iitm.ac.in/byroll.php?roll=${user.roll}')),
            const SizedBox(height: 10),
            Center(
              child: Text(
                user.ldapName == null || user.ldapName!.isEmpty
                    ? user.name!
                    : user.ldapName!,
                style: const TextStyle(
                    color: Color(0xFF2f247b),
                    fontSize: 21,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                user.roll!,
                style: const TextStyle(
                    color: Colors.purple,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),
            if (user.interets != null && user.interets!.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.5,
                    color: Colors.purple,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    const LabelText(text: "Followed Tags"),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: List.generate(user.interets!.length, (index) {
                          return Chip(
                            label: Text(user.interets![index].title),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(4),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side:
                                    const BorderSide(color: Color(0xFF2f247b))),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            if ((user.id == null || user.id!.isEmpty) &&
                user.ldapName != null &&
                user.ldapName!.isNotEmpty)
            Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.5,
                    color: Colors.purple,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text(
                        "User is not registered.\nDo you like to invite the user?",
                        style:
                            TextStyle(color: Color(0xFF2f247b), fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: CustomElevatedButton(
                        onPressed: () {},
                        text: "Invite ${user.ldapName}",
                      ),
                    )
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
