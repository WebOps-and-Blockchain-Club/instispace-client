import 'package:client/graphQL/a-gate/ticket.dart';
import 'package:client/models/ticket.dart';
import 'package:client/screens/a-gate/ticket/ticket_card.dart';
import 'package:client/screens/a-gate/ticket/ticket_creating_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../themes.dart';
import '../../../widgets/helpers/error.dart';

class Ticket extends StatefulWidget {
  const Ticket({super.key});

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RAISE TICKET",
          style: TextStyle(
              letterSpacing: 1,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Color(0xFF3C3C3C),
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Query(
          options: QueryOptions(
              document: gql(TicketGQL.getAllTickets),
              parserFn: ((data) => TicketsModel.fromJson(data))),
          builder: (result, {fetchMore, refetch}) {
            if (result.hasException && result.data == null) {
              return Center(child: ErrorWidget(result.exception.toString()));
            }
            if (result.hasException && result.data != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Use Future.delayed to delay the execution of showDialog
                Future.delayed(Duration.zero, () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Center(child: Text("Error")),
                        content: Text(formatErrorMessage(
                            result.exception.toString(), context)),
                        actions: [
                          TextButton(
                            child: const Text("Ok"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("Retry"),
                            onPressed: () {
                              refetch!();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                });
              });
            }
            if (result.isLoading && result.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final TicketsModel resultParsedData =
                result.parsedData as TicketsModel;
            final List<TicketModel> tickets =
                resultParsedData.tickets as List<TicketModel>;
            if (tickets.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Error(
                      error: '',
                      message: 'Your feed is empty',
                      onRefresh: refetch,
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return TicketCard(ticket: ticket);
              },
            );
          }),
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
