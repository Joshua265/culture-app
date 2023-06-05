import 'package:culture_app/models/event.dart';
import 'package:culture_app/screens/showtime_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:culture_app/services/event_service.dart';
import 'package:flutter/material.dart';

class EventSearch extends SearchDelegate<String> {
  final String city;

  EventSearch(this.city);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.searchTermTooShort,
        ),
      );
    }

    // Fetch the search results and show them as list
    return FutureBuilder(
      future: EventService.searchEvents(query, city),
      builder: (context, AsyncSnapshot<List<Event>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(AppLocalizations.of(context)!.eventsNotFound));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Event event = snapshot.data![index];
              // Replace with your own item widget
              return ListTile(
                title: Text(event.title),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShowtimeScreen(
                    title: event.title,
                    city: city,
                  ),
                )),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length < 3) {
      return const Center(
        child: Text(
          "Search term must be longer than two letters.",
        ),
      );
    }
    // Fetch the search results and show them as list
    return FutureBuilder(
      future: EventService.searchEvents(query, city),
      builder: (context, AsyncSnapshot<List<Event>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(AppLocalizations.of(context)!.eventsNotFound));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Event event = snapshot.data![index];
              return ListTile(
                title: Text(event.title),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShowtimeScreen(
                    title: event.title,
                    city: city,
                  ),
                )),
              );
            },
          );
        }
      },
    );
  }
}
