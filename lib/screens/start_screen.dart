import 'package:culture_app/screens/event_screen.dart';
import 'package:culture_app/widgets/empty_list.dart';
import 'package:culture_app/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/event.dart';
import '../services/event_service.dart';

final eventsProvider = FutureProvider<List<Event>>((ref) async {
  final events = await EventService.getEvents();
  return events;
});

class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CultureAPP'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: events.when(
        data: (events) => _buildEventList(events),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: EmptyListWidget()),
      ),
    );
  }

  Widget _buildEventList(List<Event> events) {
    if (events.isEmpty) {
      return const Center(child: EmptyListWidget());
    }
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventCard(
          key: Key(event.id),
          event: event,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  EventScreen(event: event, key: Key(event.id)),
            ));
          },
        );
      },
    );
  }
}
