import 'dart:async';
import 'package:flutter/material.dart';

import '../../themes.dart';
import '../marquee.dart';

class Header extends StatelessWidget {
  final String title;
  final String? subTitle;
  const Header({Key? key, required this.title, this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MarqueeWidget(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        if (subTitle != null)
          Text(
            subTitle!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ColorPalette.palette(context).secondary,
                fontWeight: FontWeight.w500),
          )
      ],
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? action;
  const CustomAppBar({Key? key, required this.title, this.leading, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: SizedBox(
        height: 40,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leading != null ? leading! : const SizedBox(width: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Center(
                child: MarqueeWidget(
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            action != null ? action! : const SizedBox(width: 30),
          ],
        ),
      ),
    );
  }
}
