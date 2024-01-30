import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/models/badge.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBadge extends StatelessWidget {
  final BadgeModel badgeModel;
  const CustomBadge({Key? key, required this.badgeModel, t}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        //color: Colors.green,
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: badgeModel.imageUrl,
                placeholder: (_, __) =>
                    const Icon(Icons.account_circle_rounded, size: 60),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.account_circle_rounded, size: 60),
                imageBuilder: (context, imageProvider) => Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/illustrations/${badgeModel.tier.toLowerCase()}-medal.svg',
                width: 60,
                height: 60,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('Points : ${badgeModel.threshold.toString()}',
                    style: TextStyle(fontSize: 18)),
              )
            ],
          ),
        )),
      ),
    );
  }
}

//displayed in user profile
class CustomUserBadge extends StatelessWidget {
  final BadgeModel badgeModel;
  const CustomUserBadge({Key? key, required this.badgeModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Color(0xffD4D4D4)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: badgeModel.imageUrl,
              placeholder: (_, __) =>
                  const Icon(Icons.account_circle_rounded, size: 60),
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.account_circle_rounded, size: 60),
              imageBuilder: (context, imageProvider) => Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/illustrations/${badgeModel.tier.toLowerCase()}-medal.svg',
              width: 60,
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
