import 'package:culture_app/screens/event_screen.dart';
import 'package:culture_app/widgets/empty_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/event.dart';
import '../services/event_service.dart';
import 'start_screen.dart';

class ShowtimeScreen extends ConsumerWidget {
  final String category;
  final String contentId;

  ShowtimeScreen({required this.category, required this.contentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        bottom: TabBar(
          isScrollable: true,
          tabs: [
            for (var i = 0; i < 7; i++)
              Tab(
                text: DateFormat('EEE')
                    .format(DateTime.now().add(Duration(days: i))),
              ),
          ],
        ),
      ),
      body: events.when(
        data: (events) => _buildEventList(context, events),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
            child: EmptyListWidget(
          caption: AppLocalizations.of(context)!.eventsNotFound,
        )),
      ),
    );
  }

  Widget _buildEventList(BuildContext context, List<Event> events) {
    return FutureBuilder<List<Event>>(
      future: EventService.getEventsByContentId(contentId),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data!.isEmpty) {
            return Center(
                child: EmptyListWidget(
              caption: AppLocalizations.of(context)!.eventsNotFound,
            ));
          }
          final List<Event> events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ExpansionTile(
                title: Text(event.title),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var event in events)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    EventScreen(
                                      event: event,
                                      key: Key(event.id),
                                    );
                                  },
                                  child: Text(DateFormat('HH:mm')
                                      .format(event.startTime)),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return Center(
              child: EmptyListWidget(
            caption: AppLocalizations.of(context)!.eventsNotFound,
          ));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
