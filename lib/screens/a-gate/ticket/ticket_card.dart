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
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //title and status
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ticket.title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                      // color: const Color.fromARGB(255, 228, 47, 47),
                      padding: EdgeInsets.all(10),
                      decoration: ticket.resolvedBy == null
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.redAccent)
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.greenAccent),
                      child: ticket.resolvedBy == null
                          ? Text(
                              "Pending",
                            )
                          : Text("Resolved"))
                ],
              ),
            ),

            //createdBy and createdAt
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "Created by ${ticket.createdBy.name}, ${DateTimeFormatModel.fromString(ticket.createdAt).toDiffString()} ago", // should change it such that when clicked it opens profile page.
                style: const TextStyle(color: Colors.black45),
                textAlign: TextAlign.left,
              ),
            ),

            //images
            if (ticket.photo != null && ticket.photo!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ImageCard(
                  imageUrls: ticket.photo!,
                ),
              ),

            //description
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Description(content: ticket.description),
            ),
            // resolve button
            ticket.canResolve == true && ticket.resolvedBy == null
                ? CustomElevatedButton(
                    onPressed: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ResolveTicket(ticket: ticket)))
                        },
                    text: "Resolve")
                : Container(),

            //resolvedBy and ResolvedAt
            if (ticket.resolveDescription != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Resolved by ${ticket.resolvedBy?.name}, ${DateTimeFormatModel.fromString(ticket.updatedAt).toDiffString()} ago", // should change it such that when clicked it opens profile page.
                  style: const TextStyle(color: Colors.black45),
                  textAlign: TextAlign.left,
                ),
              ),

            //resolve description
            if (ticket.resolveDescription != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Description(content: ticket.resolveDescription!),
              ),
          ],
        ),
      ),
    );
  }
}
