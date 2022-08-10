import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../widgets/helpers/loading.dart';
import '../../../widgets/helpers/error.dart';
import '../../../graphQL/auth.dart';
import '../../../models/hostel.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../themes.dart';

class SelectHostels extends StatefulWidget {
  final HostelsModel selectedHostels;
  final ScrollController controller;
  final Function? callback;
  const SelectHostels({
    Key? key,
    required this.selectedHostels,
    required this.controller,
    this.callback,
  }) : super(key: key);

  @override
  State<SelectHostels> createState() => _SelectHostelsState();
}

class _SelectHostelsState extends State<SelectHostels> {
  late HostelsModel selectedHostels;
  List<String> minimizedCategorys = [];

  @override
  void initState() {
    selectedHostels = widget.selectedHostels;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Query(
          options: QueryOptions(
            document: gql(AuthGQL().getHostel),
          ),
          builder: (QueryResult result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Error(error: result.exception.toString());
            }

            if (result.isLoading && result.data == null) {
              return const Loading();
            }

            final List<HostelModel> hostels =
                HostelsModel.fromJson(result.data!["getHostels"]).hostels;

            if (hostels.isEmpty) {
              return const Error(message: "No Hostels Found", error: "");
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: const Text("Close"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: List.generate(hostels.length, (index) {
                        final isSelected =
                            selectedHostels.contains(hostels[index]);
                        return InkWell(
                          onTap: () {
                            isSelected
                                ? selectedHostels.remove(hostels[index])
                                : selectedHostels.add(hostels[index]);
                            setState(() {
                              selectedHostels;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.purple[100]
                                    : Colors.transparent,
                                border: Border.all(
                                    color: ColorPalette.palette(context)
                                        .secondary),
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Text(hostels[index].name),
                          ),
                        );
                      })),
                )),
                CustomElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.callback!(selectedHostels);
                    },
                    text: "Apply")
              ],
            );
          }),
    );
  }
}

Widget buildSheet(
    BuildContext context, HostelsModel selectedHostels, Function? callback) {
  return makeDimissible(
    context: context,
    child: DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.8,
      builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SelectHostels(
            selectedHostels: selectedHostels,
            controller: controller,
            callback: callback,
          )),
    ),
  );
}

Widget makeDimissible({required Widget child, required BuildContext context}) =>
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(
        onTap: () {},
        child: child,
      ),
    );
