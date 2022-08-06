import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/events.dart';
import '../../../graphQL/netops.dart';
import '../../../models/post.dart';
import '../events/actions.dart';
import '../netops/actions.dart';

PostActions tagPostActions(
    String type, PostModel post, QueryOptions<Object?> options) {
  switch (type) {
    case "Events":
      return PostActions(
          edit: editEventAction(post, options),
          delete: tagCardDeleteAction(type, post, options),
          like: likeEventAction(post, options),
          star: starEventAction(post, options));
    case "Networking & Opportunities":
      return PostActions(
          edit: netopEditAction(post, options),
          delete: tagCardDeleteAction(type, post, options),
          like: netopLikeAction(post, options),
          star: netopStarAction(post, options),
          report: netopReportAction(post, options),
          comment: netopCommentAction(post));
    default:
      return PostActions(
          edit: netopEditAction(post, options),
          delete: tagCardDeleteAction(type, post, options),
          like: netopLikeAction(post, options),
          star: netopStarAction(post, options),
          report: netopReportAction(post, options));
  }
}

PostAction tagCardDeleteAction(
    String type, PostModel post, QueryOptions<Object?> options) {
  return PostAction(
    id: post.id,
    document: (() {
      switch (type) {
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
      if (type == "Events") {
        dynamic newData = [];
        for (var i = 0; i < data["getTag"]["events"].length; i++) {
          if (data["getTag"]["events"][i]["id"] != post.id) {
            newData = [newData] + data["getTag"]["events"][i];
          }
        }
        data["getTag"]["events"] = newData;
      }
      if (type == "Networking & Opportunities") {
        dynamic newData = [];
        for (var i = 0; i < data["getTag"]["netops"].length; i++) {
          if (data["getTag"]["netops"][i]["id"] != post.id) {
            newData = [newData] + data["getTag"]["netops"][i];
          }
        }
        data["getTag"]["netops"] = newData;
      }
      cache.writeQuery(options.asRequest, data: data);
    },
  );
}
