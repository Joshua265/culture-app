import 'package:culture_app/screens/event_screen.dart';
import 'package:culture_app/services/event_service.dart';
import 'package:culture_app/widgets/empty_list.dart';
import 'package:culture_app/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:culture_app/models/event.dart';
import 'package:intl/intl.dart';

final selectedEventsProvider = StateProvider<List<Event>>((ref) => []);

List<List<Event>> groupEventsByHour(List<Event> events) {
  Map<int, List<Event>> eventGroups = {};

  for (var event in events) {
    final hour = event.startTime.hour;
    if (!eventGroups.containsKey(hour)) {
      eventGroups[hour] = [];
    }
    eventGroups[hour]!.add(event);
  }

  return eventGroups.values.toList();
}

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({Key? key}) : super(key: key);

  @override
  EventCalendarScreenState createState() => EventCalendarScreenState();
}

class EventCalendarScreenState extends State<EventCalendarScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late List<DateTime> _days;
  final String _selectedCategory = "";
  final int _numDays = 5;
  late int _selectedTabIndex = 0;
  late DateTime _selectedDay = DateTime.now();
  late List<Event> events = [];
  void _selectDate(BuildContext context) async {
    final newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (newSelectedDate != null) {
      changeDay(newSelectedDate, true);
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = 0;
    _pageController = PageController(initialPage: _selectedTabIndex);
    _days = List.generate(
      _numDays,
      (index) => _selectedDay.add(Duration(days: index)),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void changeDay(DateTime day, bool reIndex, {bool fromButton = false}) async {
    if (reIndex) {
      setState(() {
        _days = List.generate(
          _numDays,
          (index) => day.add(Duration(days: index)),
        );
        _selectedTabIndex = 0;
        _selectedDay = day;
        if (fromButton) {
          _pageController.jumpToPage(_selectedTabIndex);
        }
      });
    } else {
      setState(() {
        _selectedTabIndex = _days.indexOf(day);
        _selectedDay = day;
        if (fromButton) {
          _pageController.jumpToPage(_selectedTabIndex);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              _selectDate(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                _days.length,
                (index) {
                  final day = _days[index];
                  return TextButton(
                    onPressed: () async {
                      events = await EventService.getEventsByDay(day);
                      changeDay(day, false, fromButton: true);
                    },
                    style: ButtonStyle(
                      backgroundColor: _selectedTabIndex == index
                          ? MaterialStateProperty.all(
                              Theme.of(context).colorScheme.secondary,
                            )
                          : null,
                    ),
                    child: Text(
                      DateFormat('EEE').format(day).toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _selectedTabIndex == index
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  DateFormat('MMMM d').format(_selectedDay),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          Expanded(
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: _days.length,
                  onPageChanged: (index) async {
                    var day = _days[index];
                    events = await EventService.getEventsByDay(day);
                    changeDay(day, false);
                  },
                  itemBuilder: (context, index) {
                    final day = _days[index];
                    return FutureBuilder<List<Event>>(
                        future: EventService.getEventsByDay(day),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              !snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final events = snapshot.data!;
                          if (events.isEmpty) {
                            return const Center(
                              child: EmptyListWidget(),
                            );
                          }
                          final eventsByHour = groupEventsByHour(events);
                          return ListView.builder(
                            itemCount: eventsByHour.length,
                            itemBuilder: (context, index) {
                              final eventsOfHour = eventsByHour[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${eventsOfHour[0].startTime.hour}:00 ${eventsOfHour[0].startTime.hour < 12 ? 'AM' : 'PM'}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                    Column(
                                      children: eventsOfHour
                                          .map(
                                            (event) => EventCard(
                                              key: Key(event.id),
                                              event: event,
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EventScreen(
                                                      event: event,
                                                      key: Key(event.id),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        });
                  })),
        ],
      ),
    );
  }
}
