import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../models/postModel.dart';
import '../../../graphQL/feed.dart';
import '../comment/main.dart';

PostActions postActions(PostModel post, QueryOptions<Object?> options) {
  return PostActions(
    //edit: netopEditAction(post, options),
    //delete: netopDeleteAction(post, options),
    like: postLikeAction(post, options),
    //star: netopStarAction(post, options),
    //report: netopReportAction(post, options),
    comment: netopCommentAction(post),
    star: savePostAction(post, options),
  );
}

PostAction postLikeAction(PostModel post, QueryOptions<Object?> options) {
  return PostAction(
    id: post.id,
    document: FeedGQL().toggleLikePost,
    updateCache: (cache, result) {
      final Map<String, dynamic> updated = {
        "__typename": "Post",
        "id": post.id,
        "isLiked": !(post.like!.isLikedByUser),
        "likeCount": post.like!.isLikedByUser
            ? post.like!.count - 1
            : post.like!.count + 1
      };
      cache.writeFragment(
        Fragment(document: gql('''
                      fragment LikeField on Post{
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

NavigateAction netopCommentAction(PostModel post) {
  return NavigateAction(
      to: CommentsPage(
    id: post.id,
    comments: post.comments!,
    document: FeedGQL().createComment,
    type: "Post",
    updateCache: (cache, result) {
      var data = cache.readFragment(Fragment(document: gql('''
                      fragment PostCommentField on Post{
                        id
                        postComments {
                          content
                          id
                          createdBy {
                            name
                            id
                          }
                        }
                      }
                    ''')).asRequest(idFields: {
        '__typename': "Post",
        'postId': post.id,
      }));
      final Map<String, dynamic> updated = {
        "__typename": "Post",
        "postId": post.id,
        "comments": data!["postComments"] + [result.data!["createComment"]],
      };
      cache.writeFragment(
        Fragment(document: gql('''
                      fragment PostCommentField on Post {
                        id
                        postComments {
                          content
                          createdBy {
                            name
                            id
                          }
                        }
                      }
                    ''')).asRequest(idFields: {
          '__typename': "Post",
          'postId': post.id,
        }),
        data: updated,
        broadcast: false,
      );
    },
  ));
}

PostAction savePostAction(PostModel post, QueryOptions<Object?> options) {
  return PostAction(
    id: post.id,
    document: FeedGQL().toggleSavePost,
    updateCache: (cache, result) {
      final Map<String, dynamic> updated = {
        "__typename": "Event",
        "id": post.id,
        "isSaved": !(post.isSaved!),
      };
      cache.writeFragment(
        Fragment(document: gql('''
                      fragment eventLikeField on Event{
                        id
                        isSaved
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
