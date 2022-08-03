import 'package:graphql_flutter/graphql_flutter.dart';

import 'new_item.dart';
import '../../../graphQL/lost_and_found.dart';
import '../../../models/post.dart';

PostActions lostAndFoundActions(PostModel post, QueryOptions<Object?> options) {
  return PostActions(
    edit: lostAndFoundEditAction(post, options),
    resolve: lostAndFoundResolveAction(post, options),
  );
}

NavigateAction lostAndFoundEditAction(
    PostModel post, QueryOptions<Object?> options) {
  return NavigateAction(
    to: NewItemPage(
      category: "",
      options: options,
    ),
  );
}

PostAction lostAndFoundResolveAction(
    PostModel post, QueryOptions<Object?> options) {
  return PostAction(
      id: post.id,
      document: LostAndFoundGQL.resolve,
      updateCache: (cache, result) {
        dynamic data = cache.readQuery(options.asRequest);
        dynamic newData = [];
        for (var i = 0; i < data["getItems"]["itemsList"].length; i++) {
          if (data["getItems"]["itemsList"][i]["id"] != post.id) {
            newData = newData + [data["getItems"]["itemsList"][i]];
          }
        }
        data["getItems"]["itemsList"] = newData;
        data["getItems"]["total"] = data["getItems"]["total"] - 1;
        cache.writeQuery(options.asRequest, data: data);
      });
}
