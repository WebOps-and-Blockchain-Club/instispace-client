class CalendarGQL {
  static const get = """query GetCalendarEntry(
  \$calendarFilteringConditions: CalendarFilteringConditions!
  \$take: Float!
  \$lastEntryId: String!
) {
  getCalendarEntry(
    calendarFilteringConditions: \$calendarFilteringConditions
    take: \$take
    lastEntryId: \$lastEntryId
  ) {
    list {
      date
      description
      id
      type
    }
    total
  }
}
""";
}
