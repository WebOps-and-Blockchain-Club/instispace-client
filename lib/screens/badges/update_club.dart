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
import 'dart:convert';
import 'dart:io';

class UpdateClubPage extends StatefulWidget {
  String? photoUrl;
  String? name;
   UpdateClubPage({Key? key, this.name, this.photoUrl}) : super(key: key);

  @override
  State<UpdateClubPage> createState() => _UpdateClubPageState();
}

class _UpdateClubPageState extends State<UpdateClubPage> {
   File? image;
  String photoUrl = '';
  bool isImageLoading = false;
  final imageService = ImageService();
  final formKey = GlobalKey<FormState>();
  TextEditingController clubName = TextEditingController();
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
                        
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ViewClubPage()));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Club Updated')),
                        );
                      }),
                  builder: (
                    RunMutation runMutation,
                    QueryResult? result,
                  ) {
                    print(result);
                    return ChangeNotifierProvider(
                      create: (_) => ImagePickerService(noOfImages: 1),
                      child: Consumer<ImagePickerService>(
                          builder: (context, imagePickerService, child) {
                        if (result != null &&
                            result.data != null &&
                            result.data!["updateClub"] != null) {
                          imagePickerService.clearPreview();
                        }
                        List<dynamic>? imgFiles = imagePickerService.get();
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
                                  print('loading');
                                  setState(() {
                                    isImageLoading = true;
                                  });
                                  uploadResult =
                                      await imageService.upload([image]);
                                      setState(() {
                                        isImageLoading = false;
                                      });
                                  print('loaded');
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
                                    'updateClubInput': {
                                      "clubName": clubName.text,
                                      'logo': uploadResult[0]
                                    }
                                  });
                                }
                              },
                              text: "Update Club",
                              isLoading: result!.isLoading || isImageLoading,
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
