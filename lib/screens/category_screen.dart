import 'package:culture_app/main.dart';
import 'package:culture_app/providers/settings_provider.dart';
import 'package:culture_app/screens/showtime_screen.dart';
import 'package:culture_app/services/image_service.dart';
import 'package:culture_app/services/event_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/event.dart';

final selectedGenresProvider =
    StateNotifierProvider<SelectedGenresNotifier, Set<String>>((ref) {
  return SelectedGenresNotifier();
});

class SelectedGenresNotifier extends StateNotifier<Set<String>> {
  SelectedGenresNotifier() : super({});

  Future<List<Event>> getFilteredEvents(String category, String city) async {
    final selectedGenres = state;
    final events =
        await EventService.getEventsByCategory(category: category, city: city);
    final uniqueEvents = <Event>[];
    for (var event in events) {
      if (!uniqueEvents.any((e) => e.title == event.title) &&
          (selectedGenres.isEmpty ||
              selectedGenres.any((genre) => event.genres.contains(genre)))) {
        uniqueEvents.add(event);
      }
    }
    return uniqueEvents;
  }

  void toggleGenre(String genre) {
    if (state.contains(genre)) {
      state = {...state}..remove(genre);
    } else {
      state = {...state}..add(genre);
    }
  }
}

class CategoryScreen extends ConsumerWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final city = settings.city;
    final selectedGenres = ref.watch(selectedGenresProvider.notifier);
    final eventsFuture = selectedGenres.getFilteredEvents(category, city);
    AppBar appBar;
    String titleLabel = '';
    switch (category) {
      case 'theater':
        titleLabel = AppLocalizations.of(context)!.theater;
        break;
      case 'movie':
        titleLabel = AppLocalizations.of(context)!.movie;
        break;
      case 'concert':
        titleLabel = AppLocalizations.of(context)!.concert;
        break;
      case 'festival':
        titleLabel = AppLocalizations.of(context)!.festival;
        break;
    }

    if (category == 'movie' || category == 'theater') {
      appBar = AppBar(
        title: Text(titleLabel),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: _buildGenreChips(context, ref),
        ),
      );
    } else {
      appBar = AppBar(
        title: Text(category),
      );
    }
    return Scaffold(
      appBar: appBar,
      body: FutureBuilder<List<Event>>(
        future: eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final events = snapshot.data!;
            return _buildEventList(events, ref);
          } else {
            return const Center(child: Text('No events available'));
          }
        },
      ),
    );
  }

  Widget _buildGenreChips(BuildContext context, WidgetRef ref) {
    final selectedGenres = ref.watch(selectedGenresProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: genres.map((genre) {
          final isSelected = selectedGenres.contains(genre);
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FilterChip(
                  label: Text(genre.toTitleCase()),
                  selected: isSelected,
                  onSelected: (_) => ref
                      .read(selectedGenresProvider.notifier)
                      .toggleGenre(genre),
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyLarge!.color,
                  )));
        }).toList(),
      ),
    );
  }

  Widget _buildEventList(List<Event> events, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return PageView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ShowtimeScreen(
                      title: event.title,
                      city: settings.city,
                    )));
          },
          child: Stack(
            children: [
              FutureBuilder<Uint8List>(
                future: ImageService.getImageBytes(event.imageId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return const Text('No Image');
                  }
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    if (category == 'movie' || category == 'theater')
                      Text(
                        event.genres.join(' ').toTitleCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8.0),
                    Text(
                      event.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
