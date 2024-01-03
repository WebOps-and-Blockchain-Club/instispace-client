import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/graphQL/badge.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../models/badge.dart';
import 'package:client/themes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateBadgesPage extends StatefulWidget {
  const CreateBadgesPage({Key? key}) : super(key: key);

  @override
  State<CreateBadgesPage> createState() => _CreateBadgesPageState();
}

class _CreateBadgesPageState extends State<CreateBadgesPage> {
  List<BadgeModel> badges = [];
  TextEditingController threshold = TextEditingController();
  String tier = 'Gold';
  void showDialogForBadges(String logo) {
    List<String> tiers = ['Gold', 'Silver', 'Bronze'];
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Add Badge'),
            content: Column(
              children: [
                TextFormField(
                  controller: threshold,
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: "Threshold",
                    prefixIcon: const Icon(Icons.account_balance, size: 20),
                    prefixIconConstraints: Themes.inputIconConstraints,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter the threshold";
                    }
                    return null;
                  },
                ),
                DropdownButton(
                    value: tier,
                    items: tiers.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? valueChosen) {
                      setState(() {
                        tier = valueChosen!;
                      });
                    })
              ],
            ),
            actions: [
              TextButton(
                child: Text('Add'),
                onPressed: () {
                  BadgeModel badge = BadgeModel(
                      tier: tier,
                      threshold: int.parse(threshold.text),
                      imageUrl: logo);

                  setState(() {
                    badges.add(badge);
                  });
                },
              )
            ],
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
        return Scaffold(
          floatingActionButton: SizedBox(
              height: 50,
              width: 50,
              child: FloatingActionButton(
                onPressed: () {
                  showDialogForBadges(result.data!['getMyClub']['logo']);
                },
                backgroundColor: ColorPalette.palette(context).secondary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: const Icon(
                  Icons.add,
                  size: 30,
                ),
              )),
          appBar: AppBar(
            title: CustomAppBar(
              title: 'Add Badges',
              leading: CustomIconButton(
                icon: Icons.arrow_back,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Mutation(
                      options: MutationOptions(
                          document: gql(BadgeGQL().createBadges)),
                      builder: (RunMutation runMutation,
                          QueryResult? mutationResult) {
                        return ListView(children: []);
                      }))),
        );
      },
    );
  }
}
