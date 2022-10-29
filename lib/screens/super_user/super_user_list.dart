import 'package:client/graphQL/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../screens/user/search_user.dart';
import '../../screens/user/get_user.dart';
import '../../graphQL/auth.dart';
import '../../graphQL/super_user.dart';
import '../../models/hostel.dart';
import '../../themes.dart';
import '../../utils/validation.dart';

class SuperUserList extends StatefulWidget {
  const SuperUserList({Key? key}) : super(key: key);

  @override
  State<SuperUserList> createState() => _SuperUserListState();
}

class _SuperUserListState extends State<SuperUserList> {
  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    final Map<String, dynamic> defaultVariables = {
      "take": 25,
      "lastUserId": "",
      "rolesFilter": ["LEADS", "SECRETARY", "MODERATOR", "HAS"]
    };

    return Query(
      options: QueryOptions(
          document: gql(UserGQL().getSuperUsers), variables: defaultVariables),
      builder: (QueryResult result, {FetchMore? fetchMore, refetch}) {
        return Scaffold(
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: RefreshIndicator(
                        onRefresh: () => refetch!(),
                        child: NestedScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            headerSliverBuilder: (context, innerBoxIsScrolled) {
                              return [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                    return CustomAppBar(
                                      title: "SuperUser List",
                                      leading: CustomIconButton(
                                          icon: Icons.arrow_back,
                                          onPressed: () =>
                                              Navigator.of(context).pop()),
                                    );
                                  }, childCount: 1),
                                ),
                              ];
                            },
                            body: (() {
                              final userList =
                                  result.data!["getSuperUsers"]["usersList"];
                              final total =
                                  result.data!["getSuperUsers"]["total"];
                              FetchMoreOptions opts = FetchMoreOptions(
                                  variables: {
                                    ...defaultVariables,
                                    "lastUserId": userList.last['id']
                                  },
                                  updateQuery: (previousResultData,
                                      fetchMoreResultData) {
                                    final List<dynamic> repos = [
                                      ...previousResultData!['getSuperUsers']
                                          ['usersList'] as List<dynamic>,
                                      ...fetchMoreResultData!["getSuperUsers"]
                                          ["usersList"] as List<dynamic>
                                    ];
                                    fetchMoreResultData["getSuperUsers"]
                                        ["usersList"] = repos;
                                    return fetchMoreResultData;
                                  });
                              //print(result.data);
                              return NotificationListener<ScrollNotification>(
                                  onNotification: (notification) {
                                    if (notification.metrics.pixels >
                                            0.8 *
                                                notification
                                                    .metrics.maxScrollExtent &&
                                        total > userList.length) {
                                      fetchMore!(opts);
                                    }
                                    return true;
                                  },
                                  child: RefreshIndicator(
                                    onRefresh: () {
                                      return refetch!();
                                    },
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(10),
                                      itemCount: userList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Map<String, dynamic> user = {
                                          "name":
                                              userList[index]["name"] == null
                                                  ? " "
                                                  : userList[index]["name"],
                                          "photo": userList[index]["photo"],
                                          "roll": userList[index]['roll'],
                                          "department": userList[index]
                                              ['department'],
                                          "role": userList[index]['role']
                                        };

                                        String subtitleText = userList[index]
                                                    ["department"] ==
                                                "Null"
                                            ? "${(user["roll"] as String).toUpperCase()}\n${user["role"]}"
                                            : "${(user["roll"] as String).toUpperCase()}\n${user["department"]}\n${user["role"]}";
                                        if (userList[index]["isNewUser"] ==
                                            true) user["name"] = "New User";
                                        return Card(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: ListTile(
                                              leading: CachedNetworkImage(
                                                imageUrl: user["photo"],
                                                placeholder: (_, __) =>
                                                    const SizedBox(
                                                  child:
                                                      CircularProgressIndicator(),
                                                  width: 30,
                                                ),
                                                errorWidget: (_, __, ___) =>
                                                    const Icon(Icons
                                                        .account_circle_rounded),
                                                width: 60,
                                                height: 60,
                                                imageBuilder:
                                                    (_, imageProvider) =>
                                                        CircleAvatar(
                                                  backgroundImage:
                                                      imageProvider,
                                                ),
                                              ),
                                              style: ListTileStyle.list,
                                              title: Text(user["name"]!),
                                              textColor: Colors.black,
                                              subtitle: Text(subtitleText),
                                              onTap: userList[index]
                                                          ["isNewUser"] ==
                                                      false
                                                  ? () => Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              GetUser(
                                                                userDetails: {
                                                                  "roll": user[
                                                                      "roll"],
                                                                  "name": user[
                                                                      "name"]!,
                                                                  "photo": user[
                                                                      "photo"]
                                                                },
                                                              )))
                                                  : () {},
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ));
                            }()))))));
      },
    );
  }
}
