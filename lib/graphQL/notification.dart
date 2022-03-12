class notificationQuery{
  String changeNotificationPreference = """
mutation(\$notifyEvent: Notification, \$notifyNetop: Notification, \$toggleNotifyFound: Boolean!, \$toggleNotifyMyQuery: Boolean!){
  changeNotificationSettings(notifyEvent: \$notifyEvent,notifyNetop: \$notifyNetop,toggleNotifyFound: \$toggleNotifyFound,toggleNotifyMyQuery: \$toggleNotifyMyQuery)
}
""";
}