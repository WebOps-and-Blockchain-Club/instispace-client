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
        if (result!.isLoading || result.data == null) {
          return const Loading();
        }
        if (result.data!['getMyClub'] != null) {
          //TODO: create model for club and pass
          return const ViewClubPage();
        } else {
          return const CreateClubPage();
        }
      },
    );
  }
}
