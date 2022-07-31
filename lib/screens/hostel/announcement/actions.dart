import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/announcements.dart';
import '../../../models/post.dart';

PostActions annoucementActions(PostModel post, QueryOptions<Object?> options) {
  return PostActions(
    edit: editAnnouncementAction(post, options),
    delete: deleteAnnouncementAction(post, options),
  );
}

NavigateAction editAnnouncementAction(
    PostModel post, QueryOptions<Object?> options) {
  // TODO:
  return NavigateAction(to: Container());
}

PostAction deleteAnnouncementAction(
    PostModel post, QueryOptions<Object?> options) {
  return PostAction(
    id: post.id,
    document: AnnouncementGQL.delete,
    updateCache: (cache, result) {
      dynamic data = cache.readQuery(options.asRequest);
      dynamic newData = [];
      for (var i = 0;
          i < data["getAnnouncements"]["announcementsList"].length;
          i++) {
        if (data["getAnnouncements"]["announcementsList"][i]["id"] != post.id) {
          newData =
              newData + [data["getAnnouncements"]["announcementsList"][i]];
        }
      }
      data["getAnnouncements"]["announcementsList"] = newData;
      data["getAnnouncements"]["total"] = data["getAnnouncements"]["total"] - 1;
      cache.writeQuery(options.asRequest, data: data);
    },
  );
}
