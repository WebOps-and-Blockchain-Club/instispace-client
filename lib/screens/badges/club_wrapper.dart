import 'package:client/graphQL/badge.dart';
import 'package:client/screens/badges/create_club.dart';
import 'package:client/screens/badges/view_club.dart';
import 'package:client/widgets/helpers/loading.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

class ClubWrapperPage extends StatefulWidget {
  const ClubWrapperPage({Key? key}) : super(key: key);

  @override
  State<ClubWrapperPage> createState() => _ClubWrapperPageState();
}

class _ClubWrapperPageState extends State<ClubWrapperPage> {
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(BadgeGQL().getMyClub),
      ),
      builder: (QueryResult? result, {fetchMore, refetch}) {
        if (result!.isLoading) {
          return Scaffold(body: const Loading());
        }

        else if (result.data == null || result.data!['getMyClub'] == null) {
          return const CreateClubPage();
        } else {
          return const ViewClubPage();
        }
      },
    );
  }
}
