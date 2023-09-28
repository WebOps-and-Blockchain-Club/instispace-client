import 'package:client/models/ticket.dart';
import 'package:client/widgets/card.dart';
import 'package:flutter/material.dart';

class TicketCard extends StatefulWidget {
  final TicketModel? ticket;
  const TicketCard({super.key, this.ticket});

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Card header
        Row(
          children: [
            Expanded(
              child: Text(
                // widget.ticket.title ?? "Title Of Post",
                "Titel of Post",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        )
      ],
    ));
  }
}
