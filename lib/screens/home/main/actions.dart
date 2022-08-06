import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/announcements.dart';
import '../../../graphQL/events.dart';
import '../../../graphQL/netops.dart';
import '../../../graphQL/user.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../hostel/announcement/actions.dart';
import '../events/actions.dart';
import '../netops/actions.dart';

PostActions homePostActions(UserModel user, String type, PostModel post) {
  final QueryOptions<Object?> options =
      QueryOptions(document: gql(UserGQL().getMe));
  switch (type) {
    case "Announcements":
      return PostActions(
          edit: editAnnouncementAction(user, post, options),
          delete: homeCardDeleteAction(type, post, options));
    case "Events":
      return PostActions(
          edit: editEventAction(post, options),
          delete: homeCardDeleteAction(type, post, options),
          like: likeEventAction(post, options),
          star: starEventAction(post, options));
    case "Networking & Opportunities":
      return PostActions(
          edit: netopEditAction(post, options),
          delete: homeCardDeleteAction(type, post, options),
          like: netopLikeAction(post, options),
          star: netopStarAction(post, options),
          report: netopReportAction(post, options),
          comment: netopCommentAction(post));
    default:
      return PostActions(
          edit: netopEditAction(post, options),
          delete: homeCardDeleteAction(type, post, options),
          like: netopLikeAction(post, options),
          star: netopStarAction(post, options),
          report: netopReportAction(post, options));
  }
}

PostAction homeCardDeleteAction(
    String type, PostModel post, QueryOptions<Object?> options) {
  return PostAction(
    id: post.id,
    document: (() {
      switch (type) {
        case "Announcements":
          return AnnouncementGQL.delete;
        case "Events":
          return EventGQL().delete;
        case "Networking & Opportunities":
          return NetopGQL.delete;
        default:
          return NetopGQL.delete;
      }
    }()),
    updateCache: (cache, result) {
      dynamic data = cache.readQuery(options.asRequest);
      if (type == "Announcements") {
        dynamic newData = [];
        for (var i = 0;
            i < data["getMe"]["getHome"]["announcements"].length;
            i++) {
          if (data["getMe"]["getHome"]["announcements"][i]["id"] != post.id) {
            newData = [newData] + data["getMe"]["getHome"]["announcements"][i];
          }
        }
        data["getMe"]["getHome"]["announcements"] = newData;
      }
      if (type == "Events") {
        dynamic newData = [];
        for (var i = 0; i < data["getMe"]["getHome"]["events"].length; i++) {
          if (data["getMe"]["getHome"]["events"][i]["id"] != post.id) {
            newData = [newData] + data["getMe"]["getHome"]["events"][i];
          }
        }
        data["getMe"]["getHome"]["events"] = newData;
      }
      if (type == "Networking & Opportunities") {
        dynamic newData = [];
        for (var i = 0; i < data["getMe"]["getHome"]["netops"].length; i++) {
          if (data["getMe"]["getHome"]["netops"][i]["id"] != post.id) {
            newData = [newData] + data["getMe"]["getHome"]["netops"][i];
          }
        }
        data["getMe"]["getHome"]["netops"] = newData;
      }
      cache.writeQuery(options.asRequest, data: data);
    },
  );
}
