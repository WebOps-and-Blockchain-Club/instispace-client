import 'package:client/graphQL/badge.dart';
import 'package:client/graphQL/feed.dart';
import 'package:client/screens/teasure_hunt/group.dart';
import 'package:client/services/local_storage.dart';
import 'package:client/utils/custom_icons.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:client/widgets/helpers/loading.dart';
import 'package:flutter/src/foundation/key.dart';
import 'dart:io';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

final localStorage = LocalStorageService();

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String treasure_hunt_qr = 'https://instispace.iitm.ac.in/app';
  Barcode? scanResult;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void showDialogForRedeemingPoints(String scannedCode) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Redeem points'),
            content: Query(
              options: QueryOptions(
                  document: gql(FeedGQL().findOnePost),
                  variables: {'Postid': scannedCode}),
              builder: (result, {fetchMore, refetch}) {
                if (result.data == null ||
                    result.data!['findOnePost'] == null) {
                  return const Text('Invalid QR code');
                } else if (result.isLoading) {
                  return const Loading();
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        'This event is worth ${result.data!['findOnePost']['pointsValue']} points'),
                    const SizedBox(
                      height: 15,
                    ),
                    Mutation(
                      options: MutationOptions(
                          document: gql(BadgeGQL().markAttendance),
                          onCompleted: (dynamic resultData) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Points Redeemed')),
                            );
                            Navigator.of(context).pop();
                          }),
                      builder: (runMutation, result) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: CustomElevatedButton(
                            onPressed: () {
                              runMutation({'postId': scanResult!.code});
                            },
                            textSize: 18,
                            padding: const [25, 15],
                            text: "Redeem",
                            isLoading: result!.isLoading,
                          ),
                        );
                      },
                    )
                  ],
                );
              },
            ),
          );
        });
  }

  // set true if they have scanned the right qr
  Future<void> setTreasureHunt(bool scanned) async {
    await localStorage.setData("treasure_hunt", {"scanned": scanned});
  }

  // redirect them to join a group
  void showDialogForJoiningGroup() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Great! You can join a group now"),
              content: CustomElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const GroupPage(
                                refetch: null,
                              ))),
                  text: "Join Group"));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const CustomAppBar(title: 'Scan QR'),
          leading: CustomIconButton(
            icon: Icons.arrow_back,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scanResult = scanData;
      });
      print(scanData.code);

      if (scanResult!.code != null || scanResult!.code!.isNotEmpty) {
        controller.pauseCamera();
        if (scanResult!.code == treasure_hunt_qr) {
          setTreasureHunt(true);
          showDialogForJoiningGroup();
        } else
          showDialogForRedeemingPoints(scanResult!.code!);
      }
    });
  }
}
