import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/graphQL/badge.dart';
import 'package:client/graphQL/query.dart';
import 'package:client/screens/badges/create_badges.dart';
import 'package:client/services/image_picker.dart';
import 'package:client/utils/custom_icons.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:client/widgets/helpers/loading.dart';
import 'package:client/widgets/text/label.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(BadgeGQL().getMyClub),
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading || result.data == null) return const Loading();
        return Scaffold(
            appBar: AppBar(
                title: CustomAppBar(
              title: 'My Club',
            )),
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: ListView(children: [
                      Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: result.data!['getMyClub']['logo'],
                            placeholder: (_, __) => const Icon(
                                Icons.account_circle_rounded,
                                size: 60),
                            errorWidget: (_, __, ___) => const Icon(
                                Icons.account_circle_rounded,
                                size: 60),
                            imageBuilder: (context, imageProvider) => Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            result.data!['getMyClub']['clubName'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Text(
                        'Create Badges :',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: threshold,
                        maxLength: 20,
                        decoration: InputDecoration(
                          labelText: "Threshold",
                          prefixIcon:
                              const Icon(Icons.account_balance, size: 20),
                          prefixIconConstraints: Themes.inputIconConstraints,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the threshold";
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Text(
                            'Tier',
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          DropdownButton<String>(
                              value: tier,
                              items: tiers.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                          new Spacer(),
                          CustomElevatedButton(
                              onPressed: () {
                                BadgeModel badge = BadgeModel(
                                    tier: tier,
                                    threshold: int.parse(threshold.text),
                                    imageUrl: result.data!['getMyClub']
                                        ['logo']);

                                setState(() {
                                  badges.add(badge);
                                });
                              },
                              text: 'Add')
                        ],
                      ),
                      for (var badge in badges)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            //color: Colors.green,
                            child: Card(
                                child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: result.data!['getMyClub']['logo'],
                                  placeholder: (_, __) => const Icon(
                                      Icons.account_circle_rounded,
                                      size: 60),
                                  errorWidget: (_, __, ___) => const Icon(
                                      Icons.account_circle_rounded,
                                      size: 60),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
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
                                  'assets/illustrations/${tier.toLowerCase()}-medal.svg',
                                  width: 60,
                                  height: 60,
                                ),
                                new Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                      'Points : ${badge.threshold.toString()}',
                                      style: TextStyle(fontSize: 18)),
                                )
                              ],
                            )),
                          ),
                        ),
                      Mutation(
                          options: MutationOptions(
                              document: gql(BadgeGQL().createBadges),
                              onCompleted: (resultData) {
                                refetch!();
                              }),
                          builder: (RunMutation runMutation,
                              QueryResult? mutationResult) {
                            print(mutationResult);

                            return CustomElevatedButton(
                              onPressed: () {
                                List<Map<String, dynamic>> badgesJson = [];
                                for (var badge in badges) {
                                  badgesJson.add(badge.toJson());
                                }
                                runMutation({
                                  "createBadgesInput": {"badges": badgesJson}
                                });
                                setState(() {
                                  badges = [];
                                });
                              },
                              text: 'Add Badges',
                              isLoading: mutationResult!.isLoading,
                            );
                          }),
                      Text(
                        'My Badges :',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      for (var badge in result.data!['getMyClub']['badges'])
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            width: double.infinity,
                            //color: Colors.green,
                            child: Card(
                                child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: result.data!['getMyClub']['logo'],
                                  placeholder: (_, __) => const Icon(
                                      Icons.account_circle_rounded,
                                      size: 60),
                                  errorWidget: (_, __, ___) => const Icon(
                                      Icons.account_circle_rounded,
                                      size: 60),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
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
                    ]))));
      },
    );
  }
}
/*ListView(children: [
                          for (var badge in badges)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.infinity,
                                //color: Colors.green,
                                child: Card(
                                    child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: result.data!['getMyClub']
                                          ['logo'],
                                      placeholder: (_, __) => const Icon(
                                          Icons.account_circle_rounded,
                                          size: 60),
                                      errorWidget: (_, __, ___) => const Icon(
                                          Icons.account_circle_rounded,
                                          size: 60),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
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
                                      'assets/illustrations/${tier.toLowerCase()}-medal.svg',
                                      width: 60,
                                      height: 60,
                                    ),
                                    new Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                          'Points : ${badge.threshold.toString()}',
                                          style: TextStyle(fontSize: 18)),
                                    )
                                  ],
                                )),
                              ),
                            ),*/