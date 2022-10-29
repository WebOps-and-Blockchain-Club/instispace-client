import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../../widgets/helpers/error.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/button/icon_button.dart';
import '../../graphQL/teasure_hunt.dart';
import '../../models/date_time_format.dart';
import '../../models/teasure_hunt.dart';
import '../../services/image_picker.dart';
import '../../widgets/button/elevated_button.dart';
import '../../widgets/card/description.dart';
import '../../widgets/card/image.dart';
import '../../themes.dart';
import 'group.dart';

class QuestionsPage extends StatefulWidget {
  final GroupModel group;
  final Future<QueryResult<Object?>?> Function()? refetch;

  const QuestionsPage({Key? key, required this.group, required this.refetch})
      : super(key: key);

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  //Controllers
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final List<QuestionModel> questions = widget.group.questions ?? [];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: RefreshIndicator(
            onRefresh: () => widget.refetch!(),
            child: NestedScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return CustomAppBar(
                        title: "Treasure Hunt",
                        leading: CustomIconButton(
                            icon: Icons.arrow_back,
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        action: (DateTimeFormatModel.fromString(
                                        widget.group.startTime)
                                    .toDiffInSeconds() <=
                                0)
                            ? null
                            : LeaveGroup(refetch: widget.refetch),
                      );
                    }, childCount: 1),
                  ),
                ];
              },
              body: (() {
                return RefreshIndicator(
                  onRefresh: () => widget.refetch!(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SelectableText(
                            widget.group.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SelectableText(
                            "Group Code: ${widget.group.code}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SelectableText(
                            "(Use the code to invite your friends)",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color:
                                        ColorPalette.palette(context).primary),
                          ),
                          const SizedBox(height: 10),
                          if (DateTimeFormatModel.fromString(
                                      widget.group.startTime)
                                  .toDiffInSeconds() >
                              0)
                            SelectableText(
                              "Treasure starts at ${DateTimeFormatModel.fromString(widget.group.startTime).toFormat("hh:mm a")}.",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          if (questions.isNotEmpty)
                            SelectableText(
                              "Treasure ends in ${DateTimeFormatModel.fromString(widget.group.endTime).toDiffString(abs: true)}.",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          if (!(widget.group.users != null &&
                              widget.group.minMembers != null &&
                              (widget.group.minMembers! <=
                                  widget.group.users!.length)))
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: SelectableText(
                                "A minimum of ${widget.group.minMembers} members are required to start the treasure hunt.",
                                style: Theme.of(context).textTheme.titleLarge,
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (questions.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                              itemCount: questions.length,
                              itemBuilder: (context, index) {
                                return QuestionCard(
                                  index: index,
                                  question: questions[index],
                                  refetch: widget.refetch,
                                );
                              }),
                        ),
                    ],
                  ),
                );
              }()),
            ),
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatefulWidget {
  final int index;
  final QuestionModel question;
  final Future<QueryResult<Object?>?> Function()? refetch;
  const QuestionCard(
      {Key? key, required this.index, required this.question, this.refetch})
      : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    final question = widget.question;
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Expanded(
                    child: SelectableText("Question ${widget.index + 1}",
                        style: Theme.of(context).textTheme.titleLarge)),
              ],
            ),

            // Description
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Description(content: question.description),
            ),

            //Images
            if (question.image != null && question.image!.isNotEmpty)
              ImageCard(imageUrls: [question.image!]),
            const Divider(),

            // Add Submission
            if (question.submission == null)
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: AddSubmission(
                    id: question.id,
                    refetch: widget.refetch,
                  )),

            // View Submission
            if (question.submission != null)
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Images
                    if (question.submission!.images != null &&
                        question.submission!.images!.isNotEmpty)
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: ImageCard(
                              imageUrls: [question.submission!.images!])),

                    // Description
                    Description(content: question.submission!.description),

                    // Posted By & Time
                    SelectableText(
                        'Submitted by ${question.submission!.createdBy.name}, ${DateTimeFormatModel.fromString(question.submission!.createdAt).toDiffString()} ago',
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

class AddSubmission extends StatefulWidget {
  final String id;
  final Future<QueryResult<Object?>?> Function()? refetch;
  const AddSubmission({Key? key, required this.id, this.refetch})
      : super(key: key);

  @override
  State<AddSubmission> createState() => _AddSubmissionState();
}

class _AddSubmissionState extends State<AddSubmission> {
  final TextEditingController comment = TextEditingController();
  final addSubmission = TeasureHuntGQL.addSubmission;
  bool imageUploadLoading = false;

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: gql(addSubmission),
          update: (cache, result) {
            if (result != null &&
                result.data != null &&
                result.data!["addSubmission"] != null) {
              final Map<String, dynamic> updated = {
                "__typename": "Question",
                "id": widget.id,
                "submission": result.data!["addSubmission"],
              };
              cache.writeFragment(
                Fragment(document: gql('''
                      fragment questionSubmissionField on Question {
                        id
                        submission {
                          id
                          description
                          images
                          createdAt
                          submittedBy {
                            id
                            roll
                            name
                            role
                          }
                        }
                      }
                    ''')).asRequest(idFields: {
                  '__typename': "Question",
                  'id': widget.id,
                }),
                data: updated,
                broadcast: false,
              );
            }
          },
          onError: (error) {
            if (error.toString().contains("Invalid Time")) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Oops! Time Over")),
              );
              widget.refetch!();
            } else if (error.toString().contains("Already answered")) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text("Submission is been made by another team member")),
              );
              widget.refetch!();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(formatErrorMessage(error.toString()))),
              );
            }
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return ChangeNotifierProvider(
              create: (_) => ImagePickerService(noOfImages: 1),
              child: Consumer<ImagePickerService>(
                  builder: (context, imagePickerService, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SingleChildScrollView(
                        child: TextFormField(
                          controller: comment,
                          maxLength: 3000,
                          minLines: 3,
                          maxLines: null,
                          decoration:
                              const InputDecoration(labelText: "Comment"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the comment for submission";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    imagePickerService.previewImages(),
                    imagePickerService.pickImageButton(
                      context: context,
                    ),
                    CustomElevatedButton(
                      onPressed: () async {
                        List<String> uploadResult;

                        try {
                          setState(() {
                            imageUploadLoading = true;
                          });
                          uploadResult = await imagePickerService.uploadImage();
                          setState(() {
                            imageUploadLoading = false;
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Image Upload Failed'),
                              backgroundColor: Theme.of(context).errorColor,
                            ),
                          );

                          return;
                        }
                        if (!(result != null && result.isLoading) &&
                            comment.text.isNotEmpty) {
                          runMutation({
                            "submissionData": {
                              "description": comment.text,
                              "imageUrls": uploadResult
                            },
                            "questionId": widget.id,
                          });
                        }
                      },
                      text: "Add Submission",
                      isLoading: (result != null && result.isLoading) ||
                          imageUploadLoading,
                    ),
                    // if (result != null && result.hasException)
                    //   IntrinsicHeight(
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(top: 4.0),
                    //       child: ErrorText(
                    //         error:
                    //             formatErrorMessage(result.exception.toString()),
                    //       ),
                    //     ),
                    //   )
                  ],
                );
              }));
        });
  }
}
