import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/auth.dart';
import '../../../models/hostel.dart';
import '../../../themes.dart';
import '../../../widgets/form/dropdown_button.dart';
import '../../../widgets/text/label.dart';

class HostelListDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?)? onChanged;
  final String? error;
  const HostelListDropdown(
      {Key? key, required this.value, required this.onChanged, this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LabelText(text: "Select Hostel"),
        Query(
            options: QueryOptions(
              document: gql(AuthGQL().getHostel),
            ),
            builder: (QueryResult queryResult, {fetchMore, refetch}) {
              if (queryResult.hasException) {
                return SelectableText(queryResult.exception.toString());
              }

              if (queryResult.isLoading) {
                return const Text('Loading');
              }

              HostelsModel hostels =
                  HostelsModel.fromJson(queryResult.data!["getHostels"]);
              List<String> hostelNames = hostels.getNames();
              return CustomDropdownButton(
                value: hostels.getName(value),
                items: hostelNames,
                onChanged: (val) {
                  String? id = hostels.getId(val);
                  if (onChanged != null) onChanged!(id);
                },
              );
            }),
        if (error != null)
          Text(error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorPalette.palette(context).error, fontSize: 12)),
      ],
    );
  }
}
