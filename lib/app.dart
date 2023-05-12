import 'package:culture_app/widgets/custom_bottom_navigation_bar.dart';
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

void main() async {
  await dotenv.load();
  runApp(MyApp());
}

class IndexNotifier extends StateNotifier<int> {
  IndexNotifier(super.state);
}

final indexProvider = StateNotifierProvider<IndexNotifier, int>((ref) {
  return IndexNotifier(0);
});

class MyApp extends ConsumerWidget {
  final List<Widget> _screens = [
    const StartScreen(),
    const MediaCategoriesScreen(),
    const EventCalendarScreen(),
    const UserScreen(),
  ];

  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(indexProvider);
    final settings = ref.watch(settingsProvider);
    return MaterialApp(
      title: 'CultureAPP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: _screens[currentIndex],
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => ref.read(indexProvider.notifier).state = index,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            scanBarCode();
          },
          child: const Icon(Icons.qr_code),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
