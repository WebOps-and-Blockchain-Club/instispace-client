class TicketGQL {
  static const createTicket = """
        mutation CreateTicket(\$createTicketInput: CreateTicketInput!) {
          createTicket(createTicketInput: \$createTicketInput) {
            id
            title
            status
            link
            canResolve
            createdAt
            createdBy {
              name
              roll
            }
            resolvedAt
            resolvedBy {
              roll
              name
            }
            imageUrls
            description
          }
        }
      """;
}
