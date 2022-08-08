class NotificationGQL {
  static const get = """
    query {
      getMe {
        notifyNetop
        notifyEvent
        notifyMyQuery
        notifyFound
        notifyNetopComment
      }
    }
  """;

  static const edit = """
    mutation(\$notifyEvent: Notification, \$notifyNetop: Notification, \$toggleNotifyFound: Boolean!, \$toggleNotifyMyQuery: Boolean!){
      changeNotificationSettings(notifyEvent: \$notifyEvent,notifyNetop: \$notifyNetop,toggleNotifyFound: \$toggleNotifyFound,toggleNotifyMyQuery: \$toggleNotifyMyQuery)
    }
  """;
}
