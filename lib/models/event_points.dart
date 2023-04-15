import 'package:client/graphQL/badge.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EventPointsModel{
 final bool isQRActive;
 final int pointsValue;

 EventPointsModel({
  required this.isQRActive,
  required this.pointsValue,
 });
}
void showDialogForQR(BuildContext context, String postId){
    showDialog(
            context: context,
            builder: (context) {
              TextEditingController points = TextEditingController();
              return Mutation(
                options: MutationOptions(document: gql(BadgeGQL().toggleIsQRActive)),
                builder:(runMutation, result) {
                  return AlertDialog(
                    title: const Text('Activate QR'),
                    content: TextFormField(
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