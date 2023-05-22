import 'package:culture_app/models/event.dart';
import 'package:culture_app/services/event_service.dart';
import 'package:flutter/material.dart';

List<DateTime> createDayTabs(DateTime day, int numDays) {
  DateTime startOfDay = DateTime(day.year, day.month, day.day);
  return List.generate(
    numDays,
    (index) => startOfDay.add(Duration(days: index)),
  );
}

class CalendarState {
  DateTime selectedDay;
  List<Event> selectedEvents;
  List<DateTime> days;
  int selectedTabIndex;
  int numDays;

  CalendarState({
    this.selectedTabIndex = 0,
    this.numDays = 5,
    PageController? pageController,
    DateTime? selectedDay,
    List<Event>? selectedEvents,
    List<DateTime>? days,
  })  : selectedDay = selectedDay ?? DateTime.now(),
        selectedEvents = selectedEvents ?? [],
        days = days ?? createDayTabs(DateTime.now(), numDays);
}
