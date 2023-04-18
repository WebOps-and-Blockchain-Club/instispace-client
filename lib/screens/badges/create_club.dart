import 'package:client/screens/badges/view_club.dart';
import 'package:client/screens/home/new_post/imageService.dart';
import 'package:client/services/image_picker.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:client/widgets/profile_icon.dart';
import 'package:client/widgets/text/label.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes.dart';
import '../../widgets/helpers/error.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../graphQL/badge.dart';
import 'dart:io';

class CreateClubPage extends StatefulWidget {
  
  const CreateClubPage({Key? key,}) : super(key: key);

  @override
  State<CreateClubPage> createState() => _CreateClubPageState();
}

class _CreateClubPageState extends State<CreateClubPage> {
  TextEditingController clubName = TextEditingController();
  int dummy = 0;
  File? image;
  String photoUrl = '';
  final imageService = ImageService();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const CustomAppBar(
            title: 'Create Club',
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
                  document: gql(BadgeGQL().createClub),
                  onCompleted: (dynamic resultData) {
                    if (resultData["createClub"] == true) {
                      Navigator.of(context).pop();
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('New Club Created')),
                    );
                    setState(() {
                      dummy=0;
                    });
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => const ViewClubPage())));
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
                    return Form(
                      key: formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          if (image == null)
                            ProfileIconWidget(
                              photo: photoUrl,
                              size: 100,
                            ),
                          if (image != null)
                            ProfileIconWidget(
                              photo: image?.path ?? '',
                              size: 100,
                              type: 'file',
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomElevatedButton(
                                  color: Colors.white,
                                  leading: Icons.camera_alt,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            title: const Text('Choose Images'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                    onPressed: () async {
                                                      final File? photo =
                                                          await imageService
                                                              .pickCamera();
                                                      setState(() {
                                                        if (photo != null) {
                                                          image = photo;
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      });
                                                    },
                                                    child:
                                                        const Text('Camera')),
                                                TextButton(
                                                    onPressed: () async {
                                                      final List<File> photos =
                                                          await imageService
                                                              .pickGalley();

                                                      if (photos.isNotEmpty) {
                                                        setState(() {
                                                          image = photos.last;
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      }
                                                    },
                                                    child:
                                                        const Text('Gallery')),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const Text(
                                                            "Cancel"))
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  textColor: Colors.black,
                                  text: photoUrl == '' && image == null
                                      ? 'Add Profile Photo'
                                      : 'Edit Profile Photo'),
                            ],
                          ),
                          const LabelText(text: 'Enter the name of the club'),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: clubName,
                              maxLength: 20,
                              decoration: InputDecoration(
                                labelText: "Club Name",
                                prefixIcon:
                                    const Icon(Icons.account_balance, size: 20),
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
                                  uploadResult =
                                      await imageService.upload([image]);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          const Text('Image Uploaded'),
                                    ));
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
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
                                    'createClubInput': {
                                      "clubName": clubName.text,
                                      'logo': uploadResult[0]
                                    }
                                  });
                                }
                              },
                              text: "Create Club",
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
  }
}
