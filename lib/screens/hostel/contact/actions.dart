import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/contacts.dart';
import '../../../models/contacts.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import 'new_contact.dart';

PostActions contactsActions(
    UserModel user, ContactModel post, QueryOptions<Object?> options) {
  return PostActions(
    edit: editContactsAction(user, post, options),
    delete: deleteContactsAction(post, options),
  );
}

NavigateAction editContactsAction(
    UserModel user, ContactModel post, QueryOptions<Object?> options) {
  return NavigateAction(
      to: NewContactPage(
    user: user,
    options: options,
    contact: post,
  ));
}

PostAction deleteContactsAction(
    ContactModel post, QueryOptions<Object?> options) {
  return PostAction(
    id: post.id,
    document: ContactsGQL.delete,
    updateCache: (cache, result) {
      dynamic data = cache.readQuery(options.asRequest);
      dynamic newData = [];
      for (var i = 0; i < data["getContact"].length; i++) {
        if (data["getContact"][i]["id"] != post.id) {
          newData = newData + [data["getContact"][i]];
        }
      }
      data["getContact"] = newData;
      cache.writeQuery(options.asRequest, data: data);
    },
  );
}
