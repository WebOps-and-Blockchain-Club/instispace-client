import 'package:client/models/ticket.dart';
import 'package:client/screens/a-gate/ticket/resolve_ticket.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:client/widgets/button/flat_icon_text_button.dart';
import 'package:client/widgets/card.dart';
import 'package:flutter/material.dart';

import '../../../models/date_time_format.dart';
import '../../../widgets/card/description.dart';
import '../../../widgets/card/image.dart';

class TicketCard extends StatefulWidget {
  final TicketModel ticket;
  const TicketCard({super.key, required this.ticket});

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(23),
        ),
        // color: Color.fromARGB(255, 234, 238, 241),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      ticket.title,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Color(0xFF3C3C3C),
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ticket.resolvedBy == null
                                ? Colors.orangeAccent
                                : Colors.greenAccent,
                            border: Border.all(
                              color: ticket.resolvedBy == null
                                  ? Colors.orangeAccent
                                  : Colors.greenAccent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 10,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ticket.resolvedBy == null
                                    ? Colors.orangeAccent
                                    : Colors.greenAccent,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          ticket.resolvedBy == null ? "Pending" : "Resolved",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Color(0xFF3C3C3C),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // CreatedBy and CreatedAt
              Text(
                "Created by ${ticket.createdBy.name}, ${DateTimeFormatModel.fromString(ticket.createdAt).toDiffString()} ago",
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Color(0xFF3C3C3C)),
                textAlign: TextAlign.left,
              ),

              SizedBox(height: 20),

              // Images
              if (ticket.photo != null && ticket.photo!.isNotEmpty)
                ImageCard(
                  imageUrls: ticket.photo!,
                ),

              // Description
              Description(content: ticket.description),

              // Resolve Button
              if (ticket.canResolve == true && ticket.resolvedBy == null)
                CustomElevatedButton(
                  onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ResolveTicket(ticket: ticket),
                      ),
                    )
                  },
                  text: "Resolve",
                ),

              // ResolvedBy and ResolvedAt
              if (ticket.resolveDescription != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Resolved by ${ticket.resolvedBy?.name}, ${DateTimeFormatModel.fromString(ticket.updatedAt).toDiffString()} ago",
                      style: const TextStyle(color: Colors.black54),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),

              // Resolve Description
              if (ticket.resolveDescription != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Description(content: ticket.resolveDescription!),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
