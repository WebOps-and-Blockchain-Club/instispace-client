import 'package:client/services/image_picker.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:client/widgets/text/label.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes.dart';
import '../../widgets/helpers/error.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../graphQL/badge.dart';
import 'dart:convert';
import 'dart:io';

class UpdateClubPage extends StatefulWidget {
  const UpdateClubPage({Key? key}) : super(key: key);

  @override
  State<UpdateClubPage> createState() => _UpdateClubPageState();
}

class _UpdateClubPageState extends State<UpdateClubPage> {
  TextEditingController clubName = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: gql(BadgeGQL().getMyClub)),
      builder: (QueryResult queryResult, {fetchMore, refetch}) {
        print(queryResult);
        return Scaffold(
            appBar: AppBar(
              title: const CustomAppBar(
                title: 'Update Club',
              ),
              leading: CustomIconButton(
                icon: Icons.arrow_back,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              automaticallyImplyLeading: false,
            ),
            body: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Mutation(
                  options: MutationOptions(
                      document: gql(BadgeGQL().updateClub),
                      onCompleted: (dynamic resultData) {
                        if (resultData["createClub"] == true) {
                          Navigator.of(context).pop();
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Club Updated')),
                        );
                      }),
                  builder: (
                    RunMutation runMutation,
                    QueryResult? result,
                  ) {
                    return ChangeNotifierProvider(
                      create: (_) => ImagePickerService(noOfImages: 1),
                      child: Consumer<ImagePickerService>(
                          builder: (context, imagePickerService, child) {
                        if (result != null &&
                            result.data != null &&
                            result.data!["createClub"] != null) {
                          imagePickerService.clearPreview();
                        }
                        List<dynamic>? imgFiles = imagePickerService.get();
                        return Form(
                          key: formKey,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              const SizedBox(height: 10),

                              /// Info
                              imgFiles == null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.blue, radius: 30)
                                  : CircleAvatar(
                                      child: Image.file(File(imgFiles[0].path)),
                                      radius: 30,
                                    ),
                              Row(
                                children: [
                                  SizedBox(width: 20),
                                  imagePickerService.pickImageButton(
                                      context: context)
                                ],
                              ),

                              const LabelText(
                                  text: 'Enter the name of the club'),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  //queryResult.data!['clubName'],
                                  controller: clubName,
                                  maxLength: 20,
                                  decoration: InputDecoration(
                                    labelText: "Club Name",
                                    prefixIcon: const Icon(
                                        Icons.account_balance,
                                        size: 20),
                                    prefixIconConstraints:
                                        Themes.inputIconConstraints,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter the club name";
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              if (result != null && result.hasException)
                                ErrorText(error: result.exception.toString()),

                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: CustomElevatedButton(
                                  onPressed: () async {
                                    List<String> uploadResult;
                                    try {
                                      uploadResult = await imagePickerService
                                          .uploadImage();
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              const Text('Image Upload Failed'),
                                          backgroundColor:
                                              Theme.of(context).errorColor,
                                        ),
                                      );
                                      return;
                                    }

                                    final isValid =
                                        formKey.currentState!.validate();
                                    FocusScope.of(context).unfocus();
                                    if (isValid) {
                                      runMutation({
                                        'updateClubInput': {
                                          'clubName': clubName.text,
                                          'logo': uploadResult[0],
                                        }
                                      });
                                    }
                                  },
                                  text: "Update Club",
                                  isLoading: result!.isLoading,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    );
                  }),
            )));
      },
    );
  }
}
