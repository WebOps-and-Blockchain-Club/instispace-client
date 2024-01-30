import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/graphQL/badge.dart';
import 'package:client/graphQL/query.dart';
import 'package:client/screens/badges/create_badges.dart';
import 'package:client/screens/badges/update_club.dart';
import 'package:client/services/image_picker.dart';
import 'package:client/utils/custom_icons.dart';
import 'package:client/widgets/badge/main.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:client/widgets/helpers/loading.dart';
import 'package:client/widgets/text/label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/badge.dart';
import 'package:client/themes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ViewClubPage extends StatefulWidget {
  const ViewClubPage({Key? key}) : super(key: key);

  @override
  State<ViewClubPage> createState() => _ViewClubPageState();
}

class _ViewClubPageState extends State<ViewClubPage> {
  TextEditingController threshold = TextEditingController();
  List<String> tiers = ["Gold", "Silver", "Bronze"];
  String tier = "Gold";
  List<BadgeModel> badges = [];
  void showDialogForEditBadge(
      {String? badgeId,
      BadgeModel? badge,
      Future<QueryResult<Object?>?> Function()? refetch,
      String? imageURL}) {
    TextEditingController points = TextEditingController();
    tier = badge != null ? badge.tier : 'Gold';
    bool edit = badgeId != null ? true : false;
    String title = edit ? 'Edit Badge' : 'Create Badge';
    points.text = badge != null ? badge.threshold.toString() : '0';
    showDialog(
        context: context,
        builder: (context) {
          return Mutation(
            options: MutationOptions(
              document:
                  gql(edit ? BadgeGQL().updateBadge : BadgeGQL().createBadges),
              onCompleted: (data) {
                refetch!();
                Navigator.of(context).pop();
              },
            ),
            builder: (runMutation, result) {
              print(result);
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                    title: Text(title),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: points,
                          maxLength: 20,
                          decoration: const InputDecoration(
                            labelText: "Threshold",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the number of points needed for getting that badge";
                            }
                            return null;
                          },
                        ),
                        DropdownButton<String>(
                            value: tier,
                            items: tiers
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? valueChosen) {
                              setState(() {
                                tier = valueChosen!;
                              });
                            }),
                      ],
                    ),
                    actions: [
                      CustomElevatedButton(
                        text: edit ? 'Edit' : 'Create',
                        onPressed: () {
                          if (edit) {
                            runMutation({
                              "badgeId": badgeId,
                              "updateBadgeInput": {
                                "tier": tier,
                                "threshold": int.parse(points.text)
                              }
                            });
                          } else {
                            runMutation({
                              "createBadgesInput": {
                                "badges": [
                                  {
                                    "imageURL": imageURL,
                                    "tier": tier,
                                    "threshold": int.parse(points.text)
                                  }
                                ]
                              }
                            });
                          }
                        },
                        isLoading: result!.isLoading,
                      ),
                    ]);
              });
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(BadgeGQL().getMyClub),
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading || result.data == null)
          return Scaffold(body: const Loading());
        List<BadgeModel> badgesOfUser = [];
        for (var data in result.data!['getMyClub']['badges']) {
          badgesOfUser.add(BadgeModel.fromJson(data));
        }
        // // if(badgesOfUser.isEmpty){
        // //   print('no badges');
        // //   showDialogForEditBadge(refetch:refetch, imageURL: result.data!['getMyClub']['logo']);
        // // }
        return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialogForEditBadge(
                    refetch: refetch,
                    imageURL: result.data!['getMyClub']['logo']);
              },
              backgroundColor: ColorPalette.palette(context).secondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
                title: const CustomAppBar(
              title: 'My Club',
            )),
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: ListView(children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CachedNetworkImage(
                              imageUrl: result.data!['getMyClub']['logo'],
                              placeholder: (_, __) => const Icon(
                                  Icons.account_circle_rounded,
                                  size: 60),
                              errorWidget: (_, __, ___) => const Icon(
                                  Icons.account_circle_rounded,
                                  size: 60),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            result.data!['getMyClub']['clubName'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          CustomIconButton(
                            icon: CustomIcons.edit,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UpdateClubPage(
                                  photoUrl: result.data!['getMyClub']
                                      ['clubName'],
                                ),
                              ));
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'My Badges :',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      if (badgesOfUser.isNotEmpty)
                        ...(badgesOfUser
                            .map((badge) => Stack(children: [
                                  CustomBadge(badgeModel: badge),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(
                                          CustomIcons.edit,
                                          size: 15,
                                        ),
                                        onPressed: () {
                                          showDialogForEditBadge(
                                              badgeId: badge.id,
                                              badge: badge,
                                              refetch: refetch);
                                        },
                                      )
                                    ],
                                  )
                                ]))
                            .toList())
                      else
                        const Center(
                            child: Text(
                          'No Badges Added',
                          style: TextStyle(fontSize: 18),
                        )),
                    ]))));
      },
    );
  }
}
