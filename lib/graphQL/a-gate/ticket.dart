import 'package:client/screens/a-gate/ticket/resolve_ticket.dart';

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

  static const getAllTickets = """
    query GetAllTickets {
  getAllTickets {
    canResolve
    createdAt
    createdBy {
      role
      roll
      id
      name
      photo
    }
    resolvedBy {
      role
      roll
      id
      name
      photo
    }
    description
    resolveDescription
    id
    imageUrls
    link
    resolvedAt
    status
    title
  }
}
    """;

  static const ResolveTicket = """ 
      mutation ResolveTicket(\$resolveTicketId: String!, \$resolveDescription: String!) {
  resolveTicket(id: \$resolveTicketId, resolveDescription: \$resolveDescription) {
    resolveDescription
    status
    resolvedBy {
    name  
    }
  }
}
  """;
}
