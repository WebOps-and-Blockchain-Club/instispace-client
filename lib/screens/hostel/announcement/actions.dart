import 'package:graphql_flutter/graphql_flutter.dart';

import 'new_announcement.dart';
import '../../../models/announcement.dart';
import '../../../models/user.dart';
import '../../../graphQL/announcements.dart';
import '../../../models/post.dart';

PostActions annoucementActions(
    UserModel user, PostModel post, QueryOptions<Object?> options) {
  return PostActions(
    edit: editAnnouncementAction(user, post, options),
    delete: deleteAnnouncementAction(post, options),
  );
}

NavigateAction editAnnouncementAction(
    UserModel user, PostModel post, QueryOptions<Object?> options) {
  return NavigateAction(
      to: NewAnnouncementPage(
          user: user,
          announcement: AnnouncementModel(
              id: post.id,
              title: post.title,
              description: post.description,
              attachements: post.attachements,
              createdAt: post.createdAt!,
              endTime: post.endTime!,
              createdBy: post.createdBy!,
              hostels: post.hostels!,
              permissions: post.permissions),
          options: options));
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
