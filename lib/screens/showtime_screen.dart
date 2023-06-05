import 'package:culture_app/screens/event_screen.dart';
import 'package:culture_app/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';
import 'package:culture_app/models/event.dart';

class Tuple<T1, T2> {
  final T1 item1;
  final T2 item2;

  Tuple(this.item1, this.item2);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tuple &&
          runtimeType == other.runtimeType &&
          item1 == other.item1 &&
          item2 == other.item2;

  @override
  int get hashCode => item1.hashCode ^ item2.hashCode;

  @override
  String toString() => 'Tuple<$T1, $T2>{item1: $item1, item2: $item2}';
}

class ShowtimeScreen extends StatelessWidget {
  final String title;
  final String city;

  const ShowtimeScreen({Key? key, required this.title, required this.city})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Event>>(
        future: EventService.getEventsByTitle(title, city, DateTime.now()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(AppLocalizations.of(context)!.eventsNotFound));
          } else {
            final events = snapshot.data!;
            final groupedEvents = groupBy<Event, Tuple<DateTime, String>>(
                events,
                (event) => Tuple(
                    DateTime(event.startTime.year, event.startTime.month,
                        event.startTime.day),
                    event.location));

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: groupedEvents.length,
                itemBuilder: (context, index) {
                  var dateLocation = groupedEvents.keys.toList()[index];
                  var date = dateLocation.item1;
                  var location = dateLocation.item2;
                  var events = groupedEvents[dateLocation]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMd().format(date),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(location,
                          style: Theme.of(context).textTheme.bodyMedium),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 8,
                        children: [
                          for (var event in events)
                            OutlinedButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EventScreen(
                                    event: event,
                                    key: Key(event.id),
                                  ),
                                ),
                              ),
                              child:
                                  Text(DateFormat.jm().format(event.startTime)),
                            ),
                        ],
                      ),
                      const Divider(height: 8)
                    ],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
