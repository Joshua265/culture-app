import 'package:culture_app/providers/settings_provider.dart';
import 'package:culture_app/screens/event_screen.dart';
import 'package:culture_app/widgets/empty_list.dart';
import 'package:culture_app/widgets/event_card.dart';
import 'package:culture_app/widgets/event_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/event.dart';
import '../services/event_service.dart';

final eventsProvider = FutureProvider<List<Event>>((ref) async {
  print("eventsProvider");
  final settings = ref.watch(settingsProvider);
  final events = await EventService.getRandomEvents(settings.city);
  return events;
});

class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final events = ref.watch(eventsProvider);
    print("StartScreen");
    return Scaffold(
      appBar: AppBar(
        title: const Text('CultureAPP'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: EventSearch(settings.city));
            },
          ),
        ],
      ),
      body: events.when(
          data: (events) => _buildEventList(events, context),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) {
            print(events);
            print(error);
            print(stackTrace);
            return Center(
                child: EmptyListWidget(
              caption: AppLocalizations.of(context)!.errorLoadingEvents,
            ));
          }),
    );
  }

  Widget _buildEventList(List<Event> events, context) {
    if (events.isEmpty) {
      return Center(
          child: EmptyListWidget(
        caption: AppLocalizations.of(context)!.eventsNotFound,
      ));
    }
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.recommendedEvents,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 12),
          Expanded(
            // Add this
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return EventCard(
                  event: event,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          EventScreen(event: event, key: Key(event.id)),
                    ));
                  },
                );
              },
            ),
          )
        ]));
  }
}
