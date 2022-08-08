import 'package:client/models/query.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/query.dart';
import '../../../models/post.dart';
import '../comment/main.dart';
import 'new_query.dart';

PostActions queryActions(PostModel post, QueryOptions<Object?> options) {
  return PostActions(
    edit: editQueryAction(post, options),
    delete: deleteQueryAction(post, options),
    like: likeQueryAction(post, options),
    report: reportQueryAction(post, options),
    comment: commentQueryAction(post),
  );
}

NavigateAction editQueryAction(PostModel post, QueryOptions<Object?> options) {
  return NavigateAction(
    to: NewQueryPage(
      query: EditQueryModel(
          id: post.id,
          title: post.title,
          description: post.description,
          images: post.imageUrls),
      options: options,
    ),
  );
}

PostAction deleteQueryAction(PostModel post, QueryOptions<Object?> options) {
  return PostAction(
    id: post.id,
    document: QueryGQL.delete,
    updateCache: (cache, result) {
      dynamic data = cache.readQuery(options.asRequest);
      dynamic newData = [];
      for (var i = 0; i < data["getMyQuerys"]["queryList"].length; i++) {
        if (data["getMyQuerys"]["queryList"][i]["id"] != post.id) {
          newData = newData + [data["getMyQuerys"]["queryList"][i]];
        }
      }
      data["getMyQuerys"]["queryList"] = newData;
      data["getMyQuerys"]["total"] = data["getMyQuerys"]["total"] - 1;
      cache.writeQuery(options.asRequest, data: data);
    },
  );
}

PostAction likeQueryAction(PostModel post, QueryOptions<Object?> options) {
  return PostAction(
    id: post.id,
    document: QueryGQL.like,
    updateCache: (cache, result) {
      final Map<String, dynamic> updated = {
        "__typename": "MyQuery",
        "id": post.id,
        "isLiked": !(post.like!.isLikedByUser),
        "likeCount": post.like!.isLikedByUser
            ? post.like!.count - 1
            : post.like!.count + 1
      };
      cache.writeFragment(
        Fragment(document: gql('''
                      fragment queryLikeField on MyQuery {
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

PostAction reportQueryAction(PostModel post, QueryOptions<Object?> options) {
  return PostAction(
      id: post.id,
      document: QueryGQL.report,
      updateCache: (cache, result) {
        dynamic data = cache.readQuery(options.asRequest);
        dynamic newData = [];
        for (var i = 0; i < data["getMyQuerys"]["queryList"].length; i++) {
          if (data["getMyQuerys"]["queryList"][i]["id"] != post.id) {
            newData = newData + [data["getMyQuerys"]["queryList"][i]];
          }
        }
        data["getMyQuerys"]["queryList"] = newData;
        data["getMyQuerys"]["total"] = data["getMyQuerys"]["total"] - 1;
        cache.writeQuery(options.asRequest, data: data);
      });
}

NavigateAction commentQueryAction(PostModel post) {
  return NavigateAction(
      to: CommentsPage(
    id: post.id,
    comments: post.comments!,
    document:
        post.permissions.contains("COMMENT") ? QueryGQL.createComment : null,
    type: "Query",
    updateCache: (cache, result) {
      var data = cache.readFragment(Fragment(document: gql('''
                      fragment queryCommentField on MyQuery {
                        id
                        commentCount
                        comments {
                          content
                          id
                          images
                          createdBy {
                            name
                            id
                          }
                        }
                      }
                    ''')).asRequest(idFields: {
        '__typename': "MyQuery",
        'id': post.id,
      }));
      final Map<String, dynamic> updated = {
        "__typename": "MyQuery",
        "id": post.id,
        "commentCount": data!["commentCount"] + 1,
        "comments": data["comments"] + [result.data!["createCommentQuery"]],
      };
      cache.writeFragment(
        Fragment(document: gql('''
                      fragment queryCommentField on MyQuery {
                        id
                        commentCount
                        comments {
                          content
                          id
                          images
                          createdBy {
                            name
                            id
                          }
                        }
                      }
                    ''')).asRequest(idFields: {
          '__typename': "MyQuery",
          'id': post.id,
        }),
        data: updated,
        broadcast: false,
      );
    },
  ));
}
