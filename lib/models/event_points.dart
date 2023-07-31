import 'package:client/graphQL/badge.dart';
import 'package:client/screens/badges/show_qr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EventPointsModel {
  final bool isQRActive;
  final int pointsValue;

  EventPointsModel({
    required this.isQRActive,
    required this.pointsValue,
  });
}

void showDialogForQR(
    BuildContext context, String postId, bool isFirst, bool update) {
  showDialog(
      context: context,
      builder: (context) {
        TextEditingController points = TextEditingController();
        return Mutation(
          options: MutationOptions(
            document: gql(
                update ? BadgeGQL().updatePoints : BadgeGQL().toggleIsQRActive),
            onCompleted: (data) {
              if (isFirst) {
                print('......');
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShowQRPage(postId: postId)));
              }
            },
          ),
          builder: (runMutation, result) {
            return AlertDialog(
                title: const Text('Activate QR'),
                content: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: points,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: "Points",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter the points";
                    }
                    return null;
                  },
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        runMutation({
                          'postId': postId,
                          'points': int.parse(points.text)
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Start')),
                ]);
          },
        );
      });
}
