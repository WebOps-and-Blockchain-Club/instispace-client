import 'package:client/graphQL/post.dart';
import 'package:client/models/color_palette.dart';
import 'package:client/themes.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../widgets/button/icon_button.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key, this.image, this.post}) : super(key: key);
  final image;
  final post;

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();
  final TextEditingController desc = TextEditingController();
  final TextEditingController link = TextEditingController();
  final TextEditingController location = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(document: gql(PostGQl().createPost)),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return Scaffold(
            body: SafeArea(
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomAppBar(
                          title: "NEW POST",
                          leading: CustomIconButton(
                            icon: Icons.arrow_back,
                            onPressed: () => Navigator.of(context).pop(),
                          )),
                      if (widget.image != null)
                        Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 30),
                            height: 300,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                image: widget.image)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 42),
                        child: Column(
                          children: [
                            TextFormField(
                              maxLength: 40,
                              minLines: 1,
                              maxLines: null,
                              controller: title,
                              decoration:
                                  const InputDecoration(label: Text("Title")),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter the title of the post";
                                }
                              },
                            ),
                            TextFormField(
                              controller: desc,
                              maxLength: 3000,
                              maxLines: null,
                              decoration: const InputDecoration(
                                  label: Text("Description")),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter the description of the post";
                                }
                              },
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomElevatedButton(
                                    onPressed: () {},
                                    text: "Date",
                                    padding: const [27, 16],
                                    textColor: Colors.black,
                                    color: Colors.white),
                                CustomElevatedButton(
                                    onPressed: () {},
                                    text: "Time",
                                    padding: const [27, 16],
                                    textColor: Colors.black,
                                    color:
                                        ColorPalette.palette(context).secondary)
                              ],
                            ),
                            TextFormField(
                              controller: location,
                              decoration: const InputDecoration(
                                  label: Text("Location")),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: link,
                              decoration:
                                  const InputDecoration(label: Text("link")),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          );
        });
  }
}
