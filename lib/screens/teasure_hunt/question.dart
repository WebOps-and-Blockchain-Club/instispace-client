import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../../widgets/helpers/error.dart';
import '../../../widgets/helpers/navigate.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/button/icon_button.dart';
import '../../graphQL/teasure_hunt.dart';
import '../../models/date_time_format.dart';
import '../../models/teasure_hunt.dart';
import '../../services/image_picker.dart';
import '../../widgets/button/elevated_button.dart';
import '../../widgets/card/description.dart';
import '../../widgets/card/image.dart';

class QuestionsPage extends StatefulWidget {
  final List<QuestionModel> questions;
  final Future<QueryResult<Object?>?> Function()? refetch;

  const QuestionsPage(
      {Key? key, required this.questions, required this.refetch})
      : super(key: key);

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  //Controllers
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
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
                        title: "Teasure Hunt",
                        leading: CustomIconButton(
                            icon: Icons.arrow_back,
                            onPressed: () {
                              Navigator.of(context);
                            }),
                        // TODO: Create Leave Group Button
                        action: CustomIconButton(
                            icon: Icons.logout,
                            onPressed: () => navigate(context, Container())),
                      );
                    }, childCount: 1),
                  ),
                ];
              },
              body: (() {
                final List<QuestionModel> questions = widget.questions;

                if (questions.isEmpty) {
                  return const Error(error: "", message: "No Questions");
                }

                return RefreshIndicator(
                  onRefresh: () => widget.refetch!(),
                  child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        return QuestionCard(
                            index: index, question: questions[index]);
                      }),
                );
              }()),
            ),
          ),
        ),
      ),
    );
    ;
  }
}

class QuestionCard extends StatefulWidget {
  final int index;
  final QuestionModel question;
  const QuestionCard({Key? key, required this.index, required this.question})
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
                  child: AddSubmission(id: question.id)),

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
  const AddSubmission({Key? key, required this.id}) : super(key: key);

  @override
  State<AddSubmission> createState() => _AddSubmissionState();
}

class _AddSubmissionState extends State<AddSubmission> {
  final TextEditingController comment = TextEditingController();
  final addSubmission = TeasureHuntGQL.addSubmission;

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
            document: gql(addSubmission),
            update: (cache, result) {
              if (result != null) {
                // TODO:
                // widget.updateCache(cache, result);
                // widget.updateComments(CommentModel.fromJson(
                //     result.data!["createComment${widget.type}"]));
                // comment.clear();
              }
            }),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return ChangeNotifierProvider(
              create: (_) => ImagePickerService(noOfImages: 1),
              child: Consumer<ImagePickerService>(
                  builder: (context, imagePickerService, child) {
                // TODO:
                // if (result != null &&
                //     result.data != null &&
                //     result.data!["createComment${widget.type}"] != null) {
                //   imagePickerService.clearPreview();
                // }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    imagePickerService.previewImages(),
                    imagePickerService.pickImageButton(
                      context: context,
                    ),
                    CustomElevatedButton(
                      onPressed: () async {
                        List<String> uploadResult;
                        try {
                          uploadResult = await imagePickerService.uploadImage();
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
                            // TODO: Submission Input Object
                            // "commentData": {
                            //   "content": comment.text,
                            //   "imageUrls": uploadResult
                            // },
                            // "id": widget.id,
                          });
                        }
                      },
                      text: "Add Submission",
                      isLoading: result != null && result.isLoading,
                    ),
                    if (result != null && result.hasException)
                      IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: ErrorText(
                            error:
                                formatErrorMessage(result.exception.toString()),
                          ),
                        ),
                      )
                  ],
                );
              }));
        });
  }
}
