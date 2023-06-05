import 'package:culture_app/screens/reservation_screen.dart';
import 'package:culture_app/services/image_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:culture_app/models/event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventScreen extends StatefulWidget {
  final Event event;

  const EventScreen({required Key key, required this.event}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  int _selectedSeatIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.event.location,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.event.startTime.day}.${widget.event.startTime.month}.${widget.event.startTime.year}',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.event.startTime.hour}:${widget.event.startTime.minute} - ${widget.event.endTime.hour}:${widget.event.endTime.minute}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<Uint8List>(
                      future: ImageService.getImageBytes(widget.event.imageId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return const Text('No Image');
                        }
                        return Image.memory(
                          snapshot.data!,
                          height: 200,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.event.title,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.event.description,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ReservationScreen(event: widget.event),
                  ));
                },
                child: Text(
                  AppLocalizations.of(context)!.reserveTicket,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
