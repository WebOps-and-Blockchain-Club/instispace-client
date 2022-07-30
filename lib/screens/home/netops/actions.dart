import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/netops.dart';
import '../../../models/netop.dart';
import '../../../models/post.dart';
import 'new_netop.dart';

PostActions netopActions(PostModel post, QueryOptions<Object?> options) {
  return PostActions(
      edit: netopEditAction(post, options),
      delete: netopDeleteAction(post, options),
      like: netopLikeAction(post, options),
      star: netopStarAction(post, options),
      report: netopReportAction(post, options));
}

NavigateAction netopEditAction(PostModel post, QueryOptions<Object?> options) {
  return NavigateAction(
    to: NewNetopPage(
      netop: EditNetopModel(
          id: post.id,
          title: post.title,
          description: post.description,
          imageUrls: post.imageUrls != null
              ? post.imageUrls! +
                  (post.attachements != null ? post.attachements! : [])
              : post.attachements ?? [],
          endTime: post.endTime!,
          tags: post.tags!,
          cta: post.cta),
      options: options,
    ),
  );
}

PostAction netopDeleteAction(PostModel post, QueryOptions<Object?> options) {
  return PostAction(
    id: post.id,
    document: NetopGQL.delete,
    updateCache: (cache, result) {
      dynamic data = cache.readQuery(options.asRequest);
      dynamic newData = [];
      for (var i = 0; i < data["getNetops"]["netopList"].length; i++) {
        if (data["getNetops"]["netopList"][i]["id"] != post.id) {
          newData = newData + [data["getNetops"]["netopList"][i]];
        }
      }
      data["getNetops"]["netopList"] = newData;
      data["getNetops"]["total"] = data["getNetops"]["total"] - 1;
      cache.writeQuery(options.asRequest, data: data);
    },
  );
}

PostAction netopLikeAction(PostModel post, QueryOptions<Object?> options) {
  return PostAction(
    id: post.id,
    document: NetopGQL.like,
    updateCache: (cache, result) {
      final Map<String, dynamic> updated = {
        "__typename": "Netop",
        "id": post.id,
        "isLiked": !(post.like!.isLikedByUser),
        "likeCount": post.like!.isLikedByUser
            ? post.like!.count - 1
            : post.like!.count + 1
      };
      cache.writeFragment(
        Fragment(document: gql('''
                      fragment netopLikeField on Netop {
                        id
                        isLiked
                        likeCount
                      }
                    ''')).asRequest(idFields: {
          '__typename': updated['__typename'],
          'id': updated['id'],
        }),
        data: updated,
        broadcast: false,
      );
    },
  );
}

PostAction netopStarAction(PostModel post, QueryOptions<Object?> options) {
  return PostAction(
    id: post.id,
    document: NetopGQL.star,
    updateCache: (cache, result) {
      final Map<String, dynamic> updated = {
        "__typename": "Netop",
        "id": post.id,
        "isStared": !(post.star!.isStarredByUser),
      };
      cache.writeFragment(
        Fragment(document: gql('''
                      fragment netopLikeField on Netop {
                        id
                        isStared
                      }
                    ''')).asRequest(idFields: {
          '__typename': updated['__typename'],
          'id': updated['id'],
        }),
        data: updated,
        broadcast: false,
      );
    },
  );
}

PostAction netopReportAction(PostModel post, QueryOptions<Object?> options) {
  return PostAction(
      id: post.id,
      document: NetopGQL.report,
      updateCache: (cache, result) {
        dynamic data = cache.readQuery(options.asRequest);
        dynamic newData = [];
        for (var i = 0; i < data["getNetops"]["netopList"].length; i++) {
          if (data["getNetops"]["netopList"][i]["id"] != post.id) {
            newData = newData + [data["getNetops"]["netopList"][i]];
          }
        }
        data["getNetops"]["netopList"] = newData;
        data["getNetops"]["total"] = data["getNetops"]["total"] - 1;
        cache.writeQuery(options.asRequest, data: data);
      });
}
