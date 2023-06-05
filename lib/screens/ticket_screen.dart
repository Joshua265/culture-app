import 'dart:convert';

import 'package:culture_app/models/ticket_information.dart';
import 'package:culture_app/widgets/fetch_event_and_navigate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<List<TicketInformation>> getTicketInformation() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('tickets')) {
    List<dynamic> rawTickets = jsonDecode(prefs.getString('tickets')!);
    List<Map<String, dynamic>> ticketsJSON =
        rawTickets.cast<Map<String, dynamic>>();
    List<TicketInformation> tickets =
        ticketsJSON.map((e) => TicketInformation.fromMap(e)).toList();
    return tickets;
  } else {
    throw Exception('No ticket information found');
  }
}

class TicketsScreen extends StatefulWidget {
  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  late Future<List<TicketInformation>> futureTickets;

  @override
  void initState() {
    super.initState();
    futureTickets = getTicketInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        AppLocalizations.of(context)!.myTickets,
      )),
      body: FutureBuilder<List<TicketInformation>>(
        future: futureTickets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noTickets));
          } else {
            return PageView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                TicketInformation ticket = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        ticket.eventTitle,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        DateFormat.yMMMMEEEEd().format(ticket.eventStartTime),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        DateFormat.jm().format(ticket.eventStartTime),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        AppLocalizations.of(context)!.bookedSeats,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      for (var seat in ticket.reservedSeats)
                        ListTile(
                          title: Text(
                            '${AppLocalizations.of(context)!.row}: ${seat.row.toString()}, ${AppLocalizations.of(context)!.seat}: ${seat.seatNumber.toString()}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      const Expanded(child: Divider()),
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FetchEventAndNavigate(
                              eventId: ticket.eventId,
                            ),
                          ),
                        ),
                        child: Text(ticket.eventTitle),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
