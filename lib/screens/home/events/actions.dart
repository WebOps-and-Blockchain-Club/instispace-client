import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/events.dart';
import '../../../models/event.dart';
import '../../../models/post.dart';
import 'new_event.dart';

PostActions eventActions(PostModel post, QueryOptions<Object?> options) {
  return PostActions(
    edit: editEventAction(post, options),
    delete: deleteEventAction(post, options),
    like: likeEventAction(post, options),
    star: starEventAction(post, options),
  );
}

NavigateAction editEventAction(PostModel post, QueryOptions<Object?> options) {
  return NavigateAction(
    to: NewEvent(
      event: EditEventModel(
          id: post.id,
          title: post.title,
          description: post.description,
          imageUrl: post.imageUrls?[0],
          location: post.location!,
          time: post.time!,
          tags: post.tags!,
          cta: post.cta),
      options: options,
    ),
  );
}

PostAction deleteEventAction(PostModel post, QueryOptions<Object?> options) {
  return PostAction(
    id: post.id,
    document: EventGQL().delete,
    updateCache: (cache, result) {
      dynamic data = cache.readQuery(options.asRequest);
      dynamic newData = [];
      for (var i = 0; i < data["getEvents"]["list"].length; i++) {
        if (data["getEvents"]["list"][i]["id"] != post.id) {
          newData = newData + [data["getEvents"]["list"][i]];
        }
      }
      data["getEvents"]["list"] = newData;
      data["getEvents"]["total"] = data["getEvents"]["total"] - 1;
      cache.writeQuery(options.asRequest, data: data);
    },
  );
}

PostAction likeEventAction(PostModel post, QueryOptions<Object?> options) {
  return PostAction(
    id: post.id,
    document: EventGQL().toggleLike,
    updateCache: (cache, result) {
      final Map<String, dynamic> updated = {
        "__typename": "Event",
        "id": post.id,
        "isLiked": !(post.like!.isLikedByUser),
        "likeCount": post.like!.isLikedByUser
            ? post.like!.count - 1
            : post.like!.count + 1
      };
      cache.writeFragment(
        Fragment(document: gql('''
                      fragment eventLikeField on Event {
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

PostAction starEventAction(PostModel post, QueryOptions<Object?> options) {
  return PostAction(
    id: post.id,
    document: EventGQL().toggleStar,
    updateCache: (cache, result) {
      final Map<String, dynamic> updated = {
        "__typename": "Event",
        "id": post.id,
        "isStared": !(post.star!.isStarredByUser),
      };
      cache.writeFragment(
        Fragment(document: gql('''
                      fragment eventLikeField on Event {
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
