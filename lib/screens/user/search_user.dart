import 'package:client/widgets/helpers/navigate.dart';
import 'package:client/widgets/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '/models/user.dart';
import 'get_user.dart';
import '/widgets/app_bar.dart';
import '/widgets/helpers/error.dart';
import '/widgets/primary_filter.dart';
import '/widgets/headers/main.dart';
import '/graphQL/user.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({Key? key}) : super(key: key);

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  //Controllers
  // final List<String> batchFilter = [
  //   '18 Batch',
  //   '19 Batch',
  //   '20 Batch',
  //   '21 Batch',
  //   '22 Batch'
  // ];
  final List<String> genderOptions = ['Male', 'Female'];
  final List<String> programOptions = [
    'B.Tech',
    'Dual Degree',
    'M.Tech',
    'M.S',
    'M.Tech',
    'MBA',
    'MA',
    'Ph.D',
    'Others'
  ];
  List<String> selectedGender = [];
  List<String> selectedProgram = [];
  final ScrollController _scrollController = ScrollController();

  late String searchValidationError = "";

  String search = "";

  @override
  Widget build(BuildContext context) {
    final QueryOptions<Object?> options = QueryOptions(
        document: gql(UserGQL().searchUser),
        variables: UserQueryVariableModel(
          search: search,
          gender: selectedGender.isNotEmpty ? selectedGender.last : null,
          program: selectedProgram.isNotEmpty ? selectedProgram.last : null,
        ).toJson(),
        parserFn: (data) => LdapUsersModel.fromJson(data));

    return Scaffold(
      body: NestedScrollView(
        // physics: const AlwaysScrollableScrollPhysics(),
        controller: ScrollController(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[
            // AppBar
            secondaryAppBar(title: 'Find People'),

            // SearchBar & Filter
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SearchBar(
                    onSubmitted: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: PrimaryFilter<String>(
                    options: [...genderOptions, ...programOptions],
                    optionTextBuilder: (e) => e,
                    onSelect: (value) {
                      List<String> _selectedGender = [];
                      List<String> _selectedProgram = [];
                      for (var i = 0; i < value.length; i++) {
                        if (genderOptions.contains(value[i])) {
                          _selectedGender.add(value[i]);
                        } else if (programOptions.contains(value[i])) {
                          _selectedProgram.contains(value[i]);
                        }
                      }
                      setState(() {
                        selectedGender = _selectedGender;
                        selectedProgram = _selectedProgram;
                      });
                    },
                  ),
                ),
              ]),
            ),
          ];
        },
        body: search == ''
            ? const Padding(
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Text('  Enter the string to search'),
              )
            : QueryList<LdapUserModel>(
                options: options,
                itemBuilder: (user) => Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 20),
                  child: GestureDetector(
                    onTap: () =>
                        navigate(context, GetUser(userDetails: user.toJson())),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 30),
                      child: Row(
                        children: [
                          ProfileIconWidget(photo: user.photo),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                user.ldapName,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Text(user.roll + ', ' + user.program)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                fetchMoreOption: (item) => FetchMoreOptions(
                  variables: {...options.variables, "lastUserId": item.id},
                  updateQuery: (previousResultData, fetchMoreResultData) {
                    final List<dynamic> repos = [
                      ...previousResultData!['getLdapStudents']['list']
                          as List<dynamic>,
                      ...fetchMoreResultData!["getLdapStudents"]["list"]
                          as List<dynamic>
                    ];
                    fetchMoreResultData["getLdapStudents"]["list"] = repos;
                    return fetchMoreResultData;
                  },
                ),
                endOfListWidget: (result, fetchMore) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: (result.parsedData as LdapUsersModel).total ==
                          (result.parsedData as LdapUsersModel).list.length
                      ? null
                      : result.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TextButton(
                              onPressed: () => fetchMore,
                              child: const Text("Load More")),
                ),
              ),
      ),
    );
  }
}

class QueryListModel<T> {
  final List<T> list;
  final int total;

  QueryListModel({required this.list, required this.total});
}

class QueryList<T> extends StatefulWidget {
  final QueryOptions<Object?> options;
  final Widget Function(T) itemBuilder;
  final FetchMoreOptions Function(T) fetchMoreOption;
  final Widget Function(
          QueryResult result, Future<QueryResult<Object?>> fetchMore)?
      endOfListWidget;

  const QueryList(
      {Key? key,
      required this.options,
      required this.itemBuilder,
      required this.fetchMoreOption,
      this.endOfListWidget})
      : super(key: key);

  @override
  State<QueryList<T>> createState() => _QueryListState<T>();
}

class _QueryListState<T> extends State<QueryList<T>> {
  @override
  Widget build(BuildContext context) {
    final options = widget.options;
    return Query(
      options: options,
      builder: (result, {fetchMore, refetch}) {
        if (result.hasException) {
          return Center(
            child: Text(formatErrorMessage(result.exception.toString())),
          );
        }

        if (result.hasException && result.data != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(formatErrorMessage(result.exception.toString()))),
          );
        }

        if (result.isLoading && result.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final dynamic resultParsedData = result.parsedData;
        final List<T> items = resultParsedData.list as List<T>;
        final int total = resultParsedData.total;

        if (items.isEmpty) {
          return Center(
            child: Error(
              error: '',
              message: 'No data found.',
              onRefresh: refetch,
            ),
          );
        }

        FetchMoreOptions opts = widget.fetchMoreOption(items.last);

        return RefreshIndicator(
          onRefresh: () {
            return refetch!();
          },
          child: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >
                      0.8 * notification.metrics.maxScrollExtent &&
                  total > items.length) {
                fetchMore!(opts);
              }
              return true;
            },
            child: ListView.builder(
              itemCount:
                  items.length + (widget.endOfListWidget != null ? 1 : 0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) => index == items.length
                  ? widget.endOfListWidget!(result, fetchMore!(opts))
                  : widget.itemBuilder(items[index]),
            ),
          ),
        );
      },
    );
  }
}
