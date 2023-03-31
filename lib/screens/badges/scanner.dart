import 'package:client/graphQL/badge.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:flutter/src/foundation/key.dart';
import 'dart:io';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
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

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(document: gql(BadgeGQL().markAttendance)),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          print(result);
          return Scaffold(
              body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              /*Expanded(
                flex: 1,
                child: Center(
                    child: Row(children: [
                  (scanResult != null)
                      ? Text('Id: ${scanResult!.code}')
                      : Text('Scan a code'),
                ])),
              ),*/
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: CustomElevatedButton(
                  onPressed: () {
                    runMutation({'postId': scanResult!.code});
                  },
                  textSize: 18,
                  padding: const [25, 15],
                  text: "Mark Attendance",
                  isLoading: result!.isLoading,
                ),
              ),
            ],
          ));
        });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scanResult = scanData;
      });
    });
  }
}
