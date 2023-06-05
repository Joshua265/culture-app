import 'package:culture_app/models/event.dart';
import 'package:culture_app/screens/event_screen.dart';
import 'package:culture_app/services/event_service.dart';
import 'package:flutter/material.dart';

class FetchEventAndNavigate extends StatefulWidget {
  final String eventId;

  FetchEventAndNavigate({Key? key, required this.eventId}) : super(key: key);

  @override
  _FetchEventAndNavigateState createState() => _FetchEventAndNavigateState();
}

class _FetchEventAndNavigateState extends State<FetchEventAndNavigate> {
  late Future<Event> futureEvent;

  @override
  void initState() {
    super.initState();
    futureEvent = EventService.getEventById(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Event>(
      future: futureEvent,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Event event = snapshot.data!;
          return EventScreen(
            event: event,
            key: Key(event.id),
          );
        }
      },
    );
  }
}
