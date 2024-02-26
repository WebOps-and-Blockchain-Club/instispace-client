import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'screens/wrapper.dart';
import 'services/auth.dart';
import 'services/client.dart';
import 'services/notification.dart';
import 'services/user.dart';
import 'themes.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  LocalNotificationService service = LocalNotificationService();
  service.showFirebaseNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: Consumer<AuthService>(builder: (context, auth, child) {
          return GraphQLProvider(
            client: client(auth.token),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'InstiSpace',
              theme: Themes.theme,
              home: Wrapper(auth: auth),
            ),
          );
        }));
  }
}

//user name: me21b072- Harsh rollno
// 123456
