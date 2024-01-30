import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/graphQL/badge.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:client/widgets/helpers/loading.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MyBadgePage extends StatefulWidget {
  const MyBadgePage({Key? key}) : super(key: key);

  @override
  State<MyBadgePage> createState() => _MyBadgePageState();
}

class _MyBadgePageState extends State<MyBadgePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBar(
          title: 'My Badges',
        ),
      ),
      body: Query(
        options: QueryOptions(document: gql(BadgeGQL().getUserBadges)),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Loading();
          } else {
            return ListView(
              children: [
                for (var badge in result.data!['getMyBadges']['list'])
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: double.infinity,
                      //color: Colors.green,
                      child: Card(
                          child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: badge['imageURL '],
                            placeholder: (_, __) => const Icon(
                                Icons.account_circle_rounded,
                                size: 60),
                            errorWidget: (_, __, ___) => const Icon(
                                Icons.account_circle_rounded,
                                size: 60),
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
                            'assets/illustrations/${badge['tier'].toLowerCase()}-medal.svg',
                            width: 60,
                            height: 60,
                          ),
                          new Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                                'Points : ${badge['threshold'].toString()}',
                                style: TextStyle(fontSize: 18)),
                          )
                        ],
                      )),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
