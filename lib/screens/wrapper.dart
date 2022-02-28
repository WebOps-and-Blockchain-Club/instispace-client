import 'package:client/screens/userInit/main.dart';
import 'package:client/services/storeMe.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/login/login.dart';
import 'package:client/services/Auth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:client/screens/home/main.dart';

import 'home/home.dart';

import '../graphQL/home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AuthService(),
        child: Consumer<AuthService>(builder: (context, auth, child) {
          return auth.token == null
              ? LogIn()
              : (auth.isNewUser == false ? mainHome() : userInit(auth: auth));
        }));
  }
}

// class StoreData extends StatefulWidget {
//   const StoreData({Key? key}) : super(key: key);
//
//   @override
//   _StoreDataState createState() => _StoreDataState();
// }
//
// class _StoreDataState extends State<StoreData> {
//   String getMe = homeQuery().getMe;
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//         create: (_) => StoreMe(),
//         child: Consumer<StoreMe>(builder: (context, auth, child) {
//           return auth.roll == null ? StoreUser() : HomePage();
//         }));
//   }
// }

// class StoreUser extends StatefulWidget {
//   const StoreUser({Key? key}) : super(key: key);
//
//   @override
//   _StoreUserState createState() => _StoreUserState();
// }
//
// class _StoreUserState extends State<StoreUser> {
//   late StoreMe _storeMe;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//       _storeMe = Provider.of<StoreMe>(context, listen: false);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Query(
//         options: QueryOptions(
//           document: gql(getMe),
//         ),
//         builder: (QueryResult result, {fetchMore, refetch}) {
//           if (result.hasException) {
//             print(result.exception.toString());
//           }
//           if (result.isLoading) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: Colors.blue[700],
//               ),
//             );
//           }
//           var data = result.data!["getMe"];
//           List<String> interests = [];
//           for (var i = 0; i < data["interest"].length; i++) {
//             interests.add("${data["interest"][i]}");
//           }
//           _storeMe.setUser(
//               data["roll"], data["name"], data["role"], "", interests);
//           _storeMe.loadUser();
//           print(
//               "user data:roll:${_storeMe.roll},name:${_storeMe.name},role:${_storeMe.role},mobile:${_storeMe.mobile},interests:${_storeMe.interest}");
//           return Container();
//         });
//   }
// }
