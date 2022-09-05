import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../themes.dart';
import '../../graphQL/feedback.dart';
import '../../widgets/helpers/error.dart';
import '../../widgets/form/rating_input.dart';
import '../../widgets/text/label.dart';
import '../../widgets/button/elevated_button.dart';
import '../../widgets/button/icon_button.dart';
import '../../widgets/headers/main.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final formKey = GlobalKey<FormState>();

  int rating1 = 0;
  int rating2 = 0;
  int rating3 = 0;
  final TextEditingController ans1 = TextEditingController();
  final TextEditingController ans2 = TextEditingController();
  final TextEditingController ans3 = TextEditingController();
  bool showValidationError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Mutation(
                    options: MutationOptions(
                      document: gql(FeedbackGQL().add),
                      onCompleted: (dynamic resultData) {
                        if (resultData["addFeedback"] == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Thanks for submitting the feedback')),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    builder: (
                      RunMutation runMutation,
                      QueryResult? result,
                    ) {
                      return Form(
                        key: formKey,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            CustomAppBar(
                                title: "Feedback",
                                leading: CustomIconButton(
                                  icon: Icons.arrow_back,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )),
                            const LabelText(
                                text: "How would you rate our app?"),
                            RatingInput(
                              value: rating1,
                              onChange: (value) {
                                setState(() {
                                  rating1 = value + 1;
                                });
                              },
                            ),
                            if (showValidationError && rating1 == 0)
                              Text(
                                "This field is missing",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: ColorPalette.palette(context)
                                            .error),
                              ),

                            const LabelText(
                                text: "How easy was it to use our app?"),
                            RatingInput(
                              value: rating2,
                              onChange: (value) {
                                setState(() {
                                  rating2 = value + 1;
                                });
                              },
                            ),
                            if (showValidationError && rating2 == 0)
                              Text(
                                "This field is missing",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: ColorPalette.palette(context)
                                            .error),
                              ),

                            const LabelText(
                                text:
                                    "How likely is that would you recommend the app to your friends?"),
                            RatingInput(
                              value: rating3,
                              onChange: (value) {
                                setState(() {
                                  rating3 = value + 1;
                                });
                              },
                            ),
                            if (showValidationError && rating3 == 0)
                              Text(
                                "This field is missing",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: ColorPalette.palette(context)
                                            .error),
                              ),

                            // Additional Feedback
                            const LabelText(
                                text:
                                    "What did you like the most about the app & why?"),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: ans1,
                              ),
                            ),
                            const LabelText(
                                text:
                                    "What did you not like about the app & why?"),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: ans2,
                              ),
                            ),
                            const LabelText(
                                text: "Do you have any suggestions?"),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: ans3,
                              ),
                            ),

                            if (result != null && result.hasException)
                              ErrorText(error: result.exception.toString()),

                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CustomElevatedButton(
                                onPressed: () async {
                                  final isValid = rating1 != 0 &&
                                      rating2 != 0 &&
                                      rating3 != 0;

                                  if (isValid) {
                                    runMutation({
                                      "addFeedback": {
                                        "rating1": rating1,
                                        "rating2": rating1,
                                        "rating3": rating1,
                                        "ans1": ans1.text,
                                        "ans2": ans2.text,
                                        "ans3": ans3.text
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      showValidationError = true;
                                    });
                                  }
                                },
                                text: "Submit",
                                isLoading: result!.isLoading,
                              ),
                            )
                          ],
                        ),
                      );
                    }))));
  }
}
