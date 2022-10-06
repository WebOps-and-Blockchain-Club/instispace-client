import 'package:flutter/material.dart';

import '../../themes.dart';
import '../../services/auth.dart';
import 'splash_card.dart';

class SplashScreen extends StatefulWidget {
  final AuthService auth;
  const SplashScreen({Key? key, required this.auth}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final controller = PageController();

  final images = [
    'assets/splash/spams.png',
    'assets/splash/netops.png',
    'assets/splash/events.png',
    'assets/splash/lost_found.png',
    'assets/splash/queries.png',
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7756EC),
        leading: currentPage > 0
            ? IconButton(
                onPressed: () {
                  if (currentPage > 0) controller.jumpToPage(currentPage - 1);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              )
            : null,
        actions: currentPage < images.length - 1
            ? [
                IconButton(
                  onPressed: () {
                    widget.auth.setNewUserOnApp(false);
                  },
                  iconSize: 35,
                  icon: const Text('Skip', style: TextStyle(fontSize: 16)),
                )
              ]
            : null,
      ),
      body: Stack(children: <Widget>[
        PageView.builder(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            return SplashCard(images[index]);
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 65,
            child: (currentPage == images.length - 1)
                ? Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        color: ColorPalette.palette(context).success,
                        borderRadius: BorderRadius.circular(10)),
                    child: InkWell(
                      onTap: () {
                        widget.auth.setNewUserOnApp(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Proceed',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 20),
                            Icon(Icons.arrow_forward_rounded,
                                color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < images.length; i++)
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                color: currentPage == i
                                    ? const Color(0xff132137)
                                    : const Color(0xffE3E4E4),
                              ),
                              width: 10,
                              height: 10,
                            ),
                          )
                      ],
                    ),
                  ),
          ),
        )
      ]),
    );
  }
}
