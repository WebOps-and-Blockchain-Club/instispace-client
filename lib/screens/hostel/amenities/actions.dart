import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../models/amenities.dart';
import '../../../models/user.dart';
import 'new_amenity.dart';
import '../../../graphQL/amenities.dart';
import '../../../models/post.dart';

PostActions amenitiesActions(
    UserModel user, PostModel post, QueryOptions<Object?> options) {
  return PostActions(
    edit: editAmenitiesAction(user, post, options),
    delete: deleteAmenitiesAction(post, options),
  );
}

NavigateAction editAmenitiesAction(
    UserModel user, PostModel post, QueryOptions<Object?> options) {
  return NavigateAction(
      to: NewAmenityPage(
    amenity: AmenityEditModel(
        id: post.id, title: post.title, description: post.description),
    user: user,
    options: options,
  ));
}

PostAction deleteAmenitiesAction(
    PostModel post, QueryOptions<Object?> options) {
  return PostAction(
    id: post.id,
    document: AmenitiesGQL.delete,
    updateCache: (cache, result) {
      dynamic data = cache.readQuery(options.asRequest);
      dynamic newData = [];
      for (var i = 0; i < data["getAmenities"].length; i++) {
        if (data["getAmenities"][i]["id"] != post.id) {
          newData = newData + [data["getAmenities"][i]];
        }
      }
      data["getAmenities"] = newData;
      cache.writeQuery(options.asRequest, data: data);
    },
  );
}
