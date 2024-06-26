import 'package:client/models/course.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:uni_links/uni_links.dart';
import 'package:upgrader/upgrader.dart';
import '../config.dart';
import '../models/user.dart';
import '../services/auth.dart';
import '../../widgets/helpers/error.dart';
import '../../widgets/helpers/loading.dart';
import '../../graphQL/user.dart';
import '../services/notification.dart';
import 'splash/main.dart';
import 'auth/login.dart';
import 'home/main.dart';
import 'user/edit_profile.dart';

class Wrapper extends StatefulWidget {
  final AuthService auth;
  const Wrapper({Key? key, required this.auth}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final LocalNotificationService service = LocalNotificationService();
  String? navigatePath;

  @override
  void initState() {
    listenToNotification();
    listenToDeepLink();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService auth = widget.auth;
    if (auth.token == null || auth.newUserOnApp == null) {
      return const Scaffold(
          body: Loading(
        message: "Connecting to InstiSpace...",
      ));
    } else if (auth.newUserOnApp == true) {
      return SplashScreen(auth: auth);
    } else if (auth.token == "") {
      return LogIn(auth: auth);
    } else {
      return Query(
          options: QueryOptions(
            document: gql(UserGQL().getMe),
            parserFn: (data) => UserModel.fromJson(data['getMe']),
          ),
          builder: (QueryResult result, {FetchMore? fetchMore, refetch}) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: (() {
                if (result.hasException && result.data == null) {
                  return Center(
                      child: Error(
                    error: result.exception.toString(),
                    onRefresh: refetch,
                  ));
                }

                if (result.isLoading && result.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (result.parsedData != null) {
                  final UserModel user = result.parsedData as UserModel;
                  if (user.isNewUser == true) {
                    return EditProfile(
                      auth: auth,
                      user: user,
                      password: false,
                      refetch: refetch,
                    );
                  } else if (user.isNewUser == false) {
                    return UpgradeAlert(
                      upgrader: Upgrader(
                          debugLogging: true,
                          // debugDisplayOnce: true,
                          countryCode: 'IN',
                          languageCode: 'en'),
                      child: HomeWrapper(
                        auth: auth,
                        user: user,
                        // refetch: () async {
                        //   navigatePath = null;
                        //   refetch!();
                        // },
                        navigatePath: navigatePath,
                      ),
                    );
                  }
                }

                return Center(
                    child: Error(
                  error: '',
                  message: 'Server Error!',
                  onRefresh: refetch,
                ));
              }()),
            );
          });
    }
  }

  Future<String?> listenToNotification() async {
    String? path;
    service.onNotificationClick.stream.listen((String? _payload) {
      path = _payload;
    });
    if (path == null || path!.isEmpty) {
      var details = await service.details();
      path = details?.payload;
      if (path != null && path!.isNotEmpty) {
        navigatePath = path;
      }
    }
    return path;
  }

  void listenToDeepLink() async {
    final initialLink = await getInitialLink();

    if (initialLink != null && initialLink.isNotEmpty) {
      final path = initialLink.split(shareBaseLink).last;
      if (path.isNotEmpty) {
        navigatePath = path;
      }
    }
  }
}
