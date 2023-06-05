import 'package:culture_app/widgets/custom_bottom_navigation_bar.dart';
import 'package:culture_app/widgets/fetch_event_and_navigate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:culture_app/screens/event_calendar_screen.dart';
import 'package:culture_app/screens/media_categories_screen.dart';
import 'package:culture_app/screens/start_screen.dart';
import 'package:culture_app/screens/user_screen.dart';
import 'package:culture_app/screens/scan_barcode_screen.dart';
import 'package:culture_app/providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  colorScheme: const ColorScheme.light().copyWith(
    primary: const Color(0xFF004675),
    secondary: const Color(0xFF004675),
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark().copyWith(
  primary: const Color(0xFF0094f8),
  secondary: const Color(0xFF0094f8),
  surface: const Color(0xFF0094f8),
));

void main() async {
  await dotenv.load();
  runApp(MyApp());
}

class IndexNotifier extends StateNotifier<int> {
  IndexNotifier(super.state);

  set setIndex(int index) {
    state = index;
  }
}

final indexProvider = StateNotifierProvider<IndexNotifier, int>((ref) {
  return IndexNotifier(0);
});

class MyApp extends ConsumerWidget {
  final List<Widget> _screens = [
    const StartScreen(),
    const MediaCategoriesScreen(),
    EventCalendarScreen(),
    const UserScreen(),
  ];
  late Future<String> futureBarcode;

  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(indexProvider);
    final settings = ref.watch(settingsProvider);
    return MaterialApp(
      title: 'CultureAPP',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(settings.language),
      home: Scaffold(
        body: _screens[currentIndex],
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => ref.watch(indexProvider.notifier).setIndex = index,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            scanBarCode();
            FutureBuilder(
                future: futureBarcode,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FetchEventAndNavigate(eventId: snapshot.data!),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                });
          },
          child: const Icon(Icons.qr_code),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
