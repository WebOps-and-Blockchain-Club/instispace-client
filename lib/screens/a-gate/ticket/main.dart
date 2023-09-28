import 'package:client/screens/a-gate/ticket/ticket_card.dart';
import 'package:client/screens/a-gate/ticket/ticket_creating_page.dart';
import 'package:flutter/material.dart';

import '../../../themes.dart';

class Ticket extends StatefulWidget {
  const Ticket({super.key});

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: ScrollController(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[];
        },
        body: TicketCard(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorPalette.palette(context).secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TicketForm())),
      ),
    );
  }
}
