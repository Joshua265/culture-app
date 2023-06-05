import 'package:culture_app/models/calendar_state.dart';
import 'package:culture_app/providers/settings_provider.dart';
import 'package:culture_app/screens/event_screen.dart';
import 'package:culture_app/services/event_service.dart';
import 'package:culture_app/widgets/empty_list.dart';
import 'package:culture_app/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:culture_app/models/event.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarStateNotifier extends StateNotifier<CalendarState> {
  CalendarStateNotifier() : super(CalendarState());

  Future<void> changeDay(String city, DateTime newDay, bool reIndex) async {
    DateTime startOfDay = DateTime(
      newDay.year,
      newDay.month,
      newDay.day,
    );
    if (state.selectedDay == startOfDay) {
      return;
    }
    final selectedEvents = await EventService.getEventsByTimeFrame(
      city,
      newDay.day == DateTime.now().day ? DateTime.now() : startOfDay,
      DateTime(newDay.year, newDay.month, newDay.day, 23, 59, 59, 999, 999),
    );
    final days =
        reIndex ? createDayTabs(startOfDay, state.numDays) : state.days;
    final selectedTabIndex = reIndex ? 0 : days.indexOf(startOfDay);
    state = CalendarState(
      selectedEvents: selectedEvents,
      selectedDay: startOfDay,
      days: days,
      selectedTabIndex: selectedTabIndex,
    );
  }

  void changeIndex(int newIndex) {
    final newDay = state.days[newIndex];
    state = CalendarState(
      selectedEvents: state.selectedEvents,
      selectedDay: newDay,
      days: state.days,
      selectedTabIndex: newIndex,
    );
  }
}

final calendarStateProvider =
    StateNotifierProvider<CalendarStateNotifier, CalendarState>(
        (ref) => (CalendarStateNotifier()));

List<List<Event>> groupEventsByHour(List<Event> events) {
  Map<int, List<Event>> eventGroups = {};

  for (var event in events) {
    final hour = event.startTime.hour;
    if (!eventGroups.containsKey(hour)) {
      eventGroups[hour] = [];
    }
    eventGroups[hour]!.add(event);
  }

  var sortedKeys = eventGroups.keys.toList(growable: false)
    ..sort((k1, k2) => k1.compareTo(k2));

  Map<int, List<Event>> sortedEventGroups = {
    for (var k in sortedKeys) k: eventGroups[k]!
  };

  return sortedEventGroups.values.toList();
}

class EventCalendarScreen extends ConsumerWidget {
  final PageController pageController = PageController(initialPage: 0);

  EventCalendarScreen({Key? key}) : super(key: key);

  void selectDate(BuildContext context, WidgetRef ref) async {
    final calendarState = ref.read(calendarStateProvider);
    final settings = ref.read(settingsProvider);
    final newSelectedDate = await showDatePicker(
      context: context,
      initialDate: calendarState.selectedDay,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (newSelectedDate != null) {
      ref
          .read(calendarStateProvider.notifier)
          .changeDay(settings.city, newSelectedDate, true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarStateProvider);
    final settings = ref.watch(settingsProvider);
    ref.listen(calendarStateProvider, (previous, next) {
      pageController.jumpToPage(next.selectedTabIndex);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.calendar),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              selectDate(context, ref);
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
                calendarState.numDays,
                (index) {
                  final newDay = calendarState.days[index];
                  return TextButton(
                    onPressed: () {
                      ref
                          .read(calendarStateProvider.notifier)
                          .changeIndex(index);
                    },
                    style: ButtonStyle(
                      backgroundColor: calendarState.selectedTabIndex == index
                          ? MaterialStateProperty.all(
                              Theme.of(context).colorScheme.secondary,
                            )
                          : null,
                    ),
                    child: Text(
                      DateFormat('EEE').format(newDay).toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: calendarState.selectedTabIndex == index
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge!.color,
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
                  DateFormat('MMMM d').format(calendarState.selectedDay),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          Expanded(
            child: PageView.builder(
              itemCount: calendarState.numDays,
              controller: pageController,
              onPageChanged: (index) {
                ref.read(calendarStateProvider.notifier).changeIndex(index);
              },
              itemBuilder: (context, index) {
                final day = calendarState.days[index];
                return Consumer(
                  builder: (context, ref, _) {
                    // final events = ref.watch(calendarStateProvider.select(
                    //   (value) => value.selectedEvents,
                    // ));
                    return FutureBuilder<List<Event>>(
                      future: EventService.getEventsByTimeFrame(
                        settings.city,
                        day,
                        DateTime(
                          day.year,
                          day.month,
                          day.day,
                          23,
                          59,
                          59,
                        ),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: EmptyListWidget(
                              caption:
                                  AppLocalizations.of(context)!.eventsNotFound,
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Error'),
                          );
                        }
                        final events = snapshot.data!;
                        if (events.isEmpty) {
                          return Center(
                            child: EmptyListWidget(
                              caption:
                                  AppLocalizations.of(context)!.eventsNotFound,
                            ),
                          );
                        }
                        final eventsByHour = groupEventsByHour(events);

                        return ListView.builder(
                          itemCount: eventsByHour.length,
                          itemBuilder: (context, index) {
                            final eventsOfHour = eventsByHour[index];
                            DateTime titleHour = DateTime(
                              eventsOfHour[0].startTime.year,
                              eventsOfHour[0].startTime.month,
                              eventsOfHour[0].startTime.day,
                              eventsOfHour[0].startTime.hour,
                              0,
                              0,
                            );
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat.jm(settings.language)
                                        .format(titleHour),
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
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
