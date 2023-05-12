import 'package:flutter/material.dart';
import 'package:culture_app/models/event.dart';

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
                    Image.network(
                      widget.event.imageUrl,
                      height: 200,
                      fit: BoxFit.cover,
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
                    Text(
                      'Select a seat:',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: widget.event.prices
                          .asMap()
                          .entries
                          .map(
                            (entry) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedSeatIndex = entry.key;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: _selectedSeatIndex == entry.key
                                      ? Colors.blue
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      entry.value.category,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color:
                                                _selectedSeatIndex == entry.key
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '\$ ${entry.value.value}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color:
                                                _selectedSeatIndex == entry.key
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    _selectedSeatIndex == -1
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selected seat:',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget
                                    .event.prices[_selectedSeatIndex].category,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectedSeatIndex == -1
                  ? null
                  : () {
                      // Navigate to PaymentScreen with selected seat
                      Navigator.pushNamed(context, '/payment', arguments: {
                        'event': widget.event,
                        'selectedSeatIndex': _selectedSeatIndex,
                      });
                    },
              child: const Text('Reserve Now'),
            ),
          ],
        ),
      ),
    );
  }
}
